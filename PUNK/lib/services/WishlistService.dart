import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../Global/Global.dart';
import '../clases/Wishlist.dart';

class WishlistService{
  static Future<int> addToWishlist(Wishlist wishlist) async {
    var request = http.MultipartRequest('POST', Uri.parse('$HTTPS/api/wishlist/add'));
    request.fields['wishlist'] = jsonEncode(wishlist.toJson());
    var response = await request.send();
    return response.statusCode;
    //var responseString = await response.stream.bytesToString();;

  }

}