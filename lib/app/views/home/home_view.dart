import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laundry/app/views/address/enter_address.dart';
import 'package:laundry/app/views/pickup/pickup_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<Map<String, dynamic>> _getUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    final addressesSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .get();

    final addressList = addressesSnapshot.docs.map((doc) {
      return {'id': doc.id, ...doc.data()};
    }).toList();

    Map<String, dynamic>? defaultAddress;
    for (var addr in addressList) {
      if (addr['isDefault'] == true) {
        defaultAddress = addr;
        break;
      }
    }

    // Auto set default if only one address exists and none marked
    if (addressList.length == 1 && defaultAddress == null) {
      final onlyAddress = addressList.first;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('addresses')
          .doc(onlyAddress['id'])
          .update({'isDefault': true});
      defaultAddress = onlyAddress;
    }

    return {
      'name': userDoc['name'] ?? 'User',
      'defaultAddress': defaultAddress,
      'hasAddress': addressList.isNotEmpty,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getUserData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data!;
        final name = data['name'];
        final defaultAddress = data['defaultAddress'];

        // If user has no addresses at all, redirect to EnterAddressScreen
        if (!data['hasAddress']) {
          Future.microtask(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => EnterAddressScreen()),
            );
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ); // Prevent build errors during redirect
        }

        // If no default address set
        if (defaultAddress == null) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Home',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Welcome Back, $name',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Please select an address first',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => EnterAddressScreen()),
                        );
                      },
                      child: const Text('Select Address'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final fullAddress =
            '${defaultAddress['address']}, ${defaultAddress['city']}, ${defaultAddress['pincode']}';

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Home',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Welcome Back, $name',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: TextEditingController(text: fullAddress),
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RequestPickupScreen(
                                address: fullAddress,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text('Schedule a Pickup'),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => EnterAddressScreen()),
                      );
                    },
                    child: const Center(child: Text("Edit Address")),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
