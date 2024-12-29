import 'package:flutter/material.dart';
import 'package:resume/HELPER/helper_function.dart';
import 'package:resume/screens/home_screen.dart';
import 'package:resume/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isSignedIn = false;
  getUserLoggedInStatus() async {
    await HelperFunction.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          print("SANKAR BEHERA ${value}");
          isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lock screen orientation to portrait

    // Navigate to the home screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      getUserLoggedInStatus();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => isSignedIn ? HomeScreen() : LoginPage()));
    });

    return Scaffold(
      body: Container(
        color: Colors.green,
        child: Center(
          child: Text(
            "RESUME BUILDER",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
      ),
    );
  }
}
