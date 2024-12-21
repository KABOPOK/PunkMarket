import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:punk/supplies/app_colors.dart';

import '../../clases/Product.dart';
import '../../services/ModeratorServices.dart';
import '../../services/ProductService.dart';
import '../WelcomeScreen.dart';
import '../navigationScreens/productListScreens/ProductDetailsScreen.dart';
import 'ProductScreen.dart';
import 'UsersListPage.dart';


class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();
  late List<Product> filteredProducts= [];
  bool isLoading = true;
  String errorMessage = '';
  int _page = 1;
  final int _limit = 20;
  String _currentQuery = '';
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _fetchProducts();
  }
  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });
      ++_page;
      _fetchProducts(query: _currentQuery);
    }
  }

  Future<void> _fetchProducts({String query = ''}) async {
    try {
      List<Product> visibleProducts = await ModeratorService.fetchProducts("da10e78e-2bdb-46cc-b53a-70a7612dff24");

      setState(() {
        if (_page == 1) {
          filteredProducts = visibleProducts;
        } else {
          filteredProducts.addAll(visibleProducts);
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  void _filterUsers(String query) {
    _currentQuery = query;
    _page = 1;
    _fetchProducts(query: _currentQuery);
  }

  void _handleMenuSelection(String choice, BuildContext context) {
    switch (choice) {
      case 'settings':
      // Navigate to settings screen
        break;
      case 'log_out':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logging Out...')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
        break;
    }
  }

  void _confirmDelete(String productId, String productName, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.secondaryBackground,
          title: const Text(
            'Подтверждение удаления',
            style: TextStyle(color: AppColors.primaryText),
          ),
          content: Text(
            'Вы точно хотите удалить продукт $productName?',
            style: const TextStyle(color: AppColors.primaryText),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text(
                'Нет',
                style: TextStyle(color: AppColors.primaryText),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog
                final result = await ProductService.deleteProduct(productId, context);

                  setState(() {
                    filteredProducts.removeWhere((product) => product.productID == productId);
                  });

              },
              child: const Text(
                'Да',
                style: TextStyle(color: AppColors.primaryText),
              ),
            ),
          ],
        );
      },
    );
  }

  void _DeclineReport(Product product, String productName, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.secondaryBackground,
          title: const Text(
            'Подтверждение отказа репорта',
            style: TextStyle(color: AppColors.primaryText),
          ),
          content: Text(
            'Вы точно хотите сохранить товар $productName?',
            style: const TextStyle(color: AppColors.primaryText),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text(
                'Нет',
                style: TextStyle(color: AppColors.primaryText),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog
                final result = await ModeratorService.DeclineProductReport(product.productID, context);

                  setState(() {
                    filteredProducts.removeWhere((p) => p.productID == product.productID);
                  });

              },
              child: const Text(
                'Да',
                style: TextStyle(color: AppColors.primaryText),
              ),
            ),
          ],
        );
      },
    );
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
        flexibleSpace: const SizedBox(height: 8.0),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AppColors.primaryBackground,
            child: Text(
              'LOGO',
              style: TextStyle(color: AppColors.primaryText, fontSize: 12),
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            color: AppColors.secondaryBackground,
            icon: const Icon(
              Icons.more_horiz_rounded,
              color: AppColors.icons,
              size: 30,
            ),
            onSelected: (choice) => _handleMenuSelection(choice, context),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'settings',
                child: Text('Настройки', style: TextStyle(color: AppColors.primaryText),),
              ),
              const PopupMenuItem<String>(
                value: 'log_out',
                child: Text('Выйти из аккаунта', style: TextStyle(color: AppColors.primaryText),),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return ListTile(
            subtitle: const SizedBox(height: 8.0),
            leading: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminProductScreen(
                      title: product.title,
                      price: product.price,
                      owner: product.ownerName,
                      description: product.description,
                      productID: product.productID,
                      userID: product.userID,
                    ),
                  ),
                );
              },
            child: CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.icons2,
              backgroundImage: ((){
                if(product.photoUrl != null){
                  return NetworkImage(product.photoUrl!);
                } else {
                  return null;
                }
              })(),
              child: product.photoUrl == null
                  ? Icon(
                Icons.person,
                size: 50,
                color: AppColors.primaryBackground,
              )
                  : null,
            ),
            ),
            title: Text(product.title, style: TextStyle(color: AppColors.primaryText),),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.check, color: AppColors.priceTag),
                  onPressed: () {
                    _DeclineReport(product, product.title, context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.close, color: AppColors.error),
                  onPressed: () {
                    _confirmDelete(product.productID, product.title, context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}