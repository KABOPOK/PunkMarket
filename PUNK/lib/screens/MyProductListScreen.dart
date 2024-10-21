import 'package:flutter/material.dart';
import 'package:punk/widgets/MyProductWidget.dart';
import 'package:punk/supplies/product_list.dart';
import 'package:punk/widgets/MyNavigationBarWidget.dart'; // Import your custom navigation bar

class MyProductListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "МОИ ТОВАРЫ",
          style: TextStyle(color: Colors.orange), // Set AppBar title color to orange
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.orange), // Search icon
            onPressed: () {
              // Handle search action
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.orange), // Filter icon
            onPressed: () {
              // Handle filter action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.75, // Adjust to control card size
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return MyProduct(
              photoUrl: product["imageUrl"],
              title: product["title"],
              price: product["price"],
              owner: product["owner"],
            );
          },
        ),
      ),
    );
  }
}
