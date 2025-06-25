// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
// import 'package:laundry/app/views/order/order_details_view.dart';

// class OrdersScreen extends StatelessWidget {
//   const OrdersScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 6,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Orders"),
//           bottom: const TabBar(
//             isScrollable: true,
//             labelColor: Colors.white,
//             unselectedLabelColor: Colors.grey,
//             indicatorColor: Colors.white,
//             tabs: [
//               Tab(text: "All Orders"),
//               Tab(text: "Pending"),
//               Tab(text: "In Progress"),
//               Tab(text: "Completed"),
//               Tab(text: "Cancelled by User"),
//               Tab(text: "Cancelled by Admin"),
//             ],
//           ),
//         ),
//         body: const TabBarView(
//           children: [
//             OrdersList(status: "All"),
//             OrdersList(status: "Pending"),
//             OrdersList(status: "InProgress"),
//             OrdersList(status: "Completed"),
//             OrdersList(status: "cancelByUser"),
//             OrdersList(status: "cancelByAdmin"),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class OrdersList extends StatelessWidget {
//   final String status;

//   const OrdersList({super.key, required this.status});

//   Stream<QuerySnapshot<Map<String, dynamic>>> getPickupStream() {
//     final uid = FirebaseAuth.instance.currentUser!.uid;
//     final collection = FirebaseFirestore.instance
//         .collection('all_pickups')
//         .where('userId', isEqualTo: uid);

//     if (status == "All") {
//       return collection.orderBy('dateTime', descending: true).snapshots();
//     }

//     return collection
//         .where('status', isEqualTo: status)
//         .orderBy('dateTime', descending: true)
//         .snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: getPickupStream(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return const Center(child: Text("Something went wrong."));
//         }

//         final docs = snapshot.data?.docs ?? [];

//         if (docs.isEmpty) {
//           return const Center(child: Text("No orders found."));
//         }

//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: docs.length,
//           itemBuilder: (context, index) {
//             final order = docs[index].data() as Map<String, dynamic>;
//             order['docId'] = docs[index].id;
//             order['userId'] = FirebaseAuth.instance.currentUser!.uid;
//             final formattedDate = DateFormat('MMMM d, yyyy').format(
//               (order['dateTime'] as Timestamp).toDate(),
//             );

//             return GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => OrderDetailsScreen(order: order),
//                   ),
//                 );
//               },
//               child: Card(
//                 margin: const EdgeInsets.only(bottom: 12),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Order ${order['orderId'] ?? 'N/A'}",
//                           style: const TextStyle(fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 4),
//                       Text(formattedDate),
//                       const SizedBox(height: 4),
//                       Text(order['address'] ?? ''),
//                       const SizedBox(height: 4),
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: Text(
//                           getStatusText(order['status']),
//                           style: TextStyle(
//                             color: getStatusColor(order['status']),
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   String getStatusText(String status) {
//     switch (status) {
//       case "cancelByUser":
//         return "Cancelled by User";
//       case "cancelByAdmin":
//         return "Cancelled by Admin";
//       case "InProgress":
//         return "In Progress";
//       case "Completed":
//         return "Completed";
//       case "Pending":
//       default:
//         return status;
//     }
//   }

//   Color getStatusColor(String status) {
//     switch (status) {
//       case "cancelByUser":
//       case "cancelByAdmin":
//         return Colors.red;
//       case "Completed":
//         return Colors.green;
//       case "InProgress":
//         return Colors.orange;
//       case "Pending":
//         return Colors.blue;
//       default:
//         return Colors.grey;
//     }
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:laundry/app/views/order/order_details_view.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Orders"),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: "All Orders"),
              Tab(text: "Pending"),
              Tab(text: "In Progress"),
              Tab(text: "Completed"),
              Tab(text: "Cancelled by User"),
              Tab(text: "Cancelled by Admin"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            OrdersList(status: "All"),
            OrdersList(status: "Pending"),
            OrdersList(status: "InProgress"),
            OrdersList(status: "Completed"),
            OrdersList(status: "CancelledByUser"),
            OrdersList(status: "CancelledByAdmin"),
          ],
        ),
      ),
    );
  }
}

class OrdersList extends StatelessWidget {
  final String status;

  const OrdersList({super.key, required this.status});

  Stream<QuerySnapshot<Map<String, dynamic>>> getPickupStream() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final collection = FirebaseFirestore.instance
        .collection('all_pickups')
        .where('userId', isEqualTo: uid);

    if (status == "All") {
      return collection.orderBy('createdAt', descending: true).snapshots();
    }

    return collection
        .where('status', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
  

  @override
  Widget build(BuildContext context) {
    
    return StreamBuilder<QuerySnapshot>(
      stream: getPickupStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong."));
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return const Center(child: Text("No orders found."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final order = docs[index].data() as Map<String, dynamic>;
            log(order.toString());
            order['docId'] = docs[index].id;
            order['userId'] = FirebaseAuth.instance.currentUser!.uid;
            
            // Format both the pickup date and creation date
            final pickupDate = DateFormat('MMMM d, yyyy').format(
              (order['dateTime'] as Timestamp).toDate(),
            );
            final createdAt = (order['createdAt'] as Timestamp).toDate();
            final createdDateFormatted = DateFormat('MMMM d, yyyy - hh:mm a').format(createdAt);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrderDetailsScreen(order: order),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Order ${order['orderId'] ?? 'N/A'}",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text("Pickup Date: $pickupDate"),
                      const SizedBox(height: 4),
                      Text("Ordered On: $createdDateFormatted"),
                      const SizedBox(height: 4),
                      Text(order['address'] ?? ''),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          getStatusText(order['status']),
                          style: TextStyle(
                            color: getStatusColor(order['status']),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String getStatusText(String status) {
    switch (status) {
      case "cancelByUser":
        return "Cancelled by User";
      case "cancelByAdmin":
        return "Cancelled by Admin";
      case "InProgress":
        return "In Progress";
      case "Completed":
        return "Completed";
      case "Pending":
      default:
        return status;
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "cancelByUser":
      case "cancelByAdmin":
        return Colors.red;
      case "Completed":
        return Colors.green;
      case "InProgress":
        return Colors.orange;
      case "Pending":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}