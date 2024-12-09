import 'package:flutter/material.dart';
import 'package:punk/services/ProductService.dart';
import 'package:punk/services/UserService.dart';
import '../../../Online/Online.dart';
import '../../../clases/Product.dart';
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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _fetchProducts();
  }

  Future<void> _addToWishlist(String productID) async {
    try {
      await UserService.saveToWishlist(Online.user.userID, productID);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Could not add to wishlist')),
      );
    }
  }

  Future<void> _fetchProducts({String query = ''}) async {
    try {
      List<Product> products = await ProductService.fetchProducts(_page, _limit, query);
      setState(() {
        if (_page == 1) {
          filteredProducts = products;
        } else {
          filteredProducts.addAll(products);
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

  void _filterProducts(String query) {
    _currentQuery = query;
    _page = 1;
    _fetchProducts(query: _currentQuery);
  }

  Future<void> _fetchMoreProducts() async {
    if (_isLoadingMore) return;
    _isLoadingMore = true;
    _page++;
    try {
      List<Product> moreProducts = await ProductService.fetchProducts(_page, _limit, _currentQuery);
      setState(() {
        filteredProducts.addAll(moreProducts);
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    } finally {
      _isLoadingMore = false;
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (!_isLoadingMore) {
        _fetchMoreProducts();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            color: Colors.orange,
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
                          backgroundColor: Colors.black,
                          child: Text(
                            "Logo",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "PUNK MARKET",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.filter_list, color: Colors.white),
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
                ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red)))
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                controller: _scrollController,
                itemCount: _isLoadingMore ? filteredProducts.length + 1 : filteredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  if (index < filteredProducts.length) {
                    final product = filteredProducts[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductScreen(
                              title: product.title,
                              photoUrl: product.photoUrl,
                              price: product.price,
                              owner: product.ownerName,
                              description: product.description,
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
                        onAddToCart: () {
                          _addToWishlist(product.productID);
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.title} added to wishlist!'),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}