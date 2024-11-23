import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/cupertino.dart';
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
        Functions.showSnackBar('Product created successfully', context);
      }
      //var responseString = await response.stream.bytesToString();;
  }
  static Future<void> updateProduct(
      String productId,
      Map<String, dynamic> productDTO,
      BuildContext context,
      List<File?> images,
      ) async {
    final uri = Uri.parse('$HTTPS/api/products/update?productId=$productId');
    final request = http.MultipartRequest('PUT', uri);

    // Add product data
    request.fields.addAll(productDTO.map((key, value) => MapEntry(key, value.toString())));

    // Add images
    for (var image in images) {
      if (image != null) {
        final stream = http.ByteStream(image.openRead());
        final length = await image.length();
        final multipartFile = http.MultipartFile('images', stream, length, filename: image.path.split('/').last);
        request.files.add(multipartFile);
      }
    }

    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
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
  static Future<List<Product>> fetchWishlistProducts(int page, int limit) async {
    final userId = Online.user.userID;
    final productId = Online.user.userID;
    List<Product> products = [];
    final response = await http.get(
      Uri.parse('$HTTPS/api/products/get_fav_products?userId=$userId&productId=$productId&page=$page&limit=$limit'),
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
  static Future<List<Product>> fetchProducts(int page, int limit) async {
    final userId = Online.user.userID;
    List<Product> products = [];
    final response = await http.get(
      Uri.parse('$HTTPS/api/products/get_products?page=$page&limit=$limit'),
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