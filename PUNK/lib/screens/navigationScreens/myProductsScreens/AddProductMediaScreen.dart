import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:punk/Global/Global.dart';
import '../../../../clases/Product.dart';
import 'package:http_parser/http_parser.dart';
import '../../../Online/Online.dart';

class AddProductMediaScreen extends StatefulWidget {
  final Product product;

  AddProductMediaScreen({required this.product});

  @override
  _AddProductMediaScreenState createState() => _AddProductMediaScreenState(product: product);
}

class _AddProductMediaScreenState extends State<AddProductMediaScreen> {
  final int _maxImages = 10;
  List<File?> _productImages = List<File?>.filled(11, null); // Index 0 for cover image
  final ImagePicker _picker = ImagePicker();
  Product product;

  _AddProductMediaScreenState({required this.product});

  // Send product data and images to the server
  Future<void> _sendProduct(Product product, List<File?> images) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$HTTPS/api/products/create'));

      request.fields['product'] = jsonEncode(product.toJson());

      // Add multiple image files if available
      for (var i = 0; i < images.length; i++) {
        var image = images[i];
        if (image != null) {
          // Determine the MIME type based on the file extension
          String mimeType = 'image/jpeg'; // Default to JPEG
          if (image.path.endsWith('.png')) {
            mimeType = 'image/png';
          }

          // Add the image file to the multipart request
          request.files.add(
            await http.MultipartFile.fromPath(
              'images',  // The field name the server expects
              image.path,
              contentType: MediaType('image', mimeType.split('/')[1]), // Set the correct MIME type
            ),
          );
        }
      }

      // Send the request and handle the response
      var response = await request.send();
      var responseString = await response.stream.bytesToString();

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

      // Navigate back after successful submission
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      // Catch any exceptions and display error message
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error creating product')),
      );
    }
  }

  // Pick an image from the gallery
  Future<void> _pickImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        String customFileName;
        if(index == 0){
          customFileName = 'envelop.jpg';
        } else {
          customFileName = '${index}.jpg';
        }
        File customFile = File(pickedFile.path).renameSync(pickedFile.path.replaceAll(pickedFile.name, customFileName));
        if (index >= 0 && index < _productImages.length) {
          _productImages[index] = customFile;
        } else {
          _productImages.add(customFile);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
