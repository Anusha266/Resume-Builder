import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class ProjectsScreen extends StatefulWidget {
  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Project> projects = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController clientController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController projectLinkController = TextEditingController();
  final TextEditingController attachmentsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('projects').get();
      setState(() {
        projects = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return Project(
            id: doc.id,
            projectName: data['project_name'] ?? '',
            client: data['client'] ?? '',
            startDate: data['start_date'] ?? '',
            endDate: data['end_date'] ?? '',
            projectLink: data['project_link'] ?? '',
            attachments: data['attachments'] ?? '',
          );
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching projects: $e")),
      );
    }
  }

  bool isFormComplete() {
    return projectNameController.text.isNotEmpty &&
        clientController.text.isNotEmpty &&
        startDateController.text.isNotEmpty &&
        endDateController.text.isNotEmpty;
  }

  Future<void> addProject() async {
    if (isFormComplete()) {
      try {
        DocumentReference docRef = await _firestore.collection('projects').add({
          'project_name': projectNameController.text,
          'client': clientController.text,
          'start_date': startDateController.text,
          'end_date': endDateController.text,
          'project_link': projectLinkController.text,
          'attachments': attachmentsController.text,
          'created_at': FieldValue.serverTimestamp(),
          'user_id': FirebaseAuth.instance.currentUser?.uid
        });

        final formData = {
          'project_name': projectNameController.text,
          'client': clientController.text,
          'start_date': startDateController.text,
          'end_date': endDateController.text,
          'project_link': projectLinkController.text,
          'attachments': attachmentsController.text,
          'created_at': FieldValue.serverTimestamp(),
        };

        Project newProject = Project(
          id: docRef.id,
          projectName: projectNameController.text,
          client: clientController.text,
          startDate: startDateController.text,
          endDate: endDateController.text,
          projectLink: projectLinkController.text,
          attachments: attachmentsController.text,
        );

        setState(() {
          projects.add(newProject);
        });
        Navigator.pop(context, formData);
        clearForm();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Project added successfully!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error adding project: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all required fields."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void clearForm() {
    projectNameController.clear();
    clientController.clear();
    startDateController.clear();
    endDateController.clear();
    projectLinkController.clear();
    attachmentsController.clear();
  }

  Future<void> deleteProject(String projectId) async {
    try {
      await _firestore.collection('projects').doc(projectId).delete();
      setState(() {
        projects.removeWhere((project) => project.id == projectId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Project deleted successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting project: $e")),
      );
    }
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
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
            borderSide: BorderSide(width: 2, color: Colors.deepPurple),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Projects"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Project Details",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              _buildTextField("Project Name", projectNameController),
              _buildTextField("Client/Organization", clientController),
              _buildTextField("Start Date", startDateController),
              _buildTextField("End Date", endDateController),
              _buildTextField("Project Link (Optional)", projectLinkController),
              _buildTextField("Attachments (Optional)", attachmentsController),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: addProject,
                  icon: Icon(Icons.add),
                  label: Text("Add Project"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (projects.isNotEmpty) ...[
                Text(
                  "Projects List:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                ...projects.map((project) => ProjectCard(
                      project: project,
                      onDelete: () => deleteProject(project.id),
                    )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class Project {
  final String id;
  final String projectName;
  final String client;
  final String startDate;
  final String endDate;
  final String projectLink;
  final String attachments;

  Project({
    required this.id,
    required this.projectName,
    required this.client,
    required this.startDate,
    required this.endDate,
    this.projectLink = '',
    this.attachments = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_name': projectName,
      'client': client,
      'start_date': startDate,
      'end_date': endDate,
      'project_link': projectLink,
      'attachments': attachments,
    };
  }
}

class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onDelete;

  const ProjectCard({
    required this.project,
    required this.onDelete,
  });

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Project Name: ${project.projectName}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
            Text("Client/Organization: ${project.client}"),
            Text("Start Date: ${project.startDate}"),
            Text("End Date: ${project.endDate}"),
            if (project.projectLink.isNotEmpty)
              Text("Project Link: ${project.projectLink}"),
            if (project.attachments.isNotEmpty)
              Text("Attachments: ${project.attachments}"),
          ],
        ),
      ),
    );
  }
}
