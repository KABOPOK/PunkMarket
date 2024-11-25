import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Global/Global.dart';
import '../Online/Online.dart';
import '../clases/Product.dart';
import '../common_functions/Functions.dart';

class ProductService{

  static Future<void> sendProduct(Product product, List<File?> images, BuildContext context) async {
      var request = http.MultipartRequest('POST', Uri.parse('$HTTPS/api/products/create'));
      request.fields['product'] = jsonEncode(product.toJson());
      for (var i = 0; i < images.length; i++) {
        var image = images[i];
        if (image != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'images',
              image.path,
            ),
          );
        }
      }
      var response = await request.send();
      if (response.statusCode == 200) {
        //Functions.showSnackBar('Product created successfully', context);
      }
      //var responseString = await response.stream.bytesToString();;
  }
  static Future<void> updateProduct(String productId, Product product, BuildContext context, List<File?> images,) async {
    final uri = Uri.parse('$HTTPS/api/products/update?productId=$productId');
    final request = http.MultipartRequest('PUT', uri);
    request.fields['product'] = jsonEncode(product.toJson());
    for (var i = 0; i < images.length; i++) {
      var image = images[i];
      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'images',
            image.path,
          ),
        );
      }
    }

    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  }
  static Future<void> deleteProduct(String productId, BuildContext context) async {
    final String url = '$HTTPS/api/products/delete?productId=$productId';

    try {
      // Sending the DELETE request
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        // Successfully deleted
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product successfully deleted')),
        );

        // Optionally, you can trigger UI updates or navigation here
      } else {
        // Error response
        final errorData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorData['error'] ?? 'Failed to delete the product')),
        );
      }
    } catch (e) {
      // Exception handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  static Future<List<Product>> fetchUserProducts(int page, int limit) async {
    final userId = Online.user.userID;
    List<Product> products = [];
    final response = await http.get(
      Uri.parse('$HTTPS/api/products/get_my_products?userId=$userId&page=$page&limit=$limit'),
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
  static Future<List<Product>> fetchProducts(int page, int limit, String query) async {
    final userId = Online.user.userID;
    List<Product> products = [];
    final response = await http.get(
      Uri.parse('$HTTPS/api/products/get_products?page=$page&limit=$limit&query=$query'),
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

}