import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../clases/Product.dart';
import '../../../../common_functions/Functions.dart';
import '../../../../services/ProductService.dart';
import '../../../../supplies/app_colors.dart';
import '../../../../widgets/barWidgets/MyNavigationBarWidget.dart';

class AddProductMediaScreen extends StatefulWidget {
  final Product product;

  AddProductMediaScreen({required this.product});

  @override
  _AddProductMediaScreenState createState() => _AddProductMediaScreenState(product: product);
}

class _AddProductMediaScreenState extends State<AddProductMediaScreen> {
  final int _maxImages = 10;
  List<File?> _productImages = List<File?>.filled(11, null); // Index 0 for cover image
  List<File?> displayImages = List<File?>.filled(10, null);
  final ImagePicker _picker = ImagePicker();
  Product product;
  _AddProductMediaScreenState({required this.product});

  @override
  void initState() {
    super.initState();

    _productImages = List<File?>.filled(_maxImages, null);
    displayImages = List<File?>.filled(10, null);
    _clearSuppliesFolder();
  }

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

  Future<void> _clearSuppliesFolder() async {
    final directory = Directory('${Directory.current.path}/supplies');
    if (directory.existsSync()) {
      try {
        for (var file in directory.listSync()) {
          if (file is File) {
            file.deleteSync();
          }
        }
        debugPrint('Supplies folder cleared');
      } catch (e) {
        Functions.showSnackBar('Error clearing folder: $e', context);
      }
    }
    setState(() {
      _productImages = List<File?>.filled(_maxImages, null);
      displayImages = List<File?>.filled(10, null);
    });
  }
  Future<void> _pickImage(int index) async {

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      try {
        setState(() {
          displayImages[index] = File(pickedFile.path);
        });
        final directory = Directory('${Directory.current.path}/supplies');
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }

        final customFileName = index == 0 ? 'envelop.jpg' : '$index.jpg';
        final customFilePath = '${directory.path}/$customFileName';

          final existingFile = File(customFilePath);
          if (existingFile.existsSync()) {
            existingFile.deleteSync();
          }
          final copiedFile = await File(pickedFile.path).copy(customFilePath);

          setState(() {
            _productImages[index] = copiedFile;
            //displayImages[index] = File(copiedFile.path);
          });

      } catch (e) {
        Functions.showSnackBar('Error copying image: $e', context);
      }
    }
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
                    child: displayImages.length > index && displayImages[index] != null
                        ? Image.file(displayImages[index]!, fit: BoxFit.cover)
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