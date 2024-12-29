import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class ResumeScreen extends StatefulWidget {
  final Map<String, dynamic> profileData;

  const ResumeScreen({super.key, required this.profileData});

  @override
  State<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  late final Map<String, dynamic> profileData;

  @override
  void initState() {
    super.initState();
    profileData = widget.profileData; // Get the profileData from the widget
    print('Personal Info: ${profileData['personalInfo']}');
    print(profileData['personalInfo']['address']);
    print('Education: ${profileData['education']}');
    print('Certificates: ${profileData['certificates']}');
    print('Internships: ${profileData['internships']}');
    print('Projects: ${profileData['projects']}');
    print('Skills: ${profileData['skills']}');
    print('Domain Knowledge: ${profileData['domainKnowledge']}');
    print('Achievements: ${profileData['achievements']}');
  }

  String _formatDateForAPI(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty || dateStr == "date") {
      return "";
    }

    try {
      // Try parsing different date formats
      DateTime? date;

      // Try dd-MM-yyyy format
      try {
        date = DateFormat('dd-MM-yyyy').parse(dateStr);
      } catch (e) {
        // Try yyyy-MM-dd format
        try {
          date = DateFormat('yyyy-MM-dd').parse(dateStr);
        } catch (e) {
          // Try MM-dd-yyyy format
          try {
            date = DateFormat('MM-dd-yyyy').parse(dateStr);
          } catch (e) {
            return "";
          }
        }
      }

      // Convert to the API's expected format (assuming yyyy-MM-dd)
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      print("Date parsing error for: $dateStr - ${e.toString()}");
      return "";
    }
  }

  String formatDate(String date) {
    try {
      // Ensure date is in a proper format
      if (date.length == 4) {
        // Convert year-only string to a full date format
        date = "$date-01-01";
      }
      return DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
    } catch (e) {
      print("Invalid date format: $date");
      return "Invalid Date"; // Return a fallback value
    }
  }

  // final Map<String, dynamic> profileData = {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resume"),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Color.fromARGB(255, 7, 194, 91)), // Button background color
              padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                  vertical: 10, horizontal: 15)), // Spacing
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
              ),
              elevation:
                  MaterialStateProperty.all(5), // Shadow for a raised effect
            ),
            onPressed: () async {
              try {
                final Map<String, dynamic> apiData = {
                  "photo": profileData['personalInfo']?['profile_image'] ?? "",
                  "personal_details": {
                    "first_name":
                        profileData['personalInfo']?['first_name'] ?? "",
                    "middle_name":
                        profileData['personalInfo']?['middle_name'] ?? "",
                    "last_name":
                        profileData['personalInfo']?['last_name'] ?? "",
                    "current_designation":
                        profileData['personalInfo']?['designation'] ?? "",
                    "address":
                        profileData['personalInfo']?['address']?['city'] ?? "",
                    "email": profileData['personalInfo']
                            ?['communication_email'] ??
                        "",
                    "mobile": profileData['personalInfo']?['mobile'] ?? "",
                    "linkedin":
                        profileData['personalInfo']?['linkedin_profile'] ?? "",
                    "github":
                        profileData['personalInfo']?['github_profile'] ?? ""
                  },
                  "summary": profileData['personalInfo']?['summary'] ?? "",
                  "education": {
                    "ssc": {
                      "institution_name": profileData['institution_name'] ?? "",
                      "board":
                          profileData['education']['ssc']['board_name'] ?? "",
                      "state": profileData['education']['ssc']['state'] ?? "",
                      "city": profileData['education']['ssc']['city'] ?? "",
                      "start_date":
                          profileData['education']['ssc']['start_date'] ?? "",
                      "end_date":
                          profileData['education']['ssc']['end_date'] ?? "",
                      "CGPA/score": profileData['education']['ssc']
                                  ['cgpa_percentage']
                              ?.toString() ??
                          "0",
                    },
                    "12th": {
                      "institution_name": profileData['education']
                              ['plus11_plus12']['institution_name'] ??
                          "",
                      "board": profileData['education']['plus11_plus12']
                              ['board_name'] ??
                          "",
                      "specialization": profileData['education']
                              ['plus11_plus12']['specialization'] ??
                          "",
                      "state": profileData['education']['plus11_plus12']
                              ['state'] ??
                          "",
                      "city": profileData['education']['plus11_plus12']
                              ['city'] ??
                          "",
                      "start_date": profileData['education']['plus11_plus12']
                              ['start_date'] ??
                          "",
                      "end_date": profileData['education']['plus11_plus12']
                              ['end_date'] ??
                          "",
                      "maths": int.tryParse(profileData['education']
                                  ['plus11_plus12']['mathematics_score'] ??
                              "0") ??
                          0,
                      "physics": int.tryParse(profileData['education']
                                  ['plus11_plus12']['physics_score'] ??
                              "0") ??
                          0,
                      "chemistry": int.tryParse(profileData['education']
                                  ['plus11_plus12']['chemistry_score'] ??
                              "0") ??
                          0,
                      "CGPA/score": int.tryParse(profileData['education']
                                  ['plus11_plus12']['cgpa_percentage'] ??
                              "0") ??
                          0,
                    },
                    "under_graduation": {
                      "institution_name": profileData['education']['undergrad']
                              ['institution_name'] ??
                          "",
                      "university": "university name",
                      "specialization": profileData['education']['undergrad']
                              ['specialization'] ??
                          "",
                      "state":
                          profileData['education']['undergrad']['state'] ?? "",
                      "city":
                          profileData['education']['undergrad']['city'] ?? "",
                      "start_date": profileData['education']['undergrad']
                              ['start_date'] ??
                          "",
                      "end_date": profileData['education']['undergrad']
                              ['end_date'] ??
                          "",
                      "CGPA/score": int.tryParse(profileData['education']
                                  ['undergrad']['cgpa_percentage'] ??
                              "0") ??
                          0,
                    },
                    "graduation": {
                      "institution_name": profileData['education']['grad']
                              ['institution_name'] ??
                          "",
                      "university": "university name",
                      "specialization": profileData['education']['grad']
                              ['specialization'] ??
                          "",
                      "state": profileData['education']['grad']['state'] ?? "",
                      "city": profileData['education']['grad']['city'] ?? "",
                      "start_date":
                          profileData['education']['grad']['start_date'] ?? "",
                      "end_date":
                          profileData['education']['grad']['end_date'] ?? "",
                      "CGPA/score": int.tryParse(profileData['education']
                                  ['grad']['cgpa_percentage'] ??
                              "0") ??
                          0,
                    }
                  },
                  "certifications": (profileData['certificates'] as List)
                      .map((cert) => {
                            "certification_name":
                                cert['certification_name'] ?? "",
                            "certification_id": cert['certification_id'] ?? "",
                            "authorized_institute":
                                cert['authorized_institute'] ?? "",
                            "year_of_certification":
                                cert['year_of_certification'] ?? "",
                          })
                      .toList(),
                  "internships": (profileData['internships'] as List)
                      .map((intern) => {
                            "company": intern['organization'] ?? "",
                            "location": intern['location'] ?? "",
                            "start_date": "date",
                            "end_date": "date",
                            "paid": intern['is_paid'] ? "Yes" : "No",
                            "ongoing": intern['is_ongoing'] ? "Yes" : "No",
                            "description": intern['description'] ?? "",
                          })
                      .toList(),
                  "projects": (profileData['projects'] as List)
                      .map((proj) => {
                            "name": proj['project_name'] ?? "",
                            "organization": proj['client'] ?? "",
                            "start_date": proj['start_date'] ?? "",
                            "end_date": proj['end_date'] ?? "",
                            "project_link": proj['project_link'] ?? "",
                            "attachments": proj['attachments'] ?? "",
                          })
                      .toList(),
                  "relevant_skills": profileData['skills'] ?? [],
                  "domain_knowledge": "Good in DS and AI",
                  "achievements": profileData['achievements'] ?? []
                };

                // Make the API call
                final response = await http.post(
                  Uri.parse('https://instacks.co/api/v1/resume_score'),
                  headers: {
                    'Content-Type': 'application/json',
                  },
                  body: jsonEncode(apiData),
                );

                if (response.statusCode == 200) {
                  final scoreData = jsonDecode(response.body);
                  // Show success dialog with score
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      contentPadding: EdgeInsets.all(24),
                      title: Column(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 48,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'ATS Score',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Your resume ATS score is:',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${scoreData['score']}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          if (scoreData['feedback'] != null) ...[
                            SizedBox(height: 16),
                            Text(
                              'Feedback:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${scoreData['feedback']}',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ],
                      ),
                      actions: [
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'OK',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  throw Exception(
                      'Failed to get ATS score: ${response.statusCode}');
                }
              } catch (e) {
                print(e.toString());
                // Show error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error checking ATS score: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text(
              "Check ATS Score",
              style: TextStyle(
                fontSize: 15, // Text size
                fontWeight: FontWeight.bold, // Bold text
                color: Colors.white, // Text color
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () async {
              try {
                final pdf = await _generatePdf();
                final bytes = await pdf.save();

                // Use the printing package to handle the PDF
                await Printing.sharePdf(
                  bytes: bytes,
                  filename:
                      'resume_${DateTime.now().millisecondsSinceEpoch}.pdf',
                );
              } catch (e) {
                print(e.toString());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error generating PDF: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          )
        ],
      ),
      body: Row(
        children: [
          // Sidebar
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.3,
            color: const Color.fromARGB(255, 27, 26, 26),
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfilePicture(),
                  SizedBox(height: 16),
                  _buildContactInfo(),
                  SizedBox(height: 16),
                  _buildSkillsSection(),
                  SizedBox(height: 16),
                  _buildDomainKnowledge(),
                ],
              ),
            ),
          ),
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 16),
                  _buildSectionTitle("Summary"),
                  _buildSummary(),
                  SizedBox(height: 16),
                  _buildSectionTitle("Education"),
                  _buildEducationSection(),
                  SizedBox(height: 16),
                  _buildSectionTitle("Certifications"),
                  _buildCertificationsSection(),
                  SizedBox(height: 16),
                  _buildSectionTitle("Internships"),
                  _buildInternshipSection(),
                  SizedBox(height: 16),
                  _buildSectionTitle("Projects"),
                  _buildProjectsSection(),
                  SizedBox(height: 16),
                  _buildSectionTitle("Achievements"),
                  _buildAchievementsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePicture() {
    final personalInfo = widget.profileData['personalInfo'];

    // Decode the base64 image string
    Uint8List? decodedImage;
    if (personalInfo['profile_image'] != null) {
      decodedImage = base64Decode(personalInfo['profile_image']);
    }
    return Column(
      children: [
        if (decodedImage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CircleAvatar(
              radius: 50, // Size of the avatar
              backgroundImage:
                  MemoryImage(decodedImage), // Using the decoded image
              backgroundColor: Colors.grey[200], // Fallback background color
            ),
          ),
        SizedBox(height: 8),
        Text(
          "${widget.profileData['personalInfo']['first_name']} ${widget.profileData['personalInfo']['last_name']}",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
    final personalInfo = widget.profileData['personalInfo'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Circular avatar for profile image (if available)

        // Display Contact title
        Text(
          "CONTACT",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),

        // Contact items
        _buildContactItem(Icons.email, personalInfo['communication_email']),
        _buildContactItem(Icons.phone, personalInfo['mobile']),
        _buildContactItem(Icons.place,
            "${personalInfo['address']['city']}, ${personalInfo['address']['state']}"),
        _buildContactItem(Icons.link, personalInfo['linkedin_profile']),
        _buildContactItem(Icons.code, personalInfo['github_profile']),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 14),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    final skills = widget.profileData['skills'] as List;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "TECHNICAL SKILLS",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills.map<Widget>((skill) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                skill,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDomainKnowledge() {
    final domains = widget.profileData['domainKnowledge'] as List;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "DOMAIN KNOWLEDGE",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: domains.map<Widget>((domain) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                domain,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final personalInfo = widget.profileData['personalInfo'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${personalInfo['first_name'].toString().toUpperCase()} ${personalInfo['last_name'].toString().toUpperCase()}",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          personalInfo['designation'],
          style: TextStyle(fontSize: 16, color: Colors.blue),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Divider(color: Colors.blue),
      ],
    );
  }

  Widget _buildSummary() {
    return Text(
      widget.profileData['personalInfo']['summary'],
      style: TextStyle(fontSize: 12, height: 1.5),
    );
  }

  Widget _buildEducationSection() {
    final education = widget.profileData['education'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEducationItem(
          "Graduate",
          education['grad'],
        ),
        _buildEducationItem(
          "Undergraduate",
          education['undergrad'],
        ),
        _buildEducationItem(
          "Higher Secondary",
          education['plus11_plus12'],
        ),
        _buildEducationItem(
          "Secondary",
          education['ssc'],
        ),
      ],
    );
  }

  Widget _buildEducationItem(String level, Map<String, dynamic> edu) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            level,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "${edu['institution_name']} - ${edu['specialization']}",
            style: TextStyle(fontSize: 12),
          ),
          Text(
            "${formatDate(edu['start_date'])} - ${formatDate(edu['end_date'])}",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          if (edu['cgpa_percentage'] != null)
            Text(
              "CGPA/Percentage: ${edu['cgpa_percentage']}",
              style: TextStyle(fontSize: 12),
            ),
        ],
      ),
    );
  }

  Widget _buildCertificationsSection() {
    final certifications = widget.profileData['certificates'] as List;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: certifications.map<Widget>((cert) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cert['certification_name'],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "ID: ${cert['certification_id']} | ${cert['authorized_institute']} (${cert['year_of_certification']})",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInternshipSection() {
    final internships = widget.profileData['internships'] as List;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: internships.map<Widget>((internship) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                internship['organization'],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                internship['location'],
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                "${formatDate(internship['start_date'])} - ${formatDate(internship['end_date'])}",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 4),
              Text(
                internship['description'],
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProjectsSection() {
    final projects = widget.profileData['projects'] as List;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: projects.map<Widget>((project) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project['project_name'],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Client: ${project['client']}",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                "${formatDate(project['start_date'])} - ${formatDate(project['end_date'])}",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              if (project['project_link'] != null)
                InkWell(
                  onTap: () {
                    // Add URL launcher functionality here
                  },
                  child: Text(
                    "Project Link",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAchievementsSection() {
    final achievements = widget.profileData['achievements'] as List;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: achievements.map<Widget>((achievement) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.star, color: Colors.amber, size: 14),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  achievement,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Future<pw.Document> _generatePdf() async {
  Future<pw.Document> _generatePdf() async {
    final pdf = pw.Document();
    final personalInfo = widget.profileData['personalInfo'];

    // Decode the base64 image string
    Uint8List? decodedImage;
    if (personalInfo['profile_image'] != null) {
      decodedImage = base64Decode(personalInfo['profile_image']);
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return [
            pw.Stack(
              children: [
                // Background container for the left sidebar
                pw.Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: pw.Container(
                    width: 140,
                    color: PdfColors.black,
                  ),
                ),
                // Main content
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Left Sidebar (30% width)
                    pw.Container(
                      width: 140,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          // Contact Information
                          // Circular avatar (profile image)
                          pw.SizedBox(height: 40),
                          if (decodedImage != null)
                            pw.Center(
                                child: pw.Container(
                              width: 100,
                              height: 100,
                              decoration: pw.BoxDecoration(
                                shape: pw.BoxShape.circle,
                                image: pw.DecorationImage(
                                  image: pw.MemoryImage(decodedImage),
                                  fit: pw.BoxFit.cover,
                                ),
                              ),
                            )),

                          pw.SizedBox(height: 10),
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  'CONTACT',
                                  style: pw.TextStyle(
                                    color: PdfColors.white,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                pw.SizedBox(height: 5),
                                _buildPdfContactItem(
                                    'Email: ${widget.profileData['personalInfo']['communication_email']}'),
                                _buildPdfContactItem(
                                    'Phone: ${widget.profileData['personalInfo']['mobile']}'),
                                _buildPdfContactItem(
                                    'LinkedIn: ${widget.profileData['personalInfo']['linkedin_profile']}'),
                                _buildPdfContactItem(
                                    'GitHub: ${widget.profileData['personalInfo']['github_profile']}'),
                              ],
                            ),
                          ),

                          pw.SizedBox(height: 10),

                          // Technical Skills
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  'TECHNICAL SKILLS',
                                  style: pw.TextStyle(
                                    color: PdfColors.white,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                pw.SizedBox(height: 5),
                                ...(widget.profileData['skills'] as List)
                                    .map((skill) => _buildPdfSkillItem(skill)),
                              ],
                            ),
                          ),

                          pw.SizedBox(height: 10),

                          // Domain Knowledge
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  'DOMAIN KNOWLEDGE',
                                  style: pw.TextStyle(
                                    color: PdfColors.white,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                pw.SizedBox(height: 5),
                                ...(widget.profileData['domainKnowledge']
                                        as List)
                                    .map(
                                        (domain) => _buildPdfSkillItem(domain)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    pw.SizedBox(width: 15),

                    // Main Content
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          // Header
                          pw.Text(
                            "${widget.profileData['personalInfo']['first_name'].toString().toUpperCase()} ${widget.profileData['personalInfo']['last_name'].toString().toUpperCase()}",
                            style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            widget.profileData['personalInfo']['designation'],
                            style: pw.TextStyle(
                              fontSize: 14,
                              color: PdfColors.blue,
                            ),
                          ),

                          pw.SizedBox(height: 10),

                          // Summary
                          _buildPdfSectionTitle('SUMMARY'),
                          pw.Text(
                            widget.profileData['personalInfo']['summary'],
                            style: pw.TextStyle(fontSize: 9),
                          ),

                          pw.SizedBox(height: 10),

                          // Education
                          _buildPdfSectionTitle('EDUCATION'),
                          _buildPdfEducation(widget.profileData['education']),

                          pw.SizedBox(height: 10),

                          // Certifications
                          _buildPdfSectionTitle('CERTIFICATIONS'),
                          _buildPdfCertifications(
                              widget.profileData['certificates']),

                          pw.SizedBox(height: 10),

                          // Internships
                          _buildPdfSectionTitle('INTERNSHIPS'),
                          _buildPdfInternships(
                              widget.profileData['internships']),

                          pw.SizedBox(height: 10),

                          // Projects
                          _buildPdfSectionTitle('PROJECTS'),
                          _buildPdfProjects(widget.profileData['projects']),

                          pw.SizedBox(height: 10),

                          // Achievements
                          _buildPdfSectionTitle('ACHIEVEMENTS'),
                          _buildPdfAchievements(
                              widget.profileData['achievements']),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    return pdf;
  }

// // Updated helper methods with reduced spacing and font sizes
  pw.Widget _buildPdfContactItem(String text) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 1),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 8, // Reduced font size
        ),
      ),
    );
  }

  pw.Widget _buildPdfSkillItem(String skill) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 1),
      child: pw.Text(
        '• $skill',
        style: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 8, // Reduced font size
        ),
      ),
    );
  }

  pw.Widget _buildPdfSectionTitle(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 12, // Reduced font size
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue,
          ),
        ),
        pw.Divider(color: PdfColors.blue),
        pw.SizedBox(height: 4), // Reduced spacing
      ],
    );
  }

  pw.Widget _buildPdfEducation(Map<String, dynamic> education) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildPdfEducationItem('Graduate', education['grad']),
        _buildPdfEducationItem('Undergraduate', education['undergrad']),
        _buildPdfEducationItem('Higher Secondary', education['plus11_plus12']),
        _buildPdfEducationItem('Secondary', education['ssc']),
      ],
    );
  }

  pw.Widget _buildPdfEducationItem(String level, Map<String, dynamic> edu) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          level,
          style: pw.TextStyle(
            fontSize: 10, // Reduced font size
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(
          "${edu['institution_name']} - ${edu['specialization']}",
          style: pw.TextStyle(fontSize: 9),
        ),
        pw.Text(
          "${formatDate(edu['start_date'])} - ${formatDate(edu['end_date'])}",
          style: pw.TextStyle(fontSize: 8, color: PdfColors.grey),
        ),
        if (edu['cgpa_percentage'] != null)
          pw.Text(
            "CGPA/Percentage: ${edu['cgpa_percentage']}",
            style: pw.TextStyle(fontSize: 8),
          ),
        pw.SizedBox(height: 5), // Reduced spacing
      ],
    );
  }

  pw.Widget _buildPdfCertifications(List certifications) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: certifications.map<pw.Widget>((cert) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              cert['certification_name'],
              style: pw.TextStyle(
                fontSize: 9, // Reduced font size
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              "ID: ${cert['certification_id']} | ${cert['authorized_institute']} (${cert['year_of_certification']})",
              style: pw.TextStyle(fontSize: 8, color: PdfColors.grey),
            ),
            pw.SizedBox(height: 3), // Reduced spacing
          ],
        );
      }).toList(),
    );
  }

  pw.Widget _buildPdfInternships(List internships) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: internships.map<pw.Widget>((internship) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              internship['organization'],
              style: pw.TextStyle(
                fontSize: 10, // Reduced font size
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              internship['location'],
              style: pw.TextStyle(fontSize: 9, color: PdfColors.grey),
            ),
            pw.Text(
              "${formatDate(internship['start_date'])} - ${formatDate(internship['end_date'])}",
              style: pw.TextStyle(fontSize: 8, color: PdfColors.grey),
            ),
            pw.Text(
              internship['description'],
              style: pw.TextStyle(fontSize: 9),
            ),
            pw.SizedBox(height: 5), // Reduced spacing
          ],
        );
      }).toList(),
    );
  }

  pw.Widget _buildPdfProjects(List projects) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: projects.map<pw.Widget>((project) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              project['project_name'],
              style: pw.TextStyle(
                fontSize: 10, // Reduced font size
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              "Client: ${project['client']}",
              style: pw.TextStyle(fontSize: 9, color: PdfColors.grey),
            ),
            pw.Text(
              "${formatDate(project['start_date'])} - ${formatDate(project['end_date'])}",
              style: pw.TextStyle(fontSize: 8, color: PdfColors.grey),
            ),
            if (project['project_link'] != null)
              pw.Text(
                project['project_link'],
                style: pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.blue,
                  decoration: pw.TextDecoration.underline,
                ),
              ),
            pw.SizedBox(height: 5), // Reduced spacing
          ],
        );
      }).toList(),
    );
  }

  pw.Widget _buildPdfAchievements(List achievements) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: achievements.map<pw.Widget>((achievement) {
        return pw.Padding(
          padding: pw.EdgeInsets.symmetric(vertical: 1),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("• ", style: pw.TextStyle(fontSize: 9)),
              pw.Expanded(
                child: pw.Text(
                  achievement,
                  style: pw.TextStyle(fontSize: 9),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
