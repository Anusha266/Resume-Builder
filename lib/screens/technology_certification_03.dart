import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class TechnologyCertificationScreen extends StatefulWidget {
  @override
  _TechnologyCertificationScreenState createState() =>
      _TechnologyCertificationScreenState();
}

class _TechnologyCertificationScreenState
    extends State<TechnologyCertificationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  List<TechnologyCertification> certifications = [];

  final TextEditingController certificationNameController =
      TextEditingController();
  final TextEditingController certificationIdController =
      TextEditingController();
  final TextEditingController authorizedInstituteController =
      TextEditingController();
  final TextEditingController yearOfCertificationController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCertifications();
  }

  Future<void> fetchCertifications() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('certificates')
          .where('uid', isEqualTo: uid)
          .get();

      setState(() {
        certifications = snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return TechnologyCertification(
            certificationName: data['certification_name'] ?? '',
            certificationId: data['certification_id'] ?? '',
            authorizedInstitute: data['authorized_institute'] ?? '',
            yearOfCertification: data['year_of_certification'] ?? '',
          );
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching certifications: $e')),
      );
      setState(() => isLoading = false);
    }
  }

  bool isFormComplete() {
    return certificationNameController.text.isNotEmpty &&
        certificationIdController.text.isNotEmpty &&
        authorizedInstituteController.text.isNotEmpty &&
        yearOfCertificationController.text.isNotEmpty;
  }

  Future<void> addCertification() async {
    if (isFormComplete()) {
      try {
        String uid = FirebaseAuth.instance.currentUser!.uid;

        TechnologyCertification newCert = TechnologyCertification(
          certificationName: certificationNameController.text,
          certificationId: certificationIdController.text,
          authorizedInstitute: authorizedInstituteController.text,
          yearOfCertification: yearOfCertificationController.text,
        );

        Map<String, dynamic> certData = newCert.toJson();
        certData['uid'] = uid;

        await FirebaseFirestore.instance
            .collection('certificates')
            .add(certData);

        setState(() {
          certifications.add(newCert);
        });

        certificationNameController.clear();
        certificationIdController.clear();
        authorizedInstituteController.clear();
        yearOfCertificationController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Certification added successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding certification: $e')),
        );
      }
    }
  }

  Future<void> submitForm(BuildContext context) async {
    if (certifications.isNotEmpty) {
      final certificationsData =
          certifications.map((cert) => cert.toJson()).toList();
      final jsonData = jsonEncode({"certifications": certificationsData});
      Navigator.pop(context, jsonData);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Please add at least one certification before submitting."),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Technology Certifications"),
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
              const Text(
                "Technology Certifications (Optional)",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                  "Certification Name", certificationNameController),
              _buildTextField("Certification ID", certificationIdController),
              _buildTextField(
                  "Authorized Institute", authorizedInstituteController),
              _buildTextField("Year of Certification Completion",
                  yearOfCertificationController),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  onPressed: addCertification,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 8,
                  ),
                  icon: const Icon(Icons.add, size: 24, color: Colors.white),
                  label: const Text(
                    "Add Certification",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (certifications.isNotEmpty) ...[
                const Text(
                  "Added Certifications:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...certifications
                    .map((cert) => CertificationCard(certification: cert)),
              ],
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => submitForm(context),
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
                        color: Colors.white),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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

class TechnologyCertification {
  final String certificationName;
  final String certificationId;
  final String authorizedInstitute;
  final String yearOfCertification;

  TechnologyCertification({
    required this.certificationName,
    required this.certificationId,
    required this.authorizedInstitute,
    required this.yearOfCertification,
  });

  Map<String, dynamic> toJson() {
    return {
      'certification_name': certificationName,
      'certification_id': certificationId,
      'authorized_institute': authorizedInstitute,
      'year_of_certification': yearOfCertification,
    };
  }
}

class CertificationCard extends StatelessWidget {
  final TechnologyCertification certification;

  const CertificationCard({required this.certification});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Certification Name: ${certification.certificationName}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text("Certification ID: ${certification.certificationId}"),
            Text("Authorized Institute: ${certification.authorizedInstitute}"),
            Text("Year of Certification: ${certification.yearOfCertification}"),
          ],
        ),
      ),
    );
  }
}
