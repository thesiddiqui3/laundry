import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laundry/app/views/login/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String selectedStatus = 'All';
  DateTime? startDate;
  DateTime? endDate;

  Future<Map<String, dynamic>?> _getUserDetails(String userId) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return doc.exists ? doc.data() : null;
  }

  Stream<QuerySnapshot> getPickupStream() {
    final collection = FirebaseFirestore.instance.collection('all_pickups');
    if (selectedStatus == 'All') {
      return collection
          .where('status', whereNotIn: ['CancelledByUser', 'CancelledByAdmin'])
          .orderBy('status')
          .orderBy('createdAt', descending: true)
          .snapshots();
    } else {
      return collection
          .where('status', isEqualTo: selectedStatus)
          .orderBy('createdAt', descending: true)
          .snapshots();
    }
  }

  Stream<QuerySnapshot> getCancelledStream(String status) {
    return FirebaseFirestore.instance
        .collection('all_pickups')
        .where('status', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getFilteredAllOrdersStream() {
    final collection = FirebaseFirestore.instance.collection('all_pickups');
    Query query = collection;

    if (selectedStatus != 'All') {
      query = query.where('status', isEqualTo: selectedStatus);
    }

    if (startDate != null && endDate != null) {
      query = query
          .where('createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate!))
          .where('createdAt',
              isLessThanOrEqualTo:
                  Timestamp.fromDate(endDate!.add(const Duration(days: 1))));
    }

    return query.orderBy('createdAt', descending: true).snapshots();
  }

  Stream<QuerySnapshot> getTodaysOrdersStream() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return FirebaseFirestore.instance
        .collection('all_pickups')
        .where('createdAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .orderBy('createdAt', descending: true) // decending order
        .snapshots();
  }

  Future<Map<String, int>> getCounts() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('all_pickups').get();
    int pending = 0,
        inProgress = 0,
        completed = 0,
        userCancelled = 0,
        adminCancelled = 0;

    for (var doc in snapshot.docs) {
      final status = doc['status'];
      if (status == 'Pending') pending++;
      if (status == 'InProgress') inProgress++;
      if (status == 'Completed') completed++;
      if (status == 'CancelledByUser') userCancelled++;
      if (status == 'CancelledByAdmin') adminCancelled++;
    }

    return {
      'Pending': pending,
      'InProgress': inProgress,
      'Completed': completed,
      'CancelledByUser': userCancelled,
      'CancelledByAdmin': adminCancelled,
      'Total': snapshot.docs.length,
    };
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0, // Today's Orders will be the landing tab
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Admin Dashboard"),
          backgroundColor: Colors.indigo,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Today's Orders"),
              // Tab(text: 'Status View'),
              Tab(text: 'All Orders'),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  _logoutAdmin(context);
                },
                icon: Icon(Icons.logout))
          ],
        ),
        body: TabBarView(
          children: [
            // --- Today's Orders Tab ---
            Column(
              children: [
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Text(
                        "Today's Orders",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      StreamBuilder<QuerySnapshot>(
                        stream: getTodaysOrdersStream(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Text(
                              "Loading...",
                              style: TextStyle(color: Colors.grey),
                            );
                          }
                          return Text(
                            "Total: ${snapshot.data!.docs.length}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(thickness: 1, height: 30),
                Expanded(
                  child: buildPickupList(getTodaysOrdersStream()),
                ),
              ],
            ),

            // --- All Orders Tab with Date Filter ---
            Column(
              children: [
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 3,
                        child: TextButton.icon(
                          onPressed: () async {
                            final picked = await showDateRangePicker(
                              context: context,
                              useRootNavigator: false,
                              builder: (context, child) {
                                return Center(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                        maxWidth: 350, maxHeight: 500),
                                    child: Material(
                                      color: Colors.white,
                                      elevation: 4,
                                      borderRadius: BorderRadius.circular(12),
                                      child: child!,
                                    ),
                                  ),
                                );
                              },
                              firstDate: DateTime(2023),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 1)),
                              initialDateRange:
                                  startDate != null && endDate != null
                                      ? DateTimeRange(
                                          start: startDate!, end: endDate!)
                                      : null,
                            );

                            if (picked != null) {
                              setState(() {
                                startDate = picked.start;
                                endDate = picked.end;
                              });
                            }
                          },
                          icon: const Icon(Icons.date_range),
                          label: Text(
                            (startDate != null && endDate != null)
                                ? "${DateFormat('dd MMM').format(startDate!)} - ${DateFormat('dd MMM').format(endDate!)}"
                                : "Filter by Date",
                          ),
                        ),
                      ),
                      if (startDate != null && endDate != null)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              startDate = null;
                              endDate = null;
                            });
                          },
                        ),
                      const SizedBox(width: 8),
                      Flexible(
                        flex: 4,
                        child: DropdownButtonFormField<String>(
                          value: selectedStatus,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedStatus = value!;
                            });
                          },
                          items: [
                            'All',
                            'Pending',
                            'InProgress',
                            'Completed',
                            'CancelledByUser',
                            'CancelledByAdmin',
                          ].map((status) {
                            return DropdownMenuItem(
                              value: status,
                              child: Text(status.replaceAll('By', ' by ')),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(thickness: 1, height: 30),
                Expanded(child: buildPickupList(getFilteredAllOrdersStream())),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPickupList(Stream<QuerySnapshot> stream) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return const Center(child: Text("Something went wrong"));
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());

        final data = snapshot.data!.docs;
        if (data.isEmpty)
          return const Center(child: Text("No pickup requests found"));

        return ListView.separated(
          itemCount: data.length,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final pickup = data[index];
            final docData = pickup.data() as Map<String, dynamic>;
            final dateTime = docData['dateTime'] as Timestamp;
            final formattedDate =
                DateFormat('dd MMM yyyy, hh:mm a').format(dateTime.toDate());
            final userId = docData['userId'];

            return FutureBuilder<Map<String, dynamic>?>(
              future: _getUserDetails(userId),
              builder: (context, userSnapshot) {
                final userData = userSnapshot.data;
                final status = docData['status'];

                return Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order ID: ${docData['orderId'] ?? 'N/A'}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 6),
                        if (userData != null) ...[
                          Text("Name: ${userData['name'] ?? 'N/A'}"),
                          Text("Phone: ${userData['phone'] ?? 'N/A'}"),
                        ] else
                          const Text("User: Not Found"),
                        const SizedBox(height: 4),
                        Text("Address: ${docData['address']}"),
                        Text("Pickup Date: $formattedDate"),
                        Text("Clothes Count: ${docData['clothesCount']}"),
                        if (docData['notes'] != null)
                          Text("Notes: ${docData['notes']}"),
                        const SizedBox(height: 8),
                        _buildStatusInfo(docData),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Status: ${status.replaceAll('By', ' by ')}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            if (![
                              'Completed',
                              'CancelledByAdmin',
                              'CancelledByUser'
                            ].contains(status))
                              _buildStatusActions(pickup.id, status, docData),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildStatusActions(
      String docId, String currentStatus, Map<String, dynamic> data) {
    return PopupMenuButton<String>(
      onSelected: (newStatus) async {
        final updateData = <String, dynamic>{'status': newStatus};

        if (newStatus == 'InProgress') {
          updateData['inProgressTime'] = FieldValue.serverTimestamp();
        } else if (newStatus == 'Completed') {
          updateData['completedTime'] = FieldValue.serverTimestamp();
        } else if (newStatus == 'CancelledByAdmin') {
          final controller = TextEditingController();
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Cancel Order'),
              content: TextField(
                controller: controller,
                decoration:
                    const InputDecoration(labelText: 'Reason for cancellation'),
                maxLines: 3,
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Confirm')),
              ],
            ),
          );
          if (confirmed == true && controller.text.trim().isNotEmpty) {
            updateData['adminCancelReason'] = controller.text.trim();
            updateData['cancelTimeByAdmin'] = FieldValue.serverTimestamp();
          } else {
            return;
          }
        }
        await FirebaseFirestore.instance
            .collection('all_pickups')
            .doc(docId)
            .update(updateData);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Order status updated to "$newStatus"'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
          setState(() {});
        }
      },
      itemBuilder: (context) {
        final options = <PopupMenuEntry<String>>[];

        if (currentStatus == 'Pending') {
          options.addAll([
            const PopupMenuItem(
                value: 'InProgress', child: Text('In Progress')),
            const PopupMenuItem(
                value: 'CancelledByAdmin', child: Text('Cancel')),
          ]);
        } else if (currentStatus == 'InProgress') {
          options.add(const PopupMenuItem(
              value: 'Completed', child: Text('Completed')));
        }

        return options;
      },
      icon: const Icon(Icons.edit, color: Colors.blue),
    );
  }

  Widget _buildStatusInfo(Map<String, dynamic> data) {
    final status = data['status'];
    final List<Widget> info = [];

    if (status == 'CancelledByUser' && data['userCancelReason'] != null) {
      info.add(Text("Reason: ${data['userCancelReason']}",
          style: const TextStyle(color: Colors.red)));
    }

    if (status == 'CancelledByAdmin' && data['adminCancelReason'] != null) {
      info.add(Text("Reason: ${data['adminCancelReason']}",
          style: const TextStyle(color: Colors.red)));
    }

    if (status == 'InProgress' && data['inProgressTime'] != null) {
      info.add(Text(
        "In Progress On: ${DateFormat('dd MMM yyyy, hh:mm a').format((data['inProgressTime'] as Timestamp).toDate())}",
        style: const TextStyle(color: Colors.orange),
      ));
    }

    if (status == 'Completed' && data['completedTime'] != null) {
      info.add(Text(
        "Completed On: ${DateFormat('dd MMM yyyy, hh:mm a').format((data['completedTime'] as Timestamp).toDate())}",
        style: const TextStyle(color: Colors.green),
      ));
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: info);
  }

  Future<void> _logoutAdmin(BuildContext context) async {
    try {
      // 1. Sign out from Firebase Auth
      await FirebaseAuth.instance.signOut();

      // 2. Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("is_admin_logged_in", false);

      // 3. Navigate back to login screen
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Logout failed: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
