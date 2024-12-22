import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:punk/services/UserService.dart';

import '../../Online/Online.dart';
import '../../clases/Product.dart';
import '../cardWidgets/ProductCardWidget.dart';
import '../cardWidgets/WishlistCardWidget.dart';

class WishlistContent extends StatefulWidget {
  final bool isLoading;
  final String errorMessage;
  final List<Product> myProducts;
  final Function(Product) onProductTap;
  List<String> wishlistProductIDs;


  WishlistContent({
    required this.isLoading,
    required this.errorMessage,
    required this.myProducts,
    required this.onProductTap,
    required this.wishlistProductIDs,
  });

  @override
  _WishlistContentState createState() => _WishlistContentState();
}

class _WishlistContentState extends State<WishlistContent> {

  Future<void> _addToWishlist(String productID) async {
    try {
      final result = await UserService.saveToWishlist(Online.user.userID,productID);

      setState(() {
        if (widget.wishlistProductIDs.contains(productID)) {
          widget.wishlistProductIDs.remove(productID);
        } else {
          widget.wishlistProductIDs.add(productID);
        }
      });
    } catch (e) {
      print('Error saving to wishlist: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (widget.errorMessage.isNotEmpty) {
      return Center(child: Text(widget.errorMessage));
    } else if (widget.myProducts.isEmpty) {
      return Center(child: Text('No wishlist items found'));
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: widget.myProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final product = widget.myProducts[index];
            final isInWishlist = widget.wishlistProductIDs.contains(product.productID);
            return GestureDetector(
              onTap: () => widget.onProductTap(product),
              child: ProductCard(
                productID: product.productID,
                photoUrl: product.photoUrl,
                title: product.title,
                price: product.price,
                owner: product.ownerName,
                description: product.description,
                onAddToCart: () {},
                onAddToWishlist: () {
                  if (Online.user.userID == null) {
                    print("User ID is null");
                  } else if (product.productID == null) {
                    print("Product ID is null");
                  } else {
                    _addToWishlist(product.productID);
                  }
                },
                isInWishlist: isInWishlist,
              ),
            );
          },
        ),
      );
    }
  }
}
