import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:punk/supplies/app_colors.dart';
import '../../../../services/ProductService.dart';
import '../../../../common_functions/Functions.dart';
import '../../../../../clases/Product.dart';
import '../../../../widgets/barWidgets/MyNavigationBarWidget.dart';

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
  List<File?> displayImages = List<File?>.filled(10, null);
  bool isLoading = true;
  Product product;
  _EditProductMediaScreenState({required this.product});

  @override
  void initState() {
    super.initState();
    newImages = List<File?>.filled(_maxImages, null);
    displayImages = List<File?>.filled(10, null);
    _loadExistingImages();
  }

  Future<void> _pickImage(int index) async {

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      try {
        // Get project directory
        final directory = Directory('${Directory.current.path}/supplies');
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }

        // Define custom file name and path
        final customFileName = index == 0 ? 'envelop.jpg' : '$index.jpg';
        final customFilePath = '${directory.path}/$customFileName';

        // Delete existing file at the target path (if any)
        final existingFile = File(customFilePath);
        if (existingFile.existsSync()) {
          existingFile.deleteSync();
        }

        // Copy the picked file to the target path
        final copiedFile = await File(pickedFile.path).copy(customFilePath);

        // Update the image list and UI
        setState(() {
          newImages[index] = copiedFile;
          displayImages[index] = File(pickedFile.path);
        });

        // Log the updated file path
        debugPrint('Image copied to: ${copiedFile.path}');
      } catch (e) {
        Functions.showSnackBar('Error copying image: $e', context);
      }
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
    // Reset in-memory state
    setState(() {
      newImages = List<File?>.filled(_maxImages, null);
      displayImages = List<File?>.filled(10, null);
    });
  }

  Future<void> _loadExistingImages() async {
    try {
      await _clearSuppliesFolder();

      newImages = List<File?>.filled(_maxImages, null);
      displayImages = List<File?>.filled(10, null);
      List<String> fetchedUrls = await ProductService.fetchProductUrlList(product.productID);
      final directory = Directory('${Directory.current.path}/supplies');

      setState(() {
        existingImageUrls = fetchedUrls;
      });

      for (int i = 0; i < existingImageUrls.length; ++i) {
        File file = await Functions.urlToFile(existingImageUrls[i]);
        final copiedFile = await file.copy('${directory.path}/${product.productID}_$i.jpg');
        setState(() {
          newImages[i] = copiedFile;
          displayImages[i] = copiedFile;
        });
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
                    child: displayImages[index] != null
                        ? Image.file(displayImages[index]!, fit: BoxFit.cover)
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
