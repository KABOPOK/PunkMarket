import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Global/Global.dart';
import '../Online/Online.dart';
import '../clases/Product.dart';
import '../clases/User.dart';
import '../common_functions/Functions.dart';
import '../widgets/barWidgets/MyNavigationBarWidget.dart';

class UserService {
  static get navigationBarState => null;

  static Future<void> registerUser(User user, {String? imagePath}) async {
    String baseUrl = await HTTP();
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl$port/api/users/create'));
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
    String baseUrl = await HTTP();
    final url = Uri.parse('$baseUrl$port/api/users/authorization?networkUrl=$baseUrl');  // Include networkUrl as query param
    var loginData = jsonEncode(user.toLogonDataDTO());
    try {
      http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: loginData,
      );
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        Online.user = User.fromJson(jsonResponse);
        Functions.showSnackBar('Bienvenido', context);

        // Navigate to the next screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyNavigationBar()),
        );
      } else {
        Functions.showSnackBar('Failed to log in. Please try again.', context);
        throw Exception('Failed to log in');
      }
    } catch (e) {
      Functions.showSnackBar('An error occurred: $e', context);
      throw Exception('An error occurred during login');
    }
  }


  static Future<void> saveToWishlist(String userId, String productId) async {
    String baseUrl = await HTTP();
    http.Response response = await http.post(
      Uri.parse('$baseUrl$port/api/wishlist/add_to_wishlist?userId=$userId&productId=$productId'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add to wishlist');
    }
  }

  static Future<List<Product>> fetchWishlistProducts(int page, int limit) async {
    String baseUrl = await HTTP();
    final userId = Online.user.userID;
    List<Product> products = [];
    final response = await http.get(
      Uri.parse('$baseUrl$port/api/wishlist/get_fav_products?userId=$userId'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> productData = json.decode(response.body);
      products = productData.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch wishlist products: ${response.statusCode}');
    }
    return products;
  }

  static Future<void> updateUser(String userId, BuildContext context, {String? imagePath}) async {
    String baseUrl = await HTTP();
    final Uri url = Uri.parse('$baseUrl$port/api/users/update?userId=$userId');
    final http.MultipartRequest request = http.MultipartRequest('PUT', url);
    request.fields['user'] = json.encode(Online.user.toJson());
    if (imagePath != null) {
      final http.MultipartFile imageFile = await http.MultipartFile.fromPath('image', imagePath);
      request.files.add(imageFile);
    }
    final http.StreamedResponse response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
    final String responseBody = await response.stream.bytesToString();
    final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
    Online.user = User.fromJson(jsonResponse);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyNavigationBar(initialScreenIndex: 2)),
    );
  }

  static Future<void> deleteUser(String userId, BuildContext context) async {
    String baseUrl = await HTTP();
    final String url = '$baseUrl$port/api/users/delete?userId=$userId';

    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User successfully deleted')),
        );
      } else {
        final errorData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorData['error'] ?? 'Failed to delete user')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}
