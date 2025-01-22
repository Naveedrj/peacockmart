import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_panel/screens/company/company_service.dart';
import 'package:company_panel/screens/company/register_company_owner_screen.dart';
import 'package:company_panel/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/auth_screen.dart';
import 'company_detail.dart';

class CompanyScreen extends StatefulWidget {

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CompanyService companyService = CompanyService();
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
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Companies'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('companies').where('status',isEqualTo: 'accepted')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No pending requests.'));
          }

          final companyDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: companyDocs.length,
            itemBuilder: (context, index) {
              final companyData = companyDocs[index].data() as Map<String, dynamic>;
              final companyId = companyDocs[index].id;

              return Column(
                children: [
                  _buildCompanyCard(companyData, context),

                ],
              );
            },
          );
        },
      ),
      floatingActionButton:   userType==true ? Container(
        padding: EdgeInsets.symmetric(horizontal: 10),  // Adds padding for bigger button
        decoration: BoxDecoration(
          color:AppColors.primaryColor,
          borderRadius: BorderRadius.circular(20), // Make it rounded
        ),
        child: TextButton(
          onPressed: () {
            // Navigate to RegisterYourCompanyScreen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterOwnerScreen()),
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
      ): Container(),
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
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  company['companyLogo'] ?? 'https://via.placeholder.com/150',
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
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
                      company['companyCategory'] ?? 'N/A',
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
              Text(
                company['companyAddress']?? 'Address not available',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  /*Row(
                    children: List.generate(
                      5,
                          (index) => Icon(
                        index < (company['rating']?.round() ?? 0)
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      ),
                    ),
                  ),*/
                  SizedBox(width: 10),
                  /*Text(
                    '(${company['rating'] ?? 0})',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Icon(
                        company['fbrVerificationStatus'] == true
                            ? Icons.verified
                            : Icons.cancel,
                        color: company['fbrVerificationStatus'] == true
                            ? Colors.green
                            : Colors.red,
                        size: 18,
                      ),
                      SizedBox(width: 5),
                      Text(
                        company['fbrVerificationStatus'] == true
                            ? 'Verified'
                            : 'Unverified',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: company['fbrVerificationStatus'] == true
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),*/
                ],
              ),
              SizedBox(height: 15),
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
          'Contact: ${company['companyPhone'] ?? 'N/A'}',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(
          'Email: ${company['companyEmail'] ?? 'N/A'}',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
