import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:punk/Online/Online.dart';
import 'package:punk/screens/navigationScreens/myProductsScreens/MyProductListScreen.dart';
import 'package:punk/Global/Global.dart';
import '../../../../clases/Product.dart';

class AddProductMediaScreen extends StatefulWidget {
  Product product;

  AddProductMediaScreen({required this.product});
  @override
  _AddProductMediaScreenState createState() => _AddProductMediaScreenState(product:product);
}

class _AddProductMediaScreenState extends State<AddProductMediaScreen> {
  final int _maxImages = 10;
  List<File?> _productImages = [];
  String? _coverImage;
  Product product;

  _AddProductMediaScreenState({required this.product});

  final ImagePicker _picker = ImagePicker();
  Future<void> _sendProduct(Product product, List<File?> images, BuildContext context) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$HTTPS/create-product'));

      // Add form fields
      request.fields['product'] = jsonEncode(product.toJson());

      // Add multiple image files if available
      for (var image in images) {
        if (image != null) {
          request.files.add(await http.MultipartFile.fromPath('images[]', image.path));
        }
      }

      // Send the request
      var response = await request.send();

      // Get the response
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
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error creating product')),
      );
    }
  }


  Future<void> _pickImage(bool isEnvelop, int number) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        // Define the new file name
        String newFileName;
        if (isEnvelop == true) {
          newFileName = '${Online.user.userID}_envelop.jpg';
        } else {
          newFileName = '${Online.user.userID}_${number}.jpg';
        }

        // Generate the new path for the image
        String newPath = '${pickedFile.path.substring(0, pickedFile.path.lastIndexOf('/'))}/$newFileName';

        // Replace or add the image at the correct index
        if (number >= 0 && number < _productImages.length) {
          _productImages[number] = File(newPath);
        } else {
          _productImages.add(File(newPath));
        }

        // Save the picked file with the new name
        pickedFile.saveTo(newPath);
      } else {
        print('No image selected.');
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Добавление товара',
          style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        ),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Return to the previous screen
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Изображения от 1 до 10 фото',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'от 1 до 10 фото',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    // Image Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _maxImages,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _pickImage(false, index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: _productImages.length > index && _productImages[index] != null
                                ? Image.file(_productImages[index]!,
                                fit: BoxFit.cover) // Show selected image
                                : Icon(Icons.add), // Show 'add' icon if no image selected
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Обложка',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    // Cover Image Selector
                    GestureDetector(
                      onTap: () {
                        _pickImage(true, -1);
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.add),
                      ),
                    ),
                    SizedBox(height: 20), // Add some space above the button
                    // Create Product Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _sendProduct(product,_productImages,context);
                          //Navigator.pop(context);
                          //Navigator.pop(context); // Return to the MyProductsScreen
                        },
                        child: Text('Создать товар'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
