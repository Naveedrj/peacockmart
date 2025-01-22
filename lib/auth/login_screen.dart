import 'package:company_panel/Admin%20Panel/category/category_List.dart';
import 'package:company_panel/screens/peacock%20home/dashboard_screen.dart';
import 'package:company_panel/auth/signup.dart';
import 'package:company_panel/utils/colors.dart';
import 'package:company_panel/utils/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onLongPress: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryListScreen()));
                },
                child: Image.asset(
                  AppImages.logo, // Replace with your logo asset path
                  height: 100,
                ),
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
                'LOGIN',
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
              const SizedBox(height: 30),
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
                    suffixIcon: Icon(Icons.visibility, color: AppColors.primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Login Button
              SizedBox(
                height: 55,
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  ),
                  onPressed: authViewModel.isLoading
                      ? null
                      : () async {
                    await authViewModel.login(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                    );
        
                    if (authViewModel.user != null) {
                      // Navigate to DashboardScreen after successful login
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const DashboardScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Login failed. Please try again."),
                        ),
                      );
                    }
                  },
                  child: authViewModel.isLoading
                      ? const CupertinoActivityIndicator(color: Colors.green,)
                      : const Text(
                    "LOGIN",
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
                style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  );
                },
                child: const Text(
                  "Sign Up?",
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
