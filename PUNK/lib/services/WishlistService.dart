import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Global/Global.dart';

class WishlistService {
  static Future<void> saveToWishlist( String userId,String productId) async {
    http.Response response = await http.post(
      Uri.parse('$HTTPS/api/wishlist/add?userId=$userId&productId=$productId'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add to wishlist');
    }
  }
}
