import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:resume/screens/edit_screen.dart';

class ResumeTemplatePage extends StatefulWidget {
  @override
  _ResumeTemplatePageState createState() => _ResumeTemplatePageState();
}

class _ResumeTemplatePageState extends State<ResumeTemplatePage> {
  String? selectedJobStream;
  String? selectedJobTitle;

  // Job titles mapped to job streams
  final Map<String, List<String>> jobTitlesByStream = {
    "Engineering": [
      "Software Developer",
      "Data Engineer",
      "DevOps Engineer",
      "System Architect",
      "Mobile Developer"
    ],
    "Business": [
      "Marketing Manager",
      "Business Analyst",
      "Product Manager",
      "Financial Analyst",
      "HR Manager"
    ],
    "Healthcare": [
      "Clinical Nurse",
      "Medical Doctor",
      "Healthcare Administrator",
      "Physical Therapist",
      "Pharmacist"
    ],
    "Arts": [
      "Graphic Designer",
      "UI/UX Designer",
      "Content Writer",
      "Art Director",
      "Visual Artist"
    ],
  };

  final List<Map<String, dynamic>> resumeTemplates = [
    {
      "title": "Modern",
      "image": "assets/images/modern_template.png",
      "description": "A sleek design with a touch of modern aesthetics."
    },
    {
      "title": "Classic",
      "image": "assets/images/classic_template.png",
      "description": "A clean and professional layout suitable for all domains."
    },
    {
      "title": "Creative",
      "image": "assets/images/creative_template.png",
      "description": "Showcase your creativity with this vibrant template."
    },
    {
      "title": "Minimal",
      "image": "assets/images/minimal_template.png",
      "description": "A minimalist approach focusing on content clarity."
    },
  ];

  List<String> getJobTitles() {
    return selectedJobStream != null
        ? jobTitlesByStream[selectedJobStream] ?? []
        : [];
  }

  void showValidationToast() {
    Fluttertoast.showToast(
      msg: "Please select both Job Stream and Job Title first",
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Resume Template"),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Your Career Path",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedJobStream,
                        decoration: InputDecoration(
                          labelText: "Job Stream",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                        items: jobTitlesByStream.keys
                            .map((stream) => DropdownMenuItem(
                                  value: stream,
                                  child: Text(stream),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedJobStream = value;
                            selectedJobTitle =
                                null; // Reset job title when stream changes
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedJobTitle,
                        decoration: InputDecoration(
                          labelText: "Job Title",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                        items: getJobTitles()
                            .map((title) => DropdownMenuItem(
                                  value: title,
                                  child: Text(title),
                                ))
                            .toList(),
                        onChanged: selectedJobStream == null
                            ? null
                            : (value) {
                                setState(() {
                                  selectedJobTitle = value;
                                });
                              },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3 / 4,
              ),
              itemCount: resumeTemplates.length,
              itemBuilder: (context, index) {
                final template = resumeTemplates[index];
                return FadeInUp(
                  duration: Duration(milliseconds: 800 + index * 100),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15.0)),
                            child: Image.asset(
                              template['image'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                template['title'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                template['description'],
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedJobStream != null &&
                                      selectedJobTitle != null
                                  ? Colors.teal
                                  : Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(15.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (selectedJobStream != null &&
                                  selectedJobTitle != null) {
                                if (index <= 1) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditPage(
                                        indexValue: index,
                                        jobStream: selectedJobStream!,
                                        jobTitle: selectedJobTitle!,
                                      ),
                                    ),
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                    msg:
                                        "This Resume Template is not available yet",
                                    backgroundColor: Colors.orange,
                                  );
                                }
                              } else {
                                showValidationToast();
                              }
                            },
                            child: Text(
                              "Select Template",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
