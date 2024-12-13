import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:punk/supplies/app_colors.dart';
import '../../../services/ProductService.dart';
import '../../../common_functions/Functions.dart';
import '../../../../clases/Product.dart';
import '../../../widgets/barWidgets/MyNavigationBarWidget.dart';

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
  bool isLoading = true;
  Product product;
  _EditProductMediaScreenState({required this.product});

  @override
  void initState() {
    super.initState();
    _loadExistingImages();
  }

  Future<void> _loadExistingImages() async {
    try {
      List<String> fetchedUrls = await ProductService.fetchProductUrlList(product.productID);
      setState(() {
        existingImageUrls = fetchedUrls;
      });
      for (int i = 0; i < existingImageUrls.length; ++i) {
        File file = await Functions.urlToFile(existingImageUrls[i]);
        int index = 0;
        int j = 0;
        while(file.path[j+1] != '.') { ++j; } // set index from filenames for valid order
        if (file.path[j] != 'p') { index = int.parse(file.path[j]); }
        newImages[index] = file;
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      Functions.showSnackBar('Error loading images: $e', context);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        String customFileName;
        if (index == 0) {
          customFileName = 'envelop.jpg';
        } else {
          customFileName = '$index.jpg';
        }
        File customFile = File(pickedFile.path).renameSync(pickedFile.path.replaceAll(pickedFile.name, customFileName));
        newImages[index] = customFile;
      });
    }
  }

  Future<void> _updateProduct() async {
    try {
      List<File?> imagesToSend = [...newImages.where((image) => image != null)];
      await ProductService.updateProduct(
        product.productID,
        product,
        context,
        imagesToSend,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyNavigationBar(initialScreenIndex: 1)),
      );
    } catch (e) {
      Functions.showSnackBar('Error updating product: $e', context);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Edit Media',style: TextStyle(color: AppColors.primaryText),),
        backgroundColor: AppColors.accent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.icons,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Edit Images (up to 10)', style: TextStyle(fontSize: 16, color: AppColors.primaryText)),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
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
                      border: Border.all(color: AppColors.accentBackground),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: newImages[index] != null
                        ? Image.file(newImages[index]!, fit: BoxFit.cover)
                        : const Icon(Icons.add),
                  ),
                );
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: _updateProduct,
              child: const Text('Save Changes', style: TextStyle(color: AppColors.primaryText),),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryText,
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

