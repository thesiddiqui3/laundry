// // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // // // // // // import 'package:intl/intl.dart';

// // // // // // // // class AdminReportsTab extends StatefulWidget {
// // // // // // // //   const AdminReportsTab({super.key});

// // // // // // // //   @override
// // // // // // // //   State<AdminReportsTab> createState() => _AdminReportsTabState();
// // // // // // // // }

// // // // // // // // class _AdminReportsTabState extends State<AdminReportsTab> {
// // // // // // // //   DateTime? startDate;
// // // // // // // //   DateTime? endDate;
// // // // // // // //   bool isLoading = false;
// // // // // // // //   List<Map<String, dynamic>> reportData = [];

// // // // // // // //   Future<void> generateReport() async {
// // // // // // // //     setState(() => isLoading = true);
// // // // // // // //     reportData.clear();

// // // // // // // //     if (startDate == null || endDate == null) {
// // // // // // // //       setState(() => isLoading = false);
// // // // // // // //       return;
// // // // // // // //     }

// // // // // // // //     final days = endDate!.difference(startDate!).inDays;

// // // // // // // //     for (int i = 0; i <= days; i++) {
// // // // // // // //       final currentDate = startDate!.add(Duration(days: i));
// // // // // // // //       final nextDate = currentDate.add(const Duration(days: 1));

// // // // // // // //       final snapshot = await FirebaseFirestore.instance
// // // // // // // //           .collection('all_pickups')
// // // // // // // //           .where('createdAt',
// // // // // // // //               isGreaterThanOrEqualTo: Timestamp.fromDate(currentDate))
// // // // // // // //           .where('createdAt', isLessThan: Timestamp.fromDate(nextDate))
// // // // // // // //           .get();

// // // // // // // //       reportData.add({
// // // // // // // //         'date': DateFormat('MMM dd').format(currentDate),
// // // // // // // //         'orders': snapshot.docs.length,
// // // // // // // //       });
// // // // // // // //     }

// // // // // // // //     setState(() => isLoading = false);
// // // // // // // //   }

// // // // // // // //   @override
// // // // // // // //   Widget build(BuildContext context) {
// // // // // // // //     return Padding(
// // // // // // // //       padding: const EdgeInsets.all(16.0),
// // // // // // // //       child: Column(
// // // // // // // //         children: [
// // // // // // // //           Row(
// // // // // // // //             children: [
// // // // // // // //               Expanded(
// // // // // // // //                 child: TextButton.icon(
// // // // // // // //                   onPressed: () async {
// // // // // // // //                     final picked = await showDateRangePicker(
// // // // // // // //                       context: context,
// // // // // // // //                       firstDate: DateTime(2023),
// // // // // // // //                       lastDate: DateTime.now(),
// // // // // // // //                     );
// // // // // // // //                     if (picked != null) {
// // // // // // // //                       setState(() {
// // // // // // // //                         startDate = picked.start;
// // // // // // // //                         endDate = picked.end;
// // // // // // // //                       });
// // // // // // // //                     }
// // // // // // // //                   },
// // // // // // // //                   icon: const Icon(Icons.date_range),
// // // // // // // //                   label: Text(
// // // // // // // //                     startDate == null || endDate == null
// // // // // // // //                         ? 'Select Date Range'
// // // // // // // //                         : '${DateFormat('MMM dd').format(startDate!)} - ${DateFormat('MMM dd').format(endDate!)}',
// // // // // // // //                   ),
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //             ],
// // // // // // // //           ),
// // // // // // // //           ElevatedButton(
// // // // // // // //             onPressed: generateReport,
// // // // // // // //             child: const Text('Generate Report'),
// // // // // // // //           ),
// // // // // // // //           const SizedBox(height: 20),
// // // // // // // //           if (isLoading)
// // // // // // // //             const CircularProgressIndicator()
// // // // // // // //           else if (reportData.isNotEmpty)
// // // // // // // //             Expanded(
// // // // // // // //               child: ListView(
// // // // // // // //                 children: [
// // // // // // // //                   const Text('Order Report',
// // // // // // // //                       style:
// // // // // // // //                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// // // // // // // //                   const SizedBox(height: 10),
// // // // // // // //                   Table(
// // // // // // // //                     border: TableBorder.all(),
// // // // // // // //                     children: [
// // // // // // // //                       const TableRow(
// // // // // // // //                         children: [
// // // // // // // //                           Padding(
// // // // // // // //                             padding: EdgeInsets.all(8.0),
// // // // // // // //                             child: Text('Date',
// // // // // // // //                                 style: TextStyle(fontWeight: FontWeight.bold)),
// // // // // // // //                           ),
// // // // // // // //                           Padding(
// // // // // // // //                             padding: EdgeInsets.all(8.0),
// // // // // // // //                             child: Text('Orders',
// // // // // // // //                                 style: TextStyle(fontWeight: FontWeight.bold)),
// // // // // // // //                           ),
// // // // // // // //                         ],
// // // // // // // //                       ),
// // // // // // // //                       ...reportData
// // // // // // // //                           .map((data) => TableRow(
// // // // // // // //                                 children: [
// // // // // // // //                                   Padding(
// // // // // // // //                                     padding: const EdgeInsets.all(8.0),
// // // // // // // //                                     child: Text(data['date']),
// // // // // // // //                                   ),
// // // // // // // //                                   Padding(
// // // // // // // //                                     padding: const EdgeInsets.all(8.0),
// // // // // // // //                                     child: Text(data['orders'].toString()),
// // // // // // // //                                   ),
// // // // // // // //                                 ],
// // // // // // // //                               ))
// // // // // // // //                           .toList(),
// // // // // // // //                     ],
// // // // // // // //                   ),
// // // // // // // //                 ],
// // // // // // // //               ),
// // // // // // // //             ),
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // // }
// // // // // // // import 'package:flutter/material.dart';
// // // // // // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // // // // // import 'package:intl/intl.dart';

// // // // // // // class AdminReportsTab extends StatefulWidget {
// // // // // // //   const AdminReportsTab({super.key});

// // // // // // //   @override
// // // // // // //   State<AdminReportsTab> createState() => _AdminReportsTabState();
// // // // // // // }

// // // // // // // class _AdminReportsTabState extends State<AdminReportsTab> {
// // // // // // //   DateTime? startDate;
// // // // // // //   DateTime? endDate;
// // // // // // //   bool isLoading = false;
// // // // // // //   List<Map<String, dynamic>> reportData = [];
// // // // // // //   int totalOrders = 0;
// // // // // // //   int pendingOrders = 0;
// // // // // // //   int cancelledOrders = 0;
// // // // // // //   int completedOrders = 0;

// // // // // // //   Future<void> generateReport() async {
// // // // // // //     setState(() {
// // // // // // //       isLoading = true;
// // // // // // //       reportData.clear();
// // // // // // //       totalOrders = 0;
// // // // // // //       pendingOrders = 0;
// // // // // // //       cancelledOrders = 0;
// // // // // // //       completedOrders = 0;
// // // // // // //     });

// // // // // // //     if (startDate == null || endDate == null) {
// // // // // // //       setState(() => isLoading = false);
// // // // // // //       return;
// // // // // // //     }

// // // // // // //     final days = endDate!.difference(startDate!).inDays;

// // // // // // //     for (int i = 0; i <= days; i++) {
// // // // // // //       final currentDate = startDate!.add(Duration(days: i));
// // // // // // //       final nextDate = currentDate.add(const Duration(days: 1));

// // // // // // //       // Get all orders for the day
// // // // // // //       final allOrdersSnapshot = await FirebaseFirestore.instance
// // // // // // //           .collection('all_pickups')
// // // // // // //           .where('createdAt',
// // // // // // //               isGreaterThanOrEqualTo: Timestamp.fromDate(currentDate))
// // // // // // //           .where('createdAt', isLessThan: Timestamp.fromDate(nextDate))
// // // // // // //           .get();

// // // // // // //       // Get pending orders
// // // // // // //       final pendingSnapshot = await FirebaseFirestore.instance
// // // // // // //           .collection('all_pickups')
// // // // // // //           .where('createdAt',
// // // // // // //               isGreaterThanOrEqualTo: Timestamp.fromDate(currentDate))
// // // // // // //           .where('createdAt', isLessThan: Timestamp.fromDate(nextDate))
// // // // // // //           .where('status', isEqualTo: 'pending')
// // // // // // //           .get();

// // // // // // //       // Get cancelled orders
// // // // // // //       final cancelledSnapshot = await FirebaseFirestore.instance
// // // // // // //           .collection('all_pickups')
// // // // // // //           .where('createdAt',
// // // // // // //               isGreaterThanOrEqualTo: Timestamp.fromDate(currentDate))
// // // // // // //           .where('createdAt', isLessThan: Timestamp.fromDate(nextDate))
// // // // // // //           .where('status', isEqualTo: 'cancelled')
// // // // // // //           .get();

// // // // // // //       // Get completed orders
// // // // // // //       final completedSnapshot = await FirebaseFirestore.instance
// // // // // // //           .collection('all_pickups')
// // // // // // //           .where('createdAt',
// // // // // // //               isGreaterThanOrEqualTo: Timestamp.fromDate(currentDate))
// // // // // // //           .where('createdAt', isLessThan: Timestamp.fromDate(nextDate))
// // // // // // //           .where('status', isEqualTo: 'completed')
// // // // // // //           .get();

// // // // // // //       final total = allOrdersSnapshot.docs.length;
// // // // // // //       final pending = pendingSnapshot.docs.length;
// // // // // // //       final cancelled = cancelledSnapshot.docs.length;
// // // // // // //       final completed = completedSnapshot.docs.length;

// // // // // // //       reportData.add({
// // // // // // //         'date': DateFormat('MMM dd, yyyy').format(currentDate),
// // // // // // //         'total': total,
// // // // // // //         'pending': pending,
// // // // // // //         'cancelled': cancelled,
// // // // // // //         'completed': completed,
// // // // // // //       });

// // // // // // //       totalOrders += total;
// // // // // // //       pendingOrders += pending;
// // // // // // //       cancelledOrders += cancelled;
// // // // // // //       completedOrders += completed;
// // // // // // //     }

// // // // // // //     setState(() => isLoading = false);
// // // // // // //   }

// // // // // // //   @override
// // // // // // //   Widget build(BuildContext context) {
// // // // // // //     return Padding(
// // // // // // //       padding: const EdgeInsets.all(16.0),
// // // // // // //       child: Column(
// // // // // // //         children: [
// // // // // // //           Row(
// // // // // // //             children: [
// // // // // // //               Expanded(
// // // // // // //                 child: TextButton.icon(
// // // // // // //                   onPressed: () async {
// // // // // // //                     final picked = await showDateRangePicker(
// // // // // // //                       context: context,
// // // // // // //                       firstDate: DateTime(2023),
// // // // // // //                       lastDate: DateTime.now(),
// // // // // // //                     );
// // // // // // //                     if (picked != null) {
// // // // // // //                       setState(() {
// // // // // // //                         startDate = picked.start;
// // // // // // //                         endDate = picked.end;
// // // // // // //                       });
// // // // // // //                     }
// // // // // // //                   },
// // // // // // //                   icon: const Icon(Icons.date_range),
// // // // // // //                   label: Text(
// // // // // // //                     startDate == null || endDate == null
// // // // // // //                         ? 'Select Date Range'
// // // // // // //                         : '${DateFormat('MMM dd, yyyy').format(startDate!)} - ${DateFormat('MMM dd, yyyy').format(endDate!)}',
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             ],
// // // // // // //           ),
// // // // // // //           ElevatedButton(
// // // // // // //             onPressed: generateReport,
// // // // // // //             child: const Text('Generate Report'),
// // // // // // //           ),
// // // // // // //           const SizedBox(height: 20),
// // // // // // //           if (isLoading)
// // // // // // //             const CircularProgressIndicator()
// // // // // // //           else if (reportData.isNotEmpty) ...[
// // // // // // //             // Summary Cards
// // // // // // //             Wrap(
// // // // // // //               spacing: 16,
// // // // // // //               runSpacing: 16,
// // // // // // //               children: [
// // // // // // //                 _buildSummaryCard('Total Orders', totalOrders, Colors.blue),
// // // // // // //                 _buildSummaryCard('Pending', pendingOrders, Colors.orange),
// // // // // // //                 _buildSummaryCard('Cancelled', cancelledOrders, Colors.red),
// // // // // // //                 _buildSummaryCard('Completed', completedOrders, Colors.green),
// // // // // // //               ],
// // // // // // //             ),
// // // // // // //             const SizedBox(height: 20),
// // // // // // //             // Detailed Report
// // // // // // //             Expanded(
// // // // // // //               child: ListView(
// // // // // // //                 children: [
// // // // // // //                   const Text('Detailed Order Report',
// // // // // // //                       style:
// // // // // // //                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// // // // // // //                   const SizedBox(height: 10),
// // // // // // //                   SingleChildScrollView(
// // // // // // //                     scrollDirection: Axis.horizontal,
// // // // // // //                     child: Table(
// // // // // // //                       border: TableBorder.all(),
// // // // // // //                       columnWidths: const {
// // // // // // //                         0: FixedColumnWidth(120),
// // // // // // //                         1: FixedColumnWidth(80),
// // // // // // //                         2: FixedColumnWidth(80),
// // // // // // //                         3: FixedColumnWidth(80),
// // // // // // //                         4: FixedColumnWidth(80),
// // // // // // //                       },
// // // // // // //                       children: [
// // // // // // //                         TableRow(
// // // // // // //                           decoration: BoxDecoration(
// // // // // // //                             color: Colors.grey[200],
// // // // // // //                           ),
// // // // // // //                           children: [
// // // // // // //                             _buildHeaderCell('Date'),
// // // // // // //                             _buildHeaderCell('Total'),
// // // // // // //                             _buildHeaderCell('Pending'),
// // // // // // //                             _buildHeaderCell('Cancelled'),
// // // // // // //                             _buildHeaderCell('Completed'),
// // // // // // //                           ],
// // // // // // //                         ),
// // // // // // //                         ...reportData
// // // // // // //                             .map((data) => TableRow(
// // // // // // //                                   children: [
// // // // // // //                                     _buildDataCell(data['date']),
// // // // // // //                                     _buildDataCell(data['total'].toString()),
// // // // // // //                                     _buildDataCell(data['pending'].toString()),
// // // // // // //                                     _buildDataCell(data['cancelled'].toString()),
// // // // // // //                                     _buildDataCell(data['completed'].toString()),
// // // // // // //                                   ],
// // // // // // //                                 ))
// // // // // // //                             .toList(),
// // // // // // //                         // Totals row
// // // // // // //                         TableRow(
// // // // // // //                           decoration: BoxDecoration(
// // // // // // //                             color: Colors.grey[100],
// // // // // // //                           ),
// // // // // // //                           children: [
// // // // // // //                             _buildHeaderCell('TOTAL'),
// // // // // // //                             _buildHeaderCell(totalOrders.toString()),
// // // // // // //                             _buildHeaderCell(pendingOrders.toString()),
// // // // // // //                             _buildHeaderCell(cancelledOrders.toString()),
// // // // // // //                             _buildHeaderCell(completedOrders.toString()),
// // // // // // //                           ],
// // // // // // //                         ),
// // // // // // //                       ],
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                   const SizedBox(height: 20),
// // // // // // //                   // Export button
// // // // // // //                   ElevatedButton.icon(
// // // // // // //                     onPressed: () {
// // // // // // //                       // TODO: Implement export functionality
// // // // // // //                       ScaffoldMessenger.of(context).showSnackBar(
// // // // // // //                         const SnackBar(
// // // // // // //                             content: Text('Export functionality coming soon')),
// // // // // // //                       );
// // // // // // //                     },
// // // // // // //                     icon: const Icon(Icons.download),
// // // // // // //                     label: const Text('Export Report'),
// // // // // // //                   ),
// // // // // // //                 ],
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ],
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Widget _buildSummaryCard(String title, int value, Color color) {
// // // // // // //     return Card(
// // // // // // //       color: color.withOpacity(0.1),
// // // // // // //       child: Padding(
// // // // // // //         padding: const EdgeInsets.all(16.0),
// // // // // // //         child: Column(
// // // // // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //           children: [
// // // // // // //             Text(
// // // // // // //               title,
// // // // // // //               style: TextStyle(
// // // // // // //                 color: color,
// // // // // // //                 fontSize: 14,
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //             const SizedBox(height: 8),
// // // // // // //             Text(
// // // // // // //               value.toString(),
// // // // // // //               style: TextStyle(
// // // // // // //                 color: color,
// // // // // // //                 fontSize: 24,
// // // // // // //                 fontWeight: FontWeight.bold,
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ],
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Widget _buildHeaderCell(String text) {
// // // // // // //     return Padding(
// // // // // // //       padding: const EdgeInsets.all(8.0),
// // // // // // //       child: Text(
// // // // // // //         text,
// // // // // // //         style: const TextStyle(fontWeight: FontWeight.bold),
// // // // // // //         textAlign: TextAlign.center,
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Widget _buildDataCell(String text) {
// // // // // // //     return Padding(
// // // // // // //       padding: const EdgeInsets.all(8.0),
// // // // // // //       child: Text(
// // // // // // //         text,
// // // // // // //         textAlign: TextAlign.center,
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // // }
// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // // // // import 'package:intl/intl.dart';

// // // // // // class AdminReportsTab extends StatefulWidget {
// // // // // //   const AdminReportsTab({super.key});

// // // // // //   @override
// // // // // //   State<AdminReportsTab> createState() => _AdminReportsTabState();
// // // // // // }

// // // // // // class _AdminReportsTabState extends State<AdminReportsTab> {
// // // // // //   DateTime? startDate;
// // // // // //   DateTime? endDate;
// // // // // //   bool isLoading = false;
// // // // // //   String? errorMessage;
// // // // // //   List<Map<String, dynamic>> reportData = [];
// // // // // //   int totalOrders = 0;
// // // // // //   int pendingOrders = 0;
// // // // // //   int cancelledOrders = 0;
// // // // // //   int completedOrders = 0;

// // // // // //   Future<void> generateReport() async {
// // // // // //     setState(() {
// // // // // //       isLoading = true;
// // // // // //       errorMessage = null;
// // // // // //       reportData.clear();
// // // // // //       totalOrders = 0;
// // // // // //       pendingOrders = 0;
// // // // // //       cancelledOrders = 0;
// // // // // //       completedOrders = 0;
// // // // // //     });

// // // // // //     if (startDate == null || endDate == null) {
// // // // // //       setState(() {
// // // // // //         isLoading = false;
// // // // // //         errorMessage = 'Please select a date range';
// // // // // //       });
// // // // // //       return;
// // // // // //     }

// // // // // //     try {
// // // // // //       final days = endDate!.difference(startDate!).inDays;

// // // // // //       // Limit to 30 days to prevent excessive queries
// // // // // //       if (days > 30) {
// // // // // //         setState(() {
// // // // // //           isLoading = false;
// // // // // //           errorMessage = 'Please select a date range of 30 days or less';
// // // // // //         });
// // // // // //         return;
// // // // // //       }

// // // // // //       for (int i = 0; i <= days; i++) {
// // // // // //         final currentDate = startDate!.add(Duration(days: i));
// // // // // //         final nextDate = currentDate.add(const Duration(days: 1));

// // // // // //         // Get all orders for the day
// // // // // //         final allOrdersSnapshot = await _safeQuery(
// // // // // //           FirebaseFirestore.instance
// // // // // //               .collection('all_pickups')
// // // // // //               .where('createdAt',
// // // // // //                   isGreaterThanOrEqualTo: Timestamp.fromDate(currentDate))
// // // // // //               .where('createdAt', isLessThan: Timestamp.fromDate(nextDate)),
// // // // // //           'all_orders_query',
// // // // // //         );

// // // // // //         // Get pending orders
// // // // // //         final pendingSnapshot = await _safeQuery(
// // // // // //           FirebaseFirestore.instance
// // // // // //               .collection('all_pickups')
// // // // // //               .where('createdAt',
// // // // // //                   isGreaterThanOrEqualTo: Timestamp.fromDate(currentDate))
// // // // // //               .where('createdAt', isLessThan: Timestamp.fromDate(nextDate))
// // // // // //               .where('status', isEqualTo: 'pending'),
// // // // // //           'pending_orders_query',
// // // // // //         );

// // // // // //         // Get cancelled orders
// // // // // //         final cancelledSnapshot = await _safeQuery(
// // // // // //           FirebaseFirestore.instance
// // // // // //               .collection('all_pickups')
// // // // // //               .where('createdAt',
// // // // // //                   isGreaterThanOrEqualTo: Timestamp.fromDate(currentDate))
// // // // // //               .where('createdAt', isLessThan: Timestamp.fromDate(nextDate))
// // // // // //               .where('status', isEqualTo: 'cancelled'),
// // // // // //           'cancelled_orders_query',
// // // // // //         );

// // // // // //         // Get completed orders
// // // // // //         final completedSnapshot = await _safeQuery(
// // // // // //           FirebaseFirestore.instance
// // // // // //               .collection('all_pickups')
// // // // // //               .where('createdAt',
// // // // // //                   isGreaterThanOrEqualTo: Timestamp.fromDate(currentDate))
// // // // // //               .where('createdAt', isLessThan: Timestamp.fromDate(nextDate))
// // // // // //               .where('status', isEqualTo: 'completed'),
// // // // // //           'completed_orders_query',
// // // // // //         );

// // // // // //         final total = allOrdersSnapshot.docs.length;
// // // // // //         final pending = pendingSnapshot.docs.length;
// // // // // //         final cancelled = cancelledSnapshot.docs.length;
// // // // // //         final completed = completedSnapshot.docs.length;

// // // // // //         reportData.add({
// // // // // //           'date': DateFormat('MMM dd, yyyy').format(currentDate),
// // // // // //           'total': total,
// // // // // //           'pending': pending,
// // // // // //           'cancelled': cancelled,
// // // // // //           'completed': completed,
// // // // // //         });

// // // // // //         totalOrders += total;
// // // // // //         pendingOrders += pending;
// // // // // //         cancelledOrders += cancelled;
// // // // // //         completedOrders += completed;
// // // // // //       }
// // // // // //     } catch (e) {
// // // // // //       setState(() {
// // // // // //         errorMessage = 'Error generating report: ${e.toString()}';
// // // // // //       });
// // // // // //     } finally {
// // // // // //       setState(() => isLoading = false);
// // // // // //     }
// // // // // //   }

// // // // // //   Future<QuerySnapshot> _safeQuery(Query query, String queryType) async {
// // // // // //     try {
// // // // // //       return await query.get();
// // // // // //     } on FirebaseException catch (e) {
// // // // // //       if (e.code == 'failed-precondition') {
// // // // // //         setState(() {
// // // // // //           errorMessage = '''Query requires an index.
// // // // // // Please create the index in Firebase Console for query type: $queryType
// // // // // // Error details: ${e.message}''';
// // // // // //         });
// // // // // //       }
// // // // // //       rethrow;
// // // // // //     }
// // // // // //   }

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     return Padding(
// // // // // //       padding: const EdgeInsets.all(16.0),
// // // // // //       child: Column(
// // // // // //         children: [
// // // // // //           // Date Range Selector
// // // // // //           Card(
// // // // // //             child: Padding(
// // // // // //               padding: const EdgeInsets.all(12.0),
// // // // // //               child: Column(
// // // // // //                 children: [
// // // // // //                   const Text('Select Date Range',
// // // // // //                       style: TextStyle(
// // // // // //                           fontSize: 16, fontWeight: FontWeight.bold)),
// // // // // //                   const SizedBox(height: 10),
// // // // // //                   Row(
// // // // // //                     children: [
// // // // // //                       Expanded(
// // // // // //                         child: TextButton.icon(
// // // // // //                           onPressed: () async {
// // // // // //                             final picked = await showDateRangePicker(
// // // // // //                               context: context,
// // // // // //                               firstDate: DateTime(2023),
// // // // // //                               lastDate: DateTime.now(),
// // // // // //                               initialDateRange: startDate != null && endDate != null
// // // // // //                                   ? DateTimeRange(
// // // // // //                                       start: startDate!, end: endDate!)
// // // // // //                                   : null,
// // // // // //                             );
// // // // // //                             if (picked != null) {
// // // // // //                               setState(() {
// // // // // //                                 startDate = picked.start;
// // // // // //                                 endDate = picked.end;
// // // // // //                               });
// // // // // //                             }
// // // // // //                           },
// // // // // //                           icon: const Icon(Icons.date_range),
// // // // // //                           label: Text(
// // // // // //                             startDate == null || endDate == null
// // // // // //                                 ? 'Tap to select dates'
// // // // // //                                 : '${DateFormat('MMM dd, yyyy').format(startDate!)} - ${DateFormat('MMM dd, yyyy').format(endDate!)}',
// // // // // //                           ),
// // // // // //                         ),
// // // // // //                       ),
// // // // // //                     ],
// // // // // //                   ),
// // // // // //                 ],
// // // // // //               ),
// // // // // //             ),
// // // // // //           ),
// // // // // //           const SizedBox(height: 16),

// // // // // //           // Generate Report Button
// // // // // //           SizedBox(
// // // // // //             width: double.infinity,
// // // // // //             child: ElevatedButton(
// // // // // //               style: ElevatedButton.styleFrom(
// // // // // //                 padding: const EdgeInsets.symmetric(vertical: 16),
// // // // // //               ),
// // // // // //               onPressed: generateReport,
// // // // // //               child: isLoading
// // // // // //                   ? const SizedBox(
// // // // // //                       height: 20,
// // // // // //                       width: 20,
// // // // // //                       child: CircularProgressIndicator(
// // // // // //                         color: Colors.white,
// // // // // //                         strokeWidth: 2,
// // // // // //                       ),
// // // // // //                     )
// // // // // //                   : const Text('Generate Report',
// // // // // //                       style: TextStyle(fontSize: 16)),
// // // // // //             ),
// // // // // //           ),

// // // // // //           // Error Message
// // // // // //           if (errorMessage != null)
// // // // // //             Padding(
// // // // // //               padding: const EdgeInsets.symmetric(vertical: 8.0),
// // // // // //               child: Card(
// // // // // //                 color: Colors.red[50],
// // // // // //                 child: Padding(
// // // // // //                   padding: const EdgeInsets.all(12.0),
// // // // // //                   child: Text(
// // // // // //                     errorMessage!,
// // // // // //                     style: const TextStyle(color: Colors.red),
// // // // // //                     textAlign: TextAlign.center,
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ),

// // // // // //           const SizedBox(height: 16),

// // // // // //           // Summary Cards
// // // // // //           if (reportData.isNotEmpty) ...[
// // // // // //             Wrap(
// // // // // //               spacing: 12,
// // // // // //               runSpacing: 12,
// // // // // //               children: [
// // // // // //                 _buildSummaryCard('Total Orders', totalOrders, Colors.blue),
// // // // // //                 _buildSummaryCard('Pending', pendingOrders, Colors.orange),
// // // // // //                 _buildSummaryCard('Cancelled', cancelledOrders, Colors.red),
// // // // // //                 _buildSummaryCard('Completed', completedOrders, Colors.green),
// // // // // //               ],
// // // // // //             ),
// // // // // //             const SizedBox(height: 20),

// // // // // //             // Detailed Report
// // // // // //             Expanded(
// // // // // //               child: Column(
// // // // // //                 children: [
// // // // // //                   // Report Title
// // // // // //                   const Text('Daily Order Breakdown',
// // // // // //                       style: TextStyle(
// // // // // //                           fontSize: 18, fontWeight: FontWeight.bold)),
// // // // // //                   const SizedBox(height: 10),

// // // // // //                   // Report Table
// // // // // //                   Expanded(
// // // // // //                     child: SingleChildScrollView(
// // // // // //                       scrollDirection: Axis.vertical,
// // // // // //                       child: Card(
// // // // // //                         child: Padding(
// // // // // //                           padding: const EdgeInsets.all(12.0),
// // // // // //                           child: Table(
// // // // // //                             border: TableBorder.all(
// // // // // //                               color: Colors.grey[300]!,
// // // // // //                               borderRadius: BorderRadius.circular(8),
// // // // // //                             ),
// // // // // //                             columnWidths: const {
// // // // // //                               0: FixedColumnWidth(120),
// // // // // //                               1: FixedColumnWidth(80),
// // // // // //                               2: FixedColumnWidth(80),
// // // // // //                               3: FixedColumnWidth(80),
// // // // // //                               4: FixedColumnWidth(80),
// // // // // //                             },
// // // // // //                             children: [
// // // // // //                               // Header Row
// // // // // //                               TableRow(
// // // // // //                                 decoration: BoxDecoration(
// // // // // //                                   color: Colors.grey[200],
// // // // // //                                   borderRadius: const BorderRadius.only(
// // // // // //                                     topLeft: Radius.circular(8),
// // // // // //                                     topRight: Radius.circular(8),
// // // // // //                                   ),
// // // // // //                                 ),
// // // // // //                                 children: [
// // // // // //                                   _buildHeaderCell('Date'),
// // // // // //                                   _buildHeaderCell('Total'),
// // // // // //                                   _buildHeaderCell('Pending'),
// // // // // //                                   _buildHeaderCell('Cancelled'),
// // // // // //                                   _buildHeaderCell('Completed'),
// // // // // //                                 ],
// // // // // //                               ),
// // // // // //                               // Data Rows
// // // // // //                               ...reportData
// // // // // //                                   .map((data) => TableRow(
// // // // // //                                         children: [
// // // // // //                                           _buildDataCell(data['date']),
// // // // // //                                           _buildDataCell(data['total'].toString()),
// // // // // //                                           _buildDataCell(data['pending'].toString()),
// // // // // //                                           _buildDataCell(data['cancelled'].toString()),
// // // // // //                                           _buildDataCell(data['completed'].toString()),
// // // // // //                                         ],
// // // // // //                                       ))
// // // // // //                                   .toList(),
// // // // // //                               // Totals Row
// // // // // //                               TableRow(
// // // // // //                                 decoration: BoxDecoration(
// // // // // //                                   color: Colors.grey[100],
// // // // // //                                   borderRadius: const BorderRadius.only(
// // // // // //                                     bottomLeft: Radius.circular(8),
// // // // // //                                     bottomRight: Radius.circular(8),
// // // // // //                                   ),
// // // // // //                                 ),
// // // // // //                                 children: [
// // // // // //                                   _buildHeaderCell('TOTAL'),
// // // // // //                                   _buildHeaderCell(totalOrders.toString()),
// // // // // //                                   _buildHeaderCell(pendingOrders.toString()),
// // // // // //                                   _buildHeaderCell(cancelledOrders.toString()),
// // // // // //                                   _buildHeaderCell(completedOrders.toString()),
// // // // // //                                 ],
// // // // // //                               ),
// // // // // //                             ],
// // // // // //                           ),
// // // // // //                         ),
// // // // // //                       ),
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                   const SizedBox(height: 16),

// // // // // //                   // Export Button
// // // // // //                   SizedBox(
// // // // // //                     width: double.infinity,
// // // // // //                     child: OutlinedButton.icon(
// // // // // //                       onPressed: reportData.isEmpty
// // // // // //                           ? null
// // // // // //                           : () {
// // // // // //                               // TODO: Implement export functionality
// // // // // //                               ScaffoldMessenger.of(context).showSnackBar(
// // // // // //                                 const SnackBar(
// // // // // //                                     content: Text('Export functionality coming soon')),
// // // // // //                               );
// // // // // //                             },
// // // // // //                       icon: const Icon(Icons.download),
// // // // // //                       label: const Text('Export Report'),
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                 ],
// // // // // //               ),
// // // // // //             ),
// // // // // //           ] else if (!isLoading) ...[
// // // // // //             const Expanded(
// // // // // //               child: Center(
// // // // // //                 child: Column(
// // // // // //                   mainAxisAlignment: MainAxisAlignment.center,
// // // // // //                   children: [
// // // // // //                     Icon(Icons.analytics, size: 64, color: Colors.grey),
// // // // // //                     SizedBox(height: 16),
// // // // // //                     Text('No report data available',
// // // // // //                         style: TextStyle(color: Colors.grey)),
// // // // // //                     Text('Select a date range and generate report',
// // // // // //                         style: TextStyle(color: Colors.grey)),
// // // // // //                   ],
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ),
// // // // // //           ],
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   Widget _buildSummaryCard(String title, int value, Color color) {
// // // // // //     return SizedBox(
// // // // // //       width: 150,
// // // // // //       child: Card(
// // // // // //         color: color.withOpacity(0.1),
// // // // // //         child: Padding(
// // // // // //           padding: const EdgeInsets.all(16.0),
// // // // // //           child: Column(
// // // // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //             children: [
// // // // // //               Text(
// // // // // //                 title,
// // // // // //                 style: TextStyle(
// // // // // //                   color: color,
// // // // // //                   fontSize: 14,
// // // // // //                 ),
// // // // // //               ),
// // // // // //               const SizedBox(height: 8),
// // // // // //               Text(
// // // // // //                 value.toString(),
// // // // // //                 style: TextStyle(
// // // // // //                   color: color,
// // // // // //                   fontSize: 24,
// // // // // //                   fontWeight: FontWeight.bold,
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ],
// // // // // //           ),
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   Widget _buildHeaderCell(String text) {
// // // // // //     return Padding(
// // // // // //       padding: const EdgeInsets.all(10.0),
// // // // // //       child: Text(
// // // // // //         text,
// // // // // //         style: const TextStyle(fontWeight: FontWeight.bold),
// // // // // //         textAlign: TextAlign.center,
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   Widget _buildDataCell(String text) {
// // // // // //     return Padding(
// // // // // //       padding: const EdgeInsets.all(10.0),
// // // // // //       child: Text(
// // // // // //         text,
// // // // // //         textAlign: TextAlign.center,
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // // // import 'package:intl/intl.dart';

// // // // // class AdminReportsTab extends StatefulWidget {
// // // // //   const AdminReportsTab({super.key});

// // // // //   @override
// // // // //   State<AdminReportsTab> createState() => _AdminReportsTabState();
// // // // // }

// // // // // class _AdminReportsTabState extends State<AdminReportsTab> {
// // // // //   DateTime? startDate;
// // // // //   DateTime? endDate;
// // // // //   bool isLoading = false;
// // // // //   String? errorMessage;
// // // // //   List<Map<String, dynamic>> reportData = [];
// // // // //   int totalOrders = 0;
// // // // //   int pendingOrders = 0;
// // // // //   int cancelledOrders = 0;
// // // // //   int completedOrders = 0;

// // // // //   Future<void> generateReport() async {
// // // // //     setState(() {
// // // // //       isLoading = true;
// // // // //       errorMessage = null;
// // // // //       reportData.clear();
// // // // //       totalOrders = 0;
// // // // //       pendingOrders = 0;
// // // // //       cancelledOrders = 0;
// // // // //       completedOrders = 0;
// // // // //     });

// // // // //     if (startDate == null || endDate == null) {
// // // // //       setState(() {
// // // // //         isLoading = false;
// // // // //         errorMessage = 'Please select a date range';
// // // // //       });
// // // // //       return;
// // // // //     }

// // // // //     try {
// // // // //       final days = endDate!.difference(startDate!).inDays;

// // // // //       // Limit to 30 days to prevent excessive queries
// // // // //       if (days > 30) {
// // // // //         setState(() {
// // // // //           isLoading = false;
// // // // //           errorMessage = 'Please select a date range of 30 days or less';
// // // // //         });
// // // // //         return;
// // // // //       }

// // // // //       for (int i = 0; i <= days; i++) {
// // // // //         final currentDate = startDate!.add(Duration(days: i));
// // // // //         final nextDate = currentDate.add(const Duration(days: 1));

// // // // //         // Get all orders for the day
// // // // //         final allOrdersSnapshot = await _safeQuery(
// // // // //           FirebaseFirestore.instance
// // // // //               .collection('all_pickups')
// // // // //               .where('createdAt',
// // // // //                   isGreaterThanOrEqualTo: Timestamp.fromDate(currentDate))
// // // // //               .where('createdAt', isLessThan: Timestamp.fromDate(nextDate)),
// // // // //           'all_orders_query',
// // // // //         );

// // // // //         // Get pending orders
// // // // //         final pendingSnapshot = await _safeQuery(
// // // // //           FirebaseFirestore.instance
// // // // //               .collection('all_pickups')
// // // // //               .where('createdAt',
// // // // //                   isGreaterThanOrEqualTo: Timestamp.fromDate(currentDate))
// // // // //               .where('createdAt', isLessThan: Timestamp.fromDate(nextDate))
// // // // //               .where('status', isEqualTo: 'pending'),
// // // // //           'pending_orders_query',
// // // // //         );

// // // // //         // Get cancelled orders
// // // // //         final cancelledSnapshot = await _safeQuery(
// // // // //           FirebaseFirestore.instance
// // // // //               .collection('all_pickups')
// // // // //               .where('createdAt',
// // // // //                   isGreaterThanOrEqualTo: Timestamp.fromDate(currentDate))
// // // // //               .where('createdAt', isLessThan: Timestamp.fromDate(nextDate))
// // // // //               .where('status', isEqualTo: 'cancelled'),
// // // // //           'cancelled_orders_query',
// // // // //         );

// // // // //         // Get completed orders
// // // // //         final completedSnapshot = await _safeQuery(
// // // // //           FirebaseFirestore.instance
// // // // //               .collection('all_pickups')
// // // // //               .where('createdAt',
// // // // //                   isGreaterThanOrEqualTo: Timestamp.fromDate(currentDate))
// // // // //               .where('createdAt', isLessThan: Timestamp.fromDate(nextDate))
// // // // //               .where('status', isEqualTo: 'completed'),
// // // // //           'completed_orders_query',
// // // // //         );

// // // // //         final total = allOrdersSnapshot.docs.length;
// // // // //         final pending = pendingSnapshot.docs.length;
// // // // //         final cancelled = cancelledSnapshot.docs.length;
// // // // //         final completed = completedSnapshot.docs.length;

// // // // //         reportData.add({
// // // // //           'date': DateFormat('MMM dd, yyyy').format(currentDate),
// // // // //           'total': total,
// // // // //           'pending': pending,
// // // // //           'cancelled': cancelled,
// // // // //           'completed': completed,
// // // // //         });

// // // // //         totalOrders += total;
// // // // //         pendingOrders += pending;
// // // // //         cancelledOrders += cancelled;
// // // // //         completedOrders += completed;
// // // // //       }
// // // // //     } catch (e) {
// // // // //       setState(() {
// // // // //         errorMessage = 'Error generating report: ${e.toString()}';
// // // // //       });
// // // // //     } finally {
// // // // //       setState(() => isLoading = false);
// // // // //     }
// // // // //   }

// // // // //   Future<QuerySnapshot> _safeQuery(Query query, String queryType) async {
// // // // //     try {
// // // // //       return await query.get();
// // // // //     } on FirebaseException catch (e) {
// // // // //       if (e.code == 'failed-precondition') {
// // // // //         setState(() {
// // // // //           errorMessage = '''Query requires an index.
// // // // // Please create the index in Firebase Console for query type: $queryType
// // // // // Error details: ${e.message}''';
// // // // //         });
// // // // //       }
// // // // //       rethrow;
// // // // //     }
// // // // //   }

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Padding(
// // // // //       padding: const EdgeInsets.all(16.0),
// // // // //       child: Column(
// // // // //         children: [
// // // // //           // Date Range Selector
// // // // //           Card(
// // // // //             child: Padding(
// // // // //               padding: const EdgeInsets.all(12.0),
// // // // //               child: Column(
// // // // //                 children: [
// // // // //                   const Text('Select Date Range',
// // // // //                       style: TextStyle(
// // // // //                           fontSize: 16, fontWeight: FontWeight.bold)),
// // // // //                   const SizedBox(height: 10),
// // // // //                   Row(
// // // // //                     children: [
// // // // //                       Expanded(
// // // // //                         child: TextButton.icon(
// // // // //                           onPressed: () async {
// // // // //                             final picked = await showDateRangePicker(
// // // // //                               context: context,
// // // // //                               firstDate: DateTime(2023),
// // // // //                               lastDate: DateTime.now(),
// // // // //                               initialDateRange: startDate != null && endDate != null
// // // // //                                   ? DateTimeRange(
// // // // //                                       start: startDate!, end: endDate!)
// // // // //                                   : null,
// // // // //                             );
// // // // //                             if (picked != null) {
// // // // //                               setState(() {
// // // // //                                 startDate = picked.start;
// // // // //                                 endDate = picked.end;
// // // // //                               });
// // // // //                             }
// // // // //                           },
// // // // //                           icon: const Icon(Icons.date_range),
// // // // //                           label: Text(
// // // // //                             startDate == null || endDate == null
// // // // //                                 ? 'Tap to select dates'
// // // // //                                 : '${DateFormat('MMM dd, yyyy').format(startDate!)} - ${DateFormat('MMM dd, yyyy').format(endDate!)}',
// // // // //                           ),
// // // // //                         ),
// // // // //                       ),
// // // // //                     ],
// // // // //                   ),
// // // // //                 ],
// // // // //               ),
// // // // //             ),
// // // // //           ),
// // // // //           const SizedBox(height: 16),

// // // // //           // Generate Report Button
// // // // //           SizedBox(
// // // // //             width: double.infinity,
// // // // //             child: ElevatedButton(
// // // // //               style: ElevatedButton.styleFrom(
// // // // //                 padding: const EdgeInsets.symmetric(vertical: 16),
// // // // //               ),
// // // // //               onPressed: generateReport,
// // // // //               child: isLoading
// // // // //                   ? const SizedBox(
// // // // //                       height: 20,
// // // // //                       width: 20,
// // // // //                       child: CircularProgressIndicator(
// // // // //                         color: Colors.white,
// // // // //                         strokeWidth: 2,
// // // // //                       ),
// // // // //                     )
// // // // //                   : const Text('Generate Report',
// // // // //                       style: TextStyle(fontSize: 16)),
// // // // //             ),
// // // // //           ),

// // // // //           // Error Message
// // // // //           if (errorMessage != null)
// // // // //             Padding(
// // // // //               padding: const EdgeInsets.symmetric(vertical: 8.0),
// // // // //               child: Card(
// // // // //                 color: Colors.red[50],
// // // // //                 child: Padding(
// // // // //                   padding: const EdgeInsets.all(12.0),
// // // // //                   child: Text(
// // // // //                     errorMessage!,
// // // // //                     style: const TextStyle(color: Colors.red),
// // // // //                     textAlign: TextAlign.center,
// // // // //                   ),
// // // // //                 ),
// // // // //               ),
// // // // //             ),

// // // // //           const SizedBox(height: 16),

// // // // //           // Summary Cards
// // // // //           if (reportData.isNotEmpty) ...[
// // // // //             Wrap(
// // // // //               spacing: 12,
// // // // //               runSpacing: 12,
// // // // //               children: [
// // // // //                 _buildSummaryCard('Total Orders', totalOrders, Colors.blue),
// // // // //                 _buildSummaryCard('Pending', pendingOrders, Colors.orange),
// // // // //                 _buildSummaryCard('Cancelled', cancelledOrders, Colors.red),
// // // // //                 _buildSummaryCard('Completed', completedOrders, Colors.green),
// // // // //               ],
// // // // //             ),
// // // // //             const SizedBox(height: 20),

// // // // //             // Detailed Report
// // // // //             Expanded(
// // // // //               child: Column(
// // // // //                 children: [
// // // // //                   // Report Title
// // // // //                   const Text('Daily Order Breakdown',
// // // // //                       style: TextStyle(
// // // // //                           fontSize: 18, fontWeight: FontWeight.bold)),
// // // // //                   const SizedBox(height: 10),

// // // // //                   // Report Table with both scrolling directions
// // // // //                   Expanded(
// // // // //                     child: Container(
// // // // //                       decoration: BoxDecoration(
// // // // //                         border: Border.all(color: Colors.grey[300]!),
// // // // //                         borderRadius: BorderRadius.circular(8),
// // // // //                       ),
// // // // //                       child: Scrollbar(
// // // // //                         thumbVisibility: true,
// // // // //                         child: SingleChildScrollView(
// // // // //                           scrollDirection: Axis.horizontal,
// // // // //                           child: SizedBox(
// // // // //                             width: MediaQuery.of(context).size.width > 600
// // // // //                                 ? MediaQuery.of(context).size.width * 0.8
// // // // //                                 : 600,
// // // // //                             child: Scrollbar(
// // // // //                               thumbVisibility: true,
// // // // //                               child: SingleChildScrollView(
// // // // //                                 scrollDirection: Axis.vertical,
// // // // //                                 child: Card(
// // // // //                                   margin: EdgeInsets.zero,
// // // // //                                   child: Padding(
// // // // //                                     padding: const EdgeInsets.all(12.0),
// // // // //                                     child: Table(
// // // // //                                       border: TableBorder.all(
// // // // //                                         color: Colors.grey[300]!,
// // // // //                                         borderRadius: BorderRadius.circular(8),
// // // // //                                       ),
// // // // //                                       columnWidths: const {
// // // // //                                         0: FixedColumnWidth(120),
// // // // //                                         1: FixedColumnWidth(80),
// // // // //                                         2: FixedColumnWidth(80),
// // // // //                                         3: FixedColumnWidth(80),
// // // // //                                         4: FixedColumnWidth(80),
// // // // //                                       },
// // // // //                                       children: [
// // // // //                                         // Header Row
// // // // //                                         TableRow(
// // // // //                                           decoration: BoxDecoration(
// // // // //                                             color: Colors.grey[200],
// // // // //                                             borderRadius: const BorderRadius.only(
// // // // //                                               topLeft: Radius.circular(8),
// // // // //                                               topRight: Radius.circular(8),
// // // // //                                             ),
// // // // //                                           ),
// // // // //                                           children: [
// // // // //                                             _buildHeaderCell('Date'),
// // // // //                                             _buildHeaderCell('Total'),
// // // // //                                             _buildHeaderCell('Pending'),
// // // // //                                             _buildHeaderCell('Cancelled'),
// // // // //                                             _buildHeaderCell('Completed'),
// // // // //                                           ],
// // // // //                                         ),
// // // // //                                         // Data Rows
// // // // //                                         ...reportData
// // // // //                                             .map((data) => TableRow(
// // // // //                                                   children: [
// // // // //                                                     _buildDataCell(data['date']),
// // // // //                                                     _buildDataCell(data['total'].toString()),
// // // // //                                                     _buildDataCell(data['pending'].toString()),
// // // // //                                                     _buildDataCell(data['cancelled'].toString()),
// // // // //                                                     _buildDataCell(data['completed'].toString()),
// // // // //                                                   ],
// // // // //                                                 ))
// // // // //                                             .toList(),
// // // // //                                         // Totals Row
// // // // //                                         TableRow(
// // // // //                                           decoration: BoxDecoration(
// // // // //                                             color: Colors.grey[100],
// // // // //                                             borderRadius: const BorderRadius.only(
// // // // //                                               bottomLeft: Radius.circular(8),
// // // // //                                               bottomRight: Radius.circular(8),
// // // // //                                             ),
// // // // //                                           ),
// // // // //                                           children: [
// // // // //                                             _buildHeaderCell('TOTAL'),
// // // // //                                             _buildHeaderCell(totalOrders.toString()),
// // // // //                                             _buildHeaderCell(pendingOrders.toString()),
// // // // //                                             _buildHeaderCell(cancelledOrders.toString()),
// // // // //                                             _buildHeaderCell(completedOrders.toString()),
// // // // //                                           ],
// // // // //                                         ),
// // // // //                                       ],
// // // // //                                     ),
// // // // //                                   ),
// // // // //                                 ),
// // // // //                               ),
// // // // //                             ),
// // // // //                           ),
// // // // //                         ),
// // // // //                       ),
// // // // //                     ),
// // // // //                   ),
// // // // //                   const SizedBox(height: 16),

// // // // //                   // Export Button
// // // // //                   SizedBox(
// // // // //                     width: double.infinity,
// // // // //                     child: OutlinedButton.icon(
// // // // //                       onPressed: reportData.isEmpty
// // // // //                           ? null
// // // // //                           : () {
// // // // //                               // TODO: Implement export functionality
// // // // //                               ScaffoldMessenger.of(context).showSnackBar(
// // // // //                                 const SnackBar(
// // // // //                                     content: Text('Export functionality coming soon')),
// // // // //                               );
// // // // //                             },
// // // // //                       icon: const Icon(Icons.download),
// // // // //                       label: const Text('Export Report'),
// // // // //                     ),
// // // // //                   ),
// // // // //                 ],
// // // // //               ),
// // // // //             ),
// // // // //           ] else if (!isLoading) ...[
// // // // //             const Expanded(
// // // // //               child: Center(
// // // // //                 child: Column(
// // // // //                   mainAxisAlignment: MainAxisAlignment.center,
// // // // //                   children: [
// // // // //                     Icon(Icons.analytics, size: 64, color: Colors.grey),
// // // // //                     SizedBox(height: 16),
// // // // //                     Text('No report data available',
// // // // //                         style: TextStyle(color: Colors.grey)),
// // // // //                     Text('Select a date range and generate report',
// // // // //                         style: TextStyle(color: Colors.grey)),
// // // // //                   ],
// // // // //                 ),
// // // // //               ),
// // // // //             ),
// // // // //           ],
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _buildSummaryCard(String title, int value, Color color) {
// // // // //     return SizedBox(
// // // // //       width: 150,
// // // // //       child: Card(
// // // // //         color: color.withOpacity(0.1),
// // // // //         child: Padding(
// // // // //           padding: const EdgeInsets.all(16.0),
// // // // //           child: Column(
// // // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // // //             children: [
// // // // //               Text(
// // // // //                 title,
// // // // //                 style: TextStyle(
// // // // //                   color: color,
// // // // //                   fontSize: 14,
// // // // //                 ),
// // // // //               ),
// // // // //               const SizedBox(height: 8),
// // // // //               Text(
// // // // //                 value.toString(),
// // // // //                 style: TextStyle(
// // // // //                   color: color,
// // // // //                   fontSize: 24,
// // // // //                   fontWeight: FontWeight.bold,
// // // // //                 ),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _buildHeaderCell(String text) {
// // // // //     return Padding(
// // // // //       padding: const EdgeInsets.all(10.0),
// // // // //       child: Text(
// // // // //         text,
// // // // //         style: const TextStyle(fontWeight: FontWeight.bold),
// // // // //         textAlign: TextAlign.center,
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _buildDataCell(String text) {
// // // // //     return Padding(
// // // // //       padding: const EdgeInsets.all(10.0),
// // // // //       child: Text(
// // // // //         text,
// // // // //         textAlign: TextAlign.center,
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }
// // // // import 'package:flutter/material.dart';
// // // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // // import 'package:intl/intl.dart';

// // // // class AdminReportsTab extends StatefulWidget {
// // // //   const AdminReportsTab({super.key});

// // // //   @override
// // // //   State<AdminReportsTab> createState() => _AdminReportsTabState();
// // // // }

// // // // class _AdminReportsTabState extends State<AdminReportsTab> {
// // // //   DateTime? startDate;
// // // //   DateTime? endDate;
// // // //   bool isLoading = false;
// // // //   String? errorMessage;
// // // //   List<Map<String, dynamic>> reportData = [];
// // // //   int totalOrders = 0;
// // // //   int pendingOrders = 0;
// // // //   int cancelledOrders = 0;
// // // //   int completedOrders = 0;

// // // //   Future<void> generateReport() async {
// // // //     setState(() {
// // // //       isLoading = true;
// // // //       errorMessage = null;
// // // //       reportData.clear();
// // // //       totalOrders = 0;
// // // //       pendingOrders = 0;
// // // //       cancelledOrders = 0;
// // // //       completedOrders = 0;
// // // //     });

// // // //     if (startDate == null || endDate == null) {
// // // //       setState(() {
// // // //         isLoading = false;
// // // //         errorMessage = 'Please select a date range';
// // // //       });
// // // //       return;
// // // //     }

// // // //     try {
// // // //       final days = endDate!.difference(startDate!).inDays;

// // // //       if (days > 30) {
// // // //         setState(() {
// // // //           isLoading = false;
// // // //           errorMessage = 'Please select a date range of 30 days or less';
// // // //         });
// // // //         return;
// // // //       }

// // // //       for (int i = 0; i <= days; i++) {
// // // //         final currentDate = startDate!.add(Duration(days: i));
// // // //         final nextDate = currentDate.add(const Duration(days: 1));

// // // //         // Get all orders for the day in a single query
// // // //         final allOrdersSnapshot = await FirebaseFirestore.instance
// // // //             .collection('all_pickups')
// // // //             .where('createdAt',
// // // //                 isGreaterThanOrEqualTo: Timestamp.fromDate(currentDate))
// // // //             .where('createdAt', isLessThan: Timestamp.fromDate(nextDate))
// // // //             .get();

// // // //         // Filter locally to count statuses
// // // //         final pending = allOrdersSnapshot.docs
// // // //             .where((doc) => (doc['status'] as String?)?.toLowerCase() == 'pending')
// // // //             .length;

// // // //         final cancelled = allOrdersSnapshot.docs
// // // //             .where((doc) => (doc['status'] as String?)?.toLowerCase() == 'cancelled')
// // // //             .length;

// // // //         final completed = allOrdersSnapshot.docs
// // // //             .where((doc) => (doc['status'] as String?)?.toLowerCase() == 'completed')
// // // //             .length;

// // // //         final total = allOrdersSnapshot.docs.length;

// // // //         reportData.add({
// // // //           'date': DateFormat('MMM dd, yyyy').format(currentDate),
// // // //           'total': total,
// // // //           'pending': pending,
// // // //           'cancelled': cancelled,
// // // //           'completed': completed,
// // // //         });

// // // //         totalOrders += total;
// // // //         pendingOrders += pending;
// // // //         cancelledOrders += cancelled;
// // // //         completedOrders += completed;
// // // //       }
// // // //     } catch (e) {
// // // //       setState(() {
// // // //         errorMessage = 'Error generating report: ${e.toString()}';
// // // //       });
// // // //       debugPrint('Error generating report: $e');
// // // //     } finally {
// // // //       setState(() => isLoading = false);
// // // //     }
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Padding(
// // // //       padding: const EdgeInsets.all(16.0),
// // // //       child: Column(
// // // //         children: [
// // // //           // Date Range Selector
// // // //           Card(
// // // //             child: Padding(
// // // //               padding: const EdgeInsets.all(12.0),
// // // //               child: Column(
// // // //                 children: [
// // // //                   const Text('Select Date Range',
// // // //                       style: TextStyle(
// // // //                           fontSize: 16, fontWeight: FontWeight.bold)),
// // // //                   const SizedBox(height: 10),
// // // //                   Row(
// // // //                     children: [
// // // //                       Expanded(
// // // //                         child: TextButton.icon(
// // // //                           onPressed: () async {
// // // //                             final picked = await showDateRangePicker(
// // // //                               context: context,
// // // //                               firstDate: DateTime(2023),
// // // //                               lastDate: DateTime.now(),
// // // //                               initialDateRange: startDate != null && endDate != null
// // // //                                   ? DateTimeRange(
// // // //                                       start: startDate!, end: endDate!)
// // // //                                   : null,
// // // //                             );
// // // //                             if (picked != null) {
// // // //                               setState(() {
// // // //                                 startDate = picked.start;
// // // //                                 endDate = picked.end;
// // // //                               });
// // // //                             }
// // // //                           },
// // // //                           icon: const Icon(Icons.date_range),
// // // //                           label: Text(
// // // //                             startDate == null || endDate == null
// // // //                                 ? 'Tap to select dates'
// // // //                                 : '${DateFormat('MMM dd, yyyy').format(startDate!)} - ${DateFormat('MMM dd, yyyy').format(endDate!)}',
// // // //                           ),
// // // //                         ),
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //           ),
// // // //           const SizedBox(height: 16),

// // // //           // Generate Report Button
// // // //           SizedBox(
// // // //             width: double.infinity,
// // // //             child: ElevatedButton(
// // // //               style: ElevatedButton.styleFrom(
// // // //                 padding: const EdgeInsets.symmetric(vertical: 16),
// // // //               ),
// // // //               onPressed: generateReport,
// // // //               child: isLoading
// // // //                   ? const SizedBox(
// // // //                       height: 20,
// // // //                       width: 20,
// // // //                       child: CircularProgressIndicator(
// // // //                         color: Colors.white,
// // // //                         strokeWidth: 2,
// // // //                       ),
// // // //                     )
// // // //                   : const Text('Generate Report',
// // // //                       style: TextStyle(fontSize: 16)),
// // // //             ),
// // // //           ),

// // // //           // Error Message
// // // //           if (errorMessage != null)
// // // //             Padding(
// // // //               padding: const EdgeInsets.symmetric(vertical: 8.0),
// // // //               child: Card(
// // // //                 color: Colors.red[50],
// // // //                 child: Padding(
// // // //                   padding: const EdgeInsets.all(12.0),
// // // //                   child: Text(
// // // //                     errorMessage!,
// // // //                     style: const TextStyle(color: Colors.red),
// // // //                     textAlign: TextAlign.center,
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //             ),

// // // //           const SizedBox(height: 16),

// // // //           // Summary Cards
// // // //           if (reportData.isNotEmpty) ...[
// // // //             Wrap(
// // // //               spacing: 12,
// // // //               runSpacing: 12,
// // // //               children: [
// // // //                 _buildSummaryCard('Total Orders', totalOrders, Colors.blue),
// // // //                 _buildSummaryCard('Pending', pendingOrders, Colors.orange),
// // // //                 _buildSummaryCard('Cancelled', cancelledOrders, Colors.red),
// // // //                 _buildSummaryCard('Completed', completedOrders, Colors.green),
// // // //               ],
// // // //             ),
// // // //             const SizedBox(height: 20),

// // // //             // Detailed Report
// // // //             Expanded(
// // // //               child: Column(
// // // //                 children: [
// // // //                   // Report Title
// // // //                   const Text('Daily Order Breakdown',
// // // //                       style: TextStyle(
// // // //                           fontSize: 18, fontWeight: FontWeight.bold)),
// // // //                   const SizedBox(height: 10),

// // // //                   // Report Table with both scrolling directions
// // // //                   Expanded(
// // // //                     child: Container(
// // // //                       decoration: BoxDecoration(
// // // //                         border: Border.all(color: Colors.grey[300]!),
// // // //                         borderRadius: BorderRadius.circular(8),
// // // //                       ),
// // // //                       child: Scrollbar(
// // // //                         thumbVisibility: true,
// // // //                         child: SingleChildScrollView(
// // // //                           scrollDirection: Axis.horizontal,
// // // //                           child: SizedBox(
// // // //                             width: MediaQuery.of(context).size.width > 600
// // // //                                 ? MediaQuery.of(context).size.width * 0.8
// // // //                                 : 600,
// // // //                             child: Scrollbar(
// // // //                               thumbVisibility: true,
// // // //                               child: SingleChildScrollView(
// // // //                                 scrollDirection: Axis.vertical,
// // // //                                 child: Card(
// // // //                                   margin: EdgeInsets.zero,
// // // //                                   child: Padding(
// // // //                                     padding: const EdgeInsets.all(12.0),
// // // //                                     child: Table(
// // // //                                       border: TableBorder.all(
// // // //                                         color: Colors.grey[300]!,
// // // //                                         borderRadius: BorderRadius.circular(8),
// // // //                                       ),
// // // //                                       columnWidths: const {
// // // //                                         0: FixedColumnWidth(120),
// // // //                                         1: FixedColumnWidth(80),
// // // //                                         2: FixedColumnWidth(80),
// // // //                                         3: FixedColumnWidth(80),
// // // //                                         4: FixedColumnWidth(80),
// // // //                                       },
// // // //                                       children: [
// // // //                                         // Header Row
// // // //                                         TableRow(
// // // //                                           decoration: BoxDecoration(
// // // //                                             color: Colors.grey[200],
// // // //                                             borderRadius: const BorderRadius.only(
// // // //                                               topLeft: Radius.circular(8),
// // // //                                               topRight: Radius.circular(8),
// // // //                                             ),
// // // //                                           ),
// // // //                                           children: [
// // // //                                             _buildHeaderCell('Date'),
// // // //                                             _buildHeaderCell('Total'),
// // // //                                             _buildHeaderCell('Pending'),
// // // //                                             _buildHeaderCell('Cancelled'),
// // // //                                             _buildHeaderCell('Completed'),
// // // //                                           ],
// // // //                                         ),
// // // //                                         // Data Rows
// // // //                                         ...reportData
// // // //                                             .map((data) => TableRow(
// // // //                                                   children: [
// // // //                                                     _buildDataCell(data['date']),
// // // //                                                     _buildDataCell(data['total'].toString()),
// // // //                                                     _buildDataCell(data['pending'].toString()),
// // // //                                                     _buildDataCell(data['cancelled'].toString()),
// // // //                                                     _buildDataCell(data['completed'].toString()),
// // // //                                                   ],
// // // //                                                 ))
// // // //                                             .toList(),
// // // //                                         // Totals Row
// // // //                                         TableRow(
// // // //                                           decoration: BoxDecoration(
// // // //                                             color: Colors.grey[100],
// // // //                                             borderRadius: const BorderRadius.only(
// // // //                                               bottomLeft: Radius.circular(8),
// // // //                                               bottomRight: Radius.circular(8),
// // // //                                             ),
// // // //                                           ),
// // // //                                           children: [
// // // //                                             _buildHeaderCell('TOTAL'),
// // // //                                             _buildHeaderCell(totalOrders.toString()),
// // // //                                             _buildHeaderCell(pendingOrders.toString()),
// // // //                                             _buildHeaderCell(cancelledOrders.toString()),
// // // //                                             _buildHeaderCell(completedOrders.toString()),
// // // //                                           ],
// // // //                                         ),
// // // //                                       ],
// // // //                                     ),
// // // //                                   ),
// // // //                                 ),
// // // //                               ),
// // // //                             ),
// // // //                           ),
// // // //                         ),
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                   const SizedBox(height: 16),

// // // //                   // Export Button
// // // //                   SizedBox(
// // // //                     width: double.infinity,
// // // //                     child: OutlinedButton.icon(
// // // //                       onPressed: reportData.isEmpty
// // // //                           ? null
// // // //                           : () {
// // // //                               // TODO: Implement export functionality
// // // //                               ScaffoldMessenger.of(context).showSnackBar(
// // // //                                 const SnackBar(
// // // //                                     content: Text('Export functionality coming soon')),
// // // //                               );
// // // //                             },
// // // //                       icon: const Icon(Icons.download),
// // // //                       label: const Text('Export Report'),
// // // //                     ),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //           ] else if (!isLoading) ...[
// // // //             const Expanded(
// // // //               child: Center(
// // // //                 child: Column(
// // // //                   mainAxisAlignment: MainAxisAlignment.center,
// // // //                   children: [
// // // //                     Icon(Icons.analytics, size: 64, color: Colors.grey),
// // // //                     SizedBox(height: 16),
// // // //                     Text('No report data available',
// // // //                         style: TextStyle(color: Colors.grey)),
// // // //                     Text('Select a date range and generate report',
// // // //                         style: TextStyle(color: Colors.grey)),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildSummaryCard(String title, int value, Color color) {
// // // //     return SizedBox(
// // // //       width: 150,
// // // //       child: Card(
// // // //         color: color.withOpacity(0.1),
// // // //         child: Padding(
// // // //           padding: const EdgeInsets.all(16.0),
// // // //           child: Column(
// // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // //             children: [
// // // //               Text(
// // // //                 title,
// // // //                 style: TextStyle(
// // // //                   color: color,
// // // //                   fontSize: 14,
// // // //                 ),
// // // //               ),
// // // //               const SizedBox(height: 8),
// // // //               Text(
// // // //                 value.toString(),
// // // //                 style: TextStyle(
// // // //                   color: color,
// // // //                   fontSize: 24,
// // // //                   fontWeight: FontWeight.bold,
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildHeaderCell(String text) {
// // // //     return Padding(
// // // //       padding: const EdgeInsets.all(10.0),
// // // //       child: Text(
// // // //         text,
// // // //         style: const TextStyle(fontWeight: FontWeight.bold),
// // // //         textAlign: TextAlign.center,
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildDataCell(String text) {
// // // //     return Padding(
// // // //       padding: const EdgeInsets.all(10.0),
// // // //       child: Text(
// // // //         text,
// // // //         textAlign: TextAlign.center,
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // import 'package:flutter/material.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:intl/intl.dart';

// // // class AdminReportsTab extends StatefulWidget {
// // //   const AdminReportsTab({super.key});

// // //   @override
// // //   State<AdminReportsTab> createState() => _AdminReportsTabState();
// // // }

// // // class _AdminReportsTabState extends State<AdminReportsTab> {
// // //   DateTime? startDate;
// // //   DateTime? endDate;
// // //   bool isLoading = false;
// // //   String? errorMessage;
// // //   List<Map<String, dynamic>> reportData = [];
// // //   int totalOrders = 0;
// // //   int pendingOrders = 0;
// // //   int cancelledOrders = 0;
// // //   int completedOrders = 0;

// // //   Future<void> generateReport() async {
// // //     setState(() {
// // //       isLoading = true;
// // //       errorMessage = null;
// // //       reportData.clear();
// // //       totalOrders = 0;
// // //       pendingOrders = 0;
// // //       cancelledOrders = 0;
// // //       completedOrders = 0;
// // //     });

// // //     if (startDate == null || endDate == null) {
// // //       setState(() {
// // //         isLoading = false;
// // //         errorMessage = 'Please select a date range';
// // //       });
// // //       return;
// // //     }

// // //     try {
// // //       final days = endDate!.difference(startDate!).inDays;

// // //       if (days > 30) {
// // //         setState(() {
// // //           isLoading = false;
// // //           errorMessage = 'Please select a date range of 30 days or less';
// // //         });
// // //         return;
// // //       }

// // //       for (int i = 0; i <= days; i++) {
// // //         final currentDate = startDate!.add(Duration(days: i));
// // //         final nextDate = currentDate.add(const Duration(days: 1));

// // //         // Get all orders for the day in a single query
// // //         final allOrdersSnapshot = await FirebaseFirestore.instance
// // //             .collection('all_pickups')
// // //             .where('createdAt',
// // //                 isGreaterThanOrEqualTo: Timestamp.fromDate(currentDate))
// // //             .where('createdAt', isLessThan: Timestamp.fromDate(nextDate))
// // //             .get();

// // //         // Filter locally to count statuses
// // //         final pending = allOrdersSnapshot.docs
// // //             .where((doc) => (doc['status'] as String?)?.toLowerCase() == 'pending')
// // //             .length;

// // //         // Count both cancelledByUser and cancelledByAdmin as cancelled
// // //         final cancelled = allOrdersSnapshot.docs
// // //             .where((doc) {
// // //               final status = (doc['status'] as String?)?.toLowerCase();
// // //               return status == 'cancelledbyuser' ||
// // //                      status == 'cancelledbyadmin' ||
// // //                      status == 'cancelled';
// // //             })
// // //             .length;

// // //         final completed = allOrdersSnapshot.docs
// // //             .where((doc) => (doc['status'] as String?)?.toLowerCase() == 'completed')
// // //             .length;

// // //         final total = allOrdersSnapshot.docs.length;

// // //         reportData.add({
// // //           'date': DateFormat('MMM dd, yyyy').format(currentDate),
// // //           'total': total,
// // //           'pending': pending,
// // //           'cancelled': cancelled,
// // //           'completed': completed,
// // //         });

// // //         totalOrders += total;
// // //         pendingOrders += pending;
// // //         cancelledOrders += cancelled;
// // //         completedOrders += completed;
// // //       }
// // //     } catch (e) {
// // //       setState(() {
// // //         errorMessage = 'Error generating report: ${e.toString()}';
// // //       });
// // //       debugPrint('Error generating report: $e');
// // //     } finally {
// // //       setState(() => isLoading = false);
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Padding(
// // //       padding: const EdgeInsets.all(16.0),
// // //       child: Column(
// // //         children: [
// // //           // Date Range Selector
// // //           Card(
// // //             child: Padding(
// // //               padding: const EdgeInsets.all(12.0),
// // //               child: Column(
// // //                 children: [
// // //                   const Text('Select Date Range',
// // //                       style: TextStyle(
// // //                           fontSize: 16, fontWeight: FontWeight.bold)),
// // //                   const SizedBox(height: 10),
// // //                   Row(
// // //                     children: [
// // //                       Expanded(
// // //                         child: TextButton.icon(
// // //                           onPressed: () async {
// // //                             final picked = await showDateRangePicker(
// // //                               context: context,
// // //                               firstDate: DateTime(2023),
// // //                               lastDate: DateTime.now(),
// // //                               initialDateRange: startDate != null && endDate != null
// // //                                   ? DateTimeRange(
// // //                                       start: startDate!, end: endDate!)
// // //                                   : null,
// // //                             );
// // //                             if (picked != null) {
// // //                               setState(() {
// // //                                 startDate = picked.start;
// // //                                 endDate = picked.end;
// // //                               });
// // //                             }
// // //                           },
// // //                           icon: const Icon(Icons.date_range),
// // //                           label: Text(
// // //                             startDate == null || endDate == null
// // //                                 ? 'Tap to select dates'
// // //                                 : '${DateFormat('MMM dd, yyyy').format(startDate!)} - ${DateFormat('MMM dd, yyyy').format(endDate!)}',
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ),
// // //           const SizedBox(height: 16),

// // //           // Generate Report Button
// // //           SizedBox(
// // //             width: double.infinity,
// // //             child: ElevatedButton(
// // //               style: ElevatedButton.styleFrom(
// // //                 padding: const EdgeInsets.symmetric(vertical: 16),
// // //               ),
// // //               onPressed: generateReport,
// // //               child: isLoading
// // //                   ? const SizedBox(
// // //                       height: 20,
// // //                       width: 20,
// // //                       child: CircularProgressIndicator(
// // //                         color: Colors.white,
// // //                         strokeWidth: 2,
// // //                       ),
// // //                     )
// // //                   : const Text('Generate Report',
// // //                       style: TextStyle(fontSize: 16)),
// // //             ),
// // //           ),

// // //           // Error Message
// // //           if (errorMessage != null)
// // //             Padding(
// // //               padding: const EdgeInsets.symmetric(vertical: 8.0),
// // //               child: Card(
// // //                 color: Colors.red[50],
// // //                 child: Padding(
// // //                   padding: const EdgeInsets.all(12.0),
// // //                   child: Text(
// // //                     errorMessage!,
// // //                     style: const TextStyle(color: Colors.red),
// // //                     textAlign: TextAlign.center,
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),

// // //           const SizedBox(height: 16),

// // //           // Summary Cards
// // //           if (reportData.isNotEmpty) ...[
// // //             Wrap(
// // //               spacing: 12,
// // //               runSpacing: 12,
// // //               children: [
// // //                 _buildSummaryCard('Total Orders', totalOrders, Colors.blue),
// // //                 _buildSummaryCard('Pending', pendingOrders, Colors.orange),
// // //                 _buildSummaryCard('Cancelled', cancelledOrders, Colors.red),
// // //                 _buildSummaryCard('Completed', completedOrders, Colors.green),
// // //               ],
// // //             ),
// // //             const SizedBox(height: 20),

// // //             // Detailed Report
// // //             Expanded(
// // //               child: Column(
// // //                 children: [
// // //                   // Report Title
// // //                   const Text('Daily Order Breakdown',
// // //                       style: TextStyle(
// // //                           fontSize: 18, fontWeight: FontWeight.bold)),
// // //                   const SizedBox(height: 10),

// // //                   // Report Table with both scrolling directions
// // //                   Expanded(
// // //                     child: Container(
// // //                       decoration: BoxDecoration(
// // //                         border: Border.all(color: Colors.grey[300]!),
// // //                         borderRadius: BorderRadius.circular(8),
// // //                       ),
// // //                       child: Scrollbar(
// // //                         thumbVisibility: true,
// // //                         child: SingleChildScrollView(
// // //                           scrollDirection: Axis.horizontal,
// // //                           child: SizedBox(
// // //                             width: MediaQuery.of(context).size.width > 600
// // //                                 ? MediaQuery.of(context).size.width * 0.8
// // //                                 : 600,
// // //                             child: Scrollbar(
// // //                               thumbVisibility: true,
// // //                               child: SingleChildScrollView(
// // //                                 scrollDirection: Axis.vertical,
// // //                                 child: Card(
// // //                                   margin: EdgeInsets.zero,
// // //                                   child: Padding(
// // //                                     padding: const EdgeInsets.all(12.0),
// // //                                     child: Table(
// // //                                       border: TableBorder.all(
// // //                                         color: Colors.grey[300]!,
// // //                                         borderRadius: BorderRadius.circular(8),
// // //                                       ),
// // //                                       columnWidths: const {
// // //                                         0: FixedColumnWidth(120),
// // //                                         1: FixedColumnWidth(80),
// // //                                         2: FixedColumnWidth(80),
// // //                                         3: FixedColumnWidth(80),
// // //                                         4: FixedColumnWidth(80),
// // //                                       },
// // //                                       children: [
// // //                                         // Header Row
// // //                                         TableRow(
// // //                                           decoration: BoxDecoration(
// // //                                             color: Colors.grey[200],
// // //                                             borderRadius: const BorderRadius.only(
// // //                                               topLeft: Radius.circular(8),
// // //                                               topRight: Radius.circular(8),
// // //                                             ),
// // //                                           ),
// // //                                           children: [
// // //                                             _buildHeaderCell('Date'),
// // //                                             _buildHeaderCell('Total'),
// // //                                             _buildHeaderCell('Pending'),
// // //                                             _buildHeaderCell('Cancelled'),
// // //                                             _buildHeaderCell('Completed'),
// // //                                           ],
// // //                                         ),
// // //                                         // Data Rows
// // //                                         ...reportData
// // //                                             .map((data) => TableRow(
// // //                                                   children: [
// // //                                                     _buildDataCell(data['date']),
// // //                                                     _buildDataCell(data['total'].toString()),
// // //                                                     _buildDataCell(data['pending'].toString()),
// // //                                                     _buildDataCell(data['cancelled'].toString()),
// // //                                                     _buildDataCell(data['completed'].toString()),
// // //                                                   ],
// // //                                                 ))
// // //                                             .toList(),
// // //                                         // Totals Row
// // //                                         TableRow(
// // //                                           decoration: BoxDecoration(
// // //                                             color: Colors.grey[100],
// // //                                             borderRadius: const BorderRadius.only(
// // //                                               bottomLeft: Radius.circular(8),
// // //                                               bottomRight: Radius.circular(8),
// // //                                             ),
// // //                                           ),
// // //                                           children: [
// // //                                             _buildHeaderCell('TOTAL'),
// // //                                             _buildHeaderCell(totalOrders.toString()),
// // //                                             _buildHeaderCell(pendingOrders.toString()),
// // //                                             _buildHeaderCell(cancelledOrders.toString()),
// // //                                             _buildHeaderCell(completedOrders.toString()),
// // //                                           ],
// // //                                         ),
// // //                                       ],
// // //                                     ),
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                   const SizedBox(height: 16),

// // //                   // Export Button
// // //                   SizedBox(
// // //                     width: double.infinity,
// // //                     child: OutlinedButton.icon(
// // //                       onPressed: reportData.isEmpty
// // //                           ? null
// // //                           : () {
// // //                               // TODO: Implement export functionality
// // //                               ScaffoldMessenger.of(context).showSnackBar(
// // //                                 const SnackBar(
// // //                                     content: Text('Export functionality coming soon')),
// // //                               );
// // //                             },
// // //                       icon: const Icon(Icons.download),
// // //                       label: const Text('Export Report'),
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ] else if (!isLoading) ...[
// // //             const Expanded(
// // //               child: Center(
// // //                 child: Column(
// // //                   mainAxisAlignment: MainAxisAlignment.center,
// // //                   children: [
// // //                     Icon(Icons.analytics, size: 64, color: Colors.grey),
// // //                     SizedBox(height: 16),
// // //                     Text('No report data available',
// // //                         style: TextStyle(color: Colors.grey)),
// // //                     Text('Select a date range and generate report',
// // //                         style: TextStyle(color: Colors.grey)),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),
// // //           ],
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildSummaryCard(String title, int value, Color color) {
// // //     return SizedBox(
// // //       width: 150,
// // //       child: Card(
// // //         color: color.withOpacity(0.1),
// // //         child: Padding(
// // //           padding: const EdgeInsets.all(16.0),
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               Text(
// // //                 title,
// // //                 style: TextStyle(
// // //                   color: color,
// // //                   fontSize: 14,
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 8),
// // //               Text(
// // //                 value.toString(),
// // //                 style: TextStyle(
// // //                   color: color,
// // //                   fontSize: 24,
// // //                   fontWeight: FontWeight.bold,
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildHeaderCell(String text) {
// // //     return Padding(
// // //       padding: const EdgeInsets.all(10.0),
// // //       child: Text(
// // //         text,
// // //         style: const TextStyle(fontWeight: FontWeight.bold),
// // //         textAlign: TextAlign.center,
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildDataCell(String text) {
// // //     return Padding(
// // //       padding: const EdgeInsets.all(10.0),
// // //       child: Text(
// // //         text,
// // //         textAlign: TextAlign.center,
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:intl/intl.dart';

// // class AdminReportsTab extends StatefulWidget {
// //   const AdminReportsTab({super.key});

// //   @override
// //   State<AdminReportsTab> createState() => _AdminReportsTabState();
// // }

// // class _AdminReportsTabState extends State<AdminReportsTab> {
// //   DateTime? startDate;
// //   DateTime? endDate;
// //   bool isLoading = false;
// //   String? errorMessage;
// //   List<Map<String, dynamic>> reportData = [];
// //   int totalOrders = 0;
// //   int pendingOrders = 0;
// //   int inProgressOrders = 0;
// //   int cancelledOrders = 0;
// //   int completedOrders = 0;

// //   Future<void> generateReport() async {
// //     setState(() {
// //       isLoading = true;
// //       errorMessage = null;
// //       reportData.clear();
// //       totalOrders = 0;
// //       pendingOrders = 0;
// //       inProgressOrders = 0;
// //       cancelledOrders = 0;
// //       completedOrders = 0;
// //     });

// //     if (startDate == null || endDate == null) {
// //       setState(() {
// //         isLoading = false;
// //         errorMessage = 'Please select a date range';
// //       });
// //       return;
// //     }

// //     try {
// //       final days = endDate!.difference(startDate!).inDays;

// //       if (days > 30) {
// //         setState(() {
// //           isLoading = false;
// //           errorMessage = 'Please select a date range of 30 days or less';
// //         });
// //         return;
// //       }

// //       for (int i = 0; i <= days; i++) {
// //         final currentDate = startDate!.add(Duration(days: i));
// //         final nextDate = currentDate.add(const Duration(days: 1));

// //         // Get all orders for the day in a single query
// //         final allOrdersSnapshot = await FirebaseFirestore.instance
// //             .collection('all_pickups')
// //             .where('createdAt',
// //                 isGreaterThanOrEqualTo: Timestamp.fromDate(currentDate))
// //             .where('createdAt', isLessThan: Timestamp.fromDate(nextDate))
// //             .get();

// //         // Filter locally to count statuses
// //         final pending = allOrdersSnapshot.docs
// //             .where((doc) => (doc['status'] as String?)?.toLowerCase() == 'pending')
// //             .length;

// //         final inProgress = allOrdersSnapshot.docs
// //             .where((doc) => (doc['status'] as String?)?.toLowerCase() == 'inprogress' ||
// //                             (doc['status'] as String?)?.toLowerCase() == 'in progress')
// //             .length;

// //         // Count both cancelledByUser and cancelledByAdmin as cancelled
// //         final cancelled = allOrdersSnapshot.docs
// //             .where((doc) {
// //               final status = (doc['status'] as String?)?.toLowerCase();
// //               return status == 'cancelledbyuser' ||
// //                      status == 'cancelledbyadmin' ||
// //                      status == 'cancelled';
// //             })
// //             .length;

// //         final completed = allOrdersSnapshot.docs
// //             .where((doc) => (doc['status'] as String?)?.toLowerCase() == 'completed')
// //             .length;

// //         final total = allOrdersSnapshot.docs.length;

// //         reportData.add({
// //           'date': DateFormat('MMM dd, yyyy').format(currentDate),
// //           'total': total,
// //           'pending': pending,
// //           'inProgress': inProgress,
// //           'cancelled': cancelled,
// //           'completed': completed,
// //         });

// //         totalOrders += total;
// //         pendingOrders += pending;
// //         inProgressOrders += inProgress;
// //         cancelledOrders += cancelled;
// //         completedOrders += completed;
// //       }
// //     } catch (e) {
// //       setState(() {
// //         errorMessage = 'Error generating report: ${e.toString()}';
// //       });
// //       debugPrint('Error generating report: $e');
// //     } finally {
// //       setState(() => isLoading = false);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.all(16.0),
// //       child: Column(
// //         children: [
// //           // Date Range Selector
// //           Card(
// //             child: Padding(
// //               padding: const EdgeInsets.all(12.0),
// //               child: Column(
// //                 children: [
// //                   const Text('Select Date Range',
// //                       style: TextStyle(
// //                           fontSize: 16, fontWeight: FontWeight.bold)),
// //                   const SizedBox(height: 10),
// //                   Row(
// //                     children: [
// //                       Expanded(
// //                         child: TextButton.icon(
// //                           onPressed: () async {
// //                             final picked = await showDateRangePicker(
// //                               context: context,
// //                               firstDate: DateTime(2023),
// //                               lastDate: DateTime.now(),
// //                               initialDateRange: startDate != null && endDate != null
// //                                   ? DateTimeRange(
// //                                       start: startDate!, end: endDate!)
// //                                   : null,
// //                             );
// //                             if (picked != null) {
// //                               setState(() {
// //                                 startDate = picked.start;
// //                                 endDate = picked.end;
// //                               });
// //                             }
// //                           },
// //                           icon: const Icon(Icons.date_range),
// //                           label: Text(
// //                             startDate == null || endDate == null
// //                                 ? 'Tap to select dates'
// //                                 : '${DateFormat('MMM dd, yyyy').format(startDate!)} - ${DateFormat('MMM dd, yyyy').format(endDate!)}',
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //           const SizedBox(height: 16),

// //           // Generate Report Button
// //           SizedBox(
// //             width: double.infinity,
// //             child: ElevatedButton(
// //               style: ElevatedButton.styleFrom(
// //                 padding: const EdgeInsets.symmetric(vertical: 16),
// //               ),
// //               onPressed: generateReport,
// //               child: isLoading
// //                   ? const SizedBox(
// //                       height: 20,
// //                       width: 20,
// //                       child: CircularProgressIndicator(
// //                         color: Colors.white,
// //                         strokeWidth: 2,
// //                       ),
// //                     )
// //                   : const Text('Generate Report',
// //                       style: TextStyle(fontSize: 16)),
// //             ),
// //           ),

// //           // Error Message
// //           if (errorMessage != null)
// //             Padding(
// //               padding: const EdgeInsets.symmetric(vertical: 8.0),
// //               child: Card(
// //                 color: Colors.red[50],
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(12.0),
// //                   child: Text(
// //                     errorMessage!,
// //                     style: const TextStyle(color: Colors.red),
// //                     textAlign: TextAlign.center,
// //                   ),
// //                 ),
// //               ),
// //             ),

// //           const SizedBox(height: 16),

// //           // Summary Cards
// //           if (reportData.isNotEmpty) ...[
// //             Wrap(
// //               spacing: 12,
// //               runSpacing: 12,
// //               children: [
// //                 _buildSummaryCard('Total Orders', totalOrders, Colors.blue),
// //                 _buildSummaryCard('Pending', pendingOrders, Colors.orange),
// //                 _buildSummaryCard('In Progress', inProgressOrders, Colors.yellow[700]!),
// //                 _buildSummaryCard('Cancelled', cancelledOrders, Colors.red),
// //                 _buildSummaryCard('Completed', completedOrders, Colors.green),
// //               ],
// //             ),
// //             const SizedBox(height: 20),

// //             // Detailed Report
// //             Expanded(
// //               child: Column(
// //                 children: [
// //                   // Report Title
// //                   const Text('Daily Order Breakdown',
// //                       style: TextStyle(
// //                           fontSize: 18, fontWeight: FontWeight.bold)),
// //                   const SizedBox(height: 10),

// //                   // Report Table with both scrolling directions
// //                   Expanded(
// //                     child: Container(
// //                       decoration: BoxDecoration(
// //                         border: Border.all(color: Colors.grey[300]!),
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                       child: Scrollbar(
// //                         thumbVisibility: true,
// //                         child: SingleChildScrollView(
// //                           scrollDirection: Axis.horizontal,
// //                           child: SizedBox(
// //                             width: MediaQuery.of(context).size.width > 600
// //                                 ? MediaQuery.of(context).size.width * 0.8
// //                                 : 600,
// //                             child: Scrollbar(
// //                               thumbVisibility: true,
// //                               child: SingleChildScrollView(
// //                                 scrollDirection: Axis.vertical,
// //                                 child: Card(
// //                                   margin: EdgeInsets.zero,
// //                                   child: Padding(
// //                                     padding: const EdgeInsets.all(12.0),
// //                                     child: Table(
// //                                       border: TableBorder.all(
// //                                         color: Colors.grey[300]!,
// //                                         borderRadius: BorderRadius.circular(8),
// //                                       ),
// //                                       columnWidths: const {
// //                                         0: FixedColumnWidth(120),
// //                                         1: FixedColumnWidth(80),
// //                                         2: FixedColumnWidth(80),
// //                                         3: FixedColumnWidth(80),
// //                                         4: FixedColumnWidth(80),
// //                                         5: FixedColumnWidth(80),
// //                                       },
// //                                       children: [
// //                                         // Header Row
// //                                         TableRow(
// //                                           decoration: BoxDecoration(
// //                                             color: Colors.grey[200],
// //                                             borderRadius: const BorderRadius.only(
// //                                               topLeft: Radius.circular(8),
// //                                               topRight: Radius.circular(8),
// //                                             ),
// //                                           ),
// //                                           children: [
// //                                             _buildHeaderCell('Date'),
// //                                             _buildHeaderCell('Total'),
// //                                             _buildHeaderCell('Pending'),
// //                                             _buildHeaderCell('In Progress'),
// //                                             _buildHeaderCell('Cancelled'),
// //                                             _buildHeaderCell('Completed'),
// //                                           ],
// //                                         ),
// //                                         // Data Rows
// //                                         ...reportData
// //                                             .map((data) => TableRow(
// //                                                   children: [
// //                                                     _buildDataCell(data['date']),
// //                                                     _buildDataCell(data['total'].toString()),
// //                                                     _buildDataCell(data['pending'].toString()),
// //                                                     _buildDataCell(data['inProgress'].toString()),
// //                                                     _buildDataCell(data['cancelled'].toString()),
// //                                                     _buildDataCell(data['completed'].toString()),
// //                                                   ],
// //                                                 ))
// //                                             .toList(),
// //                                         // Totals Row
// //                                         TableRow(
// //                                           decoration: BoxDecoration(
// //                                             color: Colors.grey[100],
// //                                             borderRadius: const BorderRadius.only(
// //                                               bottomLeft: Radius.circular(8),
// //                                               bottomRight: Radius.circular(8),
// //                                             ),
// //                                           ),
// //                                           children: [
// //                                             _buildHeaderCell('TOTAL'),
// //                                             _buildHeaderCell(totalOrders.toString()),
// //                                             _buildHeaderCell(pendingOrders.toString()),
// //                                             _buildHeaderCell(inProgressOrders.toString()),
// //                                             _buildHeaderCell(cancelledOrders.toString()),
// //                                             _buildHeaderCell(completedOrders.toString()),
// //                                           ],
// //                                         ),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 16),

// //                   // Export Button
// //                   SizedBox(
// //                     width: double.infinity,
// //                     child: OutlinedButton.icon(
// //                       onPressed: reportData.isEmpty
// //                           ? null
// //                           : () {
// //                               // TODO: Implement export functionality
// //                               ScaffoldMessenger.of(context).showSnackBar(
// //                                 const SnackBar(
// //                                     content: Text('Export functionality coming soon')),
// //                               );
// //                             },
// //                       icon: const Icon(Icons.download),
// //                       label: const Text('Export Report'),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ] else if (!isLoading) ...[
// //             const Expanded(
// //               child: Center(
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Icon(Icons.analytics, size: 64, color: Colors.grey),
// //                     SizedBox(height: 16),
// //                     Text('No report data available',
// //                         style: TextStyle(color: Colors.grey)),
// //                     Text('Select a date range and generate report',
// //                         style: TextStyle(color: Colors.grey)),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildSummaryCard(String title, int value, Color color) {
// //     return SizedBox(
// //       width: 150,
// //       child: Card(
// //         color: color.withOpacity(0.1),
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 title,
// //                 style: TextStyle(
// //                   color: color,
// //                   fontSize: 14,
// //                 ),
// //               ),
// //               const SizedBox(height: 8),
// //               Text(
// //                 value.toString(),
// //                 style: TextStyle(
// //                   color: color,
// //                   fontSize: 24,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildHeaderCell(String text) {
// //     return Padding(
// //       padding: const EdgeInsets.all(10.0),
// //       child: Text(
// //         text,
// //         style: const TextStyle(fontWeight: FontWeight.bold),
// //         textAlign: TextAlign.center,
// //       ),
// //     );
// //   }

// //   Widget _buildDataCell(String text) {
// //     return Padding(
// //       padding: const EdgeInsets.all(10.0),
// //       child: Text(
// //         text,
// //         textAlign: TextAlign.center,
// //       ),
// //     );
// //   }
// // }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:path_provider/path_provider.dart';

// class AdminReportsTab extends StatefulWidget {
//   const AdminReportsTab({super.key});

//   @override
//   State<AdminReportsTab> createState() => _AdminReportsTabState();
// }

// class _AdminReportsTabState extends State<AdminReportsTab> {
//   DateTime? startDate;
//   DateTime? endDate;
//   bool isLoading = false;
//   String? errorMessage;
//   List<Map<String, dynamic>> reportData = [];
//   int totalOrders = 0;
//   int pendingOrders = 0;
//   int inProgressOrders = 0;
//   int cancelledOrders = 0;
//   int completedOrders = 0;

//   Future<void> generateReport() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//       reportData.clear();
//       totalOrders = 0;
//       pendingOrders = 0;
//       inProgressOrders = 0;
//       cancelledOrders = 0;
//       completedOrders = 0;
//     });

//     if (startDate == null || endDate == null) {
//       setState(() {
//         isLoading = false;
//         errorMessage = 'Please select a date range';
//       });
//       return;
//     }

//     try {
//       final days = endDate!.difference(startDate!).inDays;

//       if (days > 30) {
//         setState(() {
//           isLoading = false;
//           errorMessage = 'Please select a date range of 30 days or less';
//         });
//         return;
//       }

//       for (int i = 0; i <= days; i++) {
//         final currentDate = startDate!.add(Duration(days: i));
//         final nextDate = currentDate.add(const Duration(days: 1));

//         final allOrdersSnapshot = await FirebaseFirestore.instance
//             .collection('all_pickups')
//             .where('createdAt',
//                 isGreaterThanOrEqualTo: Timestamp.fromDate(currentDate))
//             .where('createdAt', isLessThan: Timestamp.fromDate(nextDate))
//             .get();

//         final pending = allOrdersSnapshot.docs
//             .where(
//                 (doc) => (doc['status'] as String?)?.toLowerCase() == 'pending')
//             .length;

//         final inProgress = allOrdersSnapshot.docs
//             .where((doc) =>
//                 (doc['status'] as String?)?.toLowerCase() == 'inprogress' ||
//                 (doc['status'] as String?)?.toLowerCase() == 'in progress')
//             .length;

//         final cancelled = allOrdersSnapshot.docs.where((doc) {
//           final status = (doc['status'] as String?)?.toLowerCase();
//           return status == 'cancelledbyuser' ||
//               status == 'cancelledbyadmin' ||
//               status == 'cancelled';
//         }).length;

//         final completed = allOrdersSnapshot.docs
//             .where((doc) =>
//                 (doc['status'] as String?)?.toLowerCase() == 'completed')
//             .length;

//         final total = allOrdersSnapshot.docs.length;

//         reportData.add({
//           'date': DateFormat('MMM dd, yyyy').format(currentDate),
//           'total': total,
//           'pending': pending,
//           'inProgress': inProgress,
//           'cancelled': cancelled,
//           'completed': completed,
//         });

//         totalOrders += total;
//         pendingOrders += pending;
//         inProgressOrders += inProgress;
//         cancelledOrders += cancelled;
//         completedOrders += completed;
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Error generating report: ${e.toString()}';
//       });
//       debugPrint('Error generating report: $e');
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   Future<void> _exportToPdf() async {
//     if (reportData.isEmpty) return;

//     final pdf = pw.Document();

//     // Add a page to the PDF
//     pdf.addPage(
//       pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         build: (pw.Context context) => [
//           // Header
//           pw.Header(
//             level: 0,
//             child: pw.Text('Order Report',
//                 style:
//                     pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
//           ),
//           pw.SizedBox(height: 10),

//           // Date Range
//           pw.Text(
//             'Date Range: ${DateFormat('MMM dd, yyyy').format(startDate!)} - ${DateFormat('MMM dd, yyyy').format(endDate!)}',
//             style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
//           ),
//           pw.SizedBox(height: 20),

//           // Summary Cards
//           pw.Row(
//             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//             children: [
//               _buildPdfSummaryCard('Total Orders', totalOrders, PdfColors.blue),
//               _buildPdfSummaryCard('Pending', pendingOrders, PdfColors.orange),
//               _buildPdfSummaryCard(
//                   'In Progress', inProgressOrders, PdfColors.yellow),
//               _buildPdfSummaryCard('Cancelled', cancelledOrders, PdfColors.red),
//               _buildPdfSummaryCard(
//                   'Completed', completedOrders, PdfColors.green),
//             ],
//           ),
//           pw.SizedBox(height: 30),

//           // Report Title
//           pw.Text('Daily Order Breakdown',
//               style:
//                   pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),

//           // Table
//           pw.Table.fromTextArray(
//             context: context,
//             border: pw.TableBorder.all(color: PdfColors.grey300),
//             headerStyle: pw.TextStyle(
//               fontWeight: pw.FontWeight.bold,
//               color: PdfColors.white,
//             ),
//             headerDecoration: pw.BoxDecoration(color: PdfColors.blue),
//             headers: [
//               'Date',
//               'Total',
//               'Pending',
//               'In Progress',
//               'Cancelled',
//               'Completed'
//             ],
//             data: reportData
//                 .map((data) => [
//                       data['date'],
//                       data['total'].toString(),
//                       data['pending'].toString(),
//                       data['inProgress'].toString(),
//                       data['cancelled'].toString(),
//                       data['completed'].toString(),
//                     ])
//                 .toList(),
//           ),
//           pw.SizedBox(height: 20),

//           // Totals Row
//           pw.Table(
//             border: pw.TableBorder.all(color: PdfColors.grey300),
//             children: [
//               pw.TableRow(
//                 decoration: pw.BoxDecoration(color: PdfColors.grey200),
//                 children: [
//                   pw.Padding(
//                     padding: const pw.EdgeInsets.all(8),
//                     child: pw.Text('TOTAL',
//                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                   ),
//                   pw.Padding(
//                     padding: const pw.EdgeInsets.all(8),
//                     child: pw.Text(totalOrders.toString(),
//                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                   ),
//                   pw.Padding(
//                     padding: const pw.EdgeInsets.all(8),
//                     child: pw.Text(pendingOrders.toString(),
//                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                   ),
//                   pw.Padding(
//                     padding: const pw.EdgeInsets.all(8),
//                     child: pw.Text(inProgressOrders.toString(),
//                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                   ),
//                   pw.Padding(
//                     padding: const pw.EdgeInsets.all(8),
//                     child: pw.Text(cancelledOrders.toString(),
//                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                   ),
//                   pw.Padding(
//                     padding: const pw.EdgeInsets.all(8),
//                     child: pw.Text(completedOrders.toString(),
//                         style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );

//     // Save the PDF document
//     final output = await getTemporaryDirectory();
//     final file = File('${output.path}/order_report.pdf');
//     await file.writeAsBytes(await pdf.save());

//     // Open the PDF preview dialog
//     await Printing.layoutPdf(
//       onLayout: (PdfPageFormat format) async => pdf.save(),
//     );
//   }

//   pw.Widget _buildPdfSummaryCard(String title, int value, PdfColor color) {
//     return pw.Container(
//       width: 100,
//       height: 70,
//       decoration: pw.BoxDecoration(
//         // color: color.,
//         borderRadius: pw.BorderRadius.circular(8),
//       ),
//       padding: const pw.EdgeInsets.all(8),
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Text(
//             title,
//             style: pw.TextStyle(
//               color: color,
//               fontSize: 10,
//             ),
//           ),
//           pw.SizedBox(height: 4),
//           pw.Text(
//             value.toString(),
//             style: pw.TextStyle(
//               color: color,
//               fontSize: 18,
//               fontWeight: pw.FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           // Date Range Selector
//           Card(
//             child: Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Column(
//                 children: [
//                   const Text('Select Date Range',
//                       style:
//                           TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextButton.icon(
//                           onPressed: () async {
//                             final picked = await showDateRangePicker(
//                               context: context,
//                               firstDate: DateTime(2023),
//                               lastDate: DateTime.now(),
//                               initialDateRange:
//                                   startDate != null && endDate != null
//                                       ? DateTimeRange(
//                                           start: startDate!, end: endDate!)
//                                       : null,
//                             );
//                             if (picked != null) {
//                               setState(() {
//                                 startDate = picked.start;
//                                 endDate = picked.end;
//                               });
//                             }
//                           },
//                           icon: const Icon(Icons.date_range),
//                           label: Text(
//                             startDate == null || endDate == null
//                                 ? 'Tap to select dates'
//                                 : '${DateFormat('MMM dd, yyyy').format(startDate!)} - ${DateFormat('MMM dd, yyyy').format(endDate!)}',
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),

//           // Generate Report Button
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//               ),
//               onPressed: generateReport,
//               child: isLoading
//                   ? const SizedBox(
//                       height: 20,
//                       width: 20,
//                       child: CircularProgressIndicator(
//                         color: Colors.white,
//                         strokeWidth: 2,
//                       ),
//                     )
//                   : const Text('Generate Report',
//                       style: TextStyle(fontSize: 16)),
//             ),
//           ),

//           // Error Message
//           if (errorMessage != null)
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0),
//               child: Card(
//                 color: Colors.red[50],
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Text(
//                     errorMessage!,
//                     style: const TextStyle(color: Colors.red),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//             ),

//           const SizedBox(height: 16),

//           // Summary Cards
//           if (reportData.isNotEmpty) ...[
//             Wrap(
//               spacing: 12,
//               runSpacing: 12,
//               children: [
//                 _buildSummaryCard('Total Orders', totalOrders, Colors.blue),
//                 _buildSummaryCard('Pending', pendingOrders, Colors.orange),
//                 _buildSummaryCard(
//                     'In Progress', inProgressOrders, Colors.yellow[700]!),
//                 _buildSummaryCard('Cancelled', cancelledOrders, Colors.red),
//                 _buildSummaryCard('Completed', completedOrders, Colors.green),
//               ],
//             ),
//             const SizedBox(height: 20),

//             // Detailed Report
//             Expanded(
//               child: Column(
//                 children: [
//                   // Report Title
//                   const Text('Daily Order Breakdown',
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 10),

//                   // Report Table with both scrolling directions
//                   Expanded(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey[300]!),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Scrollbar(
//                         thumbVisibility: true,
//                         child: SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: SizedBox(
//                             width: MediaQuery.of(context).size.width > 600
//                                 ? MediaQuery.of(context).size.width * 0.8
//                                 : 600,
//                             child: Scrollbar(
//                               thumbVisibility: true,
//                               child: SingleChildScrollView(
//                                 scrollDirection: Axis.vertical,
//                                 child: Card(
//                                   margin: EdgeInsets.zero,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(12.0),
//                                     child: Table(
//                                       border: TableBorder.all(
//                                         color: Colors.grey[300]!,
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       columnWidths: const {
//                                         0: FixedColumnWidth(120),
//                                         1: FixedColumnWidth(80),
//                                         2: FixedColumnWidth(80),
//                                         3: FixedColumnWidth(80),
//                                         4: FixedColumnWidth(80),
//                                         5: FixedColumnWidth(80),
//                                       },
//                                       children: [
//                                         // Header Row
//                                         TableRow(
//                                           decoration: BoxDecoration(
//                                             color: Colors.grey[200],
//                                             borderRadius:
//                                                 const BorderRadius.only(
//                                               topLeft: Radius.circular(8),
//                                               topRight: Radius.circular(8),
//                                             ),
//                                           ),
//                                           children: [
//                                             _buildHeaderCell('Date'),
//                                             _buildHeaderCell('Total'),
//                                             _buildHeaderCell('Pending'),
//                                             _buildHeaderCell('In Progress'),
//                                             _buildHeaderCell('Cancelled'),
//                                             _buildHeaderCell('Completed'),
//                                           ],
//                                         ),
//                                         // Data Rows
//                                         ...reportData
//                                             .map((data) => TableRow(
//                                                   children: [
//                                                     _buildDataCell(
//                                                         data['date']),
//                                                     _buildDataCell(data['total']
//                                                         .toString()),
//                                                     _buildDataCell(
//                                                         data['pending']
//                                                             .toString()),
//                                                     _buildDataCell(
//                                                         data['inProgress']
//                                                             .toString()),
//                                                     _buildDataCell(
//                                                         data['cancelled']
//                                                             .toString()),
//                                                     _buildDataCell(
//                                                         data['completed']
//                                                             .toString()),
//                                                   ],
//                                                 ))
//                                             .toList(),
//                                         // Totals Row
//                                         TableRow(
//                                           decoration: BoxDecoration(
//                                             color: Colors.grey[100],
//                                             borderRadius:
//                                                 const BorderRadius.only(
//                                               bottomLeft: Radius.circular(8),
//                                               bottomRight: Radius.circular(8),
//                                             ),
//                                           ),
//                                           children: [
//                                             _buildHeaderCell('TOTAL'),
//                                             _buildHeaderCell(
//                                                 totalOrders.toString()),
//                                             _buildHeaderCell(
//                                                 pendingOrders.toString()),
//                                             _buildHeaderCell(
//                                                 inProgressOrders.toString()),
//                                             _buildHeaderCell(
//                                                 cancelledOrders.toString()),
//                                             _buildHeaderCell(
//                                                 completedOrders.toString()),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // Export Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: OutlinedButton.icon(
//                       onPressed: reportData.isEmpty ? null : _exportToPdf,
//                       icon: const Icon(Icons.download),
//                       label: const Text('Export Report as PDF'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ] else if (!isLoading) ...[
//             const Expanded(
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.analytics, size: 64, color: Colors.grey),
//                     SizedBox(height: 16),
//                     Text('No report data available',
//                         style: TextStyle(color: Colors.grey)),
//                     Text('Select a date range and generate report',
//                         style: TextStyle(color: Colors.grey)),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildSummaryCard(String title, int value, Color color) {
//     return SizedBox(
//       width: 150,
//       child: Card(
//         color: color.withOpacity(0.1),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   color: color,
//                   fontSize: 14,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 value.toString(),
//                 style: TextStyle(
//                   color: color,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeaderCell(String text) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Text(
//         text,
//         style: const TextStyle(fontWeight: FontWeight.bold),
//         textAlign: TextAlign.center,
//       ),
//     );
//   }

//   Widget _buildDataCell(String text) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Text(
//         text,
//         textAlign: TextAlign.center,
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

class AdminReportsTab extends StatefulWidget {
  const AdminReportsTab({super.key});

  @override
  State<AdminReportsTab> createState() => _AdminReportsTabState();
}

class _AdminReportsTabState extends State<AdminReportsTab> {
  DateTime? startDate;
  DateTime? endDate;
  bool isLoading = false;
  String? errorMessage;
  List<Map<String, dynamic>> reportData = [];
  int totalOrders = 0;
  int pendingOrders = 0;
  int inProgressOrders = 0;
  int cancelledOrders = 0;
  int completedOrders = 0;

  Future<void> generateReport() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      reportData.clear();
      totalOrders = 0;
      pendingOrders = 0;
      inProgressOrders = 0;
      cancelledOrders = 0;
      completedOrders = 0;
    });

    if (startDate == null || endDate == null) {
      setState(() {
        isLoading = false;
        errorMessage = 'Please select a date range';
      });
      return;
    }

    try {
      final days = endDate!.difference(startDate!).inDays;

      if (days > 30) {
        setState(() {
          isLoading = false;
          errorMessage = 'Please select a date range of 30 days or less';
        });
        return;
      }

      for (int i = 0; i <= days; i++) {
        final currentDate = startDate!.add(Duration(days: i));
        final nextDate = currentDate.add(const Duration(days: 1));

        final allOrdersSnapshot = await FirebaseFirestore.instance
            .collection('all_pickups')
            .where('createdAt',
                isGreaterThanOrEqualTo: Timestamp.fromDate(currentDate))
            .where('createdAt', isLessThan: Timestamp.fromDate(nextDate))
            .get();

        final pending = allOrdersSnapshot.docs
            .where((doc) => (doc['status'] as String?)?.toLowerCase() == 'pending')
            .length;
        
        final inProgress = allOrdersSnapshot.docs
            .where((doc) => (doc['status'] as String?)?.toLowerCase() == 'inprogress' ||
                            (doc['status'] as String?)?.toLowerCase() == 'in progress')
            .length;
        
        final cancelled = allOrdersSnapshot.docs
            .where((doc) {
              final status = (doc['status'] as String?)?.toLowerCase();
              return status == 'cancelledbyuser' || 
                     status == 'cancelledbyadmin' ||
                     status == 'cancelled';
            })
            .length;
        
        final completed = allOrdersSnapshot.docs
            .where((doc) => (doc['status'] as String?)?.toLowerCase() == 'completed')
            .length;

        final total = allOrdersSnapshot.docs.length;

        reportData.add({
          'date': DateFormat('MMM dd, yyyy').format(currentDate),
          'total': total,
          'pending': pending,
          'inProgress': inProgress,
          'cancelled': cancelled,
          'completed': completed,
        });

        totalOrders += total;
        pendingOrders += pending;
        inProgressOrders += inProgress;
        cancelledOrders += cancelled;
        completedOrders += completed;
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error generating report: ${e.toString()}';
      });
      debugPrint('Error generating report: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _exportToPdf() async {
    if (reportData.isEmpty) return;

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          pw.Header(
            level: 0,
            child: pw.Text('Order Report',
                style: pw.TextStyle(
                    fontSize: 24, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Date Range: ${DateFormat('MMM dd, yyyy').format(startDate!)} - ${DateFormat('MMM dd, yyyy').format(endDate!)}',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildPdfSummaryCard('Total Orders', totalOrders, PdfColors.blue),
              _buildPdfSummaryCard('Pending', pendingOrders, PdfColors.orange),
              _buildPdfSummaryCard('In Progress', inProgressOrders, PdfColors.yellow),
              _buildPdfSummaryCard('Cancelled', cancelledOrders, PdfColors.red),
              _buildPdfSummaryCard('Completed', completedOrders, PdfColors.green),
            ],
          ),
          pw.SizedBox(height: 30),
          pw.Text('Daily Order Breakdown',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Table.fromTextArray(
            context: context,
            border: pw.TableBorder.all(color: PdfColors.grey300),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
            headerDecoration: pw.BoxDecoration(color: PdfColors.blue),
            headers: ['Date', 'Total', 'Pending', 'In Progress', 'Cancelled', 'Completed'],
            data: reportData.map((data) => [
              data['date'],
              data['total'].toString(),
              data['pending'].toString(),
              data['inProgress'].toString(),
              data['cancelled'].toString(),
              data['completed'].toString(),
            ]).toList(),
          ),
          pw.SizedBox(height: 20),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text('TOTAL',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(totalOrders.toString(),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(pendingOrders.toString(),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(inProgressOrders.toString(),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(cancelledOrders.toString(),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(completedOrders.toString(),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/order_report.pdf');
    await file.writeAsBytes(await pdf.save());

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pw.Widget _buildPdfSummaryCard(String title, int value, PdfColor color) {
    return pw.Container(
      width: 100,
      height: 70,
      decoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(8),
      ),
      padding: const pw.EdgeInsets.all(8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              color: color,
              fontSize: 10,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value.toString(),
            style: pw.TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Date Range Selector
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const Text('Select Date Range',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () async {
                            final picked = await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2023),
                              lastDate: DateTime.now(),
                              initialDateRange: startDate != null && endDate != null
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
                            startDate == null || endDate == null
                                ? 'Tap to select dates'
                                : '${DateFormat('MMM dd, yyyy').format(startDate!)} - ${DateFormat('MMM dd, yyyy').format(endDate!)}',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Generate Report Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: generateReport,
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Generate Report',
                      style: TextStyle(fontSize: 16)),
            ),
          ),

          // Error Message
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Card(
                color: Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Summary Cards
          if (reportData.isNotEmpty) ...[
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildSummaryCard('Total Orders', totalOrders, Colors.blue),
                _buildSummaryCard('Pending', pendingOrders, Colors.orange),
                _buildSummaryCard('In Progress', inProgressOrders, Colors.yellow[700]!),
                _buildSummaryCard('Cancelled', cancelledOrders, Colors.red),
                _buildSummaryCard('Completed', completedOrders, Colors.green),
              ],
            ),
            const SizedBox(height: 20),

            // Detailed Report - Expanded to take maximum available space
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    // Report Title
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: const Text('Daily Order Breakdown',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 10),
                    
                    // Expanded Table Area
                    Expanded(
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Scrollbar(
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Table(
                                  border: TableBorder.all(
                                    color: Colors.grey[300]!,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  columnWidths: const {
                                    0: FixedColumnWidth(140),  // Wider date column
                                    1: FixedColumnWidth(100),  // Wider columns for better readability
                                    2: FixedColumnWidth(100),
                                    3: FixedColumnWidth(100),
                                    4: FixedColumnWidth(100),
                                    5: FixedColumnWidth(100),
                                  },
                                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                  children: [
                                    // Header Row with larger padding
                                    TableRow(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4),
                                          topRight: Radius.circular(4),
                                        ),
                                      ),
                                      children: [
                                        _buildHeaderCell('Date'),
                                        _buildHeaderCell('Total'),
                                        _buildHeaderCell('Pending'),
                                        _buildHeaderCell('In Progress'),
                                        _buildHeaderCell('Cancelled'),
                                        _buildHeaderCell('Completed'),
                                      ],
                                    ),
                                    // Data Rows
                                    ...reportData.map((data) => TableRow(
                                      children: [
                                        _buildDataCell(data['date']),
                                        _buildDataCell(data['total'].toString()),
                                        _buildDataCell(data['pending'].toString()),
                                        _buildDataCell(data['inProgress'].toString()),
                                        _buildDataCell(data['cancelled'].toString()),
                                        _buildDataCell(data['completed'].toString()),
                                      ],
                                    )),
                                    // Totals Row
                                    TableRow(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(4),
                                          bottomRight: Radius.circular(4),
                                        ),
                                      ),
                                      children: [
                                        _buildHeaderCell('TOTAL'),
                                        _buildHeaderCell(totalOrders.toString()),
                                        _buildHeaderCell(pendingOrders.toString()),
                                        _buildHeaderCell(inProgressOrders.toString()),
                                        _buildHeaderCell(cancelledOrders.toString()),
                                        _buildHeaderCell(completedOrders.toString()),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Export Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: reportData.isEmpty
                    ? null
                    : _exportToPdf,
                icon: const Icon(Icons.download),
                label: const Text('Export Report as PDF'),
              ),
            ),
          ] else if (!isLoading) ...[
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.analytics, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No report data available',
                        style: TextStyle(color: Colors.grey)),
                    Text('Select a date range and generate report',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, int value, Color color) {
    return SizedBox(
      width: 150,
      child: Card(
        color: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value.toString(),
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12.0),  // Increased padding
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,  // Slightly larger font
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDataCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12.0),  // Increased padding
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),  // Slightly larger font
        textAlign: TextAlign.center,
      ),
    );
  }
}