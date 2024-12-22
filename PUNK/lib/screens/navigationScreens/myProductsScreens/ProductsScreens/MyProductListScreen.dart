import 'package:flutter/material.dart';
import 'package:punk/clases/Product.dart';
import 'package:punk/services/ProductService.dart';
import 'package:punk/services/UserService.dart';
import '../../productListScreens/ProductDetailsScreen.dart';
import 'MyProductDetailScreen.dart';

import '../../../../supplies/app_colors.dart';
import '../../../../widgets/ProductContent/MyProductsContent.dart';
import '../../../../widgets/ProductContent/WishlistContent.dart';

class MyProductListPage extends StatefulWidget {
  final ValueNotifier<String> currentProductContent;

  MyProductListPage({required this.currentProductContent});

  @override
  _MyProductListPageState createState() => _MyProductListPageState();
}

class _MyProductListPageState extends State<MyProductListPage> {
  List<Product> _myProducts = [];
  List<Product> _wishlistProducts = [];
  List<String> _wishlistProductIDs = [];
  List<Product> _soldProducts = [];
  bool _isLoading = true;
  bool _isWishlistLoading = true;
  bool _isSoldLoading = true;
  String _errorMessage = "";
  String _wishlistErrorMessage = "";
  String _soldErrorMessage = "";
  int _currentPage = 0;

  final int _limit = 20;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _fetchUserProducts();
    _fetchWishlistProducts();
    _fetchSoldProducts();
  }

  Future<void> _fetchUserProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });
    try {
      List<Product> allProducts = await ProductService.fetchUserProducts(1, _limit);
      List<Product> products = allProducts.where((product) => !product.isSold).toList();
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
        _wishlistProductIDs = products.map((product) => product.productID).toList();
        _isWishlistLoading = false;
      });
    } catch (e) {
      setState(() {
        _wishlistErrorMessage = "Error: $e";
        _isWishlistLoading = false;
      });
    }
  }

  Future<void> _fetchSoldProducts() async {
    setState(() {
      _isSoldLoading = true;
      _soldErrorMessage = "";
    });
    try {
      List<Product> products = await ProductService.fetchUserProducts(1, _limit);
      List<Product> soldProducts = products.where((product) => product.isSold).toList();
      setState(() {
        _soldProducts = soldProducts;
        _isSoldLoading = false;
      });
    } catch (e) {
      setState(() {
        _soldErrorMessage = "Error: $e";
        _isSoldLoading = false;
      });
    }
  }

  void _onTabChanged(int pageIndex) {
    setState(() {
      _currentPage = pageIndex;
      _fetchSoldProducts();
      _fetchUserProducts();
      _fetchWishlistProducts();
    });
    widget.currentProductContent.value =
    pageIndex == 0 ? "MyProducts" : pageIndex == 1 ? "Wishlist" : "MySoldProducts";
    _pageController.jumpToPage(pageIndex);
  }

  void _navigateToProductDetailScreen(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyProductDetailScreen(
          title: product.title,
          price: product.price,
          owner: product.ownerName,
          description: product.description,
          productID: product.productID,
        ),
      ),
    );
  }

  void _navigateToWishlistProductDetailScreen(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductScreen(
          title: product.title,
          price: product.price,
          owner: product.ownerName,
          description: product.description,
          productID: product.productID,
          userID: product.userID,
          isReported: product.isReported,
        ),
      ),
    );
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
              Expanded(
                child: GestureDetector(
                  onTap: () => _onTabChanged(2),
                  child: Container(
                    color: _currentPage == 2
                        ? AppColors.accentHover
                        : AppColors.accent,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Icon(Icons.check_circle,
                        color: _currentPage == 2
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
                  onProductTap: (product) {
                    _navigateToProductDetailScreen(context, product);
                  },
                ),
                WishlistContent(
                  isLoading: _isWishlistLoading,
                  errorMessage: _wishlistErrorMessage,
                  myProducts: _wishlistProducts,
                  wishlistProductIDs: _wishlistProductIDs,
                  onProductTap: (product) {
                    _navigateToWishlistProductDetailScreen(context, product);
                  },
                ),
                MyProductsContent(
                  isLoading: _isSoldLoading,
                  errorMessage: _soldErrorMessage,
                  myProducts: _soldProducts,
                  onProductTap: (product ) {
                    _navigateToProductDetailScreen(context, product);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
