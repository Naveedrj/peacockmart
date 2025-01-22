import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void updateStatus(String companyId, String status, {String? reason}) {
    _firestore.collection('companies').doc(companyId).update({
      'status': status,
      'reason': reason ?? 'N/A', // Default reason if not provided
    });
  }

}