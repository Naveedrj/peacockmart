import 'package:company_panel/screens/register_company_screen.dart';
import 'package:flutter/material.dart';

import 'company_detail.dart';

class CompanyScreen extends StatelessWidget {
  final String commonImageUrl =
      'https://img.freepik.com/premium-vector/minimalist-type-creative-business-logo-template_1283348-23026.jpg?semt=ais_hybrid';

  // Dummy data
  final List<Map<String, dynamic>> companies = [
    {
      'companyName': 'ABC Tech Pvt Ltd',
      'contactInfo': {
        'headOfficeAddress': '123 Business Avenue, Karachi',
        'contactNumber': '+92-300-1234567',
        'emailAddress': 'info@abctech.com',
        'website': 'www.abctech.com',
      },
      'authorizedPerson': {
        'name': 'Ali Khan',
        'cnic': '12345-6789012-3',
        'contactNumber': '+92-322-4567890',
      },
      'ntn': '123456789',
      'incorporationDate': DateTime(2015, 5, 10),
      'fbrVerificationStatus': true,
      'documents': [
        'Certificate of Incorporation',
        'Tax Return Filings',
        'Bank Statements',
      ],
      'registrationDate': DateTime(2020, 10, 15),
      'companyType': 'Multinational',
      'rating': 4.5,
    },
    {
      'companyName': 'XYZ Solutions',
      'contactInfo': {
        'headOfficeAddress': 'IT Park, Lahore',
        'contactNumber': '+92-321-9876543',
        'emailAddress': 'contact@xyzsolutions.com',
        'website': 'www.xyzsolutions.com',
      },
      'authorizedPerson': {
        'name': 'Sarah Ahmed',
        'cnic': '67890-1234567-8',
        'contactNumber': '+92-311-7654321',
      },
      'ntn': '987654321',
      'incorporationDate': DateTime(2018, 3, 22),
      'fbrVerificationStatus': false,
      'documents': [
        'Certificate of Incorporation',
        'Tax Return Filings',
        'Bank Statements',
      ],
      'registrationDate': DateTime(2021, 1, 25),
      'companyType': 'Local',
      'rating': 3.0,
    },
    {
      'companyName': 'PQR Enterprises',
      'contactInfo': {
        'headOfficeAddress': 'Corporate Zone, Islamabad',
        'contactNumber': '+92-333-2468101',
        'emailAddress': 'support@pqrenterprises.com',
        'website': 'www.pqrenterprises.com',
      },
      'authorizedPerson': {
        'name': 'Zain Malik',
        'cnic': '24680-1357911-4',
        'contactNumber': '+92-340-5678901',
      },
      'ntn': '246801357',
      'incorporationDate': DateTime(2010, 7, 15),
      'fbrVerificationStatus': true,
      'documents': [
        'Certificate of Incorporation',
        'Tax Return Filings',
        'Bank Statements',
      ],
      'registrationDate': DateTime(2019, 6, 12),
      'companyType': 'National',
      'rating': 4.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('COMPANIES',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),
        ),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSearchBar(),
            SizedBox(height: 10),
            ...companies.map((company) => _buildCompanyCard(company,context)).toList(),
          ],
        ),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),  // Adds padding for bigger button
        decoration: BoxDecoration(
          color: Colors.green.shade700,
          borderRadius: BorderRadius.circular(20), // Make it rounded
        ),
        child: TextButton(
          onPressed: () {
            // Navigate to RegisterYourCompanyScreen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterYourCompanyScreen()),
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_business,
                color: Colors.white,
                size: 30,  // Icon size
              ),
              SizedBox(width: 10),  // Space between icon and text
              Text(
                'Register',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,  // Text size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
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

  Widget _buildCompanyCard(Map<String, dynamic> company, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to Company Detail Screen and pass the selected company
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompanyDetailScreen(company: company),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  commonImageUrl,
                  width: double.infinity,
                  height: 180, // Larger image height
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              // Company Name and Type Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      company['companyName'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      company['companyType'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              // Address Section
              Text(
                company['contactInfo']['headOfficeAddress'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 10),
              // Rating and Verification Section
              Row(
                children: [
                  Row(
                    children: List.generate(
                      5,
                          (index) => Icon(
                        index < company['rating'].round()
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '(${company['rating']})',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Icon(
                        company['fbrVerificationStatus']
                            ? Icons.verified
                            : Icons.cancel,
                        color: company['fbrVerificationStatus']
                            ? Colors.green
                            : Colors.red,
                        size: 18,
                      ),
                      SizedBox(width: 5),
                      Text(
                        company['fbrVerificationStatus']
                            ? 'Verified'
                            : 'Unverified',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: company['fbrVerificationStatus']
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15),
              // Contact Info Section
              _buildDetails(company),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetails(Map<String, dynamic> company) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact: ${company['contactInfo']['contactNumber']}',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(
          'Email: ${company['contactInfo']['emailAddress']}',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
