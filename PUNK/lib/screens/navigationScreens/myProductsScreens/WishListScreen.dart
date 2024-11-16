import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:punk/widgets/cardWidgets/WishlistCardWidget.dart';
import '../../../supplies/product_list.dart';
import '../productListScreens/ProductDetailsScreen.dart';
import 'MyProductListScreen.dart';

class WishListPage extends StatefulWidget {
  final List<Map<String, dynamic>> wishlist;  // Accept wishlist products as input

  WishListPage({Key? key, required this.wishlist}) : super(key: key);

  @override
  _WishListPageState createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Top Bar with clickable sides
          SliverAppBar(
            pinned: false,
            floating: true,
            backgroundColor: Colors.orange,
            flexibleSpace: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyProductListPage(),
                        ),
                      );
                    },
                    child: Container(
                      color: Colors.orange,
                      child: Icon(Icons.shopping_cart, color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      color: Colors.orangeAccent,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Icon(Icons.favorite, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Title and Actions Row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ОТЛОЖЕННЫЕ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.search, color: Colors.black),
                        onPressed: () {
                          // Handle search action
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.filter_list, color: Colors.black),
                        onPressed: () {
                          // Handle filter action
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Wishlist Content
          SliverFillRemaining(
            child: widget.wishlist.isEmpty
                ? Center(child: Text('No products in wishlist'))
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: widget.wishlist.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final product = widget.wishlist[index];
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
                    child: WishlistCard(
                      photoUrl: product["photoUrl"],
                      title: product["title"],
                      price: product["price"],
                      owner: product["ownerName"],
                      description: product["description"],
                      onAddToCart: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product["title"]} added to cart!'),
                          ),
                        );
                      },
                      onAddToWishlist: () {
                        setState(() {
                          widget.wishlist.remove(product);  // Remove from wishlist
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product["title"]} removed from wishlist!'),
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
