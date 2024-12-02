import 'package:flutter/material.dart';
import 'package:punk/screens/navigationScreens/profileScreens/MyProfileScreen.dart';
import 'package:punk/screens/navigationScreens/myProductsScreens/MyProductListScreen.dart';
import 'package:punk/screens/navigationScreens/productListScreens/ProductListScreen.dart';
import 'package:punk/screens/navigationScreens/myProductsScreens/AddProductScreen.dart';


class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({Key? key}) : super(key: key);

  @override
  State<MyNavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<MyNavigationBar> {
  int _screenIndex = 0;

  // ValueNotifier to track the product content
  final ValueNotifier<String> _currentProductContent = ValueNotifier<String>("MyProducts");

  // List of widgets/screens for the navigation bar
  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();

    // Initialize screens
    _screens.addAll([
      ProductListPage(),
      //ChatScreen(),
      MyProductListPage(),
      //MyChatsScreen(),
      MyProfileScreen(),
    ]);
  }

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
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.deepOrangeAccent,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: _buildNavBarIcon(Icons.home, 0),
          ),
          // BottomNavigationBarItem(
          //   label: 'Questions',
          //   icon: _buildNavBarIcon(Icons.question_answer_sharp, 1),
          // ),
          BottomNavigationBarItem(
            label: 'Products',
            icon: _buildNavBarIcon(Icons.shopping_basket, 1),
          ),
          // BottomNavigationBarItem(
          //   label: 'Messages',
          //   icon: _buildNavBarIcon(Icons.message, 3),
          // ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: _buildNavBarIcon(Icons.person, 2),
          ),
        ],
      ),
      // FAB is only visible on MyProductListPage with "MyProducts" content
      floatingActionButton: (_screenIndex == 1)
          ? ValueListenableBuilder<String>(
        valueListenable: _currentProductContent,
        builder: (context, content, child) {
          return content == "MyProducts"
              ? FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductAdditionScreen(),
                ),
              );
            },
            backgroundColor: Colors.deepOrangeAccent,
            child: const Icon(Icons.add, color: Colors.white),
          )
              : Container(); // Return an empty widget when FAB is not needed
        },
      )
          : null,
    );
  }

  Widget _buildNavBarIcon(IconData iconData, int index) {
    bool isSelected = _screenIndex == index;
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.orange : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        iconData,
        color: isSelected ? Colors.white : Colors.orangeAccent,
      ),
    );
  }
}
