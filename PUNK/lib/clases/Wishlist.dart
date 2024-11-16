import 'package:freezed_annotation/freezed_annotation.dart';

@freezed
class Wishlist {
  String productID;
  String userID;
  String wishlistID;


  // Empty constructor
  Wishlist({
    this.productID = '',
    this.wishlistID = '',
    this.userID = '',
  });

  // Method to convert Product object to JSON
  Map<String, dynamic> toJson() {
    return {
      'productID': productID,
      'wishlistID': wishlistID,
      'userID': userID,
    };
  }

  // Method to create a Product object from JSON
  factory Wishlist.fromJson(Map<String, dynamic> json) {
    return Wishlist(
      productID: json['productID'] ?? '',
      wishlistID: json['wishlistID'] ?? '',
      userID: json['userID'] ?? '',
    );
  }

  // Method to display product details
  String display() {
    return 'Product ID: $productID\n'
        'Wishlist ID: $wishlistID\n'
        'User ID: $userID';
  }
}
