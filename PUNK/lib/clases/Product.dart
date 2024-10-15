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
