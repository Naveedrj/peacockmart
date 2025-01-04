import 'package:flutter/material.dart';

class DistributorScreen extends StatelessWidget {
  final String commonImageUrl = 'https://img.freepik.com/premium-vector/minimalist-type-creative-business-logo-template_1283348-23026.jpg?semt=ais_hybrid'; // Change this link once, applies to all

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DISTRIBUTORS'),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSearchBar(),
            SizedBox(height: 10),
            _buildCompanyCard(
              title: 'ABC Tech Pvt Ltd',
              subtitle: '123 Business Avenue, Karachi',
              rating: 4.7,
              deliveryTime: '1-2 days',
              price: '2999',
            ),
            _buildCompanyCard(
              title: 'XYZ Solutions',
              subtitle: 'IT Park, Lahore',
              rating: 4.5,
              deliveryTime: '2-3 days',
              price: '1999',
            ),
            _buildCompanyCard(
              title: 'PQR Enterprises',
              subtitle: 'Corporate Zone, Islamabad',
              rating: 4.8,
              deliveryTime: '1-2 days',
              price: '3999',
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
          hintText: 'Search for companies, industries & more',
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
                commonImageUrl, // Reusable link
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
