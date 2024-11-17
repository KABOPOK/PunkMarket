import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Global/Global.dart';

class WishlistService {

  static Future<void> saveToWishlist( String userId,String productId) async {
    var request = http.MultipartRequest('POST', Uri.parse('$HTTPS/api/wishlist/add?userId=$userId&productId=$productId'));
    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to add to wishlist');
    }
  }
}
