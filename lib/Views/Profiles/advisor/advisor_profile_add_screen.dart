import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../Widgets/state_and_cities_widget.dart';
import '../../../models/all profile model.dart';
import '../../../services/profile forms/advisor/advisor add.dart';
import '../../../services/profile forms/advisor/advisor get.dart';

class AddAdvisorProfileScreen extends StatefulWidget {
  final bool isEdit;
  final AdvisorExplr? advisor;
  final String? type;
  final Function? action;

  const AddAdvisorProfileScreen({
    Key? key,
    this.isEdit = false,
    this.advisor,
    this.type,
    this.action,
  }) : super(key: key);

  @override
  _AddAdvisorProfileScreenState createState() => _AddAdvisorProfileScreenState();
}


class _AddAdvisorProfileScreenState extends State<AddAdvisorProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _designationController = TextEditingController();
  final _yearExperienceController = TextEditingController();
  final _areaOfInterestController = TextEditingController();
  final _aboutController = TextEditingController();
  String? _networkImageUrl;
  String? _selectedIndustry;
  String? _selectedState;
  String? _selectedCity;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  // Validation patterns
  final emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final phonePattern = RegExp(r'^[0-9]{10}$');

  final List<String> _industryList = [
    'Business',
    'Technology',
    'Healthcare',
    'Education',
    'Retail',
    'Manufacturing',
    'Finance',
    'Real Estate',
    'Hospitality',
    'Transportation',
    'Construction',
    'Agriculture',
    'Entertainment',
    'Energy',
    'Telecommunications',
    'Consulting'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.advisor != null) {
      _loadAdvisorData();
    }
  }

  void _loadAdvisorData() {
    final advisor = widget.advisor!;
    _fullNameController.text = advisor.name;
    _phoneController.text = advisor.contactNumber ?? '';
    _emailController.text = advisor.url ?? '';
    _designationController.text = advisor.designation ?? '';
    _yearExperienceController.text = advisor.expertise ?? '';
    _areaOfInterestController.text = advisor.interest ?? '';
    _aboutController.text = advisor.description ?? '';

    setState(() {
      _selectedIndustry = advisor.type;
      _selectedState = advisor.state;
      _selectedCity = advisor.location;

      // Handle logo display
      if (advisor.brandLogo != null && advisor.brandLogo!.isNotEmpty) {
        _networkImageUrl = advisor.brandLogo!.first;
      }
    });
  }


  bool _validateForm() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    // Remove image validation for edit mode
    if (!widget.isEdit && _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload a profile image'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (_selectedIndustry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your industry expertise'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (_selectedState == null || _selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both state and city'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (_yearExperienceController.text.isEmpty ||
        _yearExperienceController.text == '0 Years') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your years of experience'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    return true;
  }

  Future<void> _handleSubmit() async {
    if (_validateForm()) {
      try {
        setState(() => _isLoading = true);

        if (widget.isEdit) {
          // Only include brandLogo if a new image is selected
          List<File>? brandLogo;
          if (_imageFile != null) {
            brandLogo = [_imageFile!];
          }

          final success = await AdvisorFetchPage.updateAdvisorProfile(
            advisorId: int.parse(widget.advisor!.id),
            advisorName: _fullNameController.text,
            designation: _designationController.text,
            contactNumber: _phoneController.text,
            email: _emailController.text,
            industry: _selectedIndustry!,
            experience: _yearExperienceController.text,
            areaOfInterest: _areaOfInterestController.text,
            state: _selectedState!,
            city: _selectedCity!,
            description: _aboutController.text,
            brandLogo: brandLogo,
          );

          if (mounted) {
            if (success) {
              // Show success message
              Get.snackbar(
                'Success',
                'Advisor profile updated successfully!',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
                snackPosition: SnackPosition.TOP,
              );


              if (widget.action != null) {
                widget.action!();
              }

              // Navigate back to dashboard after a short delay
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pop(context, true);
              });

            } else {
              Get.snackbar(
                'Error',
                'Failed to update profile',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP,
              );
            }
          }
        } else {
          // Create new profile logic
          final response = await AdvisorProfileService.createAdvisorProfile(
            name: _fullNameController.text,
            designation: _designationController.text,
            email: _emailController.text,
            number: _phoneController.text,
            industry: _selectedIndustry!,
            experience: _yearExperienceController.text,
            areaOfInterest: _areaOfInterestController.text,
            state: _selectedState!,
            city: _selectedCity!,
            about: _aboutController.text,
            profileImage: _imageFile!,
          );

          if (mounted) {
            if (response is Map<String, dynamic> && response['status'] == true) {
              // Show success message
              Get.snackbar(
                'Success',
                'Advisor profile created successfully!',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
                snackPosition: SnackPosition.TOP,
              );

              // Navigate back to dashboard after a short delay
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.pop(context);
              });
            } else {
              Get.snackbar(
                'Error',
                response['error'] ?? 'Failed to create profile',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP,
              );
            }
          }
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'An unexpected error occurred: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() => _isLoading = true);
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error picking image')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Add Photo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Choose a photo from your gallery or take a new one',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildImagePickerOption(
                          icon: Icons.photo_library,
                          label: 'Gallery',
                          onTap: () {
                            Navigator.pop(context);
                            _pickImage(ImageSource.gallery);
                          },
                        ),
                        _buildImagePickerOption(
                          icon: Icons.camera_alt,
                          label: 'Camera',
                          onTap: () {
                            Navigator.pop(context);
                            _pickImage(ImageSource.camera);
                          },
                        ),
                      ],
                    ),
                    if (_imageFile != null) ...[
                      const SizedBox(height: 16),
                      const Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 24,
                          ),
                        ),
                        title: const Text(
                          'Remove Current Photo',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          'This action cannot be undone',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() => _imageFile = null);
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 32,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputLabel('Full Name'),
        _buildTextField(
          controller: _fullNameController,
          prefixIcon: Icons.person_outline,
          hintText: 'Enter full name',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Full name is required';
            }
            if (value.length < 2) {
              return 'Full name must be at least 2 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildInputLabel('Designation'),
        _buildTextField(
          controller: _designationController,
          prefixIcon: Icons.work_outline,
          hintText: 'Enter designation',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Designation is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildInputLabel('Phone Number'),
        _buildTextField(
          controller: _phoneController,
          prefixIcon: Icons.phone_outlined,
          hintText: 'Enter phone number',
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Phone number is required';
            }
            if (!phonePattern.hasMatch(value)) {
              return 'Please enter a valid 10-digit phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildInputLabel('Email'),
        _buildTextField(
          controller: _emailController,
          prefixIcon: Icons.mail_outline,
          hintText: 'Enter email address',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email is required';
            }
            if (!emailPattern.hasMatch(value)) {
              return 'Enter a valid email address';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildInputLabel('Industry Expertise'),
        _buildDropdownField(
          value: _selectedIndustry,
          icon: Icons.business_outlined,
          items: _industryList,
          onChanged: (value) => setState(() => _selectedIndustry = value),
          hint: 'Select Industry Expertise',
        ),
        const SizedBox(height: 16),
        _buildInputLabel('Years of Experience'),
        _buildTextField(
          controller: _yearExperienceController,
          prefixIcon: Icons.timeline_outlined,
          hintText: '0',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Years of experience is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildInputLabel('Area of Interest'),
        _buildTextField(
          controller: _areaOfInterestController,
          prefixIcon: Icons.interests_outlined,
          hintText: 'Enter your area of interest',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Area of interest is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputLabel('State'),
                  SizedBox(
                    height: 60,
                    child: _buildDropdownField(
                      value: _selectedState,
                      icon: Icons.location_on_outlined,
                      items: IndianLocations.getStates(),
                      onChanged: (value) {
                        setState(() {
                          _selectedState = value;
                          _selectedCity = null;
                        });
                      },
                      hint: 'Select State',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputLabel('City'),
                  SizedBox(
                    height: 60,
                    child: _buildDropdownField(
                      value: _selectedCity,
                      icon: Icons.location_city_outlined,
                      items: _selectedState != null
                          ? IndianLocations.getCitiesForState(_selectedState!)
                          : [],
                      onChanged: _selectedState != null
                          ? (value) => setState(() => _selectedCity = value)
                          : null,
                      hint: 'Select City',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildInputLabel('About'),
        _buildTextField(
          controller: _aboutController,
          prefixIcon: Icons.info_outline,
          hintText: 'Enter description about yourself...',
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Description is required';
            }
            if (value.length < 50) {
              return 'Description must be at least 50 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData prefixIcon,
    required String hintText,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon, color: Colors.grey),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          errorStyle: const TextStyle(color: Colors.red),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.amber, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required IconData icon,
    required List<String> items,
    required void Function(String?)? onChanged,
    required String hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        icon: const Icon(Icons.arrow_drop_down),
        isExpanded: true,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.amber, width: 1),
          ),
          filled: true,
          fillColor: Colors.white,
          hintText: hint,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select an option';
          }
          return null;
        },
        dropdownColor: Colors.white,
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: TextButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isEdit ? 'Edit Advisor' : 'Add Advisor',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: _showImagePickerModal,
                        child: Center(
                          child: _buildProfileImage(),
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildInputFields(),
                      const SizedBox(height: 32),
                      _buildNavigationButtons(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Container(
          width: 120,
          height: 120,
          color: Colors.grey[100],
          child: _imageFile != null
          // Show selected local image
              ? Image.file(
            _imageFile!,
            fit: BoxFit.cover,
            width: 120,
            height: 120,
          )
              : _networkImageUrl != null && _networkImageUrl!.isNotEmpty
          // Show network image
              ? Image.network(
            _networkImageUrl!,
            fit: BoxFit.cover,
            width: 120,
            height: 120,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 40,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Add Photo',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          )
          // Show placeholder for new images
              : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 40,
                  color: Colors.grey,
                ),
                SizedBox(height: 4),
                Text(
                  'Add Photo',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildDefaultProfileWidget() {
  //   return Stack(
  //     alignment: Alignment.center,
  //     children: [
  //       const Icon(
  //         Icons.add_photo_alternate_outlined,
  //         size: 40,
  //         color: Colors.grey,
  //       ),
  //       Positioned(
  //         bottom: 20,
  //         child: Text(
  //           'Add Photo',
  //           style: TextStyle(
  //             color: Colors.grey[600],
  //             fontSize: 12,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _designationController.dispose();
    _yearExperienceController.dispose();
    _areaOfInterestController.dispose();
    _aboutController.dispose();
    super.dispose();
  }
}
