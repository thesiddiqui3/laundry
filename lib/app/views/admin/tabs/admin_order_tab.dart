import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminOrdersTab extends StatefulWidget {
  const AdminOrdersTab({super.key});

  @override
  State<AdminOrdersTab> createState() => _AdminOrdersTabState();
}

class _AdminOrdersTabState extends State<AdminOrdersTab> {
  String selectedStatus = 'All';
  DateTime? startDate;
  DateTime? endDate;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  Future<Map<String, dynamic>?> _getUserDetails(String userId) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return doc.exists ? doc.data() : null;
  }

  Future<void> _refreshData() async {
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 500));
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
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Column(
        children: [
          Container(
            color: Colors.indigo,
            child: const TabBar(
              tabs: [
                Tab(text: "Today's Orders"),
                Tab(text: 'All Orders'),
              ],
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by Order ID...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          setState(() {
                            searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim();
                });
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _refreshData,
                  child: Column(
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
                                // Count filtered results
                                final count = snapshot.data!.docs.where((doc) {
                                  final data =
                                      doc.data() as Map<String, dynamic>;
                                  final orderId = data['orderId']
                                          ?.toString()
                                          .toLowerCase() ??
                                      '';
                                  return searchQuery.isEmpty ||
                                      orderId
                                          .contains(searchQuery.toLowerCase());
                                }).length;
                                return Text(
                                  "Total: $count",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
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
                ),
                RefreshIndicator(
                  onRefresh: _refreshData,
                  child: Column(
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
                                    firstDate: DateTime(2023),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 1)),
                                    initialDateRange:
                                        startDate != null && endDate != null
                                            ? DateTimeRange(
                                                start: startDate!,
                                                end: endDate!)
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
                                    child:
                                        Text(status.replaceAll('By', ' by ')),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(thickness: 1, height: 30),
                      Expanded(
                        child: buildPickupList(getFilteredAllOrdersStream()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPickupList(Stream<QuerySnapshot> stream) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Filter documents based on search query
        final filteredDocs = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final orderId = data['orderId']?.toString().toLowerCase() ?? '';
          return searchQuery.isEmpty ||
              orderId.contains(searchQuery.toLowerCase());
        }).toList();

        if (filteredDocs.isEmpty) {
          return Center(
            child: Text(
              searchQuery.isEmpty
                  ? "No pickup requests found"
                  : "No orders match your search",
              style: const TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.separated(
          itemCount: filteredDocs.length,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final pickup = filteredDocs[index];
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
}
