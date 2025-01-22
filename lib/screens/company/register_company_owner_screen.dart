import 'package:company_panel/screens/company/register_company_2.dart';
import 'package:company_panel/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterOwnerScreen extends StatefulWidget {
  @override
  _RegisterOwnerScreenState createState() => _RegisterOwnerScreenState();
}

class _RegisterOwnerScreenState extends State<RegisterOwnerScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _ownerIdController = TextEditingController();
  final TextEditingController _ownerEmailController = TextEditingController();
  final TextEditingController _ownerPhoneController = TextEditingController();
  final TextEditingController _ownerFatherNameController = TextEditingController();

  String? _selectedGender;
  DateTime? _ownerDob;
  bool isLoading = false;

  Future<void> _pickDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        _ownerDob = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Owner'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildGenericTextField(
                  label: 'Owner Name',
                  controller: _ownerNameController,
                  validationType: 'text',
                ),
                _buildGenericTextField(
                  label: 'Owner CNIC (13 digits)',
                  controller: _ownerIdController,
                  validationType: 'cnic',
                ),
                _buildGenericTextField(
                  label: 'Owner Gmail ID',
                  controller: _ownerEmailController,
                  validationType: 'email',
                ),
                _buildGenericTextField(
                  label: 'Owner Phone Number (11 digits)',
                  controller: _ownerPhoneController,
                  validationType: 'phone',
                ),
                _buildGenderDropdown(),
                _buildGenericTextField(
                  label: 'Owner Father\'s Name',
                  controller: _ownerFatherNameController,
                  validationType: 'text',
                ),
                _buildDatePicker('Owner Date of Birth', _ownerDob),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading
                      ? null // Disable the button if loading
                      : () async {
                    if (_formKey.currentState!.validate() && _selectedGender != null) {
                      setState(() {
                        isLoading = true; // Set loading to true
                      });

                      // Simulate some delay for registration
                      await Future.delayed(Duration(seconds: 2));

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterCompanyScreen(
                            ownerName: _ownerNameController.text,
                            ownerId: _ownerIdController.text,
                            ownerEmail: _ownerEmailController.text,
                            ownerPhone: _ownerPhoneController.text,
                            ownerGender: _selectedGender!,
                            ownerFatherName: _ownerFatherNameController.text,
                            ownerDob: _ownerDob?.toIso8601String() ?? '',
                          ),
                        ),
                      );

                      setState(() {
                        isLoading = false; // Set loading to false after navigation
                      });
                    } else if (_selectedGender == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select a gender')),
                      );
                    }
                  },
                  child: isLoading
                      ? const CupertinoActivityIndicator(color: Colors.green,)
                      : const Text(
                    'Next',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor, // Dark green color
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                    elevation: 5, // Optional: Add elevation to give it a shadow effect
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenericTextField({
    required String label,
    required TextEditingController controller,
    required String validationType,
  }) {
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
            hintText: label,  // Display label as hint text
            icon: Icon(
              _getIconForValidationType(validationType),
              color: Colors.green.shade700,  // You can customize the icon color
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label is required';
            }

            // Validation logic based on the validationType parameter
            if (validationType == 'email' &&
                !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Enter a valid email';
            } else if (validationType == 'cnic' && value.length != 13) {
              return 'Enter a valid 13-digit CNIC';
            } else if (validationType == 'phone' && value.length != 11) {
              return 'Enter a valid 11-digit phone number';
            } else if (validationType == 'text' && value.trim().isEmpty) {
              return 'This field cannot be empty';
            }

            return null;
          },
          keyboardType: _getKeyboardType(validationType),
        ),
      ),
    );
  }

// Helper method to get the appropriate icon based on the validation type
  IconData _getIconForValidationType(String validationType) {
    switch (validationType) {
      case 'email':
        return Icons.email;
      case 'cnic':
        return Icons.credit_card;
      case 'phone':
        return Icons.phone;
      case 'text':
      default:
        return Icons.text_fields;
    }
  }

// Helper method to return the correct keyboard type based on validation type
  TextInputType _getKeyboardType(String validationType) {
    switch (validationType) {
      case 'email':
        return TextInputType.emailAddress;
      case 'cnic':
      case 'phone':
        return TextInputType.number;
      case 'text':
      default:
        return TextInputType.text;
    }
  }


  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButtonFormField<String>(
          value: _selectedGender,
          items: ['Male', 'Female', 'Other']
              .map((gender) => DropdownMenuItem(
            value: gender,
            child: Text(gender),
          ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedGender = value;
            });
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Select Gender',
            icon: Icon(
              Icons.accessibility_new,  // Custom icon for gender
              color: Colors.green.shade700,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a gender';
            }
            return null;
          },
        ),
      ),
    );
  }


  Widget _buildDatePicker(String label, DateTime? date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: () => _pickDate(context),
          child: InputDecorator(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: label,
              icon: Icon(
                Icons.calendar_today,
                color: Colors.green.shade700,  // Custom icon color
              ),
            ),
            child: Text(date == null ? 'Select date' : '${date.toLocal()}'.split(' ')[0]),
          ),
        ),
      ),
    );
  }

}
