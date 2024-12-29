import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

class PersonalInformationScreen extends StatefulWidget {
  final String jobStream;
  final String jobTitle;

  const PersonalInformationScreen(
      {super.key, required this.jobStream, required this.jobTitle});
  @override
  _PersonalInformationScreenState createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController linkedInController = TextEditingController();
  final TextEditingController githubController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();

  String selectedDesignation = 'Fresher'; // Default designation
  final List<String> designations = [
    'Fresher',
    'Automation Tester',
    'Accountant',
    'Marketing',
    'Software Developer',
    'HR Manager',
  ];

  File? _selectedImage; // Profile image file
  Uint8List? _profileImageBytes; // Profile image as bytes

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchPersonData(); // Fetch user data from Firestore
  }

  Future<void> _fetchUserData() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth
              .instance.currentUser?.uid) // Replace with the current user's ID
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data();

        setState(() {
          firstNameController.text = userData?['firstName'] ?? '';
          lastNameController.text = userData?['lastName'] ?? '';
          emailController.text = userData?['email'] ?? '';
          linkedInController.text = userData?['linkedin'] ?? '';
          githubController.text = userData?['github'] ?? '';
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // Fetch user data from Firestore
  Future<void> _fetchPersonData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('personalInformation')
          .doc(uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          firstNameController.text = data['first_name'] ?? '';
          middleNameController.text = data['middle_name'] ?? '';
          lastNameController.text = data['last_name'] ?? '';
          addressController.text = data['address']['line'] ?? '';
          countryController.text = data['address']['country'] ?? '';
          stateController.text = data['address']['state'] ?? '';
          cityController.text = data['address']['city'] ?? '';
          pincodeController.text = data['address']['pincode'] ?? '';
          emailController.text = data['communication_email'] ?? '';
          mobileController.text = data['mobile'] ?? '';
          linkedInController.text = data['linkedin_profile'] ?? '';
          githubController.text = data['github_profile'] ?? '';
          selectedDesignation = data['designation'] ?? 'Fresher';

          // Decode and load the profile image
          if (data['profile_image'] != null) {
            _profileImageBytes = base64Decode(data['profile_image']);
          }
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // Function to pick an image
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Function to save data to Firestore
  Future<void> _saveDataToFirestore() async {
    if (_formKey.currentState!.validate()) {
      String? base64Image;
      if (_selectedImage != null) {
        base64Image = base64Encode(_selectedImage!.readAsBytesSync());
      }

      final formData = {
        "first_name": firstNameController.text,
        "middle_name": middleNameController.text,
        "last_name": lastNameController.text,
        "designation": selectedDesignation,
        "summary": "",
        "address": {
          "line": addressController.text,
          "country": countryController.text,
          "state": stateController.text,
          "city": cityController.text,
          "pincode": pincodeController.text,
        },
        "communication_email": emailController.text,
        "mobile": mobileController.text,
        "linkedin_profile": linkedInController.text,
        "github_profile": githubController.text,
        "profile_image": base64Image, // Profile image in base64
      };

      try {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          await FirebaseFirestore.instance
              .collection('personalInformation')
              .doc(uid)
              .set(formData);
        }
      } catch (e) {
        print('Error saving data: $e');
      }

      Navigator.pop(context); // Navigate back after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal Information"),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeIn(
                child: Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Colors.purple, Colors.purpleAccent],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.4),
                            blurRadius: 10,
                            spreadRadius: 3,
                          ),
                        ],
                        image: _selectedImage != null
                            ? DecorationImage(
                                image: FileImage(_selectedImage!),
                                fit: BoxFit.cover,
                              )
                            : _profileImageBytes != null
                                ? DecorationImage(
                                    image: MemoryImage(_profileImageBytes!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                      ),
                      child:
                          _selectedImage == null && _profileImageBytes == null
                              ? const Icon(
                                  Icons.camera_alt,
                                  size: 40,
                                  color: Colors.white,
                                )
                              : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  "Upload Your Professional Photo",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Form fields
              ...[
                _buildTextField("First Name", firstNameController),
                _buildTextField("Middle Name", middleNameController),
                _buildTextField("Last Name", lastNameController),
                _buildDropdownField("Current Designation", designations),
                const SizedBox(height: 16),
                FadeInLeft(
                  child: const Text(
                    "Residence Address",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildTextField("Address Line", addressController),
                _buildTextField("Country", countryController),
                _buildTextField("State", stateController),
                _buildTextField("City/Sector", cityController),
                _buildTextField("Pincode", pincodeController),
                const SizedBox(height: 16),
                _buildTextField("Communication Email", emailController),
                _buildTextField("Mobile", mobileController),
                _buildTextField("LinkedIn Profile", linkedInController),
                _buildTextField("GitHub Profile", githubController),
              ].expand((widget) => [widget, const SizedBox(height: 16)]),

              // Submit button
              FadeInUp(
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await _saveDataToFirestore();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 8,
                    ),
                    icon: const Icon(Icons.send, size: 24, color: Colors.white),
                    label: const Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return FadeInLeft(
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter $label";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
    return FadeInLeft(
      child: DropdownButtonFormField<String>(
        value: selectedDesignation,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        items: items
            .map((item) =>
                DropdownMenuItem<String>(value: item, child: Text(item)))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedDesignation = value ?? 'Fresher';
          });
        },
      ),
    );
  }
}
