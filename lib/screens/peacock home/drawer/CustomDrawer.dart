import 'package:company_panel/auth/login_screen.dart';
import 'package:company_panel/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/auth_screen.dart';
import '../../../widgets/profile_widget.dart';

class CustomDrawer extends StatefulWidget {
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String userType = 'customer';

  @override
  void initState() {
    super.initState();
    fetchUserType(); // Fetch user type in initState
  }

  Future<void> fetchUserType() async {
    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      String type = await authViewModel.returnUserType();
      if (mounted) {
        setState(() {
          userType = type;
        });
      }
    } catch (e) {
      print('Error fetching user type: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primaryColor),
            child: ProfileWidget(color: Colors.white,radius: 50,isHeader: true,),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // CREATE YOUR BUSINESS button
                userType!='customer'?Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle navigation
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$userType dashboard',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ): Container(),
                SizedBox(height: 10),

                // Drawer options
                _buildDrawerItem('OFFERS', Icons.local_offer, () {}),
                _buildDrawerItem('VOUCHERS', Icons.card_giftcard, () {}),
                _buildDrawerItem('Favourites', Icons.favorite, () {}),
                _buildDrawerItem(
                    'Orders & Reordering', Icons.shopping_cart, () {}),
                _buildDrawerItem('View profile', Icons.person, () {}),
                _buildDrawerItem('Addresses', Icons.location_on, () {}),
                _buildDrawerItem('Peacock Rewards', Icons.star, () {}),
                _buildDrawerItem('Help center', Icons.help, () {}),
                _buildDrawerItem('Invite friends', Icons.share, () {}),

                Divider(),

                // Footer options
                _buildDrawerItem('Settings', Icons.settings, () {}),
                _buildDrawerItem(
                    'Terms & Conditions / Privacy', Icons.description, () {}),
                _buildDrawerItem('Log out', Icons.logout, () {
                  
                  authViewModel.logout();
                  
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (route)=>false);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor),
      title: Text(title, style: TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
