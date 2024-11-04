import 'package:flutter/material.dart';
import 'package:punk/widgets/cardWidgets/WishlistCardWidget.dart'; // Import the ProductCard widget
import '../../../supplies/product_list.dart'; // Import the ProductCard widget

class WishListPage extends StatelessWidget {

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
