
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry/app/controller/profile_controller/profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final _formKey = GlobalKey<FormState>();

    final nameController = TextEditingController(text: controller.name.value);
    final emailController = TextEditingController(text: controller.email.value);
    final phoneController = TextEditingController(text: controller.phone.value);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: nameController,
                label: 'Name',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: emailController,
                label: 'Email',
                readOnly: true, // Email is not editable
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: phoneController,
                label: 'Phone Number',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Phone number is required';
                  }
                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return 'Enter a valid 10-digit number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await controller.updateProfileInFirestore(
                        newName: nameController.text.trim(),
                        newPhone: phoneController.text.trim(),
                      );

                      controller.updateProfileLocally(
                        newName: nameController.text.trim(),
                        newEmail: emailController.text.trim(),
                        newPhone: phoneController.text.trim(),
                      );

                      Get.back();
                      Get.snackbar(
                        'Profile Updated',
                        'Your profile has been successfully updated.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green.shade100,
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: readOnly ? Colors.grey[200] : Colors.blue[50],
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
