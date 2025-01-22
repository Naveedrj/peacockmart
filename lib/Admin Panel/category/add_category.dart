import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import 'category_service.dart';

class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _categoryController = TextEditingController();
  final CategoryService _categoryService = CategoryService();  // Create an instance of CategoryService


  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  // Method to add category and upload to Firebase
  void _addCategory() async {
    final category = _categoryController.text.trim();
    if (category.isNotEmpty) {
      try {
        await _categoryService.addCategory(category);  // Call the method to upload category to Firebase

        _categoryController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category added successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add category!')),
        );
        print('Error: $e');
      }
    }
  }

  // Method to remove category from the list

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Categories'),

        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // TextField to enter new category
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'Enter Category Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // Button to add category
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white
              ),
              onPressed: _addCategory,
              child: Text('Add Category'),
            ),
            SizedBox(height: 20),
            // Display the list of categories

          ],
        ),
      ),
    );
  }
}
