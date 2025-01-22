import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_screen.dart';
import '../utils/colors.dart';

class ProfileWidget extends StatelessWidget {
  final Color color;
  final double radius;
  final bool isHeader;
  const ProfileWidget({super.key, required this.color,required this.radius, required this.isHeader});

  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    final authViewModel = Provider.of<AuthViewModel>(context);

    return FutureBuilder<Map<String, dynamic>>(
      future: authViewModel.getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator(color: AppColors.primaryColor,));
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading user data'));
        }

        final userData = snapshot.data ?? {};
        final String name = userData['name'] ?? 'Unknown User';
        final String imagePath = userData['imagePath'] ?? '';

        return isHeader==false? Container(
          height: 80,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: radius,
                backgroundImage: imagePath.isNotEmpty
                    ? NetworkImage(imagePath)
                    : const AssetImage('assets/images/default_avatar.png')
                as ImageProvider,
                child: imagePath.isEmpty
                    ? const Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.white,
                )
                    : null,
              ),
              const SizedBox(width: 10),
              Text(
                name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),

        ): Container(
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: radius,
                backgroundImage: imagePath.isNotEmpty
                    ? NetworkImage(imagePath)
                    : const AssetImage('assets/images/default_avatar.png')
                as ImageProvider,
                child: imagePath.isEmpty
                    ? const Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.white,
                )
                    : null,
              ),
              const SizedBox(width: 10),
              Text(
                name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
