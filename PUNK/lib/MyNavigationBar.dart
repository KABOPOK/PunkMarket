import 'package:flutter/material.dart';
import 'package:punk/screens/MyProductList.dart';
import 'package:punk/screens/ProductList.dart';

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
    //const Icon(Icons.home), // Placeholder for Home screen
    const Icon(Icons.question_answer_sharp), // Placeholder for Questions screen
    MyProductListPage(), // My Products Page
    const Icon(Icons.message), // Placeholder for Messages screen
    const Icon(Icons.person), // Placeholder for Profile screen
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
        backgroundColor: Colors.blue,             // Change background color
        selectedItemColor: Colors.white,          // Change selected item color
        unselectedItemColor: Colors.grey,         // Change unselected item color
        type: BottomNavigationBarType.fixed,      // Ensure background color is applied
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Questions',
            icon: Icon(Icons.question_answer_sharp),
          ),
          BottomNavigationBarItem(
            label: 'Products',
            icon: Icon(Icons.shopping_basket), // Show Products when clicked
          ),
          BottomNavigationBarItem(
            label: 'Messages',
            icon: Icon(Icons.message),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
