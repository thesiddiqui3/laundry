import 'package:flutter/material.dart';
import 'package:laundry/app/views/home/home_view.dart';
import 'package:laundry/app/views/order/order_view.dart';
import 'package:laundry/app/views/profile/profile_view.dart';

class Dashboard extends StatefulWidget {
  final String address;
  final String city;
  final String pincode;

  const Dashboard({
    super.key,
    required this.address,
    required this.city,
    required this.pincode,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(),
      const OrdersScreen(),
      ProfileScreen(), // Placeholder
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
