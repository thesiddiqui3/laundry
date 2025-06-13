// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';

// // class RequestPickupScreen extends StatefulWidget {
// //   final String address;

// //   RequestPickupScreen({required this.address});

// //   @override
// //   _RequestPickupScreenState createState() => _RequestPickupScreenState();
// // }

// // class _RequestPickupScreenState extends State<RequestPickupScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   final TextEditingController notesController = TextEditingController();
// //   final TextEditingController dateTimeController = TextEditingController();
// //   late TextEditingController addressController;

// //   int clothesCount = 1;

// //   @override
// //   void initState() {
// //     super.initState();
// //     addressController = TextEditingController(text: widget.address);
// //   }

// //   Future<void> _handleSubmit() async {
// //     if (_formKey.currentState!.validate() && clothesCount > 0) {
// //       try {
// //         final userId = FirebaseAuth.instance.currentUser!.uid;
// //         final DateTime parsedDateTime = DateTime.parse(dateTimeController.text);

// //         // 🔢 1. Get latest orderId from Firestore
// //         final pickupRef = FirebaseFirestore.instance
// //             .collection('users')
// //             .doc(userId)
// //             .collection('pickups');

// //         final lastOrderSnapshot = await pickupRef
// //             .orderBy('createdAt', descending: true)
// //             .limit(1)
// //             .get();

// //         int lastOrderNumber = 1000; // Default starting orderId
// //         if (lastOrderSnapshot.docs.isNotEmpty) {
// //           final lastId = lastOrderSnapshot.docs.first.data()['orderId'];
// //           if (lastId != null && lastId.toString().startsWith('#')) {
// //             final number = int.tryParse(lastId.toString().substring(1));
// //             if (number != null) lastOrderNumber = number;
// //           }
// //         }

// //         final newOrderId = '#${lastOrderNumber + 1}';

// //         // 📝 2. Save pickup with generated orderId
// //         await pickupRef.add({
// //           'orderId': newOrderId,
// //           'userId': userId, // ✅ Needed for cancel logic
// //           'address': addressController.text.trim(),
// //           'dateTime': Timestamp.fromDate(parsedDateTime),
// //           'notes': notesController.text.trim(),
// //           'clothesCount': clothesCount,
// //           'status': 'Pending',
// //           'createdAt': FieldValue.serverTimestamp(),
// //         });

// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text("Pickup Requested Successfully")),
// //         );
// //         Navigator.pop(context);
// //       } catch (e) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text("Error: ${e.toString()}")),
// //         );
// //       }
// //     } else if (clothesCount <= 0) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Please select at least 1 cloth.")),
// //       );
// //     }
// //   }

// //   // Future<void> _handleSubmit() async {
// //   //   if (_formKey.currentState!.validate() && clothesCount > 0) {
// //   //     try {
// //   //       final userId = FirebaseAuth.instance.currentUser!.uid;

// //   //       // Parse the selected datetime string back to DateTime
// //   //       final DateTime parsedDateTime = DateTime.parse(dateTimeController.text);

// //   //       await FirebaseFirestore.instance
// //   //           .collection('users')
// //   //           .doc(userId)
// //   //           .collection('pickups')
// //   //           .add({
// //   //         'address': addressController.text.trim(),
// //   //         'dateTime': Timestamp.fromDate(parsedDateTime), // ✅ Fixed
// //   //         'notes': notesController.text.trim(),
// //   //         'clothesCount': clothesCount,
// //   //         'status': 'Pending',
// //   //         'createdAt': FieldValue.serverTimestamp(),
// //   //       });

// //   //       ScaffoldMessenger.of(context).showSnackBar(
// //   //         const SnackBar(content: Text("Pickup Requested Successfully")),
// //   //       );
// //   //       Navigator.pop(context);
// //   //     } catch (e) {
// //   //       ScaffoldMessenger.of(context).showSnackBar(
// //   //         SnackBar(content: Text("Error: ${e.toString()}")),
// //   //       );
// //   //     }
// //   //   } else if (clothesCount <= 0) {
// //   //     ScaffoldMessenger.of(context).showSnackBar(
// //   //       const SnackBar(content: Text("Please select at least 1 cloth.")),
// //   //     );
// //   //   }
// //   // }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         leading: BackButton(color: Colors.black),
// //         title: Text('Request Pickup', style: TextStyle(color: Colors.black)),
// //         backgroundColor: Colors.white,
// //         elevation: 0,
// //       ),
// //       body: Form(
// //         key: _formKey,
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Column(
// //             children: [
// //               buildInputField(
// //                 'Select Address',
// //                 addressController,
// //                 readOnly: true,
// //                 validator: (value) =>
// //                     value == null || value.isEmpty ? 'Address required' : null,
// //               ),
// //               const SizedBox(height: 12),
// //               buildInputField(
// //                 'Select Date & Time',
// //                 dateTimeController,
// //                 suffixIcon: Icons.calendar_today,
// //                 readOnly: true,
// //                 validator: (value) => value == null || value.isEmpty
// //                     ? 'Date & Time required'
// //                     : null,
// //                 onTap: () async {
// //                   final now = DateTime.now();
// //                   final date = await showDatePicker(
// //                     context: context,
// //                     initialDate: now,
// //                     firstDate: now,
// //                     lastDate: DateTime(2100),
// //                   );
// //                   if (date != null) {
// //                     final time = await showTimePicker(
// //                       context: context,
// //                       initialTime: TimeOfDay.now(),
// //                     );
// //                     if (time != null) {
// //                       final selectedDateTime = DateTime(
// //                         date.year,
// //                         date.month,
// //                         date.day,
// //                         time.hour,
// //                         time.minute,
// //                       );
// //                       if (selectedDateTime.isAfter(now)) {
// //                         dateTimeController.text =
// //                             selectedDateTime.toString(); // or format
// //                       } else {
// //                         ScaffoldMessenger.of(context).showSnackBar(
// //                           SnackBar(
// //                               content: Text('Please select a valid time.')),
// //                         );
// //                       }
// //                     }
// //                   }
// //                 },
// //               ),
// //               const SizedBox(height: 12),

// //               // Number of Clothes
// //               Container(
// //                 padding:
// //                     const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
// //                 decoration: BoxDecoration(
// //                   color: const Color(0xFFF1F5F9),
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     const Text('Number of Clothes',
// //                         style: TextStyle(fontSize: 16)),
// //                     Row(
// //                       children: [
// //                         IconButton(
// //                           icon: Icon(Icons.remove_circle_outline),
// //                           onPressed: () {
// //                             if (clothesCount > 0) {
// //                               setState(() {
// //                                 clothesCount--;
// //                               });
// //                             }
// //                           },
// //                         ),
// //                         Text(
// //                           '$clothesCount',
// //                           style: TextStyle(
// //                               fontSize: 16, fontWeight: FontWeight.bold),
// //                         ),
// //                         IconButton(
// //                           icon: Icon(Icons.add_circle_outline),
// //                           onPressed: () {
// //                             setState(() {
// //                               clothesCount++;
// //                             });
// //                           },
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               const SizedBox(height: 12),

// //               buildInputField(
// //                 'Notes (optional)',
// //                 notesController,
// //                 maxLines: 3,
// //               ),
// //               const Spacer(),
// //               SizedBox(
// //                 width: double.infinity,
// //                 child: ElevatedButton(
// //                   onPressed: _handleSubmit,
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Colors.blue,
// //                     padding: const EdgeInsets.symmetric(vertical: 16),
// //                     shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(8)),
// //                   ),
// //                   child: const Text(
// //                     'Request Pickup',
// //                     style: TextStyle(fontSize: 16),
// //                   ),
// //                 ),
// //               )
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget buildInputField(
// //     String hint,
// //     TextEditingController controller, {
// //     IconData? suffixIcon,
// //     bool readOnly = false,
// //     VoidCallback? onTap,
// //     int maxLines = 1,
// //     String? Function(String?)? validator,
// //   }) {
// //     return TextFormField(
// //       controller: controller,
// //       readOnly: readOnly,
// //       onTap: onTap,
// //       maxLines: maxLines,
// //       validator: validator,
// //       decoration: InputDecoration(
// //         hintText: hint,
// //         suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
// //         filled: true,
// //         fillColor: const Color(0xFFF1F5F9),
// //         border: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: BorderSide.none,
// //         ),
// //         contentPadding:
// //             const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
// //       ),
// //     );
// //   }
// // }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class RequestPickupScreen extends StatefulWidget {
//   final String address;

//   RequestPickupScreen({required this.address});

//   @override
//   _RequestPickupScreenState createState() => _RequestPickupScreenState();
// }

// class _RequestPickupScreenState extends State<RequestPickupScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController notesController = TextEditingController();
//   final TextEditingController dateTimeController = TextEditingController();
//   late TextEditingController addressController;

//   int clothesCount = 1;

//   @override
//   void initState() {
//     super.initState();
//     addressController = TextEditingController(text: widget.address);
//   }

//   Future<void> _handleSubmit() async {
//     if (_formKey.currentState!.validate() && clothesCount > 0) {
//       try {
//         final userId = FirebaseAuth.instance.currentUser!.uid;
//         final DateTime parsedDateTime = DateTime.parse(dateTimeController.text);

//         final pickupRef = FirebaseFirestore.instance
//             .collection('users')
//             .doc(userId)
//             .collection('pickups');

//         final lastOrderSnapshot = await pickupRef
//             .orderBy('createdAt', descending: true)
//             .limit(1)
//             .get();

//         int lastOrderNumber = 1000;
//         if (lastOrderSnapshot.docs.isNotEmpty) {
//           final lastId = lastOrderSnapshot.docs.first.data()['orderId'];
//           if (lastId != null && lastId.toString().startsWith('#')) {
//             final number = int.tryParse(lastId.toString().substring(1));
//             if (number != null) lastOrderNumber = number;
//           }
//         }

//         final newOrderId = '#${lastOrderNumber + 1}';

//         final pickupData = {
//           'orderId': newOrderId,
//           'userId': userId,
//           'address': addressController.text.trim(),
//           'dateTime': Timestamp.fromDate(parsedDateTime),
//           'notes': notesController.text.trim(),
//           'clothesCount': clothesCount,
//           'status': 'Pending',
//           'createdAt': FieldValue.serverTimestamp(),
//         };

//         // Save to user's own collection
//         await pickupRef.add(pickupData);

//         // Save to global 'all_pickups' collection for admin
//         await FirebaseFirestore.instance
//             .collection('all_pickups')
//             .add(pickupData);

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Pickup Requested Successfully")),
//         );
//         Navigator.pop(context);
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error: ${e.toString()}")),
//         );
//       }
//     } else if (clothesCount <= 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select at least 1 cloth.")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: BackButton(color: Colors.black),
//         title: Text('Request Pickup', style: TextStyle(color: Colors.black)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Form(
//         key: _formKey,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               buildInputField(
//                 'Select Address',
//                 addressController,
//                 readOnly: true,
//                 validator: (value) =>
//                     value == null || value.isEmpty ? 'Address required' : null,
//               ),
//               const SizedBox(height: 12),
//               buildInputField(
//                 'Select Date & Time',
//                 dateTimeController,
//                 suffixIcon: Icons.calendar_today,
//                 readOnly: true,
//                 validator: (value) => value == null || value.isEmpty
//                     ? 'Date & Time required'
//                     : null,
//                 onTap: () async {
//                   final now = DateTime.now();
//                   final date = await showDatePicker(
//                     context: context,
//                     initialDate: now,
//                     firstDate: now,
//                     lastDate: DateTime(2100),
//                   );
//                   if (date != null) {
//                     final time = await showTimePicker(
//                       context: context,
//                       initialTime: TimeOfDay.now(),
//                     );
//                     if (time != null) {
//                       final selectedDateTime = DateTime(
//                         date.year,
//                         date.month,
//                         date.day,
//                         time.hour,
//                         time.minute,
//                       );
//                       if (selectedDateTime.isAfter(now)) {
//                         dateTimeController.text =
//                             selectedDateTime.toIso8601String();
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                               content: Text('Please select a valid time.')),
//                         );
//                       }
//                     }
//                   }
//                 },
//               ),
//               const SizedBox(height: 12),
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF1F5F9),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text('Number of Clothes',
//                         style: TextStyle(fontSize: 16)),
//                     Row(
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.remove_circle_outline),
//                           onPressed: () {
//                             if (clothesCount > 0) {
//                               setState(() {
//                                 clothesCount--;
//                               });
//                             }
//                           },
//                         ),
//                         Text(
//                           '$clothesCount',
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.add_circle_outline),
//                           onPressed: () {
//                             setState(() {
//                               clothesCount++;
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 12),
//               buildInputField(
//                 'Notes (optional)',
//                 notesController,
//                 maxLines: 3,
//               ),
//               const Spacer(),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _handleSubmit,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8)),
//                   ),
//                   child: const Text(
//                     'Request Pickup',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildInputField(
//     String hint,
//     TextEditingController controller, {
//     IconData? suffixIcon,
//     bool readOnly = false,
//     VoidCallback? onTap,
//     int maxLines = 1,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       readOnly: readOnly,
//       onTap: onTap,
//       maxLines: maxLines,
//       validator: validator,
//       decoration: InputDecoration(
//         hintText: hint,
//         suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
//         filled: true,
//         fillColor: const Color(0xFFF1F5F9),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RequestPickupScreen extends StatefulWidget {
  final String address;

  RequestPickupScreen({required this.address});

  @override
  _RequestPickupScreenState createState() => _RequestPickupScreenState();
}

class _RequestPickupScreenState extends State<RequestPickupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();
  late TextEditingController addressController;

  int clothesCount = 1;

  @override
  void initState() {
    super.initState();
    addressController = TextEditingController(text: widget.address);
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate() && clothesCount > 0) {
      try {
        final userId = FirebaseAuth.instance.currentUser!.uid;
        final DateTime parsedDateTime = DateTime.parse(dateTimeController.text);

        final pickupRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('pickups');

        final lastOrderSnapshot = await pickupRef
            .orderBy('createdAt', descending: true)
            .limit(1)
            .get();

        int lastOrderNumber = 1000;
        if (lastOrderSnapshot.docs.isNotEmpty) {
          final lastId = lastOrderSnapshot.docs.first.data()['orderId'];
          if (lastId != null && lastId.toString().startsWith('#')) {
            final number = int.tryParse(lastId.toString().substring(1));
            if (number != null) lastOrderNumber = number;
          }
        }

        final newOrderId = '#${lastOrderNumber + 1}';

        final pickupData = {
          'orderId': newOrderId,
          'userId': userId,
          'address': addressController.text.trim(),
          'dateTime': Timestamp.fromDate(parsedDateTime),
          'notes': notesController.text.trim(),
          'clothesCount': clothesCount,
          'status': 'Pending',
          'createdAt': FieldValue.serverTimestamp(), // Keep this only
        };

        // Save to user's own collection
        await pickupRef.add(pickupData);

        // Save to global 'all_pickups' collection for admin
        await FirebaseFirestore.instance
            .collection('all_pickups')
            .add(pickupData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pickup Requested Successfully")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    } else if (clothesCount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least 1 cloth.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        title: Text('Request Pickup', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildInputField(
                'Select Address',
                addressController,
                readOnly: true,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Address required' : null,
              ),
              const SizedBox(height: 12),
              buildInputField(
                'Select Date & Time',
                dateTimeController,
                suffixIcon: Icons.calendar_today,
                readOnly: true,
                validator: (value) => value == null || value.isEmpty
                    ? 'Date & Time required'
                    : null,
                onTap: () async {
                  final now = DateTime.now();
                  final date = await showDatePicker(
                    context: context,
                    initialDate: now,
                    firstDate: now,
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      final selectedDateTime = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );
                      if (selectedDateTime.isAfter(now)) {
                        dateTimeController.text =
                            selectedDateTime.toIso8601String();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Please select a valid time.')),
                        );
                      }
                    }
                  }
                },
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Number of Clothes',
                        style: TextStyle(fontSize: 16)),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            if (clothesCount > 0) {
                              setState(() {
                                clothesCount--;
                              });
                            }
                          },
                        ),
                        Text(
                          '$clothesCount',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: () {
                            setState(() {
                              clothesCount++;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              buildInputField(
                'Notes (optional)',
                notesController,
                maxLines: 3,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Request Pickup',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(
    String hint,
    TextEditingController controller, {
    IconData? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
        filled: true,
        fillColor: const Color(0xFFF1F5F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  /// Example cancel function (call this from history screen)
  Future<void> cancelPickup(String pickupId, String pickupDocId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('all_pickups')
        .doc(pickupId)
        .update({
      'status': 'CancelledByUser',
      'userCancelTime': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('pickups')
        .doc(pickupDocId)
        .update({
      'status': 'CancelledByUser',
      'userCancelTime': FieldValue.serverTimestamp(),
    });
  }
}
