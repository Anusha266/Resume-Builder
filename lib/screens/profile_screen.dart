import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:resume/HELPER/helper_function.dart';
import 'package:resume/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
  }

  void _logout(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: 'Logout',
      desc: 'Are you sure you want to logout?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().signOut();
        await HelperFunction.saveUserLoggedInStatus(false);
        await HelperFunction.saveUserEmail("");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) =>
              false, // This condition removes all previous routes
        );
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: user == null
          ? Center(child: Text("No user found"))
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (snapshot.hasData && snapshot.data != null) {
                  final data = snapshot.data!;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: ZoomIn(
                      duration: Duration(milliseconds: 600),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoTile("First Name", data["firstName"]),
                          _buildInfoTile("Last Name", data["lastName"]),
                          _buildInfoTile("College", data["collegeName"]),
                          _buildInfoTile(
                              "Specialization", data["specialization"]),
                          _buildInfoTile("Course", data["course"]),
                          _buildInfoTile("Branch", data["branch"]),
                          _buildInfoTile("Pass Out Year", data["passOutYear"]),
                          _buildInfoTile("CGPA", data["cgpa"]),
                          _buildInfoTile("Gender", data["gender"]),
                          _buildInfoTile("GitHub", data["github"]),
                          _buildInfoTile("LinkedIn", data["linkedin"]),
                          _buildInfoTile("Preferred Countries",
                              data["preferredCountries"]),
                          _buildInfoTile(
                              "Preferred States", data["preferredStates"]),
                          _buildInfoTile(
                              "Preferred Cities", data["preferredCities"]),
                          _buildInfoTile("Date of Birth", data["dob"]),
                          _buildInfoTile("Email", data["email"]),
                          SizedBox(height: 20),
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () => _logout(context),
                              icon: Icon(Icons.logout),
                              label: Text("Logout"),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                textStyle: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Center(child: Text("No data found"));
              },
            ),
    );
  }

  Widget _buildInfoTile(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ZoomIn(
        duration: Duration(milliseconds: 400),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade200,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Flexible(
                child: Text(
                  value != null ? value.toString() : 'N/A',
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
