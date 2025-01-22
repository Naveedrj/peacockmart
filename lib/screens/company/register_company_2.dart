import 'package:company_panel/Admin%20Panel/category/category_service.dart';
import 'package:company_panel/screens/company/company_service.dart';
import 'package:company_panel/screens/peacock%20home/dashboard_screen.dart';
import 'package:company_panel/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/auth_screen.dart';
import '../../widgets/ImagePickerWidget.dart';

class RegisterCompanyScreen extends StatefulWidget {
  final String ownerName;
  final String ownerId;
  final String ownerEmail;
  final String ownerPhone;
  final String ownerGender;
  final String ownerFatherName;
  final String ownerDob;

  RegisterCompanyScreen({
    required this.ownerName,
    required this.ownerId,
    required this.ownerEmail,
    required this.ownerPhone,
    required this.ownerGender,
    required this.ownerFatherName,
    required this.ownerDob,
  });

  @override
  _RegisterCompanyScreenState createState() => _RegisterCompanyScreenState();
}

class _RegisterCompanyScreenState extends State<RegisterCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  final CompanyService companyService = CompanyService();

  // Form field controllers
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyAddressController = TextEditingController();
  final TextEditingController _companyPostalCodeController = TextEditingController();
  final TextEditingController _companyLocationController = TextEditingController();
  final TextEditingController _companyPhoneController = TextEditingController();
  final TextEditingController _companyWhatsappController = TextEditingController();
  final TextEditingController _companyWebsiteController = TextEditingController();
  final TextEditingController _companyCategoryController = TextEditingController();
  final TextEditingController _companyEmailController = TextEditingController();
  String companyLogo = "";
  bool isLoading = false;

  // Dropdown values
  String? selectedProvince;
  String? selectedCity;
  String? selectedCategory;
  List<String> categories = [];
  final CategoryService categoryService=CategoryService();
  @override
  void initState() {
    super.initState();
    // Fetch categories when the screen is initialized
    _fetchCategories();
  }
  // Fetch categories from Firestore
  Future<void> _fetchCategories() async {
    try {
      List<String> fetchedCategories = await categoryService.getCategories();
      setState(() {
        categories = fetchedCategories; // Update the list of categories
      });
    } catch (e) {
      // Handle any errors here (maybe show a snackbar or alert dialog)
      print('Error fetching categories: $e');
    }
  }

  // List of provinces and cities
  final Map<String, List<String>> provinceCityMap = {
    'Punjab': [
      'Lahore',
      'Faisalabad',
      'Multan',
      'Rawalpindi',
      'Gujranwala',
      'Sialkot',
      'Bahawalpur',
      'Sargodha',
      'Rahim Yar Khan',
      'Sheikhupura',
      'Okara',
      'Jhelum',
      'Kasur'
    ],
    'Sindh': [
      'Karachi',
      'Hyderabad',
      'Sukkur',
      'Larkana',
      'Nawabshah',
      'Mirpurkhas',
      'Thatta',
      'Badin',
      'Khairpur',
      'Jacobabad',
    ],
    'Khyber Pakhtunkhwa': [
      'Peshawar',
      'Mardan',
      'Abbottabad',
      'Swat',
      'Mansehra',
      'Kohat',
      'Dera Ismail Khan',
      'Bannu',
      'Charsadda',
      'Nowshera',
    ],
    'Balochistan': [
      'Quetta',
      'Gwadar',
      'Zhob',
      'Khuzdar',
      'Turbat',
      'Sibi',
      'Chaman',
      'Dera Murad Jamali',
      'Lasbela',
      'Panjgur',
    ],
    'Islamabad Capital Territory': ['Islamabad'],
    'Azad Jammu and Kashmir': [
      'Muzaffarabad',
      'Mirpur',
      'Kotli',
      'Rawalakot',
      'Bagh',
      'Bhimber',
    ],
    'Gilgit-Baltistan': [
      'Gilgit',
      'Skardu',
      'Hunza',
      'Chilas',
      'Ghizer',
      'Diamer',
      'Ghanche',
    ],
  };

  // Generic text field builder
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
            hintText: label,
            icon: Icon(
              _getIcon(validationType),
              color: Colors.green.shade700,  // Custom icon color
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
            } else if (validationType == 'number' &&
                !RegExp(r'^[0-9]+$').hasMatch(value)) {
              return 'Enter a valid number';
            } else if (validationType == 'phone' &&
                !RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
              return 'Enter a valid phone number';
            } else if (validationType == 'url' &&
                !RegExp(r'^(https?:\/\/[^\s]+)$').hasMatch(value)) {
              return 'Enter a valid URL';
            }

            return null;
          },
          keyboardType: _getKeyboardType(validationType),
        ),
      ),
    );
  }

  IconData _getIcon(String validationType) {
    switch (validationType) {
      case 'email':
        return Icons.email;
      case 'number':
        return Icons.numbers;
      case 'phone':
        return Icons.phone;
      case 'url':
        return Icons.link;
      default:
        return Icons.text_fields;
    }
  }

  TextInputType _getKeyboardType(String validationType) {
    switch (validationType) {
      case 'email':
        return TextInputType.emailAddress;
      case 'number':
        return TextInputType.number;
      case 'phone':
        return TextInputType.phone;
      case 'url':
        return TextInputType.url;
      default:
        return TextInputType.text;
    }
  }


  Widget _buildCategoryDropdown(List<String> categories,) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: categories.isNotEmpty
            ? DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Company Category',
            border: InputBorder.none,
            icon:Icon(Icons.category,color: Colors.green.shade700,size: 20,),
          ),

          value: selectedCategory,
          items: categories
              .map((category) => DropdownMenuItem(
            value: category,
            child: Text(category),
          ))
              .toList(),
          onChanged: (value) {
            // Update the selected category
            setState(() {
              selectedCategory = value;
              print(selectedCategory);
            });
          },
          validator: (value) =>
          value == null ? 'Category is required' : null,
        )
            : CupertinoActivityIndicator(), // Cupertino Activity Indicator
      ),
    );
  }
  Widget _buildProvinceCityDropdowns() {
    return Column(
      children: [
        // Province Dropdown
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Province',
                border: InputBorder.none,
                icon: Icon(Icons.location_city,color: Colors.green.shade700,), // Icon added to the Province dropdown
              ),
              value: selectedProvince,
              items: provinceCityMap.keys
                  .map((province) => DropdownMenuItem(
                value: province,
                child: Text(province),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedProvince = value;
                  selectedCity = null; // Reset city selection
                });
              },
              validator: (value) => value == null ? 'Province is required' : null,
            ),
          ),
        ),
        // City Dropdown (locked until a province is selected)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'City',
                border: InputBorder.none,

                icon: Icon(Icons.location_on,color: Colors.green.shade700), // Icon added to the City dropdown
              ),
              value: selectedCity,
              items: selectedProvince != null
                  ? provinceCityMap[selectedProvince!]!
                  .map((city) => DropdownMenuItem(
                value: city,
                child: Text(city),
              ))
                  .toList()
                  : [],
              onChanged: selectedProvince != null
                  ? (value) {
                setState(() {
                  selectedCity = value;
                });
              }
                  : null, // Disable the city dropdown until a province is selected
              validator: (value) => value == null ? 'City is required' : null,
            ),
          ),
        ),
      ],
    );
  }







  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Register Company Information'),
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
                // Image Picker for Company Logo
                ImagePickerWidget(
                  onImagePicked: (imagePath) {
                    setState(() {
                      companyLogo = imagePath;
                    });
                  },
                ),
                // Form Fields for Company Details
                _buildGenericTextField(
                  label: 'Company Name',
                  controller: _companyNameController,
                  validationType: 'text',
                ),
                _buildCategoryDropdown(categories,),


                _buildProvinceCityDropdowns(),
                _buildGenericTextField(
                  label: 'Company Address',
                  controller: _companyAddressController,
                  validationType: 'text',
                ),
                _buildGenericTextField(
                  label: 'Postal Code',
                  controller: _companyPostalCodeController,
                  validationType: 'number',
                ),
                _buildGenericTextField(
                  label: 'Company Location (Google Map URL)',
                  controller: _companyLocationController,
                  validationType: 'text',
                ),
                _buildGenericTextField(
                  label: 'Company Phone Number',
                  controller: _companyPhoneController,
                  validationType: 'phone',
                ),
                _buildGenericTextField(
                  label: 'Company WhatsApp Number',
                  controller: _companyWhatsappController,
                  validationType: 'phone',
                ),
                _buildGenericTextField(
                  label: 'Company Website',
                  controller: _companyWebsiteController,
                  validationType: 'url',
                ),

                _buildGenericTextField(
                  label: 'Company Gmail ID',
                  controller: _companyEmailController,
                  validationType: 'email',
                ),
                SizedBox(height: 20),
                // Register Button
                ElevatedButton(
                  onPressed: isLoading
                      ? null // Disable the button if loading
                      : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true; // Set loading to true
                      });

                      // Perform the registration logic here
                    bool isRegistered= await companyService.registerCompany(
                        widget.ownerName,
                        widget.ownerId,
                        widget.ownerEmail,
                        widget.ownerPhone,
                        widget.ownerGender,
                        widget.ownerFatherName,
                        widget.ownerDob,
                        companyLogo,
                        _companyNameController.text,
                        _companyAddressController.text,
                        selectedCity!,
                        selectedProvince!,
                        _companyPostalCodeController.text,
                        _companyLocationController.text,
                        _companyPhoneController.text,
                        _companyWhatsappController.text,
                        _companyWebsiteController.text,
                        selectedCategory.toString(),
                        _companyEmailController.text,
                        context,
                      );

                      setState(() {
                        isLoading = false; // Set loading to false after registration
                      });
                      print("Gift$selectedCategory");

                      if(isRegistered==true){
                        authViewModel.updateUserType("company");
                        showRegistrationDialog(context,"Registration Successful", "Your company has been registered.You need to wait for admin approval.",isRegistered);
                      } else {
                        showRegistrationDialog(context,"Registration unsuccessful", "Your company is not registered.",isRegistered);

                      }
                    }
                  },
                  child: isLoading
                      ? const CupertinoActivityIndicator(color: Colors.green,)
                      : const Text(
                    'Register Company',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor, // Dark green color
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
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
  void showRegistrationDialog(BuildContext context,String text1,String text2,bool isRegistered) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {

        return AlertDialog(
          title: Text(
            text1,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content:Container(
            height: 200,
            child: Column(
              children: [
                Image.asset(isRegistered==false? "assets/images/cross.png":"assets/images/tick.png",width: 100,height: 100,),
                SizedBox(height: 10,),
                Text(
                 text2,
                  style: const TextStyle(fontSize: 16,),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>DashboardScreen()), (route)=>false);
              },
              child: const Text(
                "OK",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

}
