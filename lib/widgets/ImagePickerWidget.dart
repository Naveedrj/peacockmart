import 'dart:io';
import 'dart:ui' as ui;
import 'package:company_panel/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(String) onImagePicked;

  ImagePickerWidget({required this.onImagePicked});

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  String _imagePath = "";
  String _errorText = "";


  Future<void> _showImagePickerOptions(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Photo'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final image = await decodeImageFromList(file.readAsBytesSync());

      if (image.height <= 150 && image.width <= 400) {
        setState(() {
          _imagePath = pickedFile.path;
          _errorText = "";
        });
        widget.onImagePicked(_imagePath);
      } else {
        setState(() {
          _imagePath="";
          _errorText = "Image dimensions must not\n exceed 150px height\n and 400px width.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Background image or placeholder
        Container(
          height: 150,
          width: 400,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
            image: _imagePath.isNotEmpty
                ? DecorationImage(
              image: FileImage(File(_imagePath)),
              fit: BoxFit.cover,
            )
                : null,
          ),
          child: _imagePath.isEmpty && _errorText.isEmpty
              ? Center(
            child: Text(
              "No Image Selected",
              style: TextStyle(color: Colors.grey),
            ),
          )
              : null,
        ),

        // Error text if image validation fails
        if (_errorText.isNotEmpty)
          Positioned(
            bottom: 70,
            child: Text(
              _errorText,
              style: TextStyle(color: Colors.red),
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
            ),
          ),

        // Floating button for picking/changing image
        Positioned(
          bottom: 20,
          child: ElevatedButton(
            onPressed: () => _showImagePickerOptions(context),
            child: Row(
              children: [
                Icon( _imagePath.isEmpty ? Icons.upload_file: Icons.rotate_left,color: Colors.white,),
                Text(
                  _imagePath.isEmpty ? 'Select Company Logo' : 'Change Logo',
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white
            ),
          ),
        ),
      ],
    );
  }
}
