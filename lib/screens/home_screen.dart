import 'package:flutter/material.dart';
import 'package:resume/screens/edit_screen.dart';
import 'package:resume/screens/profile_screen.dart';
import 'package:resume/screens/resume_template_page.dart';
import 'package:resume/screens/domain_list_screen.dart'; // Assuming you have this screen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    DomainListPage(), // Add the new screen here
    ResumeTemplatePage(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list), // Icon for DomainList
            label: 'Domain List', // Label for DomainList
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Template',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
