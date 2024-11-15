import 'package:flutter/material.dart';
import 'package:punk/supplies/product_list.dart';
import '../../../widgets/barWidgets/SearchBarWidget.dart';
import '../../../widgets/cardWidgets/ProductCardWidget.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late List<Map<String, dynamic>> filteredProducts;

  @override
  void initState() {
    super.initState();
    filteredProducts = products;  // Using the global product list
  }

  void _filterProducts(String query) {
    final filtered = products.where((product) {
      final titleLower = product['title'].toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredProducts = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Top bar with logo, title, and search bar

          Container(
            color: Colors.orange, // Background color for top bar
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Placeholder for Logo
                        CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.black,
                          child: Text(
                            "Logo",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Market Name
                        Text(
                          "PUNK MARKET",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    // Filter Icon
                    IconButton(
                      icon: Icon(Icons.filter_list, color: Colors.white),
                      onPressed: () {
                        // Define filter action
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                // Search Bar below the title and logo
                SearchBarWidget(onSearch: _filterProducts),
              ],
            ),
          ),

          // The product grid below the SearchBar
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: filteredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.75, // Adjust to control card size
                ),
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return ProductCard(
                    photoUrl: product["imageUrl"],
                    title: product["title"],
                    price: product["price"],
                    owner: product["owner"],
                    description: product["description"],// Pass owner to the product card
                    onAddToCart: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product["title"]} added to cart!'),
                        ),
                      );
                    },
                    onAddToWishlist: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product["title"]} added to wishlist!'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}