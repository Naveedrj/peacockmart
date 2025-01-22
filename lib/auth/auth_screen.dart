import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;



  User? _user;
  User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Signup method
  // Method to upload image to Firebase Storage
  Future<String> uploadProfileImage(File imageFile) async {
    try {
      // Create a reference to the Firebase Storage folder
      String fileName = _user!.uid;  // Use the user UID as the file name
      Reference storageReference = _storage.ref().child('peacock_profile_images/$fileName');

      // Upload the file to Firebase Storage
      UploadTask uploadTask = storageReference.putFile(imageFile);

      // Wait for the upload to complete
      TaskSnapshot taskSnapshot = await uploadTask;

      // Retrieve the download URL of the uploaded image
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      debugPrint("Image uploaded successfully. URL: $imageUrl");

      return imageUrl;
    } catch (e) {
      debugPrint("Error uploading image: $e");
      throw Exception("Error uploading image");
    }
  }

  // Signup method
  Future<void> signup(String email, String password, String name, File imageFile) async {
    _setLoading(true);
    try {
      // Create user in Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = userCredential.user;

      // Upload the profile image and get the URL
      String imagePath = await uploadProfileImage(imageFile);

      // Save user data in Firestore
      await _firestore.collection('users').doc(_user!.uid).set({
        'uid': _user!.uid,
        'email': email,
        'name': name,
        'imagePath': imagePath,
        'userType': 'customer',
        'createdAt': FieldValue.serverTimestamp(),
      });

      notifyListeners();
      debugPrint("User signed up successfully and data added to Firestore");
    } catch (e) {
      debugPrint("Signup Error: $e");
    } finally {
      _setLoading(false);
    }
  }

  // Login method
  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      notifyListeners();
      debugPrint("User logged in successfully");
    } catch (e) {
      debugPrint("Login Error: $e");
    } finally {
      _setLoading(false);
    }
  }

  // Logout method
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _auth.signOut();
      _user = null;
      notifyListeners();
      debugPrint("User logged out successfully");
    } catch (e) {
      debugPrint("Logout Error: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>> getUserData() async {
    if (_user != null) {

      DocumentSnapshot userSnapshot =
      await _firestore.collection('users').doc(_user!.uid).get();
      return userSnapshot.data() as Map<String, dynamic>;
    }
    return {}; // Return empty map if no user is logged in
  }
  Future<bool> checkUserType() async {
    try {
      // Fetch user data using getUserData method
      Map<String, dynamic> userData = await getUserData();
      // Check if the userType field exists and equals 'admin'
      if (userData.containsKey('userType') && userData['userType'] == 'customer') {

        return true; // User is an admin
      }
      return false; // User is not an admin
    } catch (e) {
      print('Error checking user type: $e');
      return false; // Return false in case of error
    }
  }Future<String> returnUserType() async {
    try {
      // Fetch user data using getUserData method
      Map<String, dynamic> userData = await getUserData();
      // Check if the userType field exists and equals 'admin'
      if (userData.containsKey('userType')) {

        return userData['userType']; // User is an admin
      }
      return 'customer'; // User is not an admin
    } catch (e) {
      print('Error checking user type: $e');
      return 'customer'; // Return false in case of error
    }
  }
  Future<bool> updateUserType(String newUserType) async {
    try {


      // Check if user is logged in
      if (_user != null) {
        // Update the userType field in Firestore
        await _firestore.collection('users').doc(_user!.uid).update({
          'userType': newUserType,
        });

        print('User type updated successfully to $newUserType.');
        return true; // Successfully updated
      } else {
        print('No user is logged in.');
        return false; // User not logged in
      }
    } catch (e) {
      print('Error updating user type: $e');
      return false; // Error occurred
    }
  }



  // Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
