import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:punk/clases/Product.dart';
import 'package:punk/widgets/cardWidgets/MyProductCardWidget.dart';
import 'package:punk/Online/Online.dart';
import 'package:http/http.dart' as http;

import '../../../Global/Global.dart';
import 'WishListScreen.dart';

class MyProductListPage extends StatefulWidget {
  @override
  _MyProductListPageState createState() => _MyProductListPageState();
}

class _MyProductListPageState extends State<MyProductListPage> {
  List<Product> _myProducts = [];
  bool _isLoading = true;
  String _errorMessage = "";
  int _page = 1;
  final int _limit = 20;

  @override
  void initState() {
    super.initState();
    _fetchUserProducts();
  }

  Future<void> _fetchUserProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      final userId = Online.user.userID;  // Ensure Online.user.userID contains the correct logged-in user ID
      final response = await http.get(
        Uri.parse('$HTTPS/api/products/get_products?userId=$userId&page=$_page&limit=$_limit'),
      );

      if (response.statusCode == 200) {
        try {
          // Parse and validate the JSON response
          final List<dynamic> productData = json.decode(response.body);
          List<Product> products = [];
          for (int i = 0; i < productData.length; ++i) {
            products.add(Product.fromJson(productData[i]));
          }

          // Check if the response is empty or if products were found
          if (productData.isNotEmpty) {
            setState(() {
              _myProducts = products;
              _isLoading = false;
            });
          } else {
            setState(() {
              _errorMessage = "No products found for this user.";
              _isLoading = false;
            });
          }
        } catch (e) {
          setState(() {
            _errorMessage = "Error parsing product data.";
            _isLoading = false;
          });
          print("JSON Parsing Error: $e");
        }
      } else {
        setState(() {
          _errorMessage = "Failed to load products. Status code: ${response.statusCode}";
          _isLoading = false;
        });
        print("Server Response Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Network error: $e";
        _isLoading = false;
      });
      print("Network Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Top Bar Switcher
          SliverAppBar(
            pinned: true,
            floating: false,
            backgroundColor: Colors.orange,
            flexibleSpace: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      color: Colors.orangeAccent,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Icon(Icons.shopping_cart, color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WishListPage()), // Example: navigate to AddProductScreen
                      );
                    },
                    child: Container(
                      color: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Icon(Icons.favorite, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Title and Actions Row (scrolls with content)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "МОИ ТОВАРЫ",
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

          // Main Content
          SliverFillRemaining(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : _myProducts.isEmpty
                ? Center(child: Text('No products found'))
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: _myProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final product = _myProducts[index];
                  return MyProduct(
                    photoUrl: _myProducts[index].photoUrl,
                    title: _myProducts[index].title,
                    price: _myProducts[index].price,
                    owner: _myProducts[index].ownerName,
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
