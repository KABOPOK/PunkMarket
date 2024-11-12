import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Global/Global.dart';
import '../clases/User.dart';

class UserService {

  static Future<void> registerUser(User user, {String? imagePath}) async {
    var request = http.MultipartRequest('POST', Uri.parse('$HTTPS/api/users/create'));
    request.fields['user'] = json.encode(user.toUserDTO());
    if (imagePath != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }
    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to register user');
    }
  }

  static Future<http.Response> loginUser(User user) async {
    final url = Uri.parse('$HTTPS/api/users/authorization');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toLogonDataDTO()),
    );
  }

}
