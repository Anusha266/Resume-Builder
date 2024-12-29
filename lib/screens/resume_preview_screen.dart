import 'package:flutter/material.dart';

class ResumePreviewScreen extends StatelessWidget {
  final Map<String, dynamic> profileData;

  // Constructor to receive the profile data
  ResumePreviewScreen({required this.profileData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Preview'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (profileData['personal_information'] != null)
              _buildSection(
                  'Personal Information', profileData['personal_information']),
            if (profileData['education'] != null)
              _buildSection('Education', profileData['education']),
            if (profileData['technology_certifications'] != null)
              _buildSection('Technology Certifications',
                  profileData['technology_certifications']),
            if (profileData['internships'] != null)
              _buildSection('Internships', profileData['internships']),
            if (profileData['projects'] != null)
              _buildSection('Projects', profileData['projects']),
            if (profileData['relevant_skills'].isNotEmpty)
              _buildSection('Relevant Skills', profileData['relevant_skills']),
            if (profileData['domain_knowledge'].isNotEmpty)
              _buildSection(
                  'Domain Knowledge', profileData['domain_knowledge']),
            if (profileData['achievements'].isNotEmpty)
              _buildSection('Achievements', profileData['achievements']),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, dynamic content) {
    if (content is List) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
          for (var item in content)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                item.toString(),
                style: const TextStyle(fontSize: 16),
              ),
            ),
        ],
      );
    } else if (content is Map) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
          ...content.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                '${entry.key}: ${entry.value}',
                style: const TextStyle(fontSize: 16),
              ),
            );
          }).toList(),
        ],
      );
    } else {
      return Container();
    }
  }
}
