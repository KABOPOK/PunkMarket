import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this for input formatter
import 'package:punk/Online/Online.dart';
import 'package:punk/screens/navigationScreens/myProductsScreens/AddProductMediaScreen.dart';
import 'package:punk/clases/Product.dart';

class ProductAdditionScreen extends StatefulWidget {
  @override
  _ProductAdditionScreenState createState() => _ProductAdditionScreenState();
}

class _ProductAdditionScreenState extends State<ProductAdditionScreen> {
  String? selectedCategory;
  String? selectedPaymentMethod;
  bool isNegotiable = false;
  final Product product = Product();

  final TextEditingController priceController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the widget tree
    priceController.dispose();
    productNameController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _addProduct() {
    if (productNameController.text.isEmpty ||
        selectedCategory == null ||
        priceController.text.isEmpty ||
        selectedPaymentMethod == null ||
        addressController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      // Show a snackbar or alert if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, заполните все поля')),
      );
      return;
    }

    // Setting product properties
    product.title = productNameController.text;
    product.ownerName = Online.user.userName;
    product.category = selectedCategory!;
    product.price = priceController.text; // Assuming price is stored as a String
    product.location = addressController.text;
    product.description = descriptionController.text;
    product.userID = Online.user.userID;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProductMediaScreen(product: product)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Добавление товара',
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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Название товара input
                TextField(
                  controller: productNameController,
                  decoration: const InputDecoration(
                    labelText: 'Наименование товара',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                // Категория Dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Категория',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedCategory,
                  onChanged: (newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                  items: ['Category 1', 'Category 2', 'Category 3']
                      .map((category) {
                    return DropdownMenuItem(
                      child: Text(category),
                      value: category,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),

                // Цена Input (Only numbers, max 1,000,000)
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Цена, Р',
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
                        return oldValue; // Keep old value if greater than 1,000,000
                      }
                      return newValue; // Otherwise, update value
                    })
                  ],
                ),
                const SizedBox(height: 10),

                // Способ оплаты Dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Способ оплаты',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedPaymentMethod,
                  onChanged: (newValue) {
                    setState(() {
                      selectedPaymentMethod = newValue;
                    });
                  },
                  items: ['Payment Method 1', 'Payment Method 2']
                      .map((method) {
                    return DropdownMenuItem(
                      child: Text(method),
                      value: method,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),

                // Торг toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Торг"),
                    ToggleButtons(
                      isSelected: [isNegotiable, !isNegotiable],
                      onPressed: (index) {
                        setState(() {
                          isNegotiable = index == 0;
                        });
                      },
                      fillColor: Colors.orange,
                      selectedColor: Colors.white,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'да',
                            style: TextStyle(
                              color: isNegotiable ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'нет',
                            style: TextStyle(
                              color: !isNegotiable ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Адрес Input
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Адрес',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                // Описание Input (align label to top)
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Описание',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 10,
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
          // Positioned "Добавить медиа" button at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(50.0),
              color: Colors.transparent,
              child: ElevatedButton(
                onPressed: _addProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                child: const Text(
                  'Добавить медиа',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}