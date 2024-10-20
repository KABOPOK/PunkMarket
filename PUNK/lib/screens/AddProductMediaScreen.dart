import 'package:flutter/material.dart';
import 'package:punk/screens/MyProductListScreen.dart';

class AddProductMediaScreen extends StatefulWidget {
  @override
  _AddProductMediaScreenState createState() => _AddProductMediaScreenState();
}

class _AddProductMediaScreenState extends State<AddProductMediaScreen> {
  final int maxImages = 10;
  List<String> productImages = [];
  String? coverImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Добавление товара',
          style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        ),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Return to the previous screen
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Изображения от 1 до 10 фото',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'от 1 до 10 фото',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    // Image Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: maxImages,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // TODO: Implement image picker here
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.add),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Обложка',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    // Cover Image Selector
                    GestureDetector(
                      onTap: () {
                        // TODO: Implement cover image picker here
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.add),
                      ),
                    ),
                    SizedBox(height: 20), // Add some space above the button
                    // Create Product Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context); // Return to the MyProductsScreen
                        },
                        child: Text('Создать товар'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
