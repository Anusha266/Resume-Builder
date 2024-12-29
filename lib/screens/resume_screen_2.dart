import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class ResumeScreen2 extends StatefulWidget {
  final Map<String, dynamic> profileData;
  const ResumeScreen2({super.key, required this.profileData});

  @override
  State<ResumeScreen2> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen2> {
  late final Map<String, dynamic> profileData;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    profileData = widget.profileData;
  }

  String formatDate(String date) {
    try {
      if (date.length == 4) {
        date = "$date-01-01";
      }
      return DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
    } catch (e) {
      print("Invalid date format: $date");
      return "Invalid Date";
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        title: Text("Resume", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () async {
              try {
                final pdf = await _generatePdf();
                final bytes = await pdf.save();
                await Printing.sharePdf(
                  bytes: bytes,
                  filename:
                      'resume_${DateTime.now().millisecondsSinceEpoch}.pdf',
                );
              } catch (e) {
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth > 600
              ? _buildWideLayout(constraints)
              : _buildNarrowLayout(constraints);
        },
      ),
    );
  }

  Widget _buildWideLayout(BoxConstraints constraints) {
    return Row(
      children: [
        Container(
          width: constraints.maxWidth * 0.3,
          color: Colors.blue.shade800,
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileSection(),
                SizedBox(height: 24),
                _buildContactInfo(),
                SizedBox(height: 24),
                _buildSkillsSection(),
                SizedBox(height: 24),
                _buildProfilesSection(),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.grey.shade50,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildMainContent(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(BoxConstraints constraints) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Colors.blue.shade800,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildProfileSection(),
                SizedBox(height: 16),
                _buildContactInfo(),
              ],
            ),
          ),
          Container(
            color: Colors.grey.shade50,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSkillsSection(),
                SizedBox(height: 16),
                ..._buildMainContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.white,
          child: Icon(Icons.person, size: 60, color: Colors.blue.shade800),
        ),
        SizedBox(height: 16),
        Text(
          "${profileData['personalInfo']['first_name']} ${profileData['personalInfo']['last_name']}",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          profileData['personalInfo']['designation'] ?? "Software Developer",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        if (profileData['personalInfo']['summary'] != null)
          Text(
            profileData['personalInfo']['summary'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }

  Widget _buildContactInfo() {
    final personalInfo = profileData['personalInfo'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitleWhite("Contact Information"),
        SizedBox(height: 8),
        _buildContactItem(
            Icons.email, personalInfo['communication_email'] ?? "N/A"),
        _buildContactItem(Icons.phone, personalInfo['mobile'] ?? "N/A"),
        _buildContactItem(Icons.location_on,
            "${personalInfo['address']['city']}, ${personalInfo['address']['state']}"),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Technical Skills"),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: (profileData['skills'] as List)
              .map((skill) => Chip(
                    label: Text(skill),
                    backgroundColor: Colors.blue.shade100,
                  ))
              .toList(),
        ),
        SizedBox(height: 16),
        _buildSectionTitle("Domain Knowledge"),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: (profileData['domainKnowledge'] as List)
              .map((domain) => Chip(
                    label: Text(domain),
                    backgroundColor: Colors.green.shade100,
                  ))
              .toList(),
        ),
      ],
    );
  }

  List<Widget> _buildMainContent() {
    return [
      _buildEducationSection(),
      SizedBox(height: 24),
      _buildExperienceSection(),
      SizedBox(height: 24),
      _buildProjectsSection(),
      SizedBox(height: 24),
      _buildCertificationsSection(),
      SizedBox(height: 24),
      _buildAchievementsSection(),
    ];
  }

  Widget _buildEducationSection() {
    final education = profileData['education'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Education"),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildEducationItem(
                  institution: education['grad']['institution_name'],
                  degree: education['grad']['specialization'],
                  period: "${education['grad']['start_date']} - Present",
                  grade: "CGPA: ${education['grad']['cgpa_percentage']}",
                ),
                Divider(),
                _buildEducationItem(
                  institution: education['undergrad']['institution_name'],
                  degree: education['undergrad']['specialization'],
                  period:
                      "${education['undergrad']['start_date']} - ${education['undergrad']['end_date']}",
                  grade: "CGPA: ${education['undergrad']['cgpa_percentage']}",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEducationItem({
    required String institution,
    required String degree,
    required String period,
    required String grade,
  }) {
    return ListTile(
      title: Text(institution, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(degree),
          Text(period, style: TextStyle(color: Colors.grey)),
          Text(grade),
        ],
      ),
    );
  }

  Widget _buildExperienceSection() {
    final internships = profileData['internships'] as List;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Experience"),
        ...internships
            .map((internship) => Card(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          internship['organization'],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "${internship['location']} | ${internship['start_date']} - ${internship['end_date']}",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(internship['description']),
                      ],
                    ),
                  ),
                ))
            .toList(),
      ],
    );
  }

  Widget _buildProjectsSection() {
    final projects = profileData['projects'] as List;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Projects"),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 900 ? 2 : 1,
            childAspectRatio: 1.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project['project_name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text("Client: ${project['client']}",
                        style:
                            TextStyle(fontSize: 14, color: Colors.grey[700])),
                    SizedBox(height: 8),
                    Text(
                      "Duration: ${project['start_date']} - ${project['end_date']}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 8),
                    if (project['description'] != null)
                      Text(
                        project['description'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(fontSize: 14),
                      ),
                    SizedBox(height: 8),
                    if (project['attachments'] != null)
                      Text(
                        "Attachments: ${project['attachments']}",
                        style: TextStyle(fontSize: 14, color: Colors.blue),
                      ),
                    if (project['project_link'] != null)
                      GestureDetector(
                        onTap: () {
                          // Handle project link navigation
                        },
                        child: Text(
                          "Project Link",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    SizedBox(height: 8),
                    if (project['tech_stack'] != null)
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: (project['tech_stack'] as String)
                            .split(',')
                            .map((tech) => Chip(
                                  label: Text(tech.trim(),
                                      style: TextStyle(fontSize: 12)),
                                  backgroundColor: Colors.blue.shade50,
                                ))
                            .toList(),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCertificationsSection() {
    final certificates = profileData['certificates'] as List;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Certifications"),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: certificates.length,
          itemBuilder: (context, index) {
            final cert = certificates[index];
            return Card(
              margin: EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(cert['certification_name']),
                subtitle: Text(
                  "${cert['authorized_institute']} (${cert['year_of_certification']})",
                ),
                leading: Icon(Icons.verified, color: Colors.blue),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAchievementsSection() {
    final achievements = profileData['achievements'] as List;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Achievements"),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: achievements
                  .map((achievement) => ListTile(
                        leading: Icon(Icons.star, color: Colors.amber),
                        title: Text(achievement),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfilesSection() {
    final personalInfo = profileData['personalInfo'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitleWhite("Professional Profiles"),
        _buildProfileLink(
            Icons.link, "LinkedIn", personalInfo['linkedin_profile'] ?? "N/A"),
        _buildProfileLink(
            Icons.code, "GitHub", personalInfo['github_profile'] ?? "N/A"),
      ],
    );
  }

  Widget _buildProfileLink(IconData icon, String platform, String url) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          SizedBox(width: 8),
          Text(
            platform,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          Expanded(
            child: Text(
              url,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue.shade800,
      ),
    );
  }

  Widget _buildSectionTitleWhite(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

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
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Left Sidebar
                pw.Container(
                  width: 140,
                  color: PdfColors.blue800,
                  child: pw.Padding(
                    padding: pw.EdgeInsets.all(16),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
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
                            ),
                          ),
                        pw.SizedBox(height: 16),
                        pw.Text(
                          "Contact Information",
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        _buildPdfContactItem(
                            "Email: ${personalInfo['communication_email']}"),
                        _buildPdfContactItem(
                            "Phone: ${personalInfo['mobile']}"),
                        _buildPdfContactItem(
                            "LinkedIn: ${personalInfo['linkedin_profile']}"),
                        _buildPdfContactItem(
                            "GitHub: ${personalInfo['github_profile']}"),
                        pw.SizedBox(height: 16),
                        pw.Text(
                          "Technical Skills",
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        ...(widget.profileData['skills'] as List)
                            .map((skill) => _buildPdfSkillItem(skill)),
                        pw.SizedBox(height: 16),
                        pw.Text(
                          "Domain Knowledge",
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        ...(widget.profileData['domainKnowledge'] as List)
                            .map((domain) => _buildPdfSkillItem(domain)),
                      ],
                    ),
                  ),
                ),

                pw.SizedBox(width: 16),

                // Main Content
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "${personalInfo['first_name']} ${personalInfo['last_name']}",
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        personalInfo['designation'] ?? "",
                        style: pw.TextStyle(
                          fontSize: 14,
                          color: PdfColors.blue,
                        ),
                      ),
                      pw.SizedBox(height: 16),
                      _buildPdfSectionTitle("Summary"),
                      pw.Text(
                        personalInfo['summary'] ?? "",
                        style: pw.TextStyle(fontSize: 10),
                      ),
                      pw.SizedBox(height: 16),
                      _buildPdfSectionTitle("Education"),
                      _buildPdfEducation(widget.profileData['education']),
                      pw.SizedBox(height: 16),
                      _buildPdfSectionTitle("Experience"),
                      _buildPdfInternships(widget.profileData['internships']),
                      pw.SizedBox(height: 16),
                      _buildPdfSectionTitle("Projects"),
                      _buildPdfProjects(widget.profileData['projects']),
                      pw.SizedBox(height: 16),
                      _buildPdfSectionTitle("Certifications"),
                      _buildPdfCertifications(
                          widget.profileData['certificates']),
                      pw.SizedBox(height: 16),
                      _buildPdfSectionTitle("Achievements"),
                      _buildPdfAchievements(widget.profileData['achievements']),
                    ],
                  ),
                ),
              ],
            ),
          ];
        },
      ),
    );

    return pdf;
  }

  pw.Widget _buildPdfContactItem(String text) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 10,
        ),
      ),
    );
  }

  pw.Widget _buildPdfSkillItem(String skill) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Text(
        "• $skill",
        style: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 10,
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
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue,
          ),
        ),
        pw.Divider(color: PdfColors.blue, thickness: 1),
      ],
    );
  }

  pw.Widget _buildPdfEducation(Map<String, dynamic> education) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildPdfEducationItem("Graduate", education['grad']),
        _buildPdfEducationItem("Undergraduate", education['undergrad']),
      ],
    );
  }

  pw.Widget _buildPdfEducationItem(String level, Map<String, dynamic> edu) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "$level: ${edu['institution_name']} - ${edu['specialization']}",
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            "${edu['start_date']} - ${edu['end_date']}",
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfInternships(List internships) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: internships.map((internship) {
        return pw.Padding(
          padding: pw.EdgeInsets.symmetric(vertical: 8),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                internship['organization'],
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                "${internship['location']} | ${internship['start_date']} - ${internship['end_date']}",
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey,
                ),
              ),
              pw.Text(
                internship['description'],
                style: pw.TextStyle(
                  fontSize: 10,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  pw.Widget _buildPdfProjects(List projects) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: projects.map((project) {
        return pw.Padding(
          padding: pw.EdgeInsets.symmetric(vertical: 8),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                project['project_name'],
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                "Client: ${project['client']}",
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey,
                ),
              ),
              pw.Text(
                "${project['start_date']} - ${project['end_date']}",
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey,
                ),
              ),
              if (project['project_link'] != null)
                pw.Text(
                  "Link: ${project['project_link']}",
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.blue,
                    decoration: pw.TextDecoration.underline,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  pw.Widget _buildPdfCertifications(List certificates) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: certificates.map((cert) {
        return pw.Padding(
          padding: pw.EdgeInsets.symmetric(vertical: 8),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                cert['certification_name'],
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                "Issued by ${cert['authorized_institute']} (${cert['year_of_certification']})",
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  pw.Widget _buildPdfAchievements(List achievements) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: achievements.map((achievement) {
        return pw.Padding(
          padding: pw.EdgeInsets.symmetric(vertical: 8),
          child: pw.Text(
            "• $achievement",
            style: pw.TextStyle(
              fontSize: 10,
            ),
          ),
        );
      }).toList(),
    );
  }
}
