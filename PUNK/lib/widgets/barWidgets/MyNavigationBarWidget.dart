import 'package:flutter/material.dart';
import 'package:punk/screens/navigationScreens/myProductsScreens/MyProductListScreen.dart';
import 'package:punk/screens/navigationScreens/productListScreens/ProductListScreen.dart';
import 'package:punk/screens/navigationScreens/myProductsScreens/AddProductScreen.dart';

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({super.key});

  @override
  State<MyNavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<MyNavigationBar> {
  int _screenIndex = 0;

  // List of widgets/screens for the navigation bar
  final List<Widget> _screens = [
    ProductListPage(), // Home Page
    const Icon(Icons.question_answer_sharp, color: Colors.deepOrangeAccent), // Placeholder for Questions screen
    MyProductListPage(), // My Products Page
    const Icon(Icons.message, color: Colors.deepOrangeAccent), // Placeholder for Messages screen
    const Icon(Icons.person, color: Colors.deepOrangeAccent), // Placeholder for Profile screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _screens[_screenIndex], // Display the selected screen
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _screenIndex,
        onTap: (int newIndex) {
          setState(() {
            _screenIndex = newIndex;
          });
        },
        selectedItemColor: Colors.white, // Change selected icon color to white
        unselectedItemColor: Colors.deepOrangeAccent, // Change unselected item color
        type: BottomNavigationBarType.fixed, // Ensures fixed navigation bar type
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: _buildNavBarIcon(Icons.home, 0),
          ),
          BottomNavigationBarItem(
            label: 'Questions',
            icon: _buildNavBarIcon(Icons.question_answer_sharp, 1),
          ),
          BottomNavigationBarItem(
            label: 'Products',
            icon: _buildNavBarIcon(Icons.shopping_basket, 2),
          ),
          BottomNavigationBarItem(
            label: 'Messages',
            icon: _buildNavBarIcon(Icons.message, 3),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: _buildNavBarIcon(Icons.person, 4),
          ),
        ],
      ),
      floatingActionButton: _screenIndex == 2 // Display FAB only on MyProductListPage (index 2)
          ? FloatingActionButton(
        onPressed: () {
          // Logic for the FAB button here
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductAdditionScreen()), // Example: navigate to AddProductScreen
          );
        },
        backgroundColor: Colors.deepOrangeAccent,
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null, // No FAB for other screens
    );
  }

  Widget _buildNavBarIcon(IconData iconData, int index) {
    bool isSelected = _screenIndex == index;
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.orange : Colors.transparent, // Set background color to orange when selected
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        iconData,
        color: isSelected ? Colors.white : Colors.orangeAccent,
      ),
    );
  }
}
