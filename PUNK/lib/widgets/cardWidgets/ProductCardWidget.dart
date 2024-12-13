import 'package:flutter/material.dart';

import '../../services/UserService.dart';
class ProductCard extends StatefulWidget {
  final String productID;
  final String photoUrl;
  final String title;
  final String price;
  final String owner;
  final String description;
  final VoidCallback onAddToCart;
  final VoidCallback onAddToWishlist;

  const ProductCard({
    Key? key,
    required this.productID,
    required this.photoUrl,
    required this.title,
    required this.price,
    required this.owner,
    required this.description,
    required this.onAddToCart,
    required this.onAddToWishlist,
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isInWishlist = false; // Tracks if the product is in the wishlist
  int _page = 1;
  final int _limit = 20;

  @override
  void initState() {
    super.initState();
    _checkWishlistStatus();
  }

  Future<void> _checkWishlistStatus() async {

    try {
      final wishlistProductIDs = await UserService.fetchWishlistProducts(_page, _limit);
      setState(() {
        _isInWishlist = wishlistProductIDs.contains(widget.productID);
      });
    } catch (error) {
      // Handle error gracefully (e.g., show a toast or log the error)
      print("Error fetching wishlist: $error");
    }
  }

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
                  widget.photoUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: imageHeight, // Dynamic height based on screen size
                ),
              ),
              // Wishlist Icon
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: widget.onAddToWishlist,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      _isInWishlist ? Icons.favorite : Icons.favorite_border, // Filled or outlined heart
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
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
                    widget.price,
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
                    onPressed: widget.onAddToCart,
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text("Add to Cart"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Content below the image
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  widget.owner,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}