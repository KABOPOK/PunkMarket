import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../clases/Product.dart';
import '../../../common_functions/Functions.dart';
import '../../../services/ProductService.dart';
import '../../../supplies/app_colors.dart';
import '../../../widgets/barWidgets/MyNavigationBarWidget.dart';

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

  Future<void> _sendProduct(Product product, List<File?> images) async {
    try {
      ProductService.sendProduct(product, images, context) ;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyNavigationBar(initialScreenIndex: 1)),
      );
    } catch (e) {
      Functions.showSnackBar('Error creating product', context);
    }
  }

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
        _productImages[index] = customFile;
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Add Media', style: TextStyle(color: AppColors.primaryText),),
        backgroundColor: AppColors.accent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.icons,),
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
            child: Text('Add Images (up to 10)', style: TextStyle(fontSize: 16, color: AppColors.primaryText)),
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
              child: const Text('Create Product',style: TextStyle(color: AppColors.primaryText),),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}