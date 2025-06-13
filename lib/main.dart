import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry/app/views/address/enter_address.dart';
import 'package:laundry/app/views/admin/admin_dashborad.dart';
import 'package:laundry/app/views/login/login_view.dart';
import 'package:laundry/app/views/onboarding/onboarding_view.dart';
import 'package:laundry/app/views/splash_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Login UI',
      theme: ThemeData(primarySwatch: Colors.blue),
      // home: AdminDashboard(),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   final prefs = await SharedPreferences.getInstance();
//   final isAdmin = prefs.getBool('is_admin_logged_in') ?? false;
//   final isUser = prefs.getBool('is_user_logged_in') ?? false;

//   Widget startScreen;
//   if (isAdmin) {
//     startScreen = AdminDashboard();
//   } else if (isUser) {
//     startScreen = EnterAddressScreen(); // or EnterAddressScreen()
//   } else {
//     startScreen = OnboardingScreen();
//   }

//   runApp(MyApp(startScreen: startScreen));
// }

// class MyApp extends StatelessWidget {
//   final Widget startScreen;

//   const MyApp({super.key, required this.startScreen});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Laundry App',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: startScreen,
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

