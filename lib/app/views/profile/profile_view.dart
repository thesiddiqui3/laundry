import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry/app/controller/profile_controller/profile_controller.dart';
import 'package:laundry/app/service/auth_service.dart';
import 'package:laundry/app/views/address/saved_address.dart';
import 'package:laundry/app/views/login/login_view.dart';
import 'package:laundry/app/views/profile/edit_profile_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: controller.userProfileStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError ||
                !snapshot.hasData ||
                !snapshot.data!.exists) {
              return const Center(child: Text("Unable to load profile"));
            }

            final userData = snapshot.data!;
            controller.updateFromSnapshot(userData);

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      'Profile',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Obx(() => Text(
                        controller.name.value,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                  Obx(() => Text(
                        controller.email.value,
                        style: const TextStyle(color: Colors.grey),
                      )),
                  const SizedBox(height: 24),
                  _profileButton(Icons.edit, "Edit Profile", () {
                    Get.to(() => const EditProfileScreen());
                  }),
                  const SizedBox(height: 12),
                  _profileButton(Icons.location_on, "Saved Addresses", () {
                    Get.to(() => SavedAddressesScreen());
                  }),
                  const SizedBox(height: 12),
                  _profileButton(Icons.logout, "Logout", () => logout(context)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _profileButton(IconData icon, String text, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        backgroundColor: Colors.blue[50],
        foregroundColor: Colors.black,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 2. Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("is_user_logged_in", false);
      await AuthService().signOut();
      Navigator.of(context).pop(); // close spinner
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
  }
}
