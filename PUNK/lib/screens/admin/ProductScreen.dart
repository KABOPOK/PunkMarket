import 'package:flutter/material.dart';
import 'package:punk/services/UserService.dart';
import 'package:punk/supplies/product_list.dart';
import '../../../common_functions/Functions.dart';
import '../../../services/ProductService.dart';
import '../../../supplies/app_colors.dart';
import '../../../widgets/cardWidgets/FullScreenImageView.dart';

class AdminProductScreen extends StatefulWidget {
  final String title;
  final String price;
  final String owner;
  final String description;
  final String productID;
  final String userID;

  const AdminProductScreen({
    Key? key,
    required this.title,
    required this.price,
    required this.owner,
    required this.description,
    required this.productID,
    required this.userID,
  }) : super(key: key);

  @override
  _AdminProductScreenState createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends State<AdminProductScreen> {
  List<String> existingImageUrls = [];
  bool isLoading = true;
  int currentIndex = 0;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(); // Initialize PageController
    _loadExistingImages();
  }

  @override
  void dispose() {
    _pageController.dispose(); // Clean up the controller
    super.dispose();
  }

  Future<void> _loadExistingImages() async {
    try {
      List<String> fetchedUrls =
      await ProductService.fetchProductUrlList(widget.productID);

      // Rearrange the images to make the last image the first one (main preview)
      if (fetchedUrls.isNotEmpty) {
        fetchedUrls.insert(0, fetchedUrls.removeLast());
      }

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

  void _goToPreviousImage() {
    setState(() {
      currentIndex = (currentIndex - 1 + existingImageUrls.length) % existingImageUrls.length;
    });
    _pageController.animateToPage(
      currentIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToNextImage() {
    setState(() {
      currentIndex = (currentIndex + 1) % existingImageUrls.length;
    });
    _pageController.animateToPage(
      currentIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleMenuSelection(String choice, BuildContext context) {
    switch (choice) {
      case 'report_user':
        UserService.reportUser(widget.userID, context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The owner of this product had been reported')),
        );
        break;
      case 'report_product':
        ProductService.reportProduct(widget.productID, context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This product had been reported')),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        title: Text(
          'PUNK MARKET',
          style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.icons),
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
                  // PageView with PageController
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: existingImageUrls.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // Navigate to full-screen image preview
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImageView(
                                  imageUrls: existingImageUrls,
                                  initialIndex: index,
                                ),
                              ),
                            );
                          },
                          child: Image.network(
                            existingImageUrls[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset('assets/placeholder.png', height: 200),
                          ),
                        );
                      },
                    ),
                  ),
                  // Left Arrow Button
                  Positioned(
                    left: 16,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          size: 30, color: AppColors.accentHover),
                      onPressed: _goToPreviousImage,
                    ),
                  ),
                  // Right Arrow Button
                  Positioned(
                    right: 16,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios,
                          size: 30, color: AppColors.accentHover),
                      onPressed: _goToNextImage,
                    ),
                  ),
                  // Image Indicator (Dots)
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
                                ? AppColors.accent
                                : AppColors.accentBackground,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Product Title and Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText),
                ),
                Text(
                  widget.price,
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.priceTag,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Описание',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText),
            ),
            const SizedBox(height: 4),
            Text(
              widget.description,
              style: TextStyle(
                  fontSize: 16, color: AppColors.primaryText),
            ),
            const SizedBox(height: 16),
            const Divider(),
            buildInfoRow('Владелец', widget.owner),
            buildInfoRow('Состояние', 'б.у.'),
            const Spacer(),
            // Contact Button
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
          Text(label, style: TextStyle(fontSize: 16, color: AppColors.primaryText)),
          Text(value, style: TextStyle(fontSize: 16, color: AppColors.primaryText)),
        ],
      ),
    );
  }
}
