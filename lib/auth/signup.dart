import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker package
import 'package:company_panel/auth/login_screen.dart';
import 'package:company_panel/utils/colors.dart';
import 'package:company_panel/utils/images.dart';

import 'auth_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _showImagePicker() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () async {
                  final pickedFile =
                  await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _imageFile = File(pickedFile.path);
                    });
                  }
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text("Camera"),
                onTap: () async {
                  final pickedFile =
                  await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _imageFile = File(pickedFile.path);
                    });
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.logo,
                height: 100,
              ),
              const SizedBox(height: 10),
              const Text(
                'Welcome to Peacock',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                  letterSpacing: 2,
                ),
              ),
              const Text(
                'Keep your data safe',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              // Profile Image
              GestureDetector(
                onTap: _showImagePicker,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                  _imageFile != null ? FileImage(_imageFile!) : null,
                  child: _imageFile == null
                      ? const Icon(
                    Icons.camera_alt,
                    size: 50,
                    color: Colors.white,
                  )
                      : null,
                  backgroundColor: Colors.grey.withOpacity(0.3),
                ),
              ),
              const SizedBox(height: 20),
              // Username Input
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter your Name",
                    icon: Icon(Icons.person, color: AppColors.primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Email Input
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter your Email",
                    icon: Icon(Icons.email, color: AppColors.primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Password Input
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter your Password",
                    icon: Icon(Icons.lock, color: AppColors.primaryColor),
                    suffixIcon:
                    Icon(Icons.visibility, color: AppColors.primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Sign Up Button
              SizedBox(
                height: 55,
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 40),
                  ),
                  onPressed: authViewModel.isLoading
                      ? null
                      : () async {
                    if (_imageFile == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                          Text("Please select a profile image."),
                        ),
                      );
                      return;
                    }
                    await authViewModel.signup(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                      _nameController.text.trim(),
                      File(_imageFile!.path),
                    );

                    if (authViewModel.user != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Sign up successful! Please log in."),
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Sign up failed. Please try again."),
                        ),
                      );
                    }
                  },
                  child: authViewModel.isLoading
                      ? const CupertinoActivityIndicator(color: Colors.green,)
                      : const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: true,
                        onChanged: (value) {},
                        activeColor: AppColors.primaryColor,
                      ),
                      const Text("Remember me"),
                    ],
                  ),
                ],
              ),
              const Text(
                "Forget Password?",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 10),
              const Text(
                "OR",
                style:
                TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text(
                  "Log in?",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
