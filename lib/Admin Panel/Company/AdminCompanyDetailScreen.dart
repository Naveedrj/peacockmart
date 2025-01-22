import 'package:company_panel/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminCompanyDetailScreen extends StatefulWidget {
  final Map<String, dynamic> company;

  // Constructor to accept the company details
  AdminCompanyDetailScreen({required this.company});

  @override
  State<AdminCompanyDetailScreen> createState() => _AdminCompanyDetailScreenState();
}

class _AdminCompanyDetailScreenState extends State<AdminCompanyDetailScreen> {
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
          widget.company['companyName'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Slider
              Image.network(
                widget.company['companyLogo']??"https://via.placeholder.com/150",
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              /*CarouselSlider(
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
                  aspectRatio: 16 / 9,
                  viewportFraction: 1.0,
                ),
              ),*/
              SizedBox(height: 15),

              // Company Information
              _buildInfoSection(
                title: 'Company Name',
                value: widget.company['companyName'],
                icon: Icons.business,
              ),
              _buildInfoSection(
                title: 'Owner Name',
                value: widget.company['ownerName'],
                icon: Icons.person,
              ),
              _buildInfoSection(
                title: 'Owner Email',
                value: widget.company['ownerEmail'],
                icon: Icons.email,
              ),
              _buildInfoSection(
                title: 'Owner Phone',
                value: widget.company['ownerPhone'],
                icon: Icons.phone,
              ),
              _buildInfoSection(
                title: 'Company Address',
                value: widget.company['companyAddress'],
                icon: Icons.location_on,
              ),
              _buildInfoSection(
                title: 'City',
                value: widget.company['companyCity'],
                icon: Icons.location_city,
              ),
              _buildInfoSection(
                title: 'Province',
                value: widget.company['companyProvince'],
                icon: Icons.map,
              ),
              _buildInfoSection(
                title: 'Postal Code',
                value: widget.company['companyPostalCode'],
                icon: Icons.markunread_mailbox,
              ),
              _buildInfoSection(
                title: 'Phone',
                value: widget.company['companyPhone'],
                icon: Icons.phone_android,
              ),
              _buildInfoSection(
                title: 'WhatsApp',
                value: widget.company['companyWhatsapp'],
                icon: FontAwesomeIcons.whatsapp,
              ),
              _buildInfoSection(
                title: 'Website',
                value: widget.company['companyWebsite'],
                icon: Icons.web,
              ),
              _buildInfoSection(
                title: 'Category',
                value: widget.company['companyCategory'],
                icon: Icons.category,
              ),
              _buildInfoSection(
                title: 'Email',
                value: widget.company['companyEmail'],
                icon: Icons.email_outlined,
              ),
              SizedBox(height: 10),

              // Additional Info Section
              /*_buildInfoSection(
                title: 'Status',
                value: widget.company['status'],
                icon: Icons.info,
              ),
              _buildInfoSection(
                title: 'Reason',
                value: widget.company['reason'],
                icon: Icons.error,
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor),
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
