import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laundry/app/views/login/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminSettingsTab extends StatelessWidget {
  const AdminSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Admin Profile'),
          onTap: () {
            // Navigate to profile
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notifications'),
          onTap: () {
            // Notification settings
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.help),
          title: const Text('Help & Support'),
          onTap: () {
            // Help screen
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Logout', style: TextStyle(color: Colors.red)),
          onTap: () => _logoutAdmin(context),
        ),
      ],
    );
  }

  Future<void> _logoutAdmin(BuildContext context) async {
    // Show full-screen loading dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) => WillPopScope(
        onWillPop: () async => false, // Prevent dismissing by back button
        child: Container(
          color: Colors.black.withOpacity(0.5), // Semi-transparent background
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );

    try {
      // Perform logout operations
      await FirebaseAuth.instance.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("is_admin_logged_in", false);

      // Close the loading dialog
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();

      // Navigate to login screen
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      // Close the loading dialog
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();

      // Show error message
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
