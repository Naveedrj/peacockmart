import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_panel/Admin%20Panel/Company/company_register_request.dart';
import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import 'add_category.dart';

class CategoryListScreen extends StatefulWidget {
  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category List'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCategoryScreen()),
              );
            },
            icon: Icon(Icons.add_business),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CompanyRegisterRequest()),
              );
            },
            icon: Icon(Icons.business),
          ),

        ],
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());  // Show a loading spinner while data is loading
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No categories available'));
          }

          // Extract category names from the snapshot
          List<String> categories = snapshot.data!.docs
              .map((doc) => doc['name'] as String)
              .toList();

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  title: Text(categories[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
