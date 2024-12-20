import 'package:flutter/material.dart';
import 'package:punk/services/ProductService.dart';

import '../../clases/Product.dart';
import '../../screens/navigationScreens/myProductsScreens/EditProduct/EditProduct.dart';
import '../../supplies/app_colors.dart';

class MyProduct extends StatefulWidget {
  final String photoUrl;
  final String title;
  final String price;
  final String owner;
  final String description;
  final String productID;
  final String userID;
  final bool isSold;

  const MyProduct({
    Key? key,
    required this.photoUrl,
    required this.title,
    required this.price,
    required this.owner,
    required this.description,
    required this.productID,
    required this.userID,
    required this.isSold,
  }) : super(key: key);

  @override
  _MyProductState createState() => _MyProductState();
}

class _MyProductState extends State<MyProduct> {
  Future<bool> _handleMenuSelection(String choice, String productId, BuildContext context) async {
    switch (choice) {
      case 'edit':
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductEditingScreen(
              product: Product(
                productID: widget.productID,
                title: widget.title,
                price: widget.price,
                ownerName: widget.owner,
                description: widget.description,
                userID: widget.userID,
                photoUrl: widget.photoUrl,
                location: '', // Add actual location if available
              ),
            ),
          ),
        );
        return result == true;

      case 'sell':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product moved to sold')),
        );
        break;
      case 'delete':
        _confirmDelete(productId, context);
        break;
    }
    return false;
  }

  void _confirmDelete(String productId, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.secondaryBackground,
          title: const Text('Подтверждение удаления', style: TextStyle(color: AppColors.primaryText)),
          content: const Text('Вы точно хотите удалить этот товар?', style: TextStyle(color: AppColors.primaryText)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text('Нет', style: TextStyle(color: AppColors.primaryText)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ProductService.deleteProduct(productId, context);
                setState(() {}); // Ensure UI updates after deletion
              },
              child: const Text('Да', style: TextStyle(color: AppColors.primaryText)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenWidth * 0.5;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: AppColors.secondaryBackground,
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  widget.photoUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: imageHeight,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: widget.isSold
                    ? Container() // Display nothing if the product is sold
                    : PopupMenuButton<String>(
                  color: AppColors.secondaryBackground,
                  icon: const Icon(
                    Icons.more_horiz_rounded,
                    color: AppColors.icons,
                  ),
                  onSelected: (choice) async {
                    final result = await _handleMenuSelection(choice, widget.productID, context);
                    if (result) {
                      setState(() {}); // Trigger UI update if necessary
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Редактировать', style: TextStyle(color: AppColors.primaryText)),
                    ),
                    const PopupMenuItem<String>(
                      value: 'sell',
                      child: Text('Архивировать', style: TextStyle(color: AppColors.primaryText)),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Удалить', style: TextStyle(color: AppColors.primaryText)),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.priceTag,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.price,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  widget.owner,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.secondaryText,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
