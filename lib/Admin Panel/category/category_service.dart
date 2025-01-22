import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to fetch categories from Firestore
  Future<List<String>> getCategories() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('categories').get();
      List<String> categories = querySnapshot.docs
          .map((doc) => doc['name'] as String)
          .toList();  // Extract category names as a list of strings
      return categories;
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // Method to upload category to Firebase Firestore
  Future<void> addCategory(String categoryName) async {
    try {
      await _firestore.collection('categories').add({
        'name': categoryName,
        'createdAt': Timestamp.now(),  // Track when the category was added
      });
    } catch (e) {
      throw Exception('Error adding category: $e');
    }
  }

}