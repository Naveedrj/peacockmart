import 'package:company_panel/utils/images.dart';
import 'package:flutter/material.dart';

import '../utils/dummy_data.dart';

class ShopsScreen extends StatelessWidget {
  final DummyData data = DummyData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SHOPS'),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSearchBar(),
            SizedBox(height: 10),
            _buildShopCard(
              imageUrl: 'https://via.placeholder.com/150',
              title: 'Tariq Cold Corner',
              subtitle: 'Alam Chowk, Gujranwala',
              rating: 4.6,
              deliveryTime: '30-45 min',
              price: '129',
            ),
            _buildShopCard(
              imageUrl: 'https://via.placeholder.com/150',
              title: 'Aliya shopping center',
              subtitle: 'Main Bazaar, Gujranwala',
              rating: 4.5,
              deliveryTime: '20-40 min',
              price: '99',
            ),
            _buildShopCard(
              imageUrl: 'https://via.placeholder.com/150',
              title: 'Jada Hotel & BBQ',
              subtitle: 'GT Road, Gujranwala',
              rating: 4.8,
              deliveryTime: '40-50 min',
              price: '199',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for shops, distributors & Companies',
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
    required String imageUrl,
    required String title,
    required String subtitle,
    required double rating,
    required String deliveryTime,
    required String price,
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
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          Text(
                            ' $rating',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text('$deliveryTime'),
                      Text('Rs. $price'),
                    ],
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
