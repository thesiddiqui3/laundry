import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry/app/views/address/enter_address.dart';
import 'package:laundry/app/views/admin/admin_dashborad.dart';
import 'package:laundry/app/views/login/login_view.dart';
import 'package:laundry/app/views/onboarding/onboarding_view.dart';
import 'package:laundry/app/views/splash_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app_util/keyboard_dimissal_ontap.dart';

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
      home: KeyboardDismissOnTap(child: SplashScreen()),
      debugShowCheckedModeBanner: false,
    );
  }
}
