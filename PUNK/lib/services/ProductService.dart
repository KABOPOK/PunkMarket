import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Global/Global.dart';
import '../Online/Online.dart';
import '../clases/Product.dart';
import '../common_functions/Functions.dart';
import '../widgets/barWidgets/MyNavigationBarWidget.dart';

class ProductService {
  static Future<void> sendProduct(Product product, List<File?> images, BuildContext context) async {
    String baseUrl = await HTTP();
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl$port/api/products/create'));
    request.fields['product'] = jsonEncode(product.toJson());
    for (var image in images) {
      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('images', image.path));
      }
    }
    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to load product: ${response.statusCode}');
    }
  }

  static Future<void> updateProduct(String productId, Product product, BuildContext context, List<File?> images) async {
    String baseUrl = await HTTP();
    var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl$port/api/products/update?productId=$productId'));
    request.fields['product'] = jsonEncode(product.toJson());
    for (var image in images) {
      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('images', image.path));
      }
    }
    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to update product: ${response.statusCode}');
    }
  }

  static Future<void> deleteProduct(String productId, BuildContext context) async {
    String baseUrl = await HTTP();
    var response = await http.delete(Uri.parse('$baseUrl$port/api/products/delete?productId=$productId'));
    if (response.statusCode == 200) {
      Functions.showSnackBar('Product successfully deleted', context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyNavigationBar(initialScreenIndex: 1)),
      );
    } else {
      throw Exception('Failed to delete product: ${response.statusCode}');
    }
  }

  static Future<List<Product>> fetchUserProducts(int page, int limit) async {
    String baseUrl = await HTTP();
    final userId = Online.user.userID;
    var response = await http.get(
      Uri.parse('$baseUrl$port/api/products/get_my_products?userId=$userId&page=$page&limit=$limit'),
    );
    if (response.statusCode == 200) {
      var productData = json.decode(response.body) as List<dynamic>;
      return productData.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  static Future<List<Product>> fetchProducts(int page, int limit, String query) async {
    String baseUrl = await HTTP();
    var response = await http.get(
      Uri.parse('$baseUrl$port/api/products/get_products?page=$page&limit=$limit&query=$query'),
    );
    if (response.statusCode == 200) {
      var productData = json.decode(response.body) as List<dynamic>;
      return productData.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  static Future<List<String>> fetchProductUrlList(String productId) async {
    String baseUrl = await HTTP();
    var response = await http.get(
      Uri.parse('$baseUrl$port/api/products/get_product_image_list?productId=$productId'),
    );
    if (response.statusCode == 200) {
      var dynamicList = json.decode(response.body) as List<dynamic>;
      return List<String>.from(dynamicList);
    } else {
      throw Exception('Failed to load product URL list: ${response.statusCode}');
    }
  }
}
