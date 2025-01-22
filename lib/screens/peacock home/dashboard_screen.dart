import 'package:company_panel/screens/company/companies_screen.dart';
import 'package:company_panel/screens/distributor/distributors_screen.dart';
import 'package:company_panel/auth/login_screen.dart';
import 'package:company_panel/screens/mart/mart_home.dart';
import 'package:company_panel/auth/signup.dart';
import 'package:company_panel/screens/peacock%20home/drawer/CustomDrawer.dart';
import 'package:company_panel/screens/shop/shops_screen.dart';
import 'package:company_panel/screens/trader/traders_screen.dart';
import 'package:company_panel/utils/colors.dart';
import 'package:company_panel/utils/images.dart';
import 'package:company_panel/widgets/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../auth/auth_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  bool userType = false;


  @override
  void initState() {
    super.initState();
    fetchUserType(); // Fetch user type in initState
  }

  Future<void> fetchUserType() async {
    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      bool type = await authViewModel.checkUserType();
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
    return Scaffold(
      backgroundColor: AppColors.lighterbackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileWidget(color: AppColors.primaryColor,radius: 50,isHeader: false,),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w300,
                        fontSize: 12
                      ),
                      hintText: "Search for shops, distributer & Companies",
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: Colors.black54),
                    ),
                  ),
                ),
              ),
            ),

            // Staggered Grid View
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: StaggeredGrid.count(
                crossAxisCount: 4, // Number of columns
                mainAxisSpacing: 8, // Vertical spacing
                crossAxisSpacing: 8, // Horizontal spacing
                children: [
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2, // Spans 2 columns
                    mainAxisCellCount: 3, // Spans 2 rows
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => CompanyScreen()));
                      },
                        child: _buildCategoryCard('Companies', AppImages.company)
                    ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2, // Spans 2 columns
                    mainAxisCellCount: 1.5, // Spans 1 row
                    child: GestureDetector(
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => DistributorScreen()));
                        },
                        child: _buildCategoryCard('Distributors', AppImages.distributor)),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2, // Spans 1 column
                    mainAxisCellCount: 1.5, // Spans 1 row
                    child: GestureDetector(
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => TraderScreen()));
                        },
                        child: _buildCategoryCard('Traders', AppImages.trader)),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 4, // Spans 1 column
                    mainAxisCellCount: 1.5, // Spans 1 row
                    child: GestureDetector(
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ShopListScreen()));
                        },
                        child: _buildCategoryCard('SHOPS', AppImages.shop)),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 4, // Spans 4 columns (full width)
                    mainAxisCellCount: 2, // Spans 2 rows
                    child: Stack(
                      children:[
                        Positioned(
                            child: Image.asset(
                              AppImages.logo,
                              height: 120,
                            ),
                          top: 0,
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => MartHomePage()));
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(height: 8.0),
                                Text(
                                  'PEACOCK MART 🏬',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Category Card Widget
  Widget _buildCategoryCard(String title, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: title == 'PEACOCK MART' ? AppColors.lightBackground : AppColors.primaryColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 50,
          ),
          const SizedBox(height: 8.0),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.lighterbackground,
            ),
          ),
        ],
      ),
    );
  }
}
