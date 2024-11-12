import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:punk/supplies/product_list.dart';

import '../../../widgets/cardWidgets/ProductCardWidget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> filteredProducts = [];
  String searchQuery = "";

  void _filterProducts(String query) {
    setState(() {
      searchQuery = query;
    });

    if (query.isEmpty) {
      setState(() {
        filteredProducts = [];  // Clears the product list when search bar is empty
      });
      return;
    }

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
      appBar: AppBar(
        title: CupertinoSearchTextField(
          autofocus: true,
          onChanged: _filterProducts,  // Filter products as user types
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: searchQuery.isEmpty
          ? const SizedBox.shrink() // No products is shown when search query is empty
          : (filteredProducts.isEmpty)
          ? Center(
        child: 
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children : [
            const Text(
              "Nothing was found(", // Display message when no products are found
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Image.network("https://i.pinimg.com/enabled/564x/d0/c2/bc/d0c2bcb07d65f2a282e133fea199d098.jpg"),
          ]
          
        ),
        
      )
          : GridView.builder(
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

    );
  }
}
