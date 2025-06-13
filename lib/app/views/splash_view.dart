import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laundry/app/service/auth_service.dart';
import 'package:laundry/app/views/admin/admin_dashborad.dart';
import 'package:laundry/app/views/address/enter_address.dart';
import 'package:laundry/app/views/dashboard/dashboard.dart';
import 'package:laundry/app/views/onboarding/onboarding_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = true;
  bool? _isFirstLogin;
  bool? _isUserLoggedIn;
  bool? _isAdminLoggedIn;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFirstLogin = prefs.getBool('is_user_first_logged_in') ?? true;
      _isUserLoggedIn = prefs.getBool('is_user_logged_in') ?? false;
      _isAdminLoggedIn = prefs.getBool('is_admin_logged_in') ?? false;
      _isLoading = false;
    });
  }

  Future<Map<String, String>?> _getUserAddress(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists && userDoc.data()?.containsKey('addresses') == true) {
        final addresses = userDoc.data()!['addresses'] as List;
        if (addresses.isNotEmpty) {
          final lastAddress = addresses.last as Map<String, dynamic>;
          return {
            'address': lastAddress['address']?.toString() ?? '',
            'city': lastAddress['city']?.toString() ?? '',
            'pincode': lastAddress['pincode']?.toString() ?? '',
          };
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: AuthService().authChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data;

          // If user is not logged in, show onboarding
          if (user == null) {
            return OnboardingScreen();
          }

          // Check if user is admin
          if (_isAdminLoggedIn == true) {
            return AdminDashboard();
          }

          // For regular users, check if they have an address
          return FutureBuilder<Map<String, String>?>(
            future: _getUserAddress(user.uid),
            builder: (context, addressSnapshot) {
              if (addressSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // If user has address data, go to dashboard
              if (addressSnapshot.hasData) {
                final addressData = addressSnapshot.data!;
                return Dashboard(
                  address: addressData['address']!,
                  city: addressData['city']!,
                  pincode: addressData['pincode']!,
                );
              }
              if (_isFirstLogin!) {
                return EnterAddressScreen();
              }

              // If no address data, go to address entry screen
              return Dashboard(
                  address: "address", city: "city", pincode: "pincode");
            },
          );
        },
      ),
    );
  }
}
