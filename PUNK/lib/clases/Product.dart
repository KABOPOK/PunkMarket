class Product {
  String cost;
  String title;
  String description;
  String category;
  String photoUrl;
  String userID;
  String location;
  String ID;

  Product(this.cost, this.title, this.description, this.category, this.photoUrl,
      this.location, this.userID, this.ID); //?

  // Constructor


  // Named constructor if you want an empty user

  Product.empty()
      : cost = '',
        title = '',
        description = '',
        category = '',
        photoUrl = '',
        location = '',
        userID = '',
        ID = '';

  // Method to display user information
  void displayProduct() {
    print('Cost: $cost');
    print('Title: $title');
    print('About Product: $description');
    print('Owner: $userID');
  }
}