import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:punk/widgets/ProductCardWidget.dart';
import 'package:punk/widgets/SearchBarWidget.dart';
import 'package:punk/supplies/product_list.dart';
import 'package:http/http.dart' as http;

import '../clases/Product.dart';
import 'package:punk/Global/Global.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  int page = 1;
  final int limit = 20;
  bool isLoading = false;
  bool hasMore = true; // To check if more products are available
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && hasMore) {
        fetchProducts();
      }
    });
  }

  Future<void> fetchProducts() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    // Replace this URL with your actual endpoint
    final response = await http.get(Uri.parse('$HTTPS/main_products'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Product> newProducts = data.map((json) => Product.fromJson(json)).toList();

      setState(() {
        products.addAll(newProducts);
        filteredProducts = products; // Set initial filtered products
        ++page;
        hasMore = newProducts.length == limit; // Check if more products are available
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void _filterProducts(String query) {
    final filtered = products.where((product) {
      final titleLower = product.title.toLowerCase(); // Assuming Product has a title property
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredProducts = filtered;
    });
  }


  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SearchBarWidget(onSearch: _filterProducts),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                controller: _scrollController,
                itemCount: filteredProducts.length + (isLoading ? 1 : 0), // Add loading indicator at the end
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  if (index < filteredProducts.length) {
                    final product = filteredProducts[index];
                    return ProductCard(
                      photoUrl: product.photoUrl, // Assuming Product has an imageUrl property
                      title: product.title,
                      price: product.price,
                      owner: product.ownerName,
                      onAddToCart: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.title} added to cart!'),
                          ),
                        );
                      },
                      onAddToWishlist: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.title} added to wishlist!'),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator()); // Show loading indicator
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}