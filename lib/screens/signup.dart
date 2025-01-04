import 'package:company_panel/screens/login_screen.dart';
import 'package:company_panel/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:company_panel/utils/colors.dart';
import 'package:company_panel/utils/images.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.logo, // Replace with your logo asset path
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
            const SizedBox(height: 30),
            // Email Input
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child:  TextField(
                decoration: InputDecoration(
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
              child: const TextField(
                obscureText: true,
                decoration: InputDecoration(
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
                onPressed: () {
                  // Handle Login Logic
                },
                child: const Text(
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
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: (){
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
    );
  }
}
