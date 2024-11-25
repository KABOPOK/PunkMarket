import 'package:flutter/material.dart';
import '../../screens/navigationScreens/productListScreens/SearchPageScreen.dart';

import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final Function(String) onSearch;  // A callback for the search query
  const SearchBarWidget({Key? key, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Uncomment this if navigating to a separate search page
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const SearchPage(),
        //   ),
        // );
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
            Expanded(
              child: TextField(
                onChanged: (query) {
                  // Call the onSearch function with the query
                  onSearch(query);
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  hintText: 'Find Products',
                  border: InputBorder.none,
                ),
              ),
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
