import 'package:flutter/material.dart';

class MartHomePage extends StatefulWidget {
  @override
  State<MartHomePage> createState() => _MartHomePageState();
}

class _MartHomePageState extends State<MartHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        toolbarHeight: 80,
        title: Row(
          children: [
            Icon(Icons.location_on, color: Colors.white),
            SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                Text(
                  '123 Anywhere St., Any City',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
            Spacer(),
            CircleAvatar(
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  'https://via.placeholder.com/400x150',
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: double.infinity,
                  height: 150,
                  color: Colors.black.withOpacity(0.5),
                  alignment: Alignment.center,
                  child: Text(
                    '20% Promo Cashback',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Think your favourite food...',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.green.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryIcon(Icons.fastfood, 'Food'),
                  _buildCategoryIcon(Icons.local_drink, 'Beverage'),
                  _buildCategoryIcon(Icons.local_offer, 'Offers'),
                  _buildCategoryIcon(Icons.more_horiz, 'Others'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Premium Food',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildHorizontalList(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Featured',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildHorizontalList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.green.shade200,
          child: Icon(icon, color: Colors.green.shade700),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildHorizontalList() {
    return Container(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFoodCard(
            imageUrl: 'https://via.placeholder.com/100',
            title: 'Strawberry Bliss Pancakes',
            rating: 4.0,
            price: '2.8',
          ),
          _buildFoodCard(
            imageUrl: 'https://via.placeholder.com/100',
            title: 'Classic Grilled Ribeye',
            rating: 4.5,
            price: '10.9',
          ),
          _buildFoodCard(
            imageUrl: 'https://via.placeholder.com/100',
            title: 'Healthy Salad Bowl',
            rating: 4.2,
            price: '5.0',
          ),
        ],
      ),
    );
  }

  Widget _buildFoodCard({
    required String imageUrl,
    required String title,
    required double rating,
    required String price,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(
              imageUrl,
              width: 120,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 14),
                        Text(' $rating'),
                      ],
                    ),
                    Text('\$$price', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
