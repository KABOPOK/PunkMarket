import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String photoUrl;
  final String title;
  final String price;
  final String owner;
  final VoidCallback onAddToCart;
  final VoidCallback onAddToWishlist;

  const ProductCard({
    Key? key,
    required this.photoUrl,
    required this.title,
    required this.price,
    required this.owner,
    required this.onAddToCart,
    required this.onAddToWishlist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            child: ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                photoUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  owner,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Add to Cart and Wishlist buttons as a Row (two columns)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Add to Cart button
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      color: Colors.blue,
                      onPressed: onAddToCart,
                    ),
                    // Add to Wishlist button
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      color: Colors.red,
                      onPressed: onAddToWishlist,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}