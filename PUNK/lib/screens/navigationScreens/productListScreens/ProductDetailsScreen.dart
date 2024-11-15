import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  final String title;
  final String photoUrl;
  final String price;
  final String owner;
  final String description;

  ProductScreen({
    required this.title,
    required this.photoUrl,
    required this.price,
    required this.owner,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Вернуться в меню поиска"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Image.network(
                    photoUrl,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset('assets/placeholder.png', height: 200),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Описание',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Divider(),
            buildInfoRow('Владелец', owner),
            buildInfoRow('Состояние', 'б.у.'),
            const Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  backgroundColor: Colors.orange,
                ),
                onPressed: () {
                  // Contact seller functionality
                },
                child: const Text(
                  'Связаться с продавцом',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.black54)),
          Text(value, style: TextStyle(fontSize: 16, color: Colors.black)),
        ],
      ),
    );
  }
}
