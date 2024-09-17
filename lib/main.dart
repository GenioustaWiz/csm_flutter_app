
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'student_list_screen.dart';

// Entry point of the application
void main() {
  runApp(const StudentDashboardApp());
}

// Root widget of the application
class StudentDashboardApp extends StatelessWidget {
  // Updated constructor using super parameter
  const StudentDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Define the initial route of the app
      initialRoute: '/',
      // Define the routes for navigation
      routes: {
        '/': (context) => const LoginScreen(),
        '/student-list': (context) => const StudentListScreen(),
      },
    );
  }
}

