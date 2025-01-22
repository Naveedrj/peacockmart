import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:company_panel/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For uploading image

class RegisterTraderScreen extends StatefulWidget {
  @override
  _RegisterTraderScreenState createState() => _RegisterTraderScreenState();
}

class _RegisterTraderScreenState extends State<RegisterTraderScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessAddressController = TextEditingController();
  final TextEditingController _ntnController = TextEditingController();

  File? _bankStatement; // Placeholder for file upload functionality
  File? _profileImage; // Placeholder for the image file

  bool isLoading = false;

  Future<void> _pickBankStatement() async {
    // Implement file picker logic here
    // Set the selected file to _bankStatement
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(String ownerId) async {
    if (_profileImage == null) return null;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('distributorImages')
          .child('$ownerId.jpg');
      await storageRef.putFile(_profileImage!);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _registerDistributor() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      String ownerId = FirebaseAuth.instance.currentUser!.uid;

      // Upload profile image
      String? imageUrl = await _uploadImage(ownerId);

      // Add distributor data to Firestore
      await FirebaseFirestore.instance.collection('distributorsAndTraders').add({
        'ownerId': ownerId,
        'fullName': _fullNameController.text,
        'cnic': _cnicController.text,
        'contactNumber': _contactNumberController.text,
        'email': _emailController.text,
        'businessName': _businessNameController.text,
        'businessAddress': _businessAddressController.text,
        'ntn': _ntnController.text,
        'bankStatement': _bankStatement != null ? 'Uploaded' : 'Not Uploaded',
        'userType': 'trader',
        'imageUrl': imageUrl,
      });

      // Update user type
      await FirebaseFirestore.instance.collection('users').doc(ownerId).update({
        'userType': 'trader',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Trader registered successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error registering distributor: $e')),
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
        title: const Text('Register Trader'),
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
                _buildProfileAvatar(),
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
                  label: 'Business Name (if applicable)',
                  controller: _businessNameController,
                  validationType: 'text',
                ),
                _buildGenericTextField(
                  label: 'Business Address',
                  controller: _businessAddressController,
                  validationType: 'text',
                ),
                _buildGenericTextField(
                  label: 'NTN (National Tax Number)',
                  controller: _ntnController,
                  validationType: 'text',
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _pickBankStatement,
                  child: Text('Upload Bank Statement'),
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
                  onPressed: isLoading ? null : _registerDistributor,
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: _profileImage != null
              ? FileImage(_profileImage!)
              : AssetImage('assets/images/placeholder.png') as ImageProvider,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _pickImage,
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
