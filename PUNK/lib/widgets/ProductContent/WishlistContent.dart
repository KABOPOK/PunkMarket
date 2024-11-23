import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:punk/services/UserService.dart';

import '../../clases/Product.dart';
import '../cardWidgets/WishlistCardWidget.dart';

class WishlistContent extends StatelessWidget {
  final bool isLoading;
  final String errorMessage;
  final List<Product> myProducts;

  const WishlistContent({
    required this.isLoading,
    required this.errorMessage,
    required this.myProducts,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (errorMessage.isNotEmpty) {
      return Center(child: Text(errorMessage));
    } else if (myProducts.isEmpty) {
      return Center(child: Text('No wishlist items found'));
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: myProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final product = myProducts[index];
            return WishlistCard(
              productID: product.productID,
              photoUrl: product.photoUrl,
              title: product.title,
              price: product.price,
              owner: product.ownerName,
              description: product.description,
              onAddToCart: () {},
              onAddToWishlist: () {},
            );
          },
        ),
      );
    }
  }
}
