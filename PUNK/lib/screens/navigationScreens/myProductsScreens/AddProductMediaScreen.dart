import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:punk/Global/Global.dart';
import '../../../../clases/Product.dart';

class AddProductMediaScreen extends StatefulWidget {
  final Product product;

  AddProductMediaScreen({required this.product});

  @override
  _AddProductMediaScreenState createState() => _AddProductMediaScreenState();
}

class _AddProductMediaScreenState extends State<AddProductMediaScreen> {
  final int _maxImages = 10;
  List<File?> _productImages = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _sendProduct(Product product, List<File?> images) async {
    try {
      // Create a multipart request to the specified endpoint
      var request = http.MultipartRequest('POST', Uri.parse('$HTTPS/api/get_products/create'));
      // Add product data as a JSON string to the request fields
      request.fields['product'] = jsonEncode(product.toJson());

      for (var image in images) {
        if (image != null) {
          request.files.add(await http.MultipartFile.fromPath('images', image.path));
        }
      }
      // Send the request and get the response
      var response = await request.send();
      var responseString = await response.stream.bytesToString();

      // Handle the response
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product created successfully')),
        );
      } else {
        final errorData = json.decode(responseString);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorData['error'] ?? 'Unknown error')),
        );
      }
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      // Catch and log any exceptions
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error creating product')),
      );
    }
  }

  Future<void> _pickImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        // Define the new file name
        if (index >= 0 && index < _productImages.length) {
          _productImages[index] = File(pickedFile.path);
        } else {
          _productImages.add(File(pickedFile.path));
        }
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Media'),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Add Images (up to 10)', style: TextStyle(fontSize: 16)),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _maxImages,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _pickImage(index),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _productImages.length > index && _productImages[index] != null
                        ? Image.file(_productImages[index]!, fit: BoxFit.cover)
                        : const Icon(Icons.add),
                  ),
                );
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () => _sendProduct(widget.product, _productImages),
              child: const Text('Create Product'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
