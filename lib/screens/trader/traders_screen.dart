import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_panel/screens/distributor/register_distributor.dart';
import 'package:company_panel/screens/trader/register_trader.dart';
import 'package:company_panel/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/auth_screen.dart';

class TraderScreen extends StatefulWidget {
  @override
  State<TraderScreen> createState() => _TraderScreenState();
}

class _TraderScreenState extends State<TraderScreen> {
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
      appBar: AppBar(
        title: const Text('Traders'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('distributorsAndTraders')
                  .where('userType', isEqualTo: 'trader') // Filter for distributors
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error fetching data'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No Trader found'));
                }

                final distributors = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: distributors.length,
                  itemBuilder: (context, index) {
                    final distributor = distributors[index];
                    return _buildCompanyCard(
                      fullName: distributor['fullName'] ?? 'Unknown Name',
                      contactNumber: distributor['contactNumber'] ?? 'Unknown Contact',
                      email: distributor['email'] ?? 'Unknown Email',
                      businessName: distributor['businessName'] ?? 'Unknown Business',
                      businessAddress: distributor['businessAddress'] ?? 'Unknown Address',
                      imageUrl: distributor['imageUrl'] ?? '', // Add imageUrl
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: userType == true
          ? Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterTraderScreen()),
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_business,
                color: Colors.white,
                size: 30,
              ),
              SizedBox(width: 10),
              Text(
                'Register',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      )
          : null,
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for distributors & more',
          prefixIcon: Icon(Icons.search),
          filled: true,
          fillColor: Colors.green.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyCard({
    required String fullName,
    required String contactNumber,
    required String email,
    required String businessName,
    required String businessAddress,
    required String imageUrl, // Add imageUrl parameter
  }) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: imageUrl.isNotEmpty
                  ? NetworkImage(imageUrl) // Display network image if available
                  : null,
              child: imageUrl.isEmpty
                  ? Icon(
                Icons.person,
                size: 30,
                color: Colors.grey,
              )
                  : null,
              backgroundColor: Colors.green.shade100,
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    businessName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Owner: $fullName',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Address: $businessAddress',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Contact: $contactNumber',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Email: $email',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
