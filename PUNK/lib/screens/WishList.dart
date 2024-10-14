import 'package:flutter/material.dart';
import 'package:punk/widgets/WishlistCard.dart'; // Import the ProductCard widget

class WishListPage extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {
      "imageUrl": "https://i.pinimg.com/736x/00/96/27/0096275511c7269eec7b77ce532b2c65.jpg",
      "title": "Product 1",
      "price": 29.99,
      "owner": "Скуф", // Add owner info here
    },
    {
      "imageUrl": "https://i.pinimg.com/564x/d6/a8/71/d6a8718dbc866678d23a432c6b084302.jpg",
      "title": "Product 2",
      "price": 99.99,
      "owner": "Альтушка", // Add owner info here
    },
    {
      "imageUrl": "https://i.pinimg.com/564x/7e/c9/89/7ec9891356b3d5cd037649400262969a.jpg",
      "title": "Product 3",
      "price": 59.99,
      "owner": "Том Бой", // Add owner info here
    },{
      "imageUrl": "https://i.pinimg.com/564x/78/2d/89/782d89e3ad8b7996c30a8a90d0dd6209.jpg",
      "title": "Product 4",
      "price": 10.99,
      "owner": "Real Life", // Add owner info here
    },
    // Add more products here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Marketplace"),
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
            return WishlistCard(
              photoUrl: product["imageUrl"],
              title: product["title"],
              price: product["price"],
              owner: product["owner"], // Pass owner to the product card
              onAddToCart: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product["title"]} added to cart!'),
                  ),
                );
              },
              onAddToWishlist: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product["title"]} added to wishlist!'),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
