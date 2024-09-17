import 'package:flutter/material.dart';
import 'package:csm_flutter_app/api/api_service.dart';
import 'package:csm_flutter_app/components/student_dashboard_components.dart';

class StudentDashboard extends StatefulWidget {
  final int studentId;

  const StudentDashboard({super.key, required this.studentId});

  @override
  StudentDashboardState createState() => StudentDashboardState();
}

class StudentDashboardState extends State<StudentDashboard> {
  late Future<Map<String, dynamic>> _dashboardData;

  @override
  void initState() {
    super.initState();
    _dashboardData = ApiService.fetchStudentDashboard(widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Dashboard')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dashboardData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  StudentInfoCard(student: data['student']),
                  AttendanceChart(attendanceData: data['attendance_data']),
                  PerformanceChart(performanceData: data['performance_data']),
                  RecentAttendanceList(
                      recentAttendance: data['recent_attendance']),
                  RecentPerformanceList(
                      recentPerformance: data['recent_performance']),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
