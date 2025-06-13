import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundry/app/views/dashboard/dashboard.dart';

class EnterAddressScreen extends StatefulWidget {
  final bool isForTemporaryUse;
  const EnterAddressScreen({this.isForTemporaryUse = false});

  @override
  _EnterAddressScreenState createState() => _EnterAddressScreenState();
}

class _EnterAddressScreenState extends State<EnterAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  String? _selectedSavedAddress;
  bool _isSaving = false;

  Future<void> _useCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location services are disabled.")),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location permission denied.")),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location permission permanently denied.")),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _addressController.text =
              '${place.street ?? ''} ${place.subLocality ?? ''}';
          _cityController.text = place.locality ?? '';
          _pincodeController.text = place.postalCode ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error getting address: $e")),
      );
    }
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final address = _addressController.text.trim();
      final city = _cityController.text.trim();
      final pincode = _pincodeController.text.trim();

      // Check if this exact address already exists
      final existingAddress = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('addresses')
          .where('address', isEqualTo: address)
          .where('city', isEqualTo: city)
          .where('pincode', isEqualTo: pincode)
          .get();

      // If address exists, just update it as default
      if (existingAddress.docs.isNotEmpty) {
        // Remove previous default address
        final previousDefaults = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('addresses')
            .where('isDefault', isEqualTo: true)
            .get();

        for (var doc in previousDefaults.docs) {
          await doc.reference.update({'isDefault': false});
        }

        // Set this address as default
        await existingAddress.docs.first.reference.update({
          'isDefault': true,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
      // If address doesn't exist, create new one
      else {
        // Remove previous default address
        final previousDefaults = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('addresses')
            .where('isDefault', isEqualTo: true)
            .get();

        for (var doc in previousDefaults.docs) {
          await doc.reference.update({'isDefault': false});
        }

        // Add new address
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('addresses')
            .add({
          'address': address,
          'city': city,
          'pincode': pincode,
          'isDefault': true,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      // Navigate to dashboard
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(
            address: address,
            city: city,
            pincode: pincode,
          ),
        ),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving address: $e")),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return Scaffold(
        body: Center(child: Text("User not authenticated")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Enter Your Address',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.location_on,
                          color: Colors.blue, size: 40),
                      onPressed: _useCurrentLocation,
                    ),
                    const Text(
                      'Use current location',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Saved addresses dropdown
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .collection('addresses')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const SizedBox();
                  }

                  final addresses = snapshot.data!.docs;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Use Saved Address",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedSavedAddress,
                        hint: const Text("Select saved address"),
                        isExpanded:
                            true, // Add this line to make dropdown take full width
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF1F4F8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: addresses.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          String label =
                              "${data['address']}, ${data['city']} - ${data['pincode']}";
                          return DropdownMenuItem<String>(
                            value: label,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width -
                                    100, // Adjust as needed
                              ),
                              child: Text(
                                label,
                                overflow: TextOverflow
                                    .ellipsis, // Handle overflow with ellipsis
                                maxLines: 2, // Allow text to wrap to 2 lines
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSavedAddress = value;
                            final selected = addresses.firstWhere((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              String label =
                                  "${data['address']}, ${data['city']} - ${data['pincode']}";
                              return label == value;
                            });
                            final selectedData =
                                selected.data() as Map<String, dynamic>;
                            _addressController.text =
                                selectedData['address'] ?? '';
                            _cityController.text = selectedData['city'] ?? '';
                            _pincodeController.text =
                                selectedData['pincode'] ?? '';
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),

              // Address form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        hintText: 'Address Line',
                        filled: true,
                        fillColor: const Color(0xFFF1F4F8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter address'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        hintText: 'City',
                        filled: true,
                        fillColor: const Color(0xFFF1F4F8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter city' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _pincodeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Pincode',
                        filled: true,
                        fillColor: const Color(0xFFF1F4F8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter pincode';
                        } else if (value.length < 5) {
                          return 'Enter valid 6-digit pincode';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveAddress,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isSaving
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                'Save Address',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
