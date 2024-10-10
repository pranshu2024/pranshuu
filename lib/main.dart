import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prophunter/provider/basicDataProvider.dart';
import 'package:prophunter/provider/propertyProvider.dart';
import 'package:prophunter/provider/unitProvider.dart';
import 'package:prophunter/provider/userProvider.dart';
import 'package:prophunter/routes.dart';
import 'package:prophunter/screens/landing_page.dart';
import 'package:prophunter/screens/login_page.dart';
import 'package:provider/provider.dart';

import 'constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PropertyProvider()),
        ChangeNotifierProvider(create: (context) => BasicDataProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => UnitProvider()),
      ],
      child: MaterialApp(
        title: 'PropHunter',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        theme: ThemeClass.darkTheme,
        darkTheme: ThemeClass.darkTheme,
        initialRoute: CheckLanding.routeName,
        routes: routes,
      ),
    );
  }
}

class CheckLanding extends StatefulWidget {
  static const String routeName = '/';

  const CheckLanding({super.key});

  @override
  State<CheckLanding> createState() => _CheckLandingState();
}

class _CheckLandingState extends State<CheckLanding> {
  Future<String> check() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection("user")
          .doc(currentUser.uid)
          .get();
      if (userDoc.exists) {
        return "home";
      } else {
        await FirebaseAuth.instance.signOut();
        return "signin";
      }
    }
    return "signin";
  }

  @override
  void initState() {
    super.initState();
    // If you need to perform some initial setup, you can call it here.
    // For example, you can call check() here if necessary.
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: check(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          if (snapshot.data == "home") {
            return const LandingPage();
          } else {
            return const LoginPage();
          }
        }
        return const Scaffold(
          body: Center(child: Text("Error occurred")),
        );
      },
    );
  }
}
