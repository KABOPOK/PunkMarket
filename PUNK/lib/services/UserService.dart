import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Global/Global.dart';
import '../Online/Online.dart';
import '../clases/User.dart';
import '../common_functions/Functions.dart';
import '../widgets/barWidgets/MyNavigationBarWidget.dart';

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

  static Future<void> loginUser(User user, BuildContext context) async {
    final url = Uri.parse('$HTTPS/api/users/authorization');
    http.Response response =  await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toLogonDataDTO()),
    );
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      Online.user = User.fromJson(jsonResponse);
      Functions.showSnackBar('здарова заебал', context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyNavigationBar()),
      );
    }
  }

}
