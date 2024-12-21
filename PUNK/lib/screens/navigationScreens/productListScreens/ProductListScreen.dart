import 'package:flutter/material.dart';
import 'package:punk/services/ProductService.dart';
import 'package:punk/services/UserService.dart';
import '../../../Online/Online.dart';
import '../../../clases/Product.dart';
import '../../../supplies/app_colors.dart';
import '../../../widgets/barWidgets/SearchBarWidget.dart';
import '../../../widgets/cardWidgets/ProductCardWidget.dart';
import 'ProductDetailsScreen.dart';

// class ProductListPage extends StatefulWidget {
//   @override
//   _ProductListPageState createState() => _ProductListPageState();
// }
//
// class _ProductListPageState extends State<ProductListPage> {
//   late List<Product> filteredProducts = [];
//   bool isLoading = true;
//   String errorMessage = '';
//   int _page = 1;
//   final int _limit = 20;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchProducts();
//   }
//
//   Future<void> _fetchProducts() async {
//     try {
//       List<Product> products = await ProductService.fetchProducts(_page,_limit, "");
//       setState(() {
//         filteredProducts = products;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Error: $e';
//         isLoading = false;
//       });
//     }
//   }
//
//   void _filterProducts(String query) {
//     final filtered = filteredProducts.where((product) {
//       final titleLower = product.title.toLowerCase();
//       final searchLower = query.toLowerCase();
//       return titleLower.contains(searchLower);
//     }).toList();
//
//     setState(() {
//       filteredProducts = filtered;
//     });
//   }
//
//   Future<void> _addToWishlist(String productID) async {
//     try {
//       await UserService.saveToWishlist(Online.user.userID, productID);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: Could not add to wishlist')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Column(
//         children: [
//           Container(
//             color: Colors.orange,
//             padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 20.0,
//                           backgroundColor: Colors.black,
//                           child: Text(
//                             "Logo",
//                             style: TextStyle(color: Colors.white, fontSize: 10),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Text(
//                           "PUNK MARKET",
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.filter_list, color: Colors.white),
//                       onPressed: () {
//                         // Define filter action
//                       },
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8.0),
//                 SearchBarWidget(onSearch: _filterProducts),
//               ],
//             ),
//           ),
//           Expanded(
//             child: isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : errorMessage.isNotEmpty
//                 ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red)))
//                 : Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: GridView.builder(
//                 itemCount: filteredProducts.length,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 10.0,
//                   mainAxisSpacing: 10.0,
//                   childAspectRatio: 0.75,
//                 ),
//                 itemBuilder: (context, index) {
//                   final product = filteredProducts[index];
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ProductScreen(
//                             title: product.title,
//                             photoUrl: product.photoUrl,
//                             price: product.price,
//                             owner: product.ownerName,
//                             description: product.description,
//                           ),
//                         ),
//                       );
//                     },
//                     child: ProductCard(
//                       productID: product.productID,
//                       photoUrl: product.photoUrl,
//                       title: product.title,
//                       price: product.price,
//                       owner: product.ownerName,
//                       description: product.description,
//                       onAddToCart: () {
//                         _addToWishlist(product.productID);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text('${product.title} added to cart!'),
//                           ),
//                         );
//                       },
//                       onAddToWishlist: () {
//                         if (Online.user.userID == null) {
//                           print("User ID is null");
//                         } else if (product.productID == null) {
//                           print("Product ID is null");
//                         } else {
//                           _addToWishlist(product.productID);
//                         }
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text('${product.title} added to wishlist!'),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
// }
class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ScrollController _scrollController = ScrollController();
  late List<Product> filteredProducts = [];
  bool isLoading = true;
  String errorMessage = '';
  int _page = 1;
  final int _limit = 20;
  String _currentQuery = '';
  bool _isLoadingMore = false;
  List<String> wishlistProductIDs = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _fetchWishlist();
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

  // Fetch the wishlist product IDs for the user
  Future<void> _fetchWishlist() async {
    try {
      final products = await UserService.fetchWishlistProducts(_page, _limit);
      setState(() {
        wishlistProductIDs = products.map((product) => product.productID).toList();
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    }
  }

  Future<void> _fetchProducts({String query = ''}) async {
    try {
      List<Product> products = await ProductService.fetchProducts(_page, _limit, query);

      List<Product> visibleProducts = products.where((product) {
        return product.ownerName != Online.user.userName && product.isSold != true;
      }).toList();

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

  Future<void> _addToWishlist(String productID) async {
    try {
      final result = await UserService.saveToWishlist(Online.user.userID,productID);

      setState(() {
        if (wishlistProductIDs.contains(productID)) {
          wishlistProductIDs.remove(productID);
        } else {
          wishlistProductIDs.add(productID);
        }
      });
    } catch (e) {
      print('Error saving to wishlist: $e');
    }
  }

  void _filterProducts(String query) {
    _currentQuery = query;
    _page = 1;
    _fetchProducts(query: _currentQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Column(
        children: [
          Container(
            color: AppColors.accent,
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.white,
                          child: Text(
                            "Logo",
                            style: TextStyle(color: AppColors.accent, fontSize: 10),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "PUNK MARKET",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.filter_list, color: AppColors.icons),
                      onPressed: () {
                        // Define filter action
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                SearchBarWidget(onSearch: _filterProducts),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage, style: TextStyle(color: AppColors.error)))
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                controller: _scrollController,
                itemCount: filteredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  final isInWishlist = wishlistProductIDs.contains(product.productID);
                  return GestureDetector(
                    onTap: () {
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
                    },
                    child: ProductCard(
                      productID: product.productID,
                      photoUrl: product.photoUrl,
                      title: product.title,
                      price: product.price,
                      owner: product.ownerName,
                      description: product.description,
                      isInWishlist: isInWishlist,
                      onAddToCart: () {
                        //_addToWishlist(product.productID);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.title} added to cart!'),
                          ),
                        );
                      },
                      onAddToWishlist: () {
                        if (Online.user.userID == null) {
                          print("User ID is null");
                        } else if (product.productID == null) {
                          print("Product ID is null");
                        } else {
                          _addToWishlist(product.productID);
                        }
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