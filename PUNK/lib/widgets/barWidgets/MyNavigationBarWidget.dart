import 'package:flutter/material.dart';
import 'package:punk/screens/navigationScreens/profileScreens/MyProfileScreen.dart';
import 'package:punk/screens/navigationScreens/myProductsScreens/MyProductListScreen.dart';
import 'package:punk/screens/navigationScreens/productListScreens/ProductListScreen.dart';
import 'package:punk/screens/navigationScreens/myProductsScreens/AddProductScreen.dart';


class MyNavigationBar extends StatefulWidget {
  final int initialScreenIndex;

  const MyNavigationBar({Key? key, this.initialScreenIndex = 0}) : super(key: key);

  @override
  State<MyNavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<MyNavigationBar> {
  late int _screenIndex;
  final ValueNotifier<String> _currentProductContent =
  ValueNotifier<String>("MyProducts");

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screenIndex = widget.initialScreenIndex;

    _screens.addAll([
      ProductListPage(),
      MyProductListPage(currentProductContent: _currentProductContent),
      MyProfileScreen(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _screens[_screenIndex],
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
          BottomNavigationBarItem(
            label: 'Products',
            icon: _buildNavBarIcon(Icons.shopping_basket, 1),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: _buildNavBarIcon(Icons.person, 2),
          ),
        ],
      ),
      floatingActionButton: (_screenIndex == 1)
          ? ValueListenableBuilder<String>(
        valueListenable: _currentProductContent,
        builder: (context, content, child) {
          return content == "MyProducts"
              ? FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductAdditionScreen(),
                ),
              );
              if (result == true) {
                setState(() {});
              }
            },
            backgroundColor: Colors.deepOrangeAccent,
            child: const Icon(Icons.add, color: Colors.white),
          )
              : Container();
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
