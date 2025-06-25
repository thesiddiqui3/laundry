import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laundry/app/service/auth_service.dart';
import 'package:laundry/app/service/firestore_service/firestore_service.dart';
import 'package:laundry/app/views/admin/admin_dashborad.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:laundry/app/views/address/enter_address.dart';
import 'package:laundry/app/views/dashboard/dashboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final AuthService _auth = AuthService();
  late TabController _tabController;
  bool _isLoggingIn = false;

  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();

  bool _loginPasswordVisible = true;
  bool _signupPasswordVisible = true;
  bool _signupConfirmPasswordVisible = true;

  // Login controllers
  final TextEditingController _loginEmailPhoneController =
      TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();

  // Signup controllers
  final TextEditingController _signupNameController = TextEditingController();
  final TextEditingController _signupPhoneController = TextEditingController();
  final TextEditingController _signupEmailController = TextEditingController();
  final TextEditingController _signupPasswordController =
      TextEditingController();
  final TextEditingController _signupConfirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailPhoneController.dispose();
    _loginPasswordController.dispose();
    _signupNameController.dispose();
    _signupPhoneController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    _signupConfirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TabBar(
                      controller: _tabController,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.blue,
                      tabs: const [
                        Tab(text: "Login"),
                        Tab(text: "Signup"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 480,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildLoginForm(),
                          _buildSignupForm(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoggingIn)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _loginEmailPhoneController,
            decoration: InputDecoration(
              hintText: "Email / Phone",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email or phone';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: _loginPasswordController,
            obscureText: _loginPasswordVisible,
            decoration: InputDecoration(
              hintText: "Password",
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _loginPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _loginPasswordVisible = !_loginPasswordVisible;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: _isLoggingIn
                  ? null
                  : _handleLogin, // Disable button when loading
              child: _isLoggingIn
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text("Login"),
            ),
          ),
          const SizedBox(height: 15),
          Text("or", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 15),
          _socialButton(
            "Continue with Google",
            Colors.white,
            Colors.black,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_loginFormKey.currentState!.validate()) {
      setState(() {
        _isLoggingIn = true; // Start loading
      });

      try {
        User? user = await _auth.login(
          _loginEmailPhoneController.text.trim(),
          _loginPasswordController.text.trim(),
        );

        if (user != null) {
          final prefs = await SharedPreferences.getInstance();

          // Admin login flow
          if (_loginEmailPhoneController.text.trim() == "admin@laundry.com") {
            await prefs.setBool('is_admin_logged_in', true);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => AdminDashboard()),
            );
            return;
          }

          // Regular user flow
          await prefs.setBool('is_user_logged_in', true);

          // Check if user has address
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          bool hasAddress = userDoc.exists &&
              userDoc.data()?['addresses'] != null &&
              (userDoc.data()!['addresses'] as List).isNotEmpty;

          if (!hasAddress) {
            // First time or no address - go to address screen
            await prefs.setBool('is_user_first_logged_in', false);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => EnterAddressScreen()),
            );
          } else {
            // Has address - go to dashboard with address data
            final addresses = userDoc.data()!['addresses'] as List;
            final lastAddress = addresses.last;

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => Dashboard(
                  address: lastAddress['address'] ?? '',
                  city: lastAddress['city'] ?? '',
                  pincode: lastAddress['pincode'] ?? '',
                ),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid credentials')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoggingIn = false; // Stop loading in any case
        });
      }
    }
  }

  Widget _buildSignupForm() {
    return Form(
      key: _signupFormKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: _signupNameController,
              decoration: InputDecoration(
                hintText: "Full Name",
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter your name'
                  : null,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _signupPhoneController,
              decoration: InputDecoration(
                hintText: "Phone Number",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Enter phone number';
                if (value.length < 10) return 'Enter a valid phone number';
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _signupEmailController,
              decoration: InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Enter email';
                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value))
                  return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _signupPasswordController,
              obscureText: _signupPasswordVisible,
              decoration: InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _signupPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _signupPasswordVisible = !_signupPasswordVisible;
                    });
                  },
                ),
              ),
              validator: (value) => value == null || value.length < 6
                  ? 'Password too short'
                  : null,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _signupConfirmPasswordController,
              obscureText: _signupConfirmPasswordVisible,
              decoration: InputDecoration(
                hintText: "Confirm Password",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _signupConfirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _signupConfirmPasswordVisible =
                          !_signupConfirmPasswordVisible;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value != _signupPasswordController.text)
                  return 'Passwords do not match';
                return null;
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: _handleSignup,
                child: Text("Signup"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSignup() async {
    if (_signupFormKey.currentState!.validate()) {
      try {
        final email = _signupEmailController.text.trim();
        final password = _signupPasswordController.text.trim();
        final name = _signupNameController.text.trim();
        final phone = _signupPhoneController.text.trim();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Creating account...')),
        );

        final user = await _auth.signUp(email, password);
        if (user != null) {
          await FirestoreService().createUserProfile(
            uid: user.uid,
            name: name,
            email: email,
            phone: phone,
          );

          // Set login status
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('is_user_logged_in', true);
          await prefs.setBool('is_user_first_logged_in', true);

          // Logout and prompt login
          await FirebaseAuth.instance.signOut();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account created. Please login.')),
          );

          _tabController.animateTo(0); // Switch to Login tab
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: ${e.toString()}')),
        );
      }
    }
  }

  Widget _socialButton(String text, Color bgColor, Color textColor) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          side: BorderSide(color: Colors.grey.shade300),
        ),
        onPressed: () async {
          try {
            final user = await AuthService().signInWithGoogle();
            if (user != null) {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('is_user_logged_in', true);

              // Check if user has address
              final userDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get();

              bool hasAddress = userDoc.exists &&
                  userDoc.data()?['addresses'] != null &&
                  (userDoc.data()!['addresses'] as List).isNotEmpty;

              if (!hasAddress) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => EnterAddressScreen()),
                );
              } else {
                final addresses = userDoc.data()!['addresses'] as List;
                final lastAddress = addresses.last;

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Dashboard(
                      address: lastAddress['address'] ?? '',
                      city: lastAddress['city'] ?? '',
                      pincode: lastAddress['pincode'] ?? '',
                    ),
                  ),
                );
              }
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Google Sign-In Failed: ${e.toString()}')),
            );
          }
        },
        child: Text(text),
      ),
    );
  }
}
