import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../Global/Global.dart';
import '../clases/Product.dart';

class MyProduct extends StatelessWidget {
  final String photoUrl;
  final String title;
  final double price;
  final String owner;

  const MyProduct({
    Key? key,
    required this.photoUrl,
    required this.title,
    required this.price,
    required this.owner,
  }) : super(key: key);

  Future<void> _sendProduct(Product product, File? image,
      BuildContext context /*for show message about product sending*/) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$HTTPS/create-product'));

      // Add form fields
      request.fields['product'] = jsonEncode(product.toJson());

      // Add image file if available
      if (image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', image!.path));
      }

      // Send the request
      var response = await request.send();

      // get response
      var responseString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully pushed')),
        );
      } else {
        final errorData = json.decode(responseString);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorData['error'] ?? 'Unknown error')),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                photoUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  owner,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
