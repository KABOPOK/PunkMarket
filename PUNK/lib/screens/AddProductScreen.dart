import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this for input formatter
import 'package:punk/screens/AddProductMediaScreen.dart';
import 'package:punk/screens/MyProductListScreen.dart';

class ProductAdditionScreen extends StatefulWidget {
  @override
  _ProductAdditionScreenState createState() => _ProductAdditionScreenState();
}

class _ProductAdditionScreenState extends State<ProductAdditionScreen> {
  String? selectedCategory;
  String? selectedPaymentMethod;
  bool isNegotiable = false;
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Добавление товара',
          style: TextStyle(
            color: Colors.white, // Set text color to white
            fontWeight: FontWeight.bold, // Set text to bold
          ),
        ),
        backgroundColor: Colors.orange, // Set AppBar color to orange
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Make the icon white too
          onPressed: () {
            Navigator.pop(context); // Return to the previous screen
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
                const TextField(
                  decoration: InputDecoration(
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
                    FilteringTextInputFormatter.singleLineFormatter,
                    // Custom logic to enforce max 1,000,000
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      if (newValue.text.isEmpty) {
                        return newValue;
                      }
                      final intValue = int.tryParse(newValue.text) ?? 0;
                      if (intValue > 1000000) {
                        return oldValue; // If greater than 1,000,000, keep old value
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
                      fillColor: Colors.orange, // Orange background when selected
                      selectedColor: Colors.white, // White text on orange background
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'да',
                            style: TextStyle(
                              color: isNegotiable ? Colors.white : Colors.black, // White text if selected
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'нет',
                            style: TextStyle(
                              color: !isNegotiable ? Colors.white : Colors.black, // White text if selected
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Адрес Input
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Адрес',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                // Описание Input (align label to top)
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Описание', // aligned label
                    alignLabelWithHint: true, // This aligns the label to the top
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 10, // increased max lines for larger text field
                ),
                const SizedBox(height: 80), // Added space to prevent overlap with button
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddProductMediaScreen()), // Example: navigate to AddProductScreen
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Set button color to orange
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                child: const Text(
                  'Добавить медиа',
                  style: TextStyle(color: Colors.white, fontSize: 20), // Set button text color to white
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


