import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CompanyDetailScreen extends StatelessWidget {
  final Map<String, dynamic> company;

  // Constructor to accept the company details
  CompanyDetailScreen({required this.company});

  @override
  Widget build(BuildContext context) {
    // Dummy images list
    final List<String> images = [
      'https://img.freepik.com/free-photo/modern-business-office-desk-with-laptop-notebook-and-coffee-cup_1150-10638.jpg',
      'https://img.freepik.com/free-photo/flat-lay-office-desk-workspace-with-laptop-pen-and-glasses_1150-15919.jpg',
      'https://img.freepik.com/free-photo/business-desk-office-with-laptop-coffee-cup-and-glasses_1150-33435.jpg',
      'https://img.freepik.com/free-photo/office-desk-business-workspace-with-laptop-pens_1150-34000.jpg',
      'https://img.freepik.com/free-photo/top-view-flat-lay-office-desk-with-laptop-and-cup-coffee_1150-15102.jpg',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          company['companyName'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Slider
              CarouselSlider(
                items: images.map((imageUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          imageUrl,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16/9,
                  viewportFraction: 1.0,
                ),
              ),
              SizedBox(height: 15),

              // Company Info Section
              _buildInfoSection(
                title: 'Company Name',
                value: company['companyName'],
                icon: Icons.business,
              ),
              _buildInfoSection(
                title: 'NTN',
                value: company['ntn'],
                icon: Icons.perm_identity,
              ),
              _buildInfoSection(
                title: 'Incorporation Date',
                value: '${company['incorporationDate'].toLocal()}',
                icon: Icons.date_range,
              ),
              _buildInfoSection(
                title: 'Registration Date',
                value: '${company['registrationDate'].toLocal()}',
                icon: Icons.date_range,
              ),
              SizedBox(height: 10),

              // Authorized Person Section
              _buildInfoSection(
                title: 'Authorized Person',
                value: company['authorizedPerson']['name'],
                icon: Icons.person,
              ),
              _buildInfoSection(
                title: 'CNIC',
                value: company['authorizedPerson']['cnic'],
                icon: Icons.card_membership,
              ),
              _buildInfoSection(
                title: 'Contact',
                value: company['authorizedPerson']['contactNumber'],
                icon: Icons.phone,
              ),
              SizedBox(height: 10),

              // Contact Info Section
              _buildInfoSection(
                title: 'Head Office Address',
                value: company['contactInfo']['headOfficeAddress'],
                icon: Icons.location_on,
              ),
              _buildInfoSection(
                title: 'Email',
                value: company['contactInfo']['emailAddress'],
                icon: Icons.email,
              ),
              _buildInfoSection(
                title: 'Website',
                value: company['contactInfo']['website'],
                icon: Icons.web,
              ),
              SizedBox(height: 10),

              // Documents Section
              _buildInfoSection(
                title: 'Documents',
                value: company['documents'].join(', '),
                icon: Icons.folder,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection({required String title, required String value, required IconData icon}) {
    return ListTile(
      leading: Icon(icon, color: Colors.green.shade700),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14,
        ),
      ),
    );
  }
}
