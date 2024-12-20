import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Global/Global.dart';
import '../Online/Online.dart';
import '../clases/Product.dart';
import '../clases/User.dart';
import '../common_functions/Functions.dart';
import '../screens/navigationScreens/profileScreens/MyProfileScreen.dart';
import '../widgets/barWidgets/MyNavigationBarWidget.dart';

class UserService {
  static get navigationBarState => null;


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
      Functions.showSnackBar('Добро пожаловать!', context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyNavigationBar()),
      );
    }
  }

  static Future<void> saveToWishlist( String userId,String productId) async {
    http.Response response = await http.post(
      Uri.parse('$HTTPS/api/users/add_to_wishlist?userId=$userId&productId=$productId'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add to wishlist');
    }
  }
  static Future<List<Product>> fetchWishlistProducts(int page, int limit) async {
    final userId = Online.user.userID;
    List<Product> products = [];
    final response = await http.get(
      Uri.parse('$HTTPS/api/users/get_fav_products?userId=$userId'),
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

  static Future<void> updateUser(String userId, BuildContext context, {String? imagePath}) async {
    final Uri url = Uri.parse('$HTTPS/api/users/update?userId=$userId');
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
    final String url = '$HTTPS/api/users/delete?userId=$userId';

    try {
      // Sending the DELETE request
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        // Successfully deleted
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User successfully deleted')),
        );

      } else {
        // Error response
        final errorData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorData['error'] ?? 'Failed to delete user')),
        );
      }
    } catch (e) {
      // Exception handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
  static Future<void> reportUser(String userId, BuildContext context) async {
    final String url = '$HTTPS/api/users/report?userId=$userId';
    final response = await http.put(Uri.parse(url));
    if (response.statusCode == 200) {
      Functions.showSnackBar('User was reported', context);
    }
    else {
      throw Exception('Failed to report user: ${response.statusCode}');
    }
  }


}