import 'package:flutter/material.dart';

import '../../../common_functions/Functions.dart';
import '../../../services/ProductService.dart';

class ProductScreen extends StatefulWidget {
  final String title;
  final String price;
  final String owner;
  final String description;
  final String productID;

  const ProductScreen({
    Key? key,
    required this.title,
    required this.price,
    required this.owner,
    required this.description,
    required this.productID,
  }) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<String> existingImageUrls = [];
  bool isLoading = true;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadExistingImages();
  }

  Future<void> _loadExistingImages() async {
    try {
      List<String> fetchedUrls = await ProductService.fetchProductUrlList(widget.productID);
      setState(() {
        existingImageUrls = fetchedUrls;
        isLoading = false;
      });
    } catch (e) {
      Functions.showSnackBar('Error loading images: $e', context);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          'PUNK MARKET',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      itemCount: existingImageUrls.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.network(
                          existingImageUrls[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset('assets/placeholder.png', height: 200),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    left: 16,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 30, color: Colors.black),
                      onPressed: () {
                        if (currentIndex > 0) {
                          setState(() {
                            currentIndex--;
                          });
                        }
                      },
                    ),
                  ),
                  Positioned(
                    right: 16,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 30, color: Colors.black),
                      onPressed: () {
                        if (currentIndex < existingImageUrls.length - 1) {
                          setState(() {
                            currentIndex++;
                          });
                        }
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        existingImageUrls.length,
                            (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentIndex == index
                                ? Colors.orange
                                : Colors.grey,
                          ),
                        ),
                      ),
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
                  widget.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.price,
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
              widget.description,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Divider(),
            buildInfoRow('Владелец', widget.owner),
            buildInfoRow('Состояние', 'б.у.'),
            const Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  backgroundColor: Colors.orange,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('The owner will be notified')),
                  );
                },
                child: const Text(
                  'Contact the owner',
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