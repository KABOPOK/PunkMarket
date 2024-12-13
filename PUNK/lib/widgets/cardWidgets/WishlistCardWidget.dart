import 'package:flutter/material.dart';

class WishlistCard extends StatelessWidget {
  final String photoUrl;
  final String title;
  final String price;
  final String owner;
  final String description;
  final VoidCallback onAddToCart;
  final VoidCallback onAddToWishlist;
  final String productID;


  const WishlistCard({
    Key? key,
    required this.photoUrl,
    required this.title,
    required this.price,
    required this.owner,
    required this.description,
    required this.onAddToCart,
    required this.onAddToWishlist,
    required this.productID,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen width to make responsive adjustments
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenWidth * 0.5; // Adjust image height based on screen width

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Product Image with Wishlist and Price Tag
          Stack(
            children: [
              // Product Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  photoUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: imageHeight, // Dynamic height based on screen size
                ),
              ),
              // Price Tag
              Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    price,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Add to cart
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ElevatedButton.icon(
                    onPressed: onAddToCart,
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text("Add to Cart"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      //minimumSize: const Size(double.infinity, 40), // Full width
                    ),
                  ),
                ),
              ),

            ],
          ),
          // Content below the image in a Scrollable Column
          Padding(
            padding: const EdgeInsets.all(10.0),
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
                  owner,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),

              ],
            ),
          ),
          // Add to Cart Button
        ],
      ),
    );
  }
}
