import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../clases/Product.dart';
import '../cardWidgets/ProductCardWidget.dart';

class ProductsContent extends StatelessWidget {
  final bool isLoading;
  final String errorMessage;
  final List<Product> products;

  const ProductsContent({
    required this.isLoading,
    required this.errorMessage,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (errorMessage.isNotEmpty) {
      return Center(child: Text(errorMessage));
    } else if (products.isEmpty) {
      return Center(child: Text('No products found'));
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              photoUrl: product.photoUrl,
              title: product.title,
              price: product.price,
              owner: product.ownerName,
              description: product.description,
              productID: product.productID,
              //userID: product.userID,
              onAddToCart: () {  },
              onAddToWishlist: () {  },
              isInWishlist: false,
            );
          },
        ),
      );
    }
  }
}
