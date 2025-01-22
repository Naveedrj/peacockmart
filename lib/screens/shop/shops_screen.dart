import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_panel/screens/shop/register_shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/auth_screen.dart'; // Import your AuthViewModel

class ShopListScreen extends StatefulWidget {
  @override
  _ShopListScreenState createState() => _ShopListScreenState();
}

class _ShopListScreenState extends State<ShopListScreen> {
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
        title: Text('Shops'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('shops')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error fetching data'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No shops found'));
                }

                final shops = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: shops.length,
                  itemBuilder: (context, index) {
                    final shop = shops[index];
                    return _buildShopCard(
                      shopName: shop['shopName'] ?? 'Unknown Shop',
                      shopAddress: shop['shopAddress'] ?? 'Unknown Address',
                      contactNumber: shop['contactNumber'] ?? 'Unknown Contact',
                      email: shop['email'] ?? 'Unknown Email',
                      imageUrl: shop['imageUrl'] ?? '',
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
          color: Colors.green,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterShopScreen()),
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
                'Register Shop',
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
          hintText: 'Search for shops & more',
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

  Widget _buildShopCard({
    required String shopName,
    required String shopAddress,
    required String contactNumber,
    required String email,
    required String imageUrl,
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
                Icons.store,
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
                    shopName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Address: $shopAddress',
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
