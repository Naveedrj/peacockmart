import 'package:company_panel/Admin%20Panel/Company/company_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../auth/auth_screen.dart';
import '../../utils/colors.dart';
import 'AdminCompanyDetailScreen.dart';

class CompanyRegisterRequest extends StatefulWidget {
  @override
  State<CompanyRegisterRequest> createState() => _CompanyRegisterRequestState();
}

class _CompanyRegisterRequestState extends State<CompanyRegisterRequest> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CompanyService companyService = CompanyService();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Register Requests'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('companies')
            .where('status', isEqualTo: 'pending')
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
    );
  }

  Widget _buildCompanyCard(Map<String, dynamic> company, BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return GestureDetector(
      onTap: () {
        // Navigate to Company Detail Screen and pass the selected company
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminCompanyDetailScreen(company: company),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      companyService.updateStatus(company['companyId'], 'accepted');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      maximumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Accept'),
                  ),
                  ElevatedButton(

                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          TextEditingController reasonController =
                          TextEditingController();

                          return AlertDialog(
                            title: const Text('Reject Request'),
                            content: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                controller: reasonController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter Reason",
                                  icon: Icon(Icons.email, color: AppColors.primaryColor),
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel',style: TextStyle(color: Colors.black.withOpacity(0.6)),),
                              ),
                              ElevatedButton(
                                style:ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  foregroundColor: Colors.white
                                ),
                                onPressed: () {
                                  companyService.updateStatus(
                                    company['companyId'],
                                    'rejected',
                                    reason: reasonController.text.trim(),
                                  );
                                  authViewModel.updateUserType('customer');

                                  Navigator.pop(context);
                                },
                                child: const Text('Reject'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      maximumSize: const Size(double.infinity, 50),

                    ),
                    child: const Text('Reject'),
                  ),
                ],
              ),
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
