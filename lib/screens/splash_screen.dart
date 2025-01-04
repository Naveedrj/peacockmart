import 'package:company_panel/screens/login_screen.dart';
import 'package:company_panel/utils/colors.dart';
import 'package:company_panel/utils/images.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final String _fullText = "PEACOCK";
  String _displayText = "";
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();

    // Set up the fade animation
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();

    // Start typing effect
    _startTypingEffect();

    // Wait for 3 seconds and navigate to DashboardScreen
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  void _startTypingEffect() {
    Timer.periodic(const Duration(milliseconds: 90), (timer) {
      if (_charIndex < _fullText.length) {
        setState(() {
          _displayText += _fullText[_charIndex];
          _charIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: Image.asset(
                  AppImages.logo, // Replace with your logo path
                  width: 250,
                  height: 250,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _displayText,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      color: Colors.black26,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                'peacock groups private limited',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primaryColor,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      color: Colors.black26,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                backgroundColor: Colors.green,
                strokeWidth: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
