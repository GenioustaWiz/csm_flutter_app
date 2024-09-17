import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// StatefulWidget for the login screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  // Controllers for managing text input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Flag to track if a login attempt is in progress
  bool _isLoading = false;

  /// Fetches the CSRF token from the login page.
  /// This is required for Django login via POST requests.
  Future<String?> fetchCsrfToken() async {
    try {
      // GET request to fetch the login page and CSRF token
      final response = await http.get(Uri.parse('http://192.168.176.182:8000/user/login/'));

      if (response.statusCode == 200) {
        // Parse the response HTML to extract CSRF token
        final document = parse(response.body);
        // Find the input element with the name "csrfmiddlewaretoken"
        final csrfInput = document.querySelector('input[name="csrfmiddlewaretoken"]');
        
        // Return CSRF token if found
        return csrfInput?.attributes['value'];
      } else {
        throw Exception('Failed to fetch CSRF token');
      }
    } catch (e) {
      print('Error fetching CSRF token: $e');
      return null;
    }
  }

  // Method to handle user login
   Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      final csrfToken = await fetchCsrfToken();
      if (csrfToken == null) {
        print('Failed to obtain CSRF token. Cannot proceed with login.');
        return;
      }

      final response = await http.post(
        Uri.parse('http://192.168.176.182:8000/api/login/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-CSRFToken': csrfToken,
          'Cookie': 'csrftoken=$csrfToken',
        },
        body: jsonEncode(<String, String>{
          'email': _emailController.text,
          'password': _passwordController.text,
          'csrfmiddlewaretoken': csrfToken,
        }),
      );

      if (response.statusCode == 200) {
        // Extract and save both CSRF token and session cookie
        final prefs = await SharedPreferences.getInstance();
        
        // Save CSRF token
        await prefs.setString('csrf_token', csrfToken);

        // Extract and save session cookie
        String? rawCookie = response.headers['set-cookie'];
        if (rawCookie != null) {
          // Split cookies if multiple are present
          List<String> cookies = rawCookie.split(',');
          for (String cookie in cookies) {
            if (cookie.trim().startsWith('sessionid=')) {
              int index = cookie.indexOf(';');
              String sessionCookie = (index == -1) ? cookie : cookie.substring(0, index);
              await prefs.setString('session_cookie', sessionCookie.trim());
              break;
            }
          }
        }

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/student-list');
        }
      } else {
        final errorMessage = jsonDecode(response.body)['detail'] ?? 'Unknown error occurred';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}
