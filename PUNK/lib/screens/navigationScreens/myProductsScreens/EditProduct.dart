import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:punk/clases/Product.dart';
import '../../../Online/Online.dart';
import '../../../services/ProductService.dart';
import 'EditProductMedia.dart';

class ProductEditingScreen extends StatefulWidget {
  final Product product;

  ProductEditingScreen({Key? key, required this.product}) : super(key: key);

  @override
  _ProductEditingScreenState createState() => _ProductEditingScreenState(product: product);
}

class _ProductEditingScreenState extends State<ProductEditingScreen> {
  late TextEditingController productNameController;
  late TextEditingController priceController;
  late TextEditingController addressController;
  late TextEditingController descriptionController;

  Product product;

  _ProductEditingScreenState({required this.product});

  @override
  void initState() {
    super.initState();
    productNameController = TextEditingController(text: product.title ?? '');
    priceController = TextEditingController(text: product.price ?? '');
    addressController = TextEditingController(text: product.location ?? '');
    descriptionController = TextEditingController(text: product.description ?? '');
  }

  @override
  void dispose() {
    productNameController.dispose();
    priceController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _updateProduct() {
    if (productNameController.text.isEmpty ||
        priceController.text.isEmpty ||
        addressController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    // Update product details
    product.title = productNameController.text;
    product.price = priceController.text;
    product.location = addressController.text;
    product.description = descriptionController.text;
    product.userID = Online.user.userID;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductMediaScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Product',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
