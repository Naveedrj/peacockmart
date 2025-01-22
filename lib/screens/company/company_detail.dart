import 'package:company_panel/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CompanyDetailScreen extends StatelessWidget {
  final Map<String, dynamic> company;

  // Constructor to accept the company details
  CompanyDetailScreen({required this.company});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(
          company['companyName'],
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
                company['companyLogo']??"https://via.placeholder.com/150",
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
                value: company['companyName'],
                icon: Icons.business,
              ),
              _buildInfoSection(
                title: 'Owner Name',
                value: company['ownerName'],
                icon: Icons.person,
              ),
              _buildInfoSection(
                title: 'Owner Email',
                value: company['ownerEmail'],
                icon: Icons.email,
              ),
              _buildInfoSection(
                title: 'Owner Phone',
                value: company['ownerPhone'],
                icon: Icons.phone,
              ),
              _buildInfoSection(
                title: 'Company Address',
                value: company['companyAddress'],
                icon: Icons.location_on,
              ),
              _buildInfoSection(
                title: 'City',
                value: company['companyCity'],
                icon: Icons.location_city,
              ),
              _buildInfoSection(
                title: 'Province',
                value: company['companyProvince'],
                icon: Icons.map,
              ),
              _buildInfoSection(
                title: 'Postal Code',
                value: company['companyPostalCode'],
                icon: Icons.markunread_mailbox,
              ),
              _buildInfoSection(
                title: 'Phone',
                value: company['companyPhone'],
                icon: Icons.phone_android,
              ),
              _buildInfoSection(
                title: 'WhatsApp',
                value: company['companyWhatsapp'],
                icon: FontAwesomeIcons.whatsapp,
              ),
              _buildInfoSection(
                title: 'Website',
                value: company['companyWebsite'],
                icon: Icons.web,
              ),
              _buildInfoSection(
                title: 'Category',
                value: company['companyCategory'],
                icon: Icons.category,
              ),
              _buildInfoSection(
                title: 'Email',
                value: company['companyEmail'],
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
