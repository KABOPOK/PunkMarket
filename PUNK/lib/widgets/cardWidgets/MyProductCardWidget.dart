import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../Global/Global.dart';
import '../../clases/Product.dart';
import '../../screens/navigationScreens/myProductsScreens/EditProduct.dart';

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

  Future<void> _sendProduct(Product product, File? image, BuildContext context /*for show message about product sending*/) async {
    try {
      var request =
      http.MultipartRequest('POST', Uri.parse('$HTTPS/create-product'));

      // Add form fields
      request.fields['product'] = jsonEncode(product.toJson());

      // Add image file if available
      if (image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', image.path));
      }

      // Send the request
      var response = await request.send();

      // get response
      var responseString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully pushed')),
        );
      } else {
        final errorData = json.decode(responseString);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorData['error'] ?? 'Unknown error')),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  Future<void> _deleteProduct(String productId, BuildContext context) async {
    final String url = '$HTTPS/api/products/delete?productId=$productId';

    try {
      // Sending the DELETE request
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        // Successfully deleted
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product successfully deleted')),
        );

        // Optionally, you can trigger UI updates or navigation here
      } else {
        // Error response
        final errorData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorData['error'] ?? 'Failed to delete the product')),
        );
      }
    } catch (e) {
      // Exception handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
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
          title: const Text('Подтверждение удаления'),
          content: const Text('Вы точно хотите удалить этот товар?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Нет'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteProduct(product, context); // Call delete
              },
              child: const Text('Да'),
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
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image with options menu
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  photoUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: imageHeight, // Dynamic height based on screen size
                ),
              ),
              // Menu PopUp
              Positioned(
                  top: 10,
                  right: 10,
                  child: PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_horiz_rounded,
                      color: Colors.white,
                    ),
                    onSelected: (choice) => _handleMenuSelection(choice, productID, context),
                    itemBuilder: (BuildContext context)=><PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                          value: 'edit',
                          child: Text('Редактировать')
                      ),
                      const PopupMenuItem<String>(
                          value: 'reserve',
                          child: Text('Забронировать')
                      ),
                      const PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Удалить')
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
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  owner,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 8),
                // Menu PopUp
                Positioned(
                    top: 10,
                    right: 10,
                    child: PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_horiz_rounded,
                        color: Colors.black,
                      ),
                      onSelected: (choice) => _handleMenuSelection(choice, productID, context),
                      itemBuilder: (BuildContext context)=><PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                            value: 'edit',
                            child: Text('Редактировать')
                        ),
                        const PopupMenuItem<String>(
                            value: 'reserve',
                            child: Text('Забронировать')
                        ),
                        const PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Удалить')
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
