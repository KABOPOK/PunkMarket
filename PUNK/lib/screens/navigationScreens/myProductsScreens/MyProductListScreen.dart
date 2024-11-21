import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:punk/clases/Product.dart';
import 'package:punk/services/ProductService.dart';
import 'package:punk/services/UserService.dart';
import 'package:punk/widgets/cardWidgets/MyProductCardWidget.dart';
import 'package:punk/Online/Online.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/ProductContent/MyProductsContent.dart';
import '../../../widgets/ProductContent/WishlistContent.dart';

class MyProductListPage extends StatefulWidget {
  @override
  _MyProductListPageState createState() => _MyProductListPageState();
}

class _MyProductListPageState extends State<MyProductListPage> {
  List<Product> _myProducts = [];
  List<Product> _wishlistProducts = [];
  bool _isLoading = true;
  bool _isWishlistLoading = true;
  String _errorMessage = "";
  String _wishlistErrorMessage = "";
  int _currentPage = 0;

  final int _limit = 20;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _fetchUserProducts();
    _fetchWishlistProducts();
  }

  Future<void> _fetchUserProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });
    try {
      List<Product> products = await ProductService.fetchUserProducts(1, _limit);
      setState(() {
        _myProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Error: $e";
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchWishlistProducts() async {
    setState(() {
      _isWishlistLoading = true;
      _wishlistErrorMessage = "";
    });
    try {
      List<Product> products = await ProductService.fetchWishlistProducts(1, _limit);
      setState(() {
        _wishlistProducts = products;
        _isWishlistLoading = false;
      });
    } catch (e) {
      setState(() {
        _wishlistErrorMessage = "Error: $e";
        _isWishlistLoading = false;
      });
    }
  }

  void _onTabChanged(int pageIndex) {
    setState(() {
      _currentPage = pageIndex;
    });
    _pageController.jumpToPage(pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Single SliverAppBar
          SliverAppBar(
            pinned: true,
            floating: false,
            backgroundColor: Colors.orange,
            flexibleSpace: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _onTabChanged(0),
                    child: Container(
                      color: _currentPage == 0 ? Colors.orangeAccent : Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Icon(Icons.shopping_cart,
                          color: _currentPage == 0 ? Colors.white : Colors.white70),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _onTabChanged(1),
                    child: Container(
                      color: _currentPage == 1 ? Colors.orangeAccent : Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Icon(Icons.favorite,
                          color: _currentPage == 1 ? Colors.white : Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // PageView Content
          SliverFillRemaining(
            child: PageView(
              controller: _pageController,
              onPageChanged: (pageIndex) {
                setState(() {
                  _currentPage = pageIndex;
                });
              },
              children: [
                MyProductsContent(
                  isLoading: _isLoading,
                  errorMessage: _errorMessage,
                  myProducts: _myProducts,
                ),
                WishlistContent(
                  isLoading: _isWishlistLoading,
                  errorMessage: _wishlistErrorMessage,
                  myProducts: _wishlistProducts,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
