import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:resume/HELPER/helper_function.dart';
import 'package:resume/SERVICES/database_services.dart';
import 'package:velocity_x/velocity_x.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // // LOGIN VIA GOOGLE
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<UserCredential?> loginWithGoogle() async {
    print("Attempting Google Sign-In");

    try {
      // Sign in with Google
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print("Google sign-in aborted.");
        return null; // User canceled the sign-in
      }

      // Get Google authentication details
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final googleEmail = googleUser.email;
      print("Email from Google: $googleEmail");

      // Fetch all users and find a matching email
      final usersSnapshot = await firestore.collection('users').get();
      final matchingUser = usersSnapshot.docs
          .where((doc) => doc.data()['email'] == googleEmail)
          .toList();

      if (matchingUser.isEmpty) {
        // No matching user found, handle accordingly
        print("No user with the email $googleEmail exists in Firestore.");
        await GoogleSignIn().signOut();
        return null;
      }
      // Matching user found
      print("User exists in Firestore with email $googleEmail.");
      await HelperFunction.saveUserEmail(googleEmail);
      await HelperFunction.saveUserLoggedInStatus(true);

      final userCredential = await auth.signInWithCredential(credential);
      print("User signed in successfully.");
      return userCredential;
    } catch (e) {
      print("Error during Google sign-in: ${e.toString()}");
    }

    return null;
  }

  Future<void> googleSignUp(
    String? firstName,
    String? lastName,
    String? collegeName,
    String? specialization,
    String? course,
    String? branch,
    int? passOutYear,
    String? cgpa,
    String? gender,
    String github,
    String linkedin,
    List<String> preferredCountries,
    List<String> preferredStates,
    List<String> preferredCities,
    DateTime? dob,
    String email,
    String password,
  ) async {
    // Create a new user document in Firestore
    try {
      final authUser = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await firestore.collection("users").doc(authUser.user?.uid).set({
        'firstName': firstName ?? "",
        'lastName': lastName ?? "",
        'collegeName': collegeName ?? "",
        'specialization': specialization ?? "",
        'course': course ?? "",
        'branch': branch ?? "",
        'passOutYear': passOutYear ?? 0,
        'cgpa': cgpa ?? "",
        'gender': gender ?? "",
        'github': github,
        'linkedin': linkedin,
        'preferredCountries':
            preferredCountries.isEmpty ? ["None"] : preferredCountries,
        'preferredStates': preferredStates.isEmpty ? ["None"] : preferredStates,
        'preferredCities': preferredCities.isEmpty ? ["None"] : preferredCities,
        'dob': dob?.toIso8601String() ?? "",
        'email': email,
        'password': password, // Avoid storing passwords in plain text
      });

      if (authUser.user == null) {
        throw Exception("Auth user creation failed.");
      }

      Fluttertoast.showToast(
        msg: "User created successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      print("Error creating user in Firestore: $e");

      Fluttertoast.showToast(
        msg: "Error creating user. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // SIGN OUT
  signOut(context) async {
    try {
      await HelperFunction.saveUserLoggedInStatus(false);
      await HelperFunction.saveUserEmail("");
      await HelperFunction.saveUserName("");
      await auth.signOut();
      await _googleSignIn.signOut();
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
      return e.toString();
    }
  }
}
