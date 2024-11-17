import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Global/Global.dart';

class WishlistService {
 // http://localhost:8021/api/wishlist/add?userId=d7d91400-0bb2-41e2-9994-ba809b1455f6&productId=0e651e89-4e4a-4b22-8ba3-ed3cceffadb5
  static Future<void> saveToWishlist( String userId,String productId) async {
    http.Response response = await http.post(
      Uri.parse('$HTTPS/api/wishlist/add?userId=$userId&productId=$productId'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add to wishlist');
    }
  }
}
