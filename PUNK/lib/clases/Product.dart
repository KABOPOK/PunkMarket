import 'dart:ffi';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../Online/Online.dart';

@freezed
class Product {
  String productID;
  String price;
  String title;
  String ownerName;
  String photoUrl;
  String location;
  String description;
  String category;
  String userID;
  bool isSold;
  bool isReported;

  // Empty constructor
  Product({
    this.productID = '',
    this.price = '',
    this.title = '',
    this.ownerName = '',
    this.photoUrl = '',
    this.location = '',
    this.description = '',
    this.category = '',
    this.userID = '',
    this.isSold = false,
    this.isReported = false,
  });

  // Method to convert Product object to JSON
  Map<String, dynamic> toJson() {
    return {
      'productID': productID,
      'price': price,
      'title': title,
      'ownerName': ownerName,
      'photoUrl': photoUrl,
      'location': location,
      'description': description,
      'category': category,
      'userID': userID,
      'isSold' : isSold,
      'isReported' : isReported,
    };
  }

  // Method to create a Product object from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productID: json['productID'] ?? '',
      price: json['price'] ?? '',
      title: json['title'] ?? '',
      ownerName: json['ownerName'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      userID: json['userID'] ?? '',
      isSold: json['isSold'] ?? '',
      isReported: json['isReported'] ?? '',
    );
  }

  // Method to display product details
  String display() {
    return 'Product ID: $productID\n'
        'Price: $price\n'
        'Title: $title\n'
        'Owner Name: $ownerName\n'
        'Photo URL: $photoUrl\n'
        'Location: $location\n'
        'Description: $description\n'
        'Category: $category\n'
        'User ID: $userID';
  }
}
