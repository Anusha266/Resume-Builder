// import 'package:animate_do/animate_do.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:convert';
// import 'dart:io';

// class EducationDataScreen extends StatefulWidget {
//   @override
//   _EducationDataScreenState createState() => _EducationDataScreenState();
// }

// class _EducationDataScreenState extends State<EducationDataScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   // Controllers for text fields
//   final TextEditingController sscInstitutionController =
//       TextEditingController();
//   final TextEditingController sscBoardController = TextEditingController();
//   final TextEditingController sscSpecializationController =
//       TextEditingController();
//   final TextEditingController sscStateController = TextEditingController();
//   final TextEditingController sscCityController = TextEditingController();
//   DateTime? sscStartDate;
//   DateTime? sscEndDate;
//   final TextEditingController sscMathematicsScoreController =
//       TextEditingController();
//   final TextEditingController sscPhysicsScoreController =
//       TextEditingController();
//   final TextEditingController sscChemistryScoreController =
//       TextEditingController();

//   DateTime? plus12StartDate;
//   DateTime? plus12EndDate;
//   final TextEditingController plus12InstitutionController =
//       TextEditingController();
//   final TextEditingController plus12BoardController = TextEditingController();
//   final TextEditingController plus12SpecializationController =
//       TextEditingController();
//   final TextEditingController plus12StateController = TextEditingController();
//   final TextEditingController plus12CityController = TextEditingController();
//   final TextEditingController plus12MathematicsScoreController =
//       TextEditingController();
//   final TextEditingController plus12PhysicsScoreController =
//       TextEditingController();
//   final TextEditingController plus12ChemistryScoreController =
//       TextEditingController();

//   DateTime? undergradStartDate;
//   DateTime? undergradEndDate;
//   final TextEditingController undergradInstitutionController =
//       TextEditingController();
//   final TextEditingController undergradBoardController =
//       TextEditingController();
//   final TextEditingController undergradSpecializationController =
//       TextEditingController();
//   final TextEditingController undergradStateController =
//       TextEditingController();
//   final TextEditingController undergradCityController = TextEditingController();
//   final TextEditingController undergradCgpaController = TextEditingController();

//   DateTime? gradStartDate;
//   DateTime? gradEndDate;
//   final TextEditingController gradInstitutionController =
//       TextEditingController();
//   final TextEditingController gradBoardController = TextEditingController();
//   final TextEditingController gradSpecializationController =
//       TextEditingController();
//   final TextEditingController gradStateController = TextEditingController();
//   final TextEditingController gradCityController = TextEditingController();
//   final TextEditingController gradCgpaController = TextEditingController();

//   String selectedStream = 'MPC'; // Dropdown for MPC stream in 11th & 12th
//   final List<String> streams = ['MPC'];

//   // Function to collect form data and navigate back
//   void submitForm(BuildContext context) {
//     if (_formKey.currentState!.validate()) {
//       final formData = {
//         "ssc": {
//           "institution_name": sscInstitutionController.text,
//           "board_name": sscBoardController.text,
//           "specialization": sscSpecializationController.text,
//           "state": sscStateController.text,
//           "city": sscCityController.text,
//           "start_date": sscStartDate?.toIso8601String(),
//           "end_date": sscEndDate?.toIso8601String(),
//           "mathematics_score": sscMathematicsScoreController.text,
//           "physics_score": sscPhysicsScoreController.text,
//           "chemistry_score": sscChemistryScoreController.text,
//         },
//         "plus11_plus12": {
//           "stream": selectedStream,
//           "institution_name": plus12InstitutionController.text,
//           "board_name": plus12BoardController.text,
//           "specialization": plus12SpecializationController.text,
//           "state": plus12StateController.text,
//           "city": plus12CityController.text,
//           "start_date": plus12StartDate?.toIso8601String(),
//           "end_date": plus12EndDate?.toIso8601String(),
//           "mathematics_score": plus12MathematicsScoreController.text,
//           "physics_score": plus12PhysicsScoreController.text,
//           "chemistry_score": plus12ChemistryScoreController.text,
//         },
//         "undergrad": {
//           "institution_name": undergradInstitutionController.text,
//           "board_name": undergradBoardController.text,
//           "specialization": undergradSpecializationController.text,
//           "state": undergradStateController.text,
//           "city": undergradCityController.text,
//           "start_date": undergradStartDate?.toIso8601String(),
//           "end_date": undergradEndDate?.toIso8601String(),
//           "cgpa_percentage": undergradCgpaController.text,
//         },
//         "grad": {
//           "institution_name": gradInstitutionController.text,
//           "board_name": gradBoardController.text,
//           "specialization": gradSpecializationController.text,
//           "state": gradStateController.text,
//           "city": gradCityController.text,
//           "start_date": gradStartDate?.toIso8601String(),
//           "end_date": gradEndDate?.toIso8601String(),
//           "cgpa_percentage": gradCgpaController.text,
//         },
//       };

//       final jsonData = jsonEncode(formData); // Convert dictionary to JSON

//       Navigator.pop(context, jsonData); // Send data back to EditPage
//     }
//   }

//   // Function to pick date using DatePicker
//   Future<void> pickDate(BuildContext context, DateTime? initialDate,
//       Function(DateTime) onDatePicked) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: initialDate ?? DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime(2100),
//     );
//     if (pickedDate != null) {
//       onDatePicked(pickedDate);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Education Data"),
//         backgroundColor: Colors.deepPurple,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Section: SSC Details
//               FadeIn(
//                 child: const Text(
//                   "SSC Details",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               _buildTextField("Institution Name", sscInstitutionController),
//               _buildTextField("Board Name", sscBoardController),
//               _buildTextField("Specialization", sscSpecializationController),
//               _buildTextField("State", sscStateController),
//               _buildTextField("City", sscCityController),
//               _buildDateField("Start Date", sscStartDate, (date) {
//                 setState(() {
//                   sscStartDate = date;
//                 });
//               }),
//               _buildDateField("End Date", sscEndDate, (date) {
//                 setState(() {
//                   sscEndDate = date;
//                 });
//               }),
//               _buildTextField(
//                   "Mathematics Score", sscMathematicsScoreController),
//               _buildTextField("Physics Score", sscPhysicsScoreController),
//               _buildTextField("Chemistry Score", sscChemistryScoreController),

//               const SizedBox(height: 16),

//               // Section: +11 and +12
//               FadeInLeft(
//                 child: const Text(
//                   "11th & 12th Grade Details",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               _buildDropdownField("Stream (MPC)", streams),
//               _buildTextField("Institution Name", plus12InstitutionController),
//               _buildTextField("Board Name", plus12BoardController),
//               _buildTextField("Specialization", plus12SpecializationController),
//               _buildTextField("State", plus12StateController),
//               _buildTextField("City", plus12CityController),
//               _buildDateField("Start Date", plus12StartDate, (date) {
//                 setState(() {
//                   plus12StartDate = date;
//                 });
//               }),
//               _buildDateField("End Date", plus12EndDate, (date) {
//                 setState(() {
//                   plus12EndDate = date;
//                 });
//               }),
//               _buildTextField(
//                   "Mathematics Score", plus12MathematicsScoreController),
//               _buildTextField("Physics Score", plus12PhysicsScoreController),
//               _buildTextField(
//                   "Chemistry Score", plus12ChemistryScoreController),

//               const SizedBox(height: 16),

//               // Section: Under Graduation (Optional)
//               FadeInLeft(
//                 child: const Text(
//                   "Under Graduation (Optional)",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               _buildTextField(
//                   "Institution Name", undergradInstitutionController),
//               _buildTextField("Board Name", undergradBoardController),
//               _buildTextField(
//                   "Specialization", undergradSpecializationController),
//               _buildTextField("State", undergradStateController),
//               _buildTextField("City", undergradCityController),
//               _buildDateField("Start Date", undergradStartDate, (date) {
//                 setState(() {
//                   undergradStartDate = date;
//                 });
//               }),
//               _buildDateField("End Date", undergradEndDate, (date) {
//                 setState(() {
//                   undergradEndDate = date;
//                 });
//               }),
//               _buildTextField("CGPA/Percentage", undergradCgpaController),

//               const SizedBox(height: 16),

//               // Section: Graduation (Optional)
//               FadeInLeft(
//                 child: const Text(
//                   "Graduation (Optional)",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               _buildTextField("Institution Name", gradInstitutionController),
//               _buildTextField("Board Name", gradBoardController),
//               _buildTextField("Specialization", gradSpecializationController),
//               _buildTextField("State", gradStateController),
//               _buildTextField("City", gradCityController),
//               _buildDateField("Start Date", gradStartDate, (date) {
//                 setState(() {
//                   gradStartDate = date;
//                 });
//               }),
//               _buildDateField("End Date", gradEndDate, (date) {
//                 setState(() {
//                   gradEndDate = date;
//                 });
//               }),
//               _buildTextField("CGPA/Percentage", gradCgpaController),

//               const SizedBox(height: 24),

//               // Submit Button
//               FadeInUp(
//                 child: Center(
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       submitForm(context);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 16, horizontal: 32),
//                       backgroundColor: Colors.deepPurple,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(24),
//                       ),
//                       elevation: 8,
//                     ),
//                     icon: const Icon(Icons.send, size: 24, color: Colors.white),
//                     label: const Text(
//                       "Submit",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(String label, TextEditingController controller) {
//     return FadeInLeft(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         child: TextFormField(
//           controller: controller,
//           decoration: InputDecoration(
//             labelText: label,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(width: 1, color: Colors.deepPurple),
//             ),
//           ),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please enter $label';
//             }
//             return null;
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildDateField(
//       String label, DateTime? selectedDate, Function(DateTime) onDatePicked) {
//     return FadeInLeft(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         child: GestureDetector(
//           onTap: () => pickDate(context, selectedDate, onDatePicked),
//           child: InputDecorator(
//             decoration: InputDecoration(
//               labelText: label,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(width: 1, color: Colors.deepPurple),
//               ),
//             ),
//             child: Text(
//               selectedDate == null
//                   ? 'Select Date'
//                   : "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
//               style: TextStyle(fontSize: 16),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDropdownField(String label, List<String> options) {
//     return FadeInLeft(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         child: DropdownButtonFormField<String>(
//           value: selectedStream,
//           items: options.map<DropdownMenuItem<String>>((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(value),
//             );
//           }).toList(),
//           decoration: InputDecoration(
//             labelText: label,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(width: 1, color: Colors.deepPurple),
//             ),
//           ),
//           onChanged: (newValue) {
//             setState(() {
//               selectedStream = newValue!;
//             });
//           },
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please select $label';
//             }
//             return null;
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EducationDataScreen extends StatefulWidget {
  @override
  _EducationDataScreenState createState() => _EducationDataScreenState();
}

class _EducationDataScreenState extends State<EducationDataScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = true;

  final TextEditingController sscInstitutionController =
      TextEditingController();
  final TextEditingController sscBoardController = TextEditingController();
  final TextEditingController sscSpecializationController =
      TextEditingController();
  final TextEditingController sscStateController = TextEditingController();
  final TextEditingController sscCityController = TextEditingController();
  final TextEditingController sscCgpaController = TextEditingController();
  DateTime? sscStartDate;
  DateTime? sscEndDate;
  final TextEditingController sscMathematicsScoreController =
      TextEditingController();
  final TextEditingController sscPhysicsScoreController =
      TextEditingController();
  final TextEditingController sscChemistryScoreController =
      TextEditingController();

  DateTime? plus12StartDate;
  DateTime? plus12EndDate;
  final TextEditingController plus12InstitutionController =
      TextEditingController();
  final TextEditingController plus12BoardController = TextEditingController();
  final TextEditingController plus12SpecializationController =
      TextEditingController();
  final TextEditingController plus12StateController = TextEditingController();
  final TextEditingController plus12CityController = TextEditingController();
  final TextEditingController plus12MathematicsScoreController =
      TextEditingController();
  final TextEditingController plus12PhysicsScoreController =
      TextEditingController();
  final TextEditingController plus12ChemistryScoreController =
      TextEditingController();
  final TextEditingController plus12CgpaController = TextEditingController();
  DateTime? undergradStartDate;
  DateTime? undergradEndDate;
  final TextEditingController undergradInstitutionController =
      TextEditingController();
  final TextEditingController undergradBoardController =
      TextEditingController();
  final TextEditingController undergradSpecializationController =
      TextEditingController();
  final TextEditingController undergradStateController =
      TextEditingController();
  final TextEditingController undergradCityController = TextEditingController();
  final TextEditingController undergradCgpaController = TextEditingController();

  DateTime? gradStartDate;
  DateTime? gradEndDate;
  final TextEditingController gradInstitutionController =
      TextEditingController();
  final TextEditingController gradBoardController = TextEditingController();
  final TextEditingController gradSpecializationController =
      TextEditingController();
  final TextEditingController gradStateController = TextEditingController();
  final TextEditingController gradCityController = TextEditingController();
  final TextEditingController gradCgpaController = TextEditingController();

  String selectedStream = 'MPC'; // Dropdown for MPC stream in 11th & 12th
  final List<String> streams = ['MPC'];

  @override
  void initState() {
    super.initState();
    fetchEducationData();
  }

  Future<void> fetchEducationData() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('education')
          .doc(uid)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // SSC Data
        Map<String, dynamic> ssc = data['ssc'] ?? {};
        sscInstitutionController.text = ssc['institution_name'] ?? '';
        sscBoardController.text = ssc['board_name'] ?? '';
        sscSpecializationController.text = ssc['specialization'] ?? '';
        sscStateController.text = ssc['state'] ?? '';
        sscCityController.text = ssc['city'] ?? '';
        sscStartDate = ssc['start_date'] != null
            ? DateTime.parse(ssc['start_date'])
            : null;
        sscEndDate =
            ssc['end_date'] != null ? DateTime.parse(ssc['end_date']) : null;
        sscMathematicsScoreController.text = ssc['mathematics_score'] ?? '';
        sscPhysicsScoreController.text = ssc['physics_score'] ?? '';
        sscChemistryScoreController.text = ssc['chemistry_score'] ?? '';

        // Plus11_Plus12 Data
        Map<String, dynamic> plus12 = data['plus11_plus12'] ?? {};
        selectedStream = plus12['stream'] ?? 'MPC';
        plus12InstitutionController.text = plus12['institution_name'] ?? '';
        plus12BoardController.text = plus12['board_name'] ?? '';
        plus12SpecializationController.text = plus12['specialization'] ?? '';
        plus12StateController.text = plus12['state'] ?? '';
        plus12CityController.text = plus12['city'] ?? '';
        plus12StartDate = plus12['start_date'] != null
            ? DateTime.parse(plus12['start_date'])
            : null;
        plus12EndDate = plus12['end_date'] != null
            ? DateTime.parse(plus12['end_date'])
            : null;
        plus12MathematicsScoreController.text =
            plus12['mathematics_score'] ?? '';
        plus12PhysicsScoreController.text = plus12['physics_score'] ?? '';
        plus12ChemistryScoreController.text = plus12['chemistry_score'] ?? '';

        // Undergrad Data
        Map<String, dynamic> undergrad = data['undergrad'] ?? {};
        undergradInstitutionController.text =
            undergrad['institution_name'] ?? '';
        undergradBoardController.text = undergrad['board_name'] ?? '';
        undergradSpecializationController.text =
            undergrad['specialization'] ?? '';
        undergradStateController.text = undergrad['state'] ?? '';
        undergradCityController.text = undergrad['city'] ?? '';
        undergradStartDate = undergrad['start_date'] != null
            ? DateTime.parse(undergrad['start_date'])
            : null;
        undergradEndDate = undergrad['end_date'] != null
            ? DateTime.parse(undergrad['end_date'])
            : null;
        undergradCgpaController.text = undergrad['cgpa_percentage'] ?? '';

        // Grad Data
        Map<String, dynamic> grad = data['grad'] ?? {};
        gradInstitutionController.text = grad['institution_name'] ?? '';
        gradBoardController.text = grad['board_name'] ?? '';
        gradSpecializationController.text = grad['specialization'] ?? '';
        gradStateController.text = grad['state'] ?? '';
        gradCityController.text = grad['city'] ?? '';
        gradStartDate = grad['start_date'] != null
            ? DateTime.parse(grad['start_date'])
            : null;
        gradEndDate =
            grad['end_date'] != null ? DateTime.parse(grad['end_date']) : null;
        gradCgpaController.text = grad['cgpa_percentage'] ?? '';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });

        String uid = FirebaseAuth.instance.currentUser!.uid;

        final formData = {
          "ssc": {
            "institution_name": sscInstitutionController.text,
            "board_name": sscBoardController.text,
            "specialization": sscSpecializationController.text,
            "state": sscStateController.text,
            "city": sscCityController.text,
            "start_date": sscStartDate?.toIso8601String(),
            "end_date": sscEndDate?.toIso8601String(),
            "mathematics_score": sscMathematicsScoreController.text,
            "physics_score": sscPhysicsScoreController.text,
            "chemistry_score": sscChemistryScoreController.text,
            "cgpa_percentage": sscCgpaController.text
          },
          "plus11_plus12": {
            "stream": selectedStream,
            "institution_name": plus12InstitutionController.text,
            "board_name": plus12BoardController.text,
            "specialization": plus12SpecializationController.text,
            "state": plus12StateController.text,
            "city": plus12CityController.text,
            "start_date": plus12StartDate?.toIso8601String(),
            "end_date": plus12EndDate?.toIso8601String(),
            "mathematics_score": plus12MathematicsScoreController.text,
            "physics_score": plus12PhysicsScoreController.text,
            "chemistry_score": plus12ChemistryScoreController.text,
            "cgpa_percentage": plus12CgpaController.text
          },
          "undergrad": {
            "institution_name": undergradInstitutionController.text,
            "board_name": undergradBoardController.text,
            "specialization": undergradSpecializationController.text,
            "state": undergradStateController.text,
            "city": undergradCityController.text,
            "start_date": undergradStartDate?.toIso8601String(),
            "end_date": undergradEndDate?.toIso8601String(),
            "cgpa_percentage": undergradCgpaController.text,
          },
          "grad": {
            "institution_name": gradInstitutionController.text,
            "board_name": gradBoardController.text,
            "specialization": gradSpecializationController.text,
            "state": gradStateController.text,
            "city": gradCityController.text,
            "start_date": gradStartDate?.toIso8601String(),
            "end_date": gradEndDate?.toIso8601String(),
            "cgpa_percentage": gradCgpaController.text,
          },
        };
        Navigator.pop(context, formData);
        await FirebaseFirestore.instance
            .collection('education')
            .doc(uid)
            .set(formData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Education data saved successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving data: $e')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> pickDate(BuildContext context, DateTime? initialDate,
      Function(DateTime) onDatePicked) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      onDatePicked(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Rest of the build method remains the same as your original code
    return Scaffold(
      appBar: AppBar(
        title: const Text("Education Data"),
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
              // Section: SSC Details
              FadeIn(
                child: const Text(
                  "SSC Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              _buildTextField("Institution Name", sscInstitutionController),
              _buildTextField("Board Name", sscBoardController),
              _buildTextField("Specialization", sscSpecializationController),
              _buildTextField("State", sscStateController),
              _buildTextField("City", sscCityController),
              _buildDateField("Start Date", sscStartDate, (date) {
                setState(() {
                  sscStartDate = date;
                });
              }),
              _buildDateField("End Date", sscEndDate, (date) {
                setState(() {
                  sscEndDate = date;
                });
              }),
              _buildTextField(
                  "Mathematics Score", sscMathematicsScoreController),
              _buildTextField("Physics Score", sscPhysicsScoreController),
              _buildTextField("Chemistry Score", sscChemistryScoreController),
              _buildTextField("CGPA/Percentage", sscCgpaController),
              const SizedBox(height: 16),

              // Section: +11 and +12
              FadeInLeft(
                child: const Text(
                  "11th & 12th Grade Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              _buildDropdownField("Stream (MPC)", streams),
              _buildTextField("Institution Name", plus12InstitutionController),
              _buildTextField("Board Name", plus12BoardController),
              _buildTextField("Specialization", plus12SpecializationController),
              _buildTextField("State", plus12StateController),
              _buildTextField("City", plus12CityController),
              _buildDateField("Start Date", plus12StartDate, (date) {
                setState(() {
                  plus12StartDate = date;
                });
              }),
              _buildDateField("End Date", plus12EndDate, (date) {
                setState(() {
                  plus12EndDate = date;
                });
              }),
              _buildTextField(
                  "Mathematics Score", plus12MathematicsScoreController),
              _buildTextField("Physics Score", plus12PhysicsScoreController),
              _buildTextField(
                  "Chemistry Score", plus12ChemistryScoreController),
              _buildTextField("CGPA/Percentage", plus12CgpaController),
              const SizedBox(height: 16),

              // Section: Under Graduation (Optional)
              FadeInLeft(
                child: const Text(
                  "Under Graduation (Optional)",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              _buildTextField(
                  "Institution Name", undergradInstitutionController),
              _buildTextField("Board Name", undergradBoardController),
              _buildTextField(
                  "Specialization", undergradSpecializationController),
              _buildTextField("State", undergradStateController),
              _buildTextField("City", undergradCityController),
              _buildDateField("Start Date", undergradStartDate, (date) {
                setState(() {
                  undergradStartDate = date;
                });
              }),
              _buildDateField("End Date", undergradEndDate, (date) {
                setState(() {
                  undergradEndDate = date;
                });
              }),
              _buildTextField("CGPA/Percentage", undergradCgpaController),

              const SizedBox(height: 16),

              // Section: Graduation (Optional)
              FadeInLeft(
                child: const Text(
                  "Graduation (Optional)",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              _buildTextField("Institution Name", gradInstitutionController),
              _buildTextField("Board Name", gradBoardController),
              _buildTextField("Specialization", gradSpecializationController),
              _buildTextField("State", gradStateController),
              _buildTextField("City", gradCityController),
              _buildDateField("Start Date", gradStartDate, (date) {
                setState(() {
                  gradStartDate = date;
                });
              }),
              _buildDateField("End Date", gradEndDate, (date) {
                setState(() {
                  gradEndDate = date;
                });
              }),
              _buildTextField("CGPA/Percentage", gradCgpaController),

              const SizedBox(height: 24),

              // Submit Button
              FadeInUp(
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      submitForm(context);
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(width: 1, color: Colors.deepPurple),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildDateField(
      String label, DateTime? selectedDate, Function(DateTime) onDatePicked) {
    return FadeInLeft(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: GestureDetector(
          onTap: () => pickDate(context, selectedDate, onDatePicked),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(width: 1, color: Colors.deepPurple),
              ),
            ),
            child: Text(
              selectedDate == null
                  ? 'Select Date'
                  : "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> options) {
    return FadeInLeft(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: DropdownButtonFormField<String>(
          value: selectedStream,
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(width: 1, color: Colors.deepPurple),
            ),
          ),
          onChanged: (newValue) {
            setState(() {
              selectedStream = newValue!;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select $label';
            }
            return null;
          },
        ),
      ),
    );
  }
}
