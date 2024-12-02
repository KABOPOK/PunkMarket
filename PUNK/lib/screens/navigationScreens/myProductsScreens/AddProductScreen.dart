import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:punk/Online/Online.dart';
import 'package:punk/screens/navigationScreens/myProductsScreens/AddProductMediaScreen.dart';
import 'package:punk/clases/Product.dart';
import 'package:punk/common_functions/Functions.dart';

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
      appBar: AppBar(
        title: const Text(
          'Add Product',
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
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
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
                  child: Text(category),
                  value: category,
                );
              }).toList(),
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
              onPressed: _addProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              child: const Text(
                'Add Media',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
