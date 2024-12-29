import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:resume/SERVICES/auth_service.dart';
import 'package:resume/screens/chinninnnni.dart';
import 'package:resume/screens/education_information_02.dart';
import 'package:resume/screens/internship_screen_04.dart';
import 'package:resume/screens/personal_information_01.dart';
import 'package:resume/screens/projects_screen_05.dart';
import 'package:resume/screens/resume_preview_screen.dart';
import 'package:resume/screens/resume_screen.dart';
import 'package:resume/screens/resume_screen_2.dart';
import 'package:resume/screens/technology_certification_03.dart';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart'; // Import AwesomeDialog

class EditPage extends StatelessWidget {
  final int indexValue;
  final String jobStream;
  final String jobTitle;

  const EditPage(
      {super.key,
      required this.indexValue,
      required this.jobStream,
      required this.jobTitle});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(
        indexValue: indexValue,
        jobStream: jobStream,
        jobTitle: jobTitle,
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  final int indexValue;

  final String jobStream;

  final String jobTitle;

  const ProfilePage(
      {super.key,
      required this.indexValue,
      required this.jobStream,
      required this.jobTitle});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<Map<String, dynamic>> cardSections = [
    {"title": "Personal Information", "icon": Icons.person},
    {"title": "Education", "icon": Icons.school},
    {"title": "Technology Certifications", "icon": Icons.verified},
    {"title": "Internships", "icon": Icons.work},
    {"title": "Projects", "icon": Icons.folder_open},
    {"title": "Relevant Skills", "icon": Icons.handyman},
    {"title": "Achievements", "icon": Icons.star},
    {"title": "Domain Knowledge", "icon": Icons.lightbulb},
    {"title": "Summary", "icon": Icons.summarize},
  ];

  Map<String, dynamic>? personalInformation;
  Map<String, dynamic>? educationData;
  Map<String, dynamic>? technologyCertificationsData;
  Map<String, dynamic>? internshipsData;
  List<Map<String, dynamic>> projectsData = [];
  final aiGeneratedSummary = "This is a sample AI-generated summary.";

  // New fields for optional inputs
  List<String> relevantSkills = [];
  List<String> domainKnowledge = [];
  List<String> achievements = [];
  TextEditingController summaryController = TextEditingController();
  TextEditingController skillController = TextEditingController();
  TextEditingController domainController = TextEditingController();
  TextEditingController achievementController = TextEditingController();

  final _geminiService =
      GeminiService(apiKey: 'AIzaSyCvG0uQZ-juIyVaBCn771xjuPiHCxnayGY');

  void generateSummary() async {
    if (relevantSkills.isEmpty) {
      Fluttertoast.showToast(
          msg:
              "Relevant Skills You Have Must Add To Generate To AI Generated Summary");
      return;
    }
    // Replace with actual AI integration logic
    const aiGeneratedSummary = "This is a sample AI-generated summary.";
    summaryController.text = aiGeneratedSummary;
    String firstPrompt =
        "Generate a professional resume summary for a ${widget.jobStream} specializing in the ${widget.jobTitle} title.";
    String middlePrompt =
        "The summary should highlight technical expertise in ";
    for (String st in relevantSkills) middlePrompt = middlePrompt + st + ",";
    String lastPrompt =
        "teamwork skills, adaptability, and a passion for innovation. Limit the response to 4 lines.";

    try {
      final response = await _geminiService
          .getCompletion(firstPrompt + middlePrompt + lastPrompt);
      setState(() {
        summaryController.text = response;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header with gradient background
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Explore and manage your information',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),

          // Smoothly animated card grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3 / 2,
              ),
              itemCount: cardSections.length,
              itemBuilder: (context, index) {
                final section = cardSections[index];
                return BounceInUp(
                  delay: Duration(milliseconds: 100 * index),
                  child: GestureDetector(
                    onTap: () async {
                      if (section['title'] == "Personal Information") {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PersonalInformationScreen(
                                    jobStream: widget.jobStream,
                                    jobTitle: widget.jobTitle,
                                  )),
                        );
                        if (result != null) {
                          setState(() {
                            personalInformation = jsonDecode(result);
                          });
                        }
                      } else if (section['title'] == "Education") {
                        final educationResult = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EducationDataScreen()),
                        );
                        if (educationResult != null) {
                          setState(() {
                            educationData = jsonDecode(educationResult);
                          });
                        }
                      } else if (section['title'] ==
                          "Technology Certifications") {
                        final certResult = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TechnologyCertificationScreen()),
                        );
                        if (certResult != null) {
                          setState(() {
                            technologyCertificationsData =
                                jsonDecode(certResult);
                          });
                        }
                      } else if (section['title'] == "Internships") {
                        final internshipResult = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InternshipScreen()),
                        );
                        if (internshipResult != null) {
                          setState(() {
                            internshipsData = jsonDecode(internshipResult);
                          });
                        }
                      } else if (section['title'] == "Projects") {
                        final projectsResult = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProjectsScreen(),
                          ),
                        );
                        if (projectsResult != null) {
                          setState(() {
                            projectsData = List<Map<String, dynamic>>.from(
                                jsonDecode(projectsResult)['projects']);
                          });
                        }
                      } else if (section['title'] == "Relevant Skills") {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.noHeader,
                          body: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                TextField(
                                  controller: skillController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter relevant skill',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    if (relevantSkills.length < 6) {
                                      setState(() {
                                        relevantSkills
                                            .add(skillController.text);
                                        skillController.clear();
                                      });
                                      Navigator.pop(context);
                                    } else {
                                      // Show warning dialog if more than 6 skills are added
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.warning,
                                        title: 'Limit Reached',
                                        desc:
                                            'You can add up to 6 skills only.',
                                        btnOkOnPress: () {},
                                      ).show();
                                    }
                                  },
                                  child: Text("Add Skill"),
                                ),
                              ],
                            ),
                          ),
                        ).show();
                      } else if (section['title'] == "Domain Knowledge") {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.noHeader,
                          body: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                TextField(
                                  controller: domainController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter domain knowledge',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    if (domainKnowledge.length < 6) {
                                      setState(() {
                                        domainKnowledge
                                            .add(domainController.text);
                                        domainController.clear();
                                      });
                                      Navigator.pop(context);
                                    } else {
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.warning,
                                        title: 'Limit Reached',
                                        desc:
                                            'You can add up to 6 domain knowledge entries.',
                                        btnOkOnPress: () {},
                                      ).show();
                                    }
                                  },
                                  child: Text("Add Domain Knowledge"),
                                ),
                              ],
                            ),
                          ),
                        ).show();
                      } else if (section['title'] == "Achievements") {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.noHeader,
                          body: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                TextField(
                                  controller: achievementController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter achievement',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      achievements
                                          .add(achievementController.text);
                                      achievementController.clear();
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text("Add Achievement"),
                                ),
                              ],
                            ),
                          ),
                        ).show();
                      } else if (section['title'] == "Summary") {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.noHeader,
                          body: FadeInLeft(
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: TextFormField(
                                    controller: summaryController,
                                    maxLines:
                                        5, // Allows multiple lines for a summary
                                    style: const TextStyle(
                                        fontSize: 16.0, color: Colors.black87),
                                    decoration: InputDecoration(
                                      labelText: "Content Summary",
                                      labelStyle: const TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.blueGrey),
                                      hintText: "Enter a brief summary here...",
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: const BorderSide(
                                            color: Colors.blueAccent,
                                            width: 2.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 2.0),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.all(16.0),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter a summary.";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 16,
                                  child: GestureDetector(
                                    onTap: () {
                                      generateSummary();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4.0,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Icon(
                                        Icons.auto_fix_high, // AI-related icon
                                        color: Colors.white,
                                        size: 24.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          btnOk: ElevatedButton(
                            onPressed: () async {
                              if (summaryController.text.isNotEmpty) {
                                try {
                                  // Replace 'userId' with the document ID you want to update
                                  await FirebaseFirestore.instance
                                      .collection('personalInformation')
                                      .doc(FirebaseAuth.instance.currentUser!
                                          .uid) // Set the document ID
                                      .update(
                                          {'summary': summaryController.text});

                                  // Close the dialog after updating
                                  Navigator.pop(context);

                                  // Optionally show a success message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text("Summary updated successfully!"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } catch (e) {
                                  // Handle errors
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text("Error updating summary: $e"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } else {
                                // If the summary is empty, show a warning message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Please enter a summary before closing."),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text("Close"),
                          ),
                        ).show();
                      }
                    },
                    child: Card(
                      elevation: 7,
                      shadowColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.purple.shade100, Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              section['icon'],
                              size: 40,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              section['title'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Preview button
          // Preview button
          Padding(
            padding: const EdgeInsets.all(16),
            child: FadeInUp(
              delay: const Duration(milliseconds: 500),
              child: ElevatedButton.icon(
                onPressed: () async {
                  String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

                  // Fetch personal information by document ID
                  var personalInfoDocId = FirebaseAuth.instance.currentUser
                      ?.uid; // Replace with actual document ID
                  var personalInfoDoc = await FirebaseFirestore.instance
                      .collection('personalInformation')
                      .doc(personalInfoDocId)
                      .get();
                  if (!personalInfoDoc.exists) {
                    Fluttertoast.showToast(
                      msg: "No personal information found.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    return;
                  }
                  var personalData = personalInfoDoc.data();
                  print("Personal Information: ");
                  print(personalData);

                  // Fetch education data by document ID
                  var educationDoc = await FirebaseFirestore.instance
                      .collection('education')
                      .doc(personalInfoDocId)
                      .get();
                  if (!educationDoc.exists) {
                    Fluttertoast.showToast(
                      msg: "No education data found.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    return;
                  }
                  var educationData = educationDoc.data();
                  print("Education Information: ");
                  print(educationData); // Print the fetched education data

                  // Fetch certificates by uid
                  var certificatesData = await FirebaseFirestore.instance
                      .collection('certificates')
                      .where('uid', isEqualTo: uid)
                      .get();
                  print("Certificates Information: ");
                  certificatesData.docs.forEach((doc) {
                    print(doc.data()); // Print each certificate document
                  });

                  // Fetch internships by uid
                  var internshipsData = await FirebaseFirestore.instance
                      .collection('internships')
                      .where('uid', isEqualTo: uid)
                      .get();
                  print("Internships Information: ");
                  internshipsData.docs.forEach((doc) {
                    print(doc.data()); // Print each internship document
                  });

                  // Fetch projects by user_id
                  var projectsData = await FirebaseFirestore.instance
                      .collection('projects')
                      .where('user_id', isEqualTo: uid)
                      .get();
                  print("Projects Information: ");
                  projectsData.docs.forEach((doc) {
                    print(doc.data()); // Print each project document
                  });

                  List<Map<String, dynamic>> certificatesList = certificatesData
                      .docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .toList();

                  List<Map<String, dynamic>> internshipsList = internshipsData
                      .docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .toList();

                  List<Map<String, dynamic>> projectsList = projectsData.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .toList();

                  print(domainKnowledge);
                  print(achievements);
                  print(relevantSkills);

                  // Create the data structure with consistent keys
                  Map<String, dynamic> data = {
                    'personalInfo': personalData ?? {},
                    'education': educationData ?? {},
                    'certificates':
                        certificatesData.docs.map((doc) => doc.data()).toList(),
                    'internships':
                        internshipsData.docs.map((doc) => doc.data()).toList(),
                    'projects':
                        projectsData.docs.map((doc) => doc.data()).toList(),
                    'skills': relevantSkills,
                    'domainKnowledge': domainKnowledge,
                    'achievements': achievements,
                  };
                  print("DFJADJFAKDFJAJDFOAIJEFAKSJFLAKSDJFA38498R");
                  print(widget.indexValue);
                  if (widget.indexValue == 0)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResumeScreen(profileData: data),
                      ),
                    );
                  else if (widget.indexValue == 1)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResumeScreen2(profileData: data),
                      ),
                    );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 8,
                  shadowColor: Colors.deepPurpleAccent,
                ),
                icon: const Icon(Icons.remove_red_eye,
                    size: 24, color: Colors.white),
                label: const Text(
                  'Preview',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
