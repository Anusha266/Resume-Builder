// import 'package:flutter/material.dart';
// import 'package:resume/HELPER/helper_function.dart';
// import 'package:resume/screens/home_screen.dart';
// import 'package:resume/screens/login_screen.dart';

// class SplashScreen extends StatefulWidget {
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   bool isSignedIn = false;
//   getUserLoggedInStatus() async {
//     await HelperFunction.getUserLoggedInStatus().then((value) {
//       if (value != null) {
//         setState(() {
//           print("SANKAR BEHERA ${value}");
//           isSignedIn = value;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Lock screen orientation to portrait

//     // Navigate to the home screen after 3 seconds
//     Future.delayed(const Duration(seconds: 3), () {
//       getUserLoggedInStatus();
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//               builder: (context) => isSignedIn ? HomeScreen() : LoginPage()));
//     });

//     return Scaffold(
//       body: Container(
//         color: Colors.green,
//         child: Center(
//           child: Text(
//             "RESUME BUILDER",
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resume/HELPER/helper_function.dart';
import 'package:resume/screens/home_screen.dart';
import 'package:resume/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool isSignedIn = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
    checkLoginStatus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void checkLoginStatus() async {
    await getUserLoggedInStatus();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isSignedIn ? HomeScreen() : LoginPage(),
        ),
      );
    });
  }

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green[700]!,
              Colors.green[500]!,
              Colors.green[300]!,
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Icon or Logo
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.description,
                      size: 80,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // App Name
                  Text(
                    "RESUME BUILDER",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(0, 3),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Future Force Text
                  Text(
                    "@FutureForce",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.9),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Version Number
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text(
                      "Version 1.0.0",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
