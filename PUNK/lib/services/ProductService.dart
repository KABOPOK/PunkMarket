import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../Global/Global.dart';
import '../clases/Product.dart';

class ProductService{
  static Future<int> sendProduct(Product product, List<File?> images) async {
      var request = http.MultipartRequest('POST', Uri.parse('$HTTPS/api/products/create'));
      request.fields['product'] = jsonEncode(product.toJson());
      for (var i = 0; i < images.length; i++) {
        var image = images[i];
        if (image != null) {
          String mimeType = 'image/jpeg';
          if (image.path.endsWith('.png')) {
            mimeType = 'image/png';
          }
          request.files.add(
            await http.MultipartFile.fromPath(
              'images',
              image.path,
            ),
          );
        }
      }
      var response = await request.send();
      return response.statusCode;
      //var responseString = await response.stream.bytesToString();;
  }

}