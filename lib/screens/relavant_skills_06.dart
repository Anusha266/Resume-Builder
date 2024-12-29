import 'package:flutter/material.dart';

class RelevantSkillsScreen extends StatefulWidget {
  @override
  _RelevantSkillsScreenState createState() => _RelevantSkillsScreenState();
}

class _RelevantSkillsScreenState extends State<RelevantSkillsScreen> {
  // List to store the skills input by the user
  List<String> skills = [];

  // Controller for the text input field
  TextEditingController skillController = TextEditingController();

  // Function to handle adding skills to the list
  void addSkill() {
    if (skills.length < 6 && skillController.text.isNotEmpty) {
      setState(() {
        skills.add(skillController.text);
        skillController.clear(); // Clear input field after adding
      });
    }
  }

  // Function to handle removing a skill from the list
  void removeSkill(int index) {
    setState(() {
      skills.removeAt(index);
    });
  }

  // Function to submit and pass data back to the previous screen
  void submitSkills() {
    // Create a JSON structure with the skills
    final Map<String, dynamic> skillsData = {
      'skills': skills,
    };

    // Pass the data back to the previous screen
    Navigator.pop(context, skillsData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Relevant Skills"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: submitSkills,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter your relevant skills (up to 6 skills):",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            // TextField for skill input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: skillController,
                    decoration: InputDecoration(
                      labelText: "Enter skill",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addSkill,
                  color: Colors.deepPurple,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Display the list of skills
            Expanded(
              child: ListView.builder(
                itemCount: skills.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                    title: Text(skills[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => removeSkill(index),
                      color: Colors.red,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Show a message if no skills are added
            if (skills.isEmpty)
              const Center(
                child: Text(
                  "No skills added yet.",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            // Save button
            ElevatedButton(
              onPressed: submitSkills,
              child: const Text("Save Skills"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
