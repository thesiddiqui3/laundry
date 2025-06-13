import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final dateTime = (order['dateTime'] as Timestamp).toDate();
    final formattedDate = DateFormat('MMMM d, yyyy – hh:mm a').format(dateTime);

    final createdAt = (order['createdAt'] as Timestamp?)?.toDate();
    final formattedCreatedAt = createdAt != null
        ? DateFormat('MMMM d, yyyy – hh:mm a').format(createdAt)
        : 'Not available';

    final cancelTimeByUser =
        (order['cancelTimeByUser'] as Timestamp?)?.toDate();
    final formattedCancelTimeByUser = cancelTimeByUser != null
        ? DateFormat('MMMM d, yyyy – hh:mm a').format(cancelTimeByUser)
        : null;

    final cancelTimeByAdmin =
        (order['cancelTimeByAdmin'] as Timestamp?)?.toDate();
    final formattedCancelTimeByAdmin = cancelTimeByAdmin != null
        ? DateFormat('MMMM d, yyyy – hh:mm a').format(cancelTimeByAdmin)
        : null;

    final inProgressTime = (order['inProgressTime'] as Timestamp?)?.toDate();
    final formattedInProgressTime = inProgressTime != null
        ? DateFormat('MMMM d, yyyy – hh:mm a').format(inProgressTime)
        : null;

    final completedTime = (order['completedTime'] as Timestamp?)?.toDate();
    final formattedCompletedTime = completedTime != null
        ? DateFormat('MMMM d, yyyy – hh:mm a').format(completedTime)
        : null;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: order['status'].toString().toLowerCase() == "pending"
                    ? Colors.blue[50]
                    : order['status']
                            .toString()
                            .toLowerCase()
                            .contains("cancel")
                        ? Colors.red[50]
                        : Colors.green[50],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                order['status'],
                style: TextStyle(
                  color: order['status'].toString().toLowerCase() == "pending"
                      ? Colors.blue
                      : order['status']
                              .toString()
                              .toLowerCase()
                              .contains("cancel")
                          ? Colors.red
                          : Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Order ID
            Text(
              "Order ${order['orderId']}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),

            // Pickup Time
            Text(
              "Pickup scheduled for: $formattedDate",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 4),

            // Requested Time
            Text(
              "Requested on: $formattedCreatedAt",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Timeline Card
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 24),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Order Status Timeline",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    _buildTimelineStep(
                      title: "Order Placed",
                      description: "Pickup request submitted",
                      time: formattedCreatedAt,
                      isActive: true,
                    ),
                    if (order['status'] == 'InProgress' ||
                        order['status'] == 'Completed')
                      _buildTimelineStep(
                        title: "Pickup In Progress",
                        description: "Your clothes are being picked up",
                        time: formattedInProgressTime ?? "",
                        isActive: true,
                      ),
                    if (order['status'] == 'Completed')
                      _buildTimelineStep(
                        title: "Order Completed",
                        description: "Laundry completed and returned",
                        time: formattedCompletedTime ?? "",
                        isActive: true,
                      ),
                    if (order['status'] == 'CancelledByUser')
                      _buildTimelineStep(
                        title: "Cancelled by You",
                        description:
                            order['userCancelReason'] ?? "No reason provided",
                        time: formattedCancelTimeByUser ?? "",
                        isActive: true,
                        isCancelled: true,
                      ),
                    if (order['status'] == 'CancelledByAdmin')
                      _buildTimelineStep(
                        title: "Cancelled by Admin",
                        description:
                            order['adminCancelReason'] ?? "No reason provided",
                        time: formattedCancelTimeByAdmin ?? "",
                        isActive: true,
                        isCancelled: true,
                      ),
                  ],
                ),
              ),
            ),

            // User Name
            // Text(
            //   order['name'] ?? "Customer Name",
            //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            // ),
            // User Name and Phone
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(order['userId'])
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Text("User info not available");
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>;
                final userName = userData['name'] ?? 'Unknown User';
                final phone = userData['phone'] ?? 'No phone';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      phone,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),

            // Address
            const Text("Pickup Address",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(order['address'] ?? "No address",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),

            // Notes
            const Text("Notes", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(order['notes'] ?? "Leave at the front desk",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),

            // Admin Cancel Reason
            if (order['status'] == 'CancelledByAdmin' &&
                order['adminCancelReason'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Cancellation Reason",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red)),
                  Text(order['adminCancelReason'],
                      style: const TextStyle(fontSize: 16, color: Colors.red)),
                ],
              ),

            const Spacer(),

            // Cancel Button
            if (order['status'].toString().toLowerCase() == 'pending')
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final reason = await _showCancelDialog(context);
                    if (reason == null) return;

                    final uid = order['userId'];
                    final orderId = order['orderId'];
                    final cancelTime = Timestamp.now();

                    try {
                      // Update user's collection
                      final userPickupQuery = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .collection('pickups')
                          .where('orderId', isEqualTo: orderId)
                          .limit(1)
                          .get();

                      if (userPickupQuery.docs.isNotEmpty) {
                        await userPickupQuery.docs.first.reference.update({
                          'status': 'CancelledByUser',
                          'userCancelReason': reason,
                          'cancelTimeByUser': cancelTime,
                        });
                      }

                      // Update global collection
                      final globalPickupQuery = await FirebaseFirestore.instance
                          .collection('all_pickups')
                          .where('orderId', isEqualTo: orderId)
                          .limit(1)
                          .get();

                      if (globalPickupQuery.docs.isNotEmpty) {
                        await globalPickupQuery.docs.first.reference.update({
                          'status': 'CancelledByUser',
                          'userCancelReason': reason,
                          'cancelTimeByUser': cancelTime,
                        });
                      }

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Pickup cancelled by user")),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error cancelling: $e")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Cancel Pickup",
                      style: TextStyle(fontSize: 16)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showCancelDialog(BuildContext context) async {
    TextEditingController reasonController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancel Pickup"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Do you want to give a reason? (Optional)"),
            const SizedBox(height: 8),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: "Enter reason (optional)",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text("Close"),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(context, reasonController.text.trim()),
            child: const Text("Confirm Cancel"),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required String description,
    required String time,
    bool isActive = false,
    bool isCancelled = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            const SizedBox(height: 4),
            Icon(
              Icons.radio_button_checked,
              color: isCancelled
                  ? Colors.red
                  : isActive
                      ? Colors.green
                      : Colors.grey,
              size: 20,
            ),
            Container(
              width: 2,
              height: 40,
              color: Colors.grey[300],
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(time,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCancelled ? Colors.red : Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isCancelled ? Colors.red[300] : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
