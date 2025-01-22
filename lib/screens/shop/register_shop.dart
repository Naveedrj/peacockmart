import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:company_panel/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For uploading image

class RegisterShopScreen extends StatefulWidget {
  @override
  _RegisterShopScreenState createState() => _RegisterShopScreenState();
}

class _RegisterShopScreenState extends State<RegisterShopScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _shopAddressController = TextEditingController();
  final TextEditingController _ntnController = TextEditingController();

  File? _shopImage; // Placeholder for shop image upload functionality

  bool isLoading = false;

  Future<void> _pickShopImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _shopImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(String ownerId) async {
    if (_shopImage == null) return null;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('shopImages')
          .child('$ownerId.jpg');
      await storageRef.putFile(_shopImage!);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _registerShop() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      String ownerId = FirebaseAuth.instance.currentUser!.uid;

      // Upload shop image
      String? imageUrl = await _uploadImage(ownerId);

      // Add shop data to Firestore
      await FirebaseFirestore.instance.collection('shops').add({
        'ownerId': ownerId,
        'fullName': _fullNameController.text,
        'cnic': _cnicController.text,
        'contactNumber': _contactNumberController.text,
        'email': _emailController.text,
        'shopName': _shopNameController.text,
        'shopAddress': _shopAddressController.text,
        'ntn': _ntnController.text,
        'imageUrl': imageUrl,
        'userType': 'shop-owner',
      });

      // Update user type to shop-owner
      await FirebaseFirestore.instance.collection('users').doc(ownerId).update({
        'userType': 'shop-owner',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Shop registered successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error registering shop: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Shop'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildShopImageAvatar(),
                SizedBox(height: 10),
                _buildGenericTextField(
                  label: 'Full Name',
                  controller: _fullNameController,
                  validationType: 'text',
                ),
                _buildGenericTextField(
                  label: 'CNIC/ID Number (13 digits)',
                  controller: _cnicController,
                  validationType: 'cnic',
                ),
                _buildGenericTextField(
                  label: 'Contact Number (11 digits)',
                  controller: _contactNumberController,
                  validationType: 'phone',
                ),
                _buildGenericTextField(
                  label: 'Email Address',
                  controller: _emailController,
                  validationType: 'email',
                ),
                _buildGenericTextField(
                  label: 'Shop Name',
                  controller: _shopNameController,
                  validationType: 'text',
                ),
                _buildGenericTextField(
                  label: 'Shop Address',
                  controller: _shopAddressController,
                  validationType: 'text',
                ),
                _buildGenericTextField(
                  label: 'NTN (National Tax Number)',
                  controller: _ntnController,
                  validationType: 'text',
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _pickShopImage,
                  child: Text('Upload Shop Image'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading ? null : _registerShop,
                  child: isLoading
                      ? CupertinoActivityIndicator(color: Colors.white)
                      : Text(
                    'Register',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShopImageAvatar() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: _shopImage != null
              ? FileImage(_shopImage!)
              : AssetImage('assets/images/placeholder.png') as ImageProvider,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _pickShopImage,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: AppColors.primaryColor,
              child: Icon(Icons.camera_alt, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenericTextField({
    required String label,
    required TextEditingController controller,
    required String validationType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: label,
            icon: Icon(
              _getIconForValidationType(validationType),
              color: Colors.green.shade700,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label is required';
            }
            if (validationType == 'email' &&
                !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Enter a valid email';
            } else if (validationType == 'cnic' && value.length != 13) {
              return 'Enter a valid 13-digit CNIC';
            } else if (validationType == 'phone' && value.length != 11) {
              return 'Enter a valid 11-digit phone number';
            }
            return null;
          },
          keyboardType: _getKeyboardType(validationType),
        ),
      ),
    );
  }

  IconData _getIconForValidationType(String validationType) {
    switch (validationType) {
      case 'email':
        return Icons.email;
      case 'cnic':
        return Icons.credit_card;
      case 'phone':
        return Icons.phone;
      case 'text':
      default:
        return Icons.text_fields;
    }
  }

  TextInputType _getKeyboardType(String validationType) {
    switch (validationType) {
      case 'email':
        return TextInputType.emailAddress;
      case 'cnic':
      case 'phone':
        return TextInputType.number;
      case 'text':
      default:
        return TextInputType.text;
    }
  }
}
