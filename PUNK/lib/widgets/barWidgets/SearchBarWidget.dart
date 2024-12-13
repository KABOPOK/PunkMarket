import 'package:flutter/material.dart';

import '../../supplies/app_colors.dart';

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
        height: 45,
        decoration: BoxDecoration(
          color: AppColors.search_bar,
          border: Border.all(
            color: AppColors.highlightBorder,
            width: 1.4,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (query) {
                  onSearch(query);
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  hintText: 'Find Products',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: AppColors.icons2),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.arrow_forward_ios, color: AppColors.icons2),
                    onPressed: () {
                      // Trigger search action here
                      onSearch('Search Query');
                    },
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