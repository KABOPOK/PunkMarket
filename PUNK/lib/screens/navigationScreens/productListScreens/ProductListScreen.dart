import 'package:flutter/material.dart';
import 'package:punk/supplies/product_list.dart';
import '../../../widgets/barWidgets/SearchBarWidget.dart';
import '../../../widgets/cardWidgets/ProductCardWidget.dart';
import 'ProductDetailsScreen.dart';

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
          SearchBarWidget(onSearch: _filterProducts),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: filteredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductScreen(
                            title: product["title"],
                            photoUrl: product["imageUrl"],
                            price: product["price"],
                            owner: product["owner"],
                            description: product["description"],
                          ),
                        ),
                      );
                    },
                    child: ProductCard(
                      photoUrl: product["imageUrl"],
                      title: product["title"],
                      price: product["price"],
                      owner: product["owner"],
                      description: product["description"],
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
                    ),
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
