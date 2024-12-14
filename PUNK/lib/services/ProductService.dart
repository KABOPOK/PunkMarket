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
      var request = http.MultipartRequest('POST', Uri.parse('$HTTPS/api/products/create'));
      request.fields['product'] = jsonEncode(product.toJson());
      for (var i = 0; i < images.length; i++) {
        File? image = images[i];
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
      if (response.statusCode != 200) {
        throw Exception('Failed to load product : ${response.statusCode}');
      }
      //var responseString = await response.stream.bytesToString();;
  }

  static Future<void> updateProduct(String productId, Product product, BuildContext context, List<File?> images) async {
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
      throw Exception('Failed to update product: ${response.statusCode}');
    }
  }

  static Future<void> deleteProduct(String productId, BuildContext context) async {
    final String url = '$HTTPS/api/products/delete?productId=$productId';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 200) {
      Functions.showSnackBar('Product successfully deleted', context);
    }
    else {
      throw Exception('Failed to update product: ${response.statusCode}');
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyNavigationBar(initialScreenIndex: 1)),
    );
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

  static Future<List<String>> fetchProductUrlList(String productId) async {
    final response = await http.get(
      Uri.parse('$HTTPS/api/products/get_product_image_list?productId=$productId'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> dynamicList = json.decode(response.body);
      final List<String> urlList = List<String>.from(dynamicList); 
      return urlList;
    } else {
      throw Exception('Failed to load product urlList: ${response.statusCode}');
    }
  }


}