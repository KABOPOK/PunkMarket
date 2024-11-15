import 'package:flutter/material.dart';
import '../../screens/navigationScreens/productListScreens/SearchPageScreen.dart';

class SearchBarWidget extends StatelessWidget {
  final Function(String) onSearch;  // A callback for the search query
  const SearchBarWidget({Key? key, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SearchPage(),
          ),
        );
      },
      child: Container(
        height: 35,  // Height of the search bar
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.orangeAccent,  // Border color
            width: 1.4,
          ),
          borderRadius: BorderRadius.circular(15),  // Border radius
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Find Products',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,  // Background color of search button
                borderRadius: BorderRadius.circular(25),
              ),
              height: 32,
              width: 75,
              child: const Center(
                child: Text(
                  'Search',
                  style: TextStyle(
                    color: Colors.orangeAccent,  // Text color
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
