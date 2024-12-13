import 'package:flutter/material.dart';
import 'package:punk/clases/Product.dart';
import 'package:punk/services/ProductService.dart';
import 'package:punk/services/UserService.dart';

import '../../../supplies/app_colors.dart';
import '../../../widgets/ProductContent/MyProductsContent.dart';
import '../../../widgets/ProductContent/WishlistContent.dart';

class MyProductListPage extends StatefulWidget {
  final ValueNotifier<String> currentProductContent;

  MyProductListPage({required this.currentProductContent});

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
    _pageController = PageController(initialPage: _currentPage);
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
      List<Product> products = await UserService.fetchWishlistProducts(1, _limit);
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
    widget.currentProductContent.value =
    pageIndex == 0 ? "MyProducts" : "Wishlist";
    _pageController.jumpToPage(pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Column(
        children: [
          // Tab Switcher
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _onTabChanged(0),
                  child: Container(
                    color: _currentPage == 0
                        ? AppColors.accentHover
                        : AppColors.accent,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Icon(Icons.shopping_cart,
                        color: _currentPage == 0
                            ? AppColors.icons
                            : AppColors.icons2),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _onTabChanged(1),
                  child: Container(
                    color: _currentPage == 1
                        ? AppColors.accentHover
                        : AppColors.accent,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Icon(Icons.favorite,
                        color: _currentPage == 1
                            ? AppColors.icons
                            : AppColors.icons2),
                  ),
                ),
              ),
            ],
          ),

          // Tab Content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (pageIndex) {
                _onTabChanged(pageIndex);
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
