import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/student_model.dart';
import 'student_dashboard_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  StudentListScreenState createState() => StudentListScreenState();
}

class StudentListScreenState extends State<StudentListScreen> {
  List<Student> students = [];
  bool isLoading = false;
  bool _needsLogin = false;
  int currentPage = 1;
  static const int pageSize = 20;
  bool hasMore = true;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMoreStudents();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreStudents();
    }
  }

  Future<void> _loadMoreStudents() async {
    if (isLoading || !hasMore) return;
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final csrfToken = prefs.getString('csrf_token');
    final sessionCookie = prefs.getString('session_cookie');

    if (csrfToken == null || sessionCookie == null) {
      setState(() {
        _needsLogin = true;
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://192.168.176.182:8000/api/student-list/?page=$currentPage&page_size=$pageSize'),
        headers: {
          'X-CSRFToken': csrfToken,
          'Cookie': '$sessionCookie; csrftoken=$csrfToken',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        List<Student> newStudents = (jsonResponse['results'] as List)
            .map((studentJson) => Student.fromJson(studentJson))
            .toList();

        setState(() {
          students.addAll(newStudents);
          currentPage++;
          isLoading = false;
          hasMore = jsonResponse['next'] != null;
        });
      } else if (response.statusCode == 401) {
        setState(() {
          _needsLogin = true;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load students');
      }
    } catch (e) {
      print('Error fetching students: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _refreshStudentList() {
    setState(() {
      students.clear();
      currentPage = 1;
      hasMore = true;
    });
    _loadMoreStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshStudentList,
          ),
        ],
      ),
      body: _needsLogin
          ? _buildLoginRedirect()
          : _buildStudentList(),
    );
  }

  Widget _buildLoginRedirect() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, '/login');
    });
    return const Center(child: Text('Redirecting to login...'));
  }

  Widget _buildStudentList() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('First Name')),
                  DataColumn(label: Text('Last Name')),
                  DataColumn(label: Text('ID')),
                ],
                rows: students.map((Student student) {
                  return DataRow(
                    cells: [
                      DataCell(Text(student.firstName)),
                      DataCell(Text(student.lastName)),
                      DataCell(Text(student.schoolIdentification)),
                    ],
                    onSelectChanged: (_) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentDashboard(studentId: student.id),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}