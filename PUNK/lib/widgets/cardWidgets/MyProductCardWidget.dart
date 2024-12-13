import 'package:flutter/material.dart';
import 'package:punk/services/ProductService.dart';

import '../../clases/Product.dart';
import '../../screens/navigationScreens/myProductsScreens/EditProduct.dart';
import '../../supplies/app_colors.dart';

class MyProduct extends StatelessWidget {
  final String photoUrl;
  final String title;
  final String price;
  final String owner;
  final String description;
  final String productID;
  final String userID;

  const MyProduct({
    Key? key,
    required this.photoUrl,
    required this.title,
    required this.price,
    required this.owner,
    required this.description,
    required this.productID,
    required this.userID,
  }) : super(key: key);

  void _handleMenuSelection(String choice, String productId, BuildContext context) {
    switch (choice) {
      case 'edit':
      // Navigate to the Edit Product Screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductEditingScreen(
              product: Product(
                productID: productID,
                title: title,
                price: price,
                ownerName: owner,
                description: description,
                userID: userID,
                photoUrl: photoUrl,
                //category: null, // Use the actual category if available
                location: '', // Use the actual location if available
                //paymentMethod: null, // Use the actual payment method if available
              ),
            ),
          ),
        );
        break;
      case 'reserve':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('RESERVE')),
        );
        break;
      case 'delete':
        _confirmDelete(productId, context);
        break;
    }
  }


  void _confirmDelete(String product, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.secondaryBackground,
          title: const Text('Подтверждение удаления',style: TextStyle(color: AppColors.primaryText),),
          content: const Text('Вы точно хотите удалить этот товар?',style: TextStyle(color: AppColors.primaryText),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Нет', style: TextStyle(color: AppColors.primaryText),),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                ProductService.deleteProduct(product, context); // Call delete
              },
              child: const Text('Да', style: TextStyle(color: AppColors.primaryText),),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenWidth * 0.5; // Adjust image height based on screen width

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
                  photoUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: imageHeight,
                ),
              ),
              // Menu PopUp
              Positioned(
                  top: 10,
                  right: 10,
                  child: PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_horiz_rounded,
                      color: AppColors.icons,
                    ),
                    onSelected: (choice) => _handleMenuSelection(choice, productID, context),
                    itemBuilder: (BuildContext context)=><PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                          value: 'edit',
                          child: Text('Редактировать', style: TextStyle(color: AppColors.primaryText),)
                      ),
                      const PopupMenuItem<String>(
                          value: 'reserve',
                          child: Text('Забронировать', style: TextStyle(color: AppColors.primaryText),)
                      ),
                      const PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Удалить', style: TextStyle(color: AppColors.primaryText),)
                      ),
                    ],
                  )
              ),
              //Price tag
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
                    price,
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
                  title,
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
                  owner,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                      color: AppColors.secondaryText,
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 8),
                // Menu PopUp
                Positioned(
                    top: 10,
                    right: 10,
                    child: PopupMenuButton<String>(
                      color: AppColors.secondaryBackground,
                      icon: const Icon(
                        Icons.more_horiz_rounded,
                        color: AppColors.icons,
                      ),
                      onSelected: (choice) => _handleMenuSelection(choice, productID, context),
                      itemBuilder: (BuildContext context)=><PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                            value: 'edit',
                            child: Text('Редактировать',style: TextStyle(color: AppColors.primaryText),)
                        ),
                        const PopupMenuItem<String>(
                            value: 'reserve',
                            child: Text('Забронировать',style: TextStyle(color: AppColors.primaryText),)
                        ),
                        const PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Удалить',style: TextStyle(color: AppColors.primaryText),)
                        ),
                      ],
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
