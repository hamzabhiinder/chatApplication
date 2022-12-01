import 'package:chatapplication/Helper/SharedPrefrenceHelper.dart';
import 'package:chatapplication/Pages/HomePage.dart';
import 'package:chatapplication/Pages/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyC5nDTfuBxLCe-Wp28igKQWZVNLc3YO-sQ",
      authDomain: "study-app-f3379.firebaseapp.com",
      projectId: "study-app-f3379",
      storageBucket: "study-app-f3379.appspot.com",
      messagingSenderId: "1087163962327",
      appId: "1:1087163962327:web:f2f5cf36de0174f8ef3192",
    ));
  } else {
    await Firebase.initializeApp();
  }
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSingedIn = false;

  @override
  void initState() {
    getUserLoggedInStatus();
    super.initState();
  }

  getUserLoggedInStatus() async {
    await HelperFuction.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          isSingedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.redAccent),
      debugShowCheckedModeBanner: false,
      home: isSingedIn ? HomePage() : LoginPage(),
    );
  }
}
