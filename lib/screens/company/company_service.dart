import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_panel/auth/auth_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CompanyService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final AuthViewModel authViewModel=AuthViewModel();


  Future<bool> registerCompany(
      String ownerName,
      String ownerId,
      String ownerEmail,
      String ownerPhone,
      String ownerGender,
      String ownerFatherName,
      String ownerDob,
      String companyLogo,
      String _companyName,
      String _companyAddress,
      String _companyCity,
      String _companyProvince,
      String _companyPostalCode,
      String _companyLocation,
      String _companyPhone,
      String _companyWhatsapp,
      String _companyWebsite,
      String _companyCategory,
      String _companyEmail,
      BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw 'User is not logged in';
      }

      // Upload the company logo and get the URL
      String companyLogoURL = await uploadCompanyImage(File(companyLogo));

      // Create a new document reference in Firestore
      DocumentReference docRef = _firestore.collection('companies').doc();

      // Create company data, including the companyId (set to the document ID)
      final companyData = {
        'ownerName': ownerName,
        'ownerId': ownerId,
        'ownerEmail': ownerEmail,
        'ownerPhone': ownerPhone,
        'ownerGender': ownerGender,
        'ownerFatherName': ownerFatherName,
        'ownerDob': ownerDob,
        'companyLogo': companyLogoURL,
        'companyName': _companyName,
        'companyAddress': _companyAddress,
        'companyCity': _companyCity,
        'companyProvince': _companyProvince,
        'companyPostalCode': _companyPostalCode,
        'companyLocation': _companyLocation,
        'companyPhone': _companyPhone,
        'companyWhatsapp': _companyWhatsapp,
        'companyWebsite': _companyWebsite,
        'companyCategory': _companyCategory,
        'companyEmail': _companyEmail,
        'userId': user.uid,
        'status': 'pending',
        'reason': 'pending',
        'companyId': docRef.id,  // Set companyId to the document ID
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Add the company data to Firestore with the generated document ID
      await docRef.set(companyData);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Company Registered Successfully')));

      return true;
    } catch (e) {
      // Show error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')));
      return false;
    }
  }

  Future<String> uploadCompanyImage(File imageFile) async {
    try {
      User? _user = _auth.currentUser;

      // Create a reference to the Firebase Storage folder
      String fileName = _user!.uid;  // Use the user UID as the file name
      Reference storageReference = _storage.ref().child('peacock_companies_logo/$fileName');

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


}
