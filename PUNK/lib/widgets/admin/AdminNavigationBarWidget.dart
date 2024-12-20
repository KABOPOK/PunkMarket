import 'package:flutter/material.dart';

import '../../screens/admin/ProductsListPage.dart';
import '../../screens/admin/UsersListPage.dart';
import '../../supplies/app_colors.dart';


class AdminNavigationBar extends StatefulWidget {
  final int initialScreenIndex;

  const AdminNavigationBar({Key? key, this.initialScreenIndex = 0}) : super(key: key);

  @override
  State<AdminNavigationBar> createState() => _AdminNavigationBarState();
}

class _AdminNavigationBarState extends State<AdminNavigationBar> {
  late int _screenIndex;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screenIndex = widget.initialScreenIndex;

    _screens.addAll([
      UserListScreen(),
      ProductListScreen(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _screens[_screenIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.primaryBackground,
        currentIndex: _screenIndex,
        onTap: (int newIndex) {
          setState(() {
            _screenIndex = newIndex;
          });
        },
        selectedItemColor: AppColors.icons,
        unselectedItemColor: AppColors.accent,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              label: 'Users',
              icon: _buildNavBarIcon(Icons.people_alt, 0),
              backgroundColor: AppColors.secondaryBackground
          ),
          BottomNavigationBarItem(
              label: 'Products',
              icon: _buildNavBarIcon(Icons.production_quantity_limits_sharp, 1),
              backgroundColor: AppColors.secondaryBackground
          ),
        ],
      ),
    );
  }

  Widget _buildNavBarIcon(IconData iconData, int index) {
    bool isSelected = _screenIndex == index;
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(

        color: isSelected ? AppColors.accent : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        iconData,
        color: isSelected ? AppColors.icons : AppColors.accentHover,
      ),
    );
  }
}