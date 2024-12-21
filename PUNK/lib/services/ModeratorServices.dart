import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Global/Global.dart';
import '../clases/Product.dart';
import '../clases/User.dart';
import '../common_functions/Functions.dart';
import '../widgets/admin/AdminNavigationBarWidget.dart';


class ModeratorService {
  static get navigationBarState => null;

  static Future<bool> loginModerator(String moderatorKey, BuildContext context) async {
    final url = Uri.parse('$HTTPS/api/moderator/login?moderatorKey=$moderatorKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        Functions.showSnackBar('Добро пожаловать!', context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AdminNavigationBar()),
        );
        return jsonDecode(response.body) as bool;
      } else {
        throw Exception('Failed to validate moderator key. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }

  static Future<List<User>> fetchUsers(String key) async {
    List<User> users = [];
    final response = await http.get(
      Uri.parse('$HTTPS /api/moderator/get_users?key=$key'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> userData = json.decode(response.body);
      for (int i = 0; i < userData.length; ++i) {
        users.add(User.fromJson(userData[i]));
      }
    }
    else {
      throw ErrorHint("Error : ${response.statusCode}");
    }
    return users;
  }

  static Future<List<Product>> fetchProducts(String key) async {
    List<Product> products = [];
    final response = await http.get(
      Uri.parse('$HTTPS/api/moderator/get_products?key=$key'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> productData = json.decode(response.body);
      for (int i = 0; i < productData.length; ++i) {
        products.add(Product.fromJson(productData[i]));
      }
    }
    else {
      throw ErrorHint("Error : ${response.statusCode}");
    }
    return products;
  }
  static Future<void> DeclineUserReport(String userId, BuildContext context) async {
    final String url = '$HTTPS /api/moderator/decline_report_user?userId=$userId';
    final response = await http.put(Uri.parse(url));
    if (response.statusCode == 200) {
      Functions.showSnackBar('Product was reported', context);
    }
    else {
      throw Exception('Failed to report product: ${response.statusCode}');
    }
  }

  static Future<void> DeclineProductReport(String productId, BuildContext context) async {
    final String url = '$HTTPS /api/moderator/decline_report_product?productId=$productId';
    final response = await http.put(Uri.parse(url));
    if (response.statusCode == 200) {
      Functions.showSnackBar('Product was reported', context);
    }
    else {
      throw Exception('Failed to report product: ${response.statusCode}');
    }
  }
}