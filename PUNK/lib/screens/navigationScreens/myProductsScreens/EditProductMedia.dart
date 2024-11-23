import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/ProductService.dart';
import '../../../common_functions/Functions.dart';
import '../../../../clases/Product.dart';

class EditProductMediaScreen extends StatefulWidget {
  final Product product;

  EditProductMediaScreen({required this.product});

  @override
  _EditProductMediaScreenState createState() =>
      _EditProductMediaScreenState(product: product);
}

class _EditProductMediaScreenState extends State<EditProductMediaScreen> {
  final int _maxImages = 10;
  final ImagePicker _picker = ImagePicker();

  List<String> existingImageUrls = [];
  List<File?> newImages = List<File?>.filled(10, null);

  Product product;

  _EditProductMediaScreenState({required this.product});

  @override
  void initState() {
    super.initState();
    existingImageUrls = product.photoUrl != null ? [product.photoUrl!] : [];
  }

  Future<void> _pickImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (pickedFile != null) {
          String customFileName;
          if(index == 0){
            customFileName = 'envelop.jpg';
          } else {
            customFileName = '${index}.jpg';
          }
          File customFile = File(pickedFile.path).renameSync(pickedFile.path.replaceAll(pickedFile.name, customFileName));
          if (index >= 0 && index < newImages.length) {
            newImages[index] = customFile;
          } else {
            newImages.add(customFile);
          }
        } else {
          print('No image selected.');
        }
      });
    }
  }

  Future<void> _removeImage(int index) {
    setState(() {
      newImages[index] = null;
    });
    return Future.value();
  }

  Future<void> _updateProduct() async {
    try {
      // Call the updateProduct service with all data
      await ProductService.updateProduct(
        product.productID,
        product,
        context,
        newImages.where((image) => image != null).toList(),
      );

      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      Functions.showSnackBar('Error updating product: $e', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Edit Media'),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Edit Images (up to 10)', style: TextStyle(fontSize: 16)),
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
                if (index < existingImageUrls.length) {
                  // Show existing image
                  return Stack(
                    children: [
                      GestureDetector(
                        onTap: () => _pickImage(index),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.network(
                            existingImageUrls[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  // Show new images or empty placeholder
                  final newImageIndex = index - existingImageUrls.length;
                  return GestureDetector(
                    onTap: () => _pickImage(newImageIndex),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: newImages[newImageIndex] != null
                          ? Image.file(newImages[newImageIndex]!, fit: BoxFit.cover)
                          : const Icon(Icons.add),
                    ),
                  );
                }
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: _updateProduct,
              child: const Text('Save Changes'),
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
