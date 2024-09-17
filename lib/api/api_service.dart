import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.176.182:8000'; // Replace with your actual API URL
  // Fetch stuent list fter login

  // Fetch student dashboard data by studentId
  static Future<Map<String, dynamic>> fetchStudentDashboard(int studentId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/student-dashboard/$studentId/'));
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load student dashboard data');
    }
  }
}
