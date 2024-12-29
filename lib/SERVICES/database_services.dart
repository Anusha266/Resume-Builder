import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  // SAVING THE USER DATA
  savingUserData(
      {name,
      email,
      password,
      mobileNumber,
      state,
      district,
      mandal,
      village}) async {
    await firestore.collection("users").doc(uid).set({
      "name": name,
      "email": email,
      "password": password,
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "mobileNumber": mobileNumber,
      "state": state,
      "district": district,
      "mandal": mandal,
      "village": village
    });
  }
}
