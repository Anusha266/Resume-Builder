import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class InternshipScreen extends StatefulWidget {
  @override
  _InternshipScreenState createState() => _InternshipScreenState();
}

class _InternshipScreenState extends State<InternshipScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  List<Internship> internships = [];

  final TextEditingController organizationController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isOngoing = false;
  bool isPaid = false;

  @override
  void initState() {
    super.initState();
    fetchInternships();
  }

  Future<void> fetchInternships() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('internships')
          .where('uid', isEqualTo: uid)
          .get();

      setState(() {
        internships = snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return Internship(
            organization: data['organization'] ?? '',
            location: data['location'] ?? '',
            startDate: data['start_date'] ?? '',
            endDate: data['end_date'] ?? '',
            isPaid: data['is_paid'] ?? false,
            isOngoing: data['is_ongoing'] ?? false,
            description: data['description'] ?? '',
          );
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching internships: $e')),
      );
      setState(() => isLoading = false);
    }
  }

  bool isFormComplete() {
    return organizationController.text.isNotEmpty &&
        locationController.text.isNotEmpty &&
        startDateController.text.isNotEmpty &&
        endDateController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty;
  }

  Future<void> addInternship() async {
    if (isFormComplete()) {
      try {
        String uid = FirebaseAuth.instance.currentUser!.uid;

        Internship newInternship = Internship(
          organization: organizationController.text,
          location: locationController.text,
          startDate: startDateController.text,
          endDate: endDateController.text,
          isPaid: isPaid,
          isOngoing: isOngoing,
          description: descriptionController.text,
        );

        Map<String, dynamic> internshipData = newInternship.toJson();
        internshipData['uid'] = uid;

        await FirebaseFirestore.instance
            .collection('internships')
            .add(internshipData);

        setState(() {
          internships.add(newInternship);
        });

        organizationController.clear();
        locationController.clear();
        startDateController.clear();
        endDateController.clear();
        descriptionController.clear();
        setState(() {
          isOngoing = false;
          isPaid = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Internship added successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding internship: $e')),
        );
      }
    }
  }

  Future<void> submitForm(BuildContext context) async {
    if (internships.isNotEmpty) {
      final internshipsData =
          internships.map((internship) => internship.toJson()).toList();
      final jsonData = jsonEncode({"internships": internshipsData});
      Navigator.pop(context, jsonData);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Please add at least one internship before submitting."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleWidth = screenWidth / 375;
    double scaleHeight = screenHeight / 812;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Internship Details"),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10 * scaleWidth),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInUp(
                child: Text(
                  "Internships (Optional)",
                  style: TextStyle(
                    fontSize: 20 * scaleWidth,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16 * scaleHeight),
              FadeInUp(
                child: _buildTextField(
                    "Organization/Company", organizationController, scaleWidth),
              ),
              FadeInUp(
                child:
                    _buildTextField("Location", locationController, scaleWidth),
              ),
              FadeInUp(
                child: _buildTextField(
                    "Start Date", startDateController, scaleWidth),
              ),
              FadeInUp(
                child:
                    _buildTextField("End Date", endDateController, scaleWidth),
              ),
              SizedBox(height: 16 * scaleHeight),
              FadeInUp(
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Checkbox(
                            value: isPaid,
                            onChanged: (value) {
                              setState(() {
                                isPaid = value ?? false;
                              });
                            },
                          ),
                          Text("Paid Internship",
                              style: TextStyle(fontSize: 14 * scaleWidth)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Checkbox(
                            value: isOngoing,
                            onChanged: (value) {
                              setState(() {
                                isOngoing = value ?? false;
                              });
                            },
                          ),
                          Text("Ongoing Internship",
                              style: TextStyle(fontSize: 14 * scaleWidth)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16 * scaleHeight),
              FadeInUp(
                child: _buildTextField("Description of Internship",
                    descriptionController, scaleWidth),
              ),
              SizedBox(height: 16 * scaleHeight),
              Center(
                child: FadeInUp(
                  child: ElevatedButton.icon(
                    onPressed: addInternship,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: 16 * scaleHeight,
                          horizontal: 32 * scaleWidth),
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 8,
                    ),
                    icon: Icon(Icons.add,
                        size: 24 * scaleWidth, color: Colors.white),
                    label: Text(
                      "Add Internship",
                      style: TextStyle(
                        fontSize: 18 * scaleWidth,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16 * scaleHeight),
              if (internships.isNotEmpty) ...[
                Text(
                  "Added Internships:",
                  style: TextStyle(
                    fontSize: 18 * scaleWidth,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8 * scaleHeight),
                ...internships.map(
                    (internship) => InternshipCard(internship: internship)),
              ],
              SizedBox(height: 24 * scaleHeight),
              Center(
                child: FadeInUp(
                  child: ElevatedButton.icon(
                    onPressed: () => submitForm(context),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: 16 * scaleHeight,
                          horizontal: 32 * scaleWidth),
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 8,
                    ),
                    icon: Icon(Icons.send,
                        size: 24 * scaleWidth, color: Colors.white),
                    label: Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 18 * scaleWidth,
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

  Widget _buildTextField(
      String label, TextEditingController controller, double scaleWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8 * scaleWidth),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.deepPurple),
          hintText: "Enter $label",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(width: 1, color: Colors.deepPurple),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(width: 1, color: Colors.deepPurpleAccent),
          ),
        ),
        style: TextStyle(color: Colors.black87),
      ),
    );
  }
}

class Internship {
  final String organization;
  final String location;
  final String startDate;
  final String endDate;
  final bool isPaid;
  final bool isOngoing;
  final String description;

  Internship({
    required this.organization,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.isPaid,
    required this.isOngoing,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'organization': organization,
      'location': location,
      'start_date': startDate,
      'end_date': endDate,
      'is_paid': isPaid,
      'is_ongoing': isOngoing,
      'description': description,
    };
  }
}

class InternshipCard extends StatelessWidget {
  final Internship internship;

  const InternshipCard({required this.internship});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Organization: ${internship.organization}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text("Location: ${internship.location}"),
            Text("Start Date: ${internship.startDate}"),
            Text("End Date: ${internship.endDate}"),
            Text("Paid: ${internship.isPaid ? 'Yes' : 'No'}"),
            Text("Ongoing: ${internship.isOngoing ? 'Yes' : 'No'}"),
            Text("Description: ${internship.description}"),
          ],
        ),
      ),
    );
  }
}
