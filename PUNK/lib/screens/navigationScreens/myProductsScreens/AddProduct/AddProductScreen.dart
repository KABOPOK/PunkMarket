import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:punk/Online/Online.dart';
import 'package:punk/clases/Product.dart';
import 'package:punk/common_functions/Functions.dart';
import 'package:punk/screens/navigationScreens/myProductsScreens/AddProduct/AddProductMediaScreen.dart';

import '../../../../supplies/app_colors.dart';

class ProductAdditionScreen extends StatefulWidget {
  @override
  _ProductAdditionScreenState createState() => _ProductAdditionScreenState();
}

class _ProductAdditionScreenState extends State<ProductAdditionScreen> {
  String? selectedCategory;
  bool isNegotiable = false;
  final Product product = Product();

  final TextEditingController priceController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isValid(){
    if (productNameController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      Functions.showSnackBar('Please fill out all fields', context);
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    priceController.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _addProduct() {
    if(!isValid()){
      return;
    }
    product.title = productNameController.text;
    product.ownerName = Online.user.userName;
    if(selectedCategory!= null){product.category = selectedCategory!;}
    product.price = priceController.text;
    product.description = descriptionController.text;
    product.userID = Online.user.userID;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductMediaScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text(
          'Add Product',
          style: TextStyle(color: AppColors.primaryText, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.accent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.icons),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: productNameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(),
                fillColor: AppColors.secondaryBackground,
              ),
              style: TextStyle(color: AppColors.primaryText),

            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              dropdownColor: AppColors.secondaryBackground,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                fillColor: AppColors.secondaryBackground,
              ),
              value: selectedCategory,
              onChanged: (newValue) {
                setState(() {
                  selectedCategory = newValue;
                });
              },
              items: ['Electronics', 'Clothing', 'Furniture']
                  .map((category) {
                return DropdownMenuItem(
                  child: Text(
                    category,
                    style: const TextStyle(color: AppColors.primaryText),
                ),

                  value: category,
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                fillColor: AppColors.secondaryBackground,
                labelText: 'Price',
                border: OutlineInputBorder(),

              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TextInputFormatter.withFunction((oldValue, newValue) {
                  if (newValue.text.isEmpty) {
                    return newValue;
                  }
                  final intValue = int.tryParse(newValue.text) ?? 0;
                  if (intValue > 1000000) {
                    return oldValue;
                  }
                  return newValue;
                })
              ],
              style: TextStyle(color: AppColors.primaryText),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
                fillColor: AppColors.secondaryBackground,

              ),
              style: TextStyle(color: AppColors.primaryText),
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              child: const Text(
                'Add Media',
                style: TextStyle(color: AppColors.primaryText, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}