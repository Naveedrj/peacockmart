import 'package:flutter/material.dart';

class RegisterYourCompanyScreen extends StatefulWidget {
  @override
  _RegisterYourCompanyScreenState createState() =>
      _RegisterYourCompanyScreenState();
}

class _RegisterYourCompanyScreenState extends State<RegisterYourCompanyScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form field controllers
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _headOfficeAddressController =
  TextEditingController();
  final TextEditingController _contactNumberController =
  TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _authorizedPersonNameController =
  TextEditingController();
  final TextEditingController _authorizedPersonCnicController =
  TextEditingController();
  final TextEditingController _authorizedPersonContactController =
  TextEditingController();
  final TextEditingController _ntnController = TextEditingController();

  DateTime? _incorporationDate;
  DateTime? _registrationDate;
  bool _isFbrVerified = false;
  List<String> _documents = ['Certificate of Incorporation', 'Tax Return Filings', 'Bank Statements'];

  // Method to pick date for incorporation and registration dates
  Future<void> _pickDate(BuildContext context, bool isIncorporationDate) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        if (isIncorporationDate) {
          _incorporationDate = pickedDate;
        } else {
          _registrationDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Company',
            style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
        ),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fill in your company details below:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _buildTextField('Company Name', _companyNameController),
                _buildTextField('Head Office Address', _headOfficeAddressController),
                _buildTextField('Contact Number', _contactNumberController),
                _buildTextField('Email Address', _emailController),
                _buildTextField('Website', _websiteController, isOptional: true),
                _buildTextField('Authorized Person Name', _authorizedPersonNameController),
                _buildTextField('Authorized Person CNIC', _authorizedPersonCnicController),
                _buildTextField('Authorized Person Contact Information', _authorizedPersonContactController),
                _buildTextField('NTN (National Tax Number)', _ntnController),
                SizedBox(height: 10),
                // Incorporation Date picker
                _buildDatePicker('Incorporation Date', _incorporationDate, true),
                // Registration Date picker
                _buildDatePicker('Registration Date', _registrationDate, false),
                SizedBox(height: 10),
                // FBR Verification Toggle
                SwitchListTile(
                  title: Text('FBR Verification Status'),
                  value: _isFbrVerified,
                  onChanged: (value) {
                    setState(() {
                      _isFbrVerified = value;
                    });
                  },
                  activeColor: Colors.green.shade700,
                ),
                SizedBox(height: 10),
                // Display Documents
                _buildDocumentsSection(),
                SizedBox(height: 20),
                // Submit Button

              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Handle form submission
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Company Registered Successfully')));
              }
            },
            child: Text('Register Company',
            style: TextStyle(
              color: Colors.white
            ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              padding: EdgeInsets.symmetric(vertical: 15),
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isOptional = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter $label',
            icon: Icon(
              label == 'Email Address' ? Icons.email : Icons.person, // Change the icon based on label
              color: Colors.green.shade700,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return isOptional ? null : '$label is required';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime? date, bool isIncorporationDate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => _pickDate(context, isIncorporationDate),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
          ),
          child: Text(
            date == null ? 'Select date' : '${date.toLocal()}'.split(' ')[0],
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Documents (Required):',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        for (var document in _documents)
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text('• $document', style: TextStyle(color: Colors.grey.shade700)),
          ),
      ],
    );
  }
}
