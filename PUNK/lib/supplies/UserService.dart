import 'dart:convert';
import 'package:http/http.dart' as http;
import '../clases/User.dart';

class UserService {
  final String baseUrl = 'http://localhost:8080/api';

  Future<User?> fetchUser(String phoneNumber, String password) async {
    final url = Uri.parse('$baseUrl/users/authorization');

    // Only send the phoneNumber and password to the server for authorization
    final Map<String, String> credentials = {
      'number': phoneNumber,
      'password': password,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(credentials),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Using the updated `fromJson` which defaults missing values to empty strings
        return User.fromJson(jsonResponse);
      } else {
        print('Error: Unexpected response format');
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }
}
