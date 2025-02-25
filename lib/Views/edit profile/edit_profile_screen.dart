// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:project_emergio/Views/dashboard/dashboard_screen.dart';
// // import 'package:project_emergio/services/sales_profile.dart';
// // import 'dart:io';
// // import '../../../Widgets/state_and_cities_widget.dart';
// // import '../../../services/profile forms/profile_creation_service.dart';
// //
// // class EditProfileScreen extends StatefulWidget {
// //   final Map<String, dynamic> profileData;
// //   final String type;
// //   final VoidCallback action;
// //
// //   const EditProfileScreen(
// //       {Key? key,
// //       required this.profileData,
// //       required this.type,
// //       required this.action})
// //       : super(key: key);
// //
// //   @override
// //   _EditProfileScreenState createState() => _EditProfileScreenState();
// // }
// //
// // class _EditProfileScreenState extends State<EditProfileScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   late final TextEditingController _nameController;
// //   late final TextEditingController _phoneController;
// //   late final TextEditingController _emailController;
// //   late final TextEditingController _websiteController;
// //   late final TextEditingController _aboutController;
// //   late final TextEditingController _occupationController;
// //   late final TextEditingController _experienceYearController;
// //   late final TextEditingController _interestedAreaController;
// //   String? _selectedIndustry;
// //   String? _selectedState;
// //   String? _selectedCity;
// //   String? _selectedGender;
// //   File? _imageFile;
// //   String? _existingImageUrl;
// //   final ImagePicker _picker = ImagePicker();
// //   bool _isLoading = false;
// //   bool _hasChanges = false;
// //
// //   // Validation patterns
// //   final emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
// //   final phonePattern = RegExp(r'^[0-9]{10}$');
// //   final urlPattern = RegExp(r'^(www\.)?[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$');
// //
// //   final List<String> _industryList = [
// //     'Technology',
// //     'Healthcare',
// //     'Education',
// //     'Retail',
// //     'Manufacturing',
// //     'Finance',
// //     'Real Estate',
// //     'Hospitality',
// //     'Transportation',
// //     'Construction',
// //     'Agriculture',
// //     'Entertainment',
// //     'Energy',
// //     'Telecommunications',
// //     'Consulting'
// //   ];
// //
// //   final List<String> _genderList = ['Male', 'Female', 'Other'];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _nameController = TextEditingController(text: widget.profileData['name']);
// //     _phoneController =
// //         TextEditingController(text: widget.profileData['number']);
// //     _emailController = TextEditingController(text: widget.profileData['email']);
// //     _websiteController =
// //         TextEditingController(text: widget.profileData['webUrl']);
// //     _aboutController = TextEditingController(text: widget.profileData['about']);
// //     _occupationController =
// //         TextEditingController(text: widget.profileData['occupation']);
// //
// //     _experienceYearController = widget.type == "advisor"
// //         ? TextEditingController(text: widget.profileData["experience"])
// //         : TextEditingController(text: "");
// //
// //     _interestedAreaController = widget.type == "advisor"
// //         ? TextEditingController(text: widget.profileData["interest"])
// //         : TextEditingController(text: "");
// //
// //     if (widget.type == 'business') {
// //       _selectedIndustry = widget.profileData['industry'];
// //     } else {
// //       _selectedGender = widget.profileData['gender'];
// //     }
// //
// //     _selectedState = widget.profileData['state'];
// //     _selectedCity = widget.profileData['city'];
// //     _existingImageUrl = widget.profileData['imageUrl'];
// //
// //     _setupChangeListeners();
// //   }
// //
// //   /// Helper method to convert image file to base64
// //   Future<String> _imageToBase64(File imageFile) async {
// //     List<int> imageBytes = await imageFile.readAsBytes();
// //     String base64Image = base64Encode(imageBytes);
// //     return base64Image;
// //   }
// //
// //   void _setupChangeListeners() {
// //     void markAsChanged() {
// //       if (mounted) {
// //         setState(() => _hasChanges = true);
// //       }
// //     }
// //
// //     _nameController.addListener(markAsChanged);
// //     _phoneController.addListener(markAsChanged);
// //     _emailController.addListener(markAsChanged);
// //     if (widget.type == 'business') {
// //       _websiteController.addListener(markAsChanged);
// //     } else {
// //       _occupationController.addListener(markAsChanged);
// //     }
// //     _aboutController.addListener(markAsChanged);
// //   }
// //
// //   @override
// //   void dispose() {
// //     _nameController.dispose();
// //     _phoneController.dispose();
// //     _emailController.dispose();
// //     _websiteController.dispose();
// //     _aboutController.dispose();
// //     _occupationController.dispose();
// //     super.dispose();
// //   }
// //
// //   Future<void> _pickImage(ImageSource source) async {
// //     try {
// //       setState(() => _isLoading = true);
// //       final XFile? pickedFile = await _picker.pickImage(
// //         source: source,
// //         maxWidth: 1000,
// //         maxHeight: 1000,
// //         imageQuality: 85,
// //       );
// //
// //       if (pickedFile != null) {
// //         setState(() {
// //           _imageFile = File(pickedFile.path);
// //           _hasChanges = true;
// //         });
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Error picking image')),
// //       );
// //     } finally {
// //       setState(() => _isLoading = false);
// //     }
// //   }
// //
// //   void _showImagePickerModal() {
// //     showModalBottomSheet(
// //       context: context,
// //       backgroundColor: Colors.transparent,
// //       builder: (BuildContext context) {
// //         return Container(
// //           decoration: const BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// //           ),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               Container(
// //                 margin: const EdgeInsets.only(top: 8),
// //                 height: 4,
// //                 width: 40,
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey[300],
// //                   borderRadius: BorderRadius.circular(2),
// //                 ),
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.all(16),
// //                 child: Column(
// //                   children: [
// //                     const Text(
// //                       'Change Profile Photo',
// //                       style: TextStyle(
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 24),
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                       children: [
// //                         _buildImagePickerOption(
// //                           icon: Icons.photo_library,
// //                           label: 'Gallery',
// //                           onTap: () {
// //                             Navigator.pop(context);
// //                             _pickImage(ImageSource.gallery);
// //                           },
// //                         ),
// //                         _buildImagePickerOption(
// //                           icon: Icons.camera_alt,
// //                           label: 'Camera',
// //                           onTap: () {
// //                             Navigator.pop(context);
// //                             _pickImage(ImageSource.camera);
// //                           },
// //                         ),
// //                       ],
// //                     ),
// //                     if (_imageFile != null || _existingImageUrl != null) ...[
// //                       const SizedBox(height: 16),
// //                       const Divider(),
// //                       ListTile(
// //                         contentPadding: EdgeInsets.zero,
// //                         leading: Container(
// //                           width: 48,
// //                           height: 48,
// //                           decoration: BoxDecoration(
// //                             color: Colors.red.withOpacity(0.1),
// //                             borderRadius: BorderRadius.circular(12),
// //                           ),
// //                           child: const Icon(
// //                             Icons.delete_outline,
// //                             color: Colors.red,
// //                             size: 24,
// //                           ),
// //                         ),
// //                         title: const Text(
// //                           'Remove Current Photo',
// //                           style: TextStyle(
// //                             color: Colors.red,
// //                             fontWeight: FontWeight.w500,
// //                           ),
// //                         ),
// //                         onTap: () {
// //                           Navigator.pop(context);
// //                           setState(() {
// //                             _imageFile = null;
// //                             _existingImageUrl = null;
// //                             _hasChanges = true;
// //                           });
// //                         },
// //                       ),
// //                     ],
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   Widget _buildImagePickerOption({
// //     required IconData icon,
// //     required String label,
// //     required VoidCallback onTap,
// //   }) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Column(
// //         children: [
// //           Container(
// //             width: 72,
// //             height: 72,
// //             decoration: BoxDecoration(
// //               color: Colors.amber.withOpacity(0.1),
// //               borderRadius: BorderRadius.circular(16),
// //             ),
// //             child: Icon(
// //               icon,
// //               size: 32,
// //               color: Colors.amber,
// //             ),
// //           ),
// //           const SizedBox(height: 8),
// //           Text(
// //             label,
// //             style: const TextStyle(
// //               fontSize: 14,
// //               fontWeight: FontWeight.w500,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildProfileImagePicker() {
// //     return GestureDetector(
// //       onTap: _showImagePickerModal,
// //       child: Center(
// //         child: Container(
// //           width: 120,
// //           height: 120,
// //           decoration: BoxDecoration(
// //             shape: BoxShape.circle,
// //             color: Colors.white,
// //             boxShadow: [
// //               BoxShadow(
// //                 color: Colors.grey.withOpacity(0.2),
// //                 blurRadius: 8,
// //                 offset: const Offset(0, 2),
// //               ),
// //             ],
// //           ),
// //           // child: _imageFile != null
// //           //     ? ClipOval(
// //           //         child: Image.file(
// //           //           _imageFile!,
// //           //           fit: BoxFit.cover,
// //           //           width: 120,
// //           //           height: 120,
// //           //         ),
// //           //       )
// //           //     : _existingImageUrl != null
// //           //         ? ClipOval(
// //           //             child: Image.network(
// //           //               widget.profileData["image"],
// //           //               fit: BoxFit.cover,
// //           //               width: 120,
// //           //               height: 120,
// //           //               errorBuilder: (context, error, stackTrace) =>
// //           //                   const Icon(
// //           //                 Icons.person,
// //           //                 size: 40,
// //           //                 color: Colors.grey,
// //           //               ),
// //           //             ),
// //           //           )
// //           //         : const Icon(
// //           //             Icons.person,
// //           //             size: 40,
// //           //             color: Colors.grey,
// //           //           ),
// //
// //           child: widget.profileData["image"] != null
// //               ? CircleAvatar(
// //                   backgroundImage: NetworkImage(widget.profileData["image"]),
// //                 )
// //               : const Icon(
// //                   Icons.person,
// //                   size: 40,
// //                   color: Colors.grey,
// //                 ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildInputLabel(String label) {
// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 8),
// //       child: Text(
// //         label,
// //         style: const TextStyle(
// //           fontSize: 16,
// //           color: Colors.black54,
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildTextField({
// //     required TextEditingController controller,
// //     required IconData prefixIcon,
// //     required String hintText,
// //     TextInputType? keyboardType,
// //     int maxLines = 1,
// //     String? Function(String?)? validator,
// //   }) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.1),
// //             blurRadius: 8,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: TextFormField(
// //         controller: controller,
// //         keyboardType: keyboardType,
// //         maxLines: maxLines,
// //         validator: validator,
// //         decoration: InputDecoration(
// //           prefixIcon: Icon(prefixIcon, color: Colors.grey),
// //           hintText: hintText,
// //           hintStyle: const TextStyle(color: Colors.grey),
// //           errorStyle: const TextStyle(color: Colors.red),
// //           border: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(12),
// //             borderSide: BorderSide.none,
// //           ),
// //           enabledBorder: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(12),
// //             borderSide: BorderSide.none,
// //           ),
// //           focusedBorder: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(12),
// //             borderSide: const BorderSide(color: Colors.amber, width: 1),
// //           ),
// //           errorBorder: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(12),
// //             borderSide: const BorderSide(color: Colors.red, width: 1),
// //           ),
// //           focusedErrorBorder: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(12),
// //             borderSide: const BorderSide(color: Colors.red, width: 1),
// //           ),
// //           filled: true,
// //           fillColor: Colors.white,
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildDropdownField({
// //     required String? value,
// //     required IconData icon,
// //     required List<String> items,
// //     required void Function(String?)? onChanged,
// //     required String hint,
// //   }) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.1),
// //             blurRadius: 8,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: DropdownButtonFormField<String>(
// //         value: value,
// //         icon: const Icon(Icons.arrow_drop_down),
// //         isExpanded: true,
// //         menuMaxHeight: 400.h,
// //         decoration: InputDecoration(
// //           prefixIcon: Icon(icon, color: Colors.grey),
// //           border: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(12),
// //             borderSide: BorderSide.none,
// //           ),
// //           enabledBorder: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(12),
// //             borderSide: BorderSide.none,
// //           ),
// //           focusedBorder: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(12),
// //             borderSide: const BorderSide(color: Colors.amber, width: 1),
// //           ),
// //           filled: true,
// //           fillColor: Colors.white,
// //           hintText: hint,
// //           contentPadding:
// //               const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //         ),
// //         items: items.map((String item) {
// //           return DropdownMenuItem<String>(
// //             value: item,
// //             child: Text(item, style: const TextStyle(fontSize: 14)),
// //           );
// //         }).toList(),
// //         validator: (value) {
// //           if (value == null || value.isEmpty) {
// //             return 'Please select an option';
// //           }
// //           return null;
// //         },
// //         onChanged: onChanged,
// //       ),
// //     );
// //   }
// //
// //   void _showDiscardChangesDialog() {
// //     if (_hasChanges) {
// //       showDialog(
// //         context: context,
// //         builder: (BuildContext context) {
// //           return AlertDialog(
// //             title: const Text('Discard Changes?'),
// //             content: const Text(
// //                 'You have unsaved changes. Are you sure you want to leave?'),
// //             actions: [
// //               TextButton(
// //                 onPressed: () => Navigator.pop(context),
// //                 child: const Text('Cancel'),
// //               ),
// //               TextButton(
// //                 onPressed: () {
// //                   Navigator.pop(context); // Close dialog
// //                   Navigator.pop(context); // Go back
// //                 },
// //                 child: const Text(
// //                   'Discard',
// //                   style: TextStyle(color: Colors.red),
// //                 ),
// //               ),
// //             ],
// //           );
// //         },
// //       );
// //     } else {
// //       Navigator.pop(context);
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return WillPopScope(
// //       onWillPop: () async {
// //         if (_formHasData()) {
// //           _showBackConfirmation();
// //           return false;
// //         }
// //         return true;
// //       },
// //       child: Scaffold(
// //         backgroundColor: Colors.white,
// //         appBar: AppBar(
// //           backgroundColor: Colors.white,
// //           elevation: 0,
// //           leading: Container(
// //             margin: const EdgeInsets.all(8),
// //             decoration: BoxDecoration(
// //               shape: BoxShape.circle,
// //               color: Colors.white,
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.grey.withOpacity(0.1),
// //                   blurRadius: 8,
// //                   offset: const Offset(0, 2),
// //                 ),
// //               ],
// //             ),
// //             child: IconButton(
// //               icon: const Icon(Icons.arrow_back, color: Colors.black),
// //               onPressed: () => _showBackConfirmation(),
// //             ),
// //           ),
// //           title: Text(
// //             'Edit ${widget.type} profile',
// //             style: TextStyle(
// //               fontSize: 22,
// //               fontWeight: FontWeight.w500,
// //               color: Colors.black,
// //             ),
// //           ),
// //         ),
// //         body: SafeArea(
// //           child: Stack(
// //             children: [
// //               SingleChildScrollView(
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(16.0),
// //                   child: Form(
// //                     key: _formKey,
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         const SizedBox(height: 10),
// //                         _buildProfileImagePicker(),
// //                         const SizedBox(height: 32),
// //                         _buildInputFields(),
// //                         const SizedBox(height: 32),
// //                         _buildNavigationButtons(),
// //                         const SizedBox(height: 20),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               if (_isLoading)
// //                 Container(
// //                   color: Colors.black.withOpacity(0.5),
// //                   child: const Center(
// //                     child: CircularProgressIndicator(
// //                       valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
// //                     ),
// //                   ),
// //                 ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildInputFields() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         _buildInputLabel('Business Name'),
// //         _buildTextField(
// //           controller: _nameController,
// //           prefixIcon: Icons.business,
// //           hintText: 'Enter business name',
// //           validator: (value) {
// //             if (value == null || value.isEmpty) {
// //               return 'Business name is required';
// //             }
// //             if (value.length < 2) {
// //               return 'Business name must be at least 2 characters';
// //             }
// //             return null;
// //           },
// //         ),
// //         const SizedBox(height: 16),
// //         _buildInputLabel('Phone Number'),
// //         _buildTextField(
// //           controller: _phoneController,
// //           prefixIcon: Icons.phone_outlined,
// //           hintText: 'Enter phone number',
// //           keyboardType: TextInputType.phone,
// //           validator: (value) {
// //             if (value == null || value.isEmpty) {
// //               return 'Phone number is required';
// //             }
// //             if (!phonePattern.hasMatch(value)) {
// //               return 'Please enter a valid 10-digit phone number';
// //             }
// //             return null;
// //           },
// //         ),
// //         const SizedBox(height: 16),
// //         _buildInputLabel('Mail Id'),
// //         _buildTextField(
// //           controller: _emailController,
// //           prefixIcon: Icons.mail_outline,
// //           hintText: 'Enter email address',
// //           keyboardType: TextInputType.emailAddress,
// //           validator: (value) {
// //             if (value == null || value.isEmpty) {
// //               return 'Email is required';
// //             }
// //             if (!emailPattern.hasMatch(value)) {
// //               return 'Enter a valid email address';
// //             }
// //             return null;
// //           },
// //         ),
// //         const SizedBox(height: 16),
// //         _buildInputLabel('Industry'),
// //         _buildDropdownField(
// //           value: _selectedIndustry,
// //           icon: Icons.business_outlined,
// //           items: _industryList,
// //           onChanged: (value) => setState(() => _selectedIndustry = value),
// //           hint: 'Select Industry',
// //         ),
// //         const SizedBox(height: 16),
// //         widget.type == "advisor"
// //             ? _buildInputLabel('Year of Experience')
// //             : _buildInputLabel('Business Website Url'),
// //         widget.type == "advisor"
// //             ? _buildTextField(
// //                 controller: _experienceYearController,
// //                 prefixIcon: Icons.work_outline,
// //                 hintText: '',
// //                 keyboardType: TextInputType.url,
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Year of experience is required';
// //                   }
// //                   if (!urlPattern.hasMatch(value)) {
// //                     return 'Enter a number';
// //                   }
// //                   return null;
// //                 },
// //               )
// //             : _buildTextField(
// //                 controller: _websiteController,
// //                 prefixIcon: Icons.language_outlined,
// //                 hintText: 'Enter website URL',
// //                 keyboardType: TextInputType.text,
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Website URL is required';
// //                   }
// //                   if (!urlPattern.hasMatch(value)) {
// //                     return 'Enter a valid website URL';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //         const SizedBox(height: 16),
// //         widget.type == "advisor"
// //             ? _buildInputLabel('Area of interest')
// //             : SizedBox.shrink(),
// //         widget.type == "advisor"
// //             ? _buildTextField(
// //                 controller: _interestedAreaController,
// //                 prefixIcon: Icons.interests_outlined,
// //                 hintText: '',
// //                 keyboardType: TextInputType.text,
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Area of interest is required';
// //                   }
// //
// //                   return null;
// //                 },
// //               )
// //             : const SizedBox.shrink(),
// //         Row(
// //           children: [
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   _buildInputLabel('State'),
// //                   SizedBox(
// //                     height: 60, // Fixed height for dropdown
// //                     child: _buildDropdownField(
// //                       value: _selectedState,
// //                       icon: Icons.location_on_outlined,
// //                       items: IndianLocations.getStates(),
// //                       onChanged: (value) {
// //                         setState(() {
// //                           _selectedState = value;
// //                           _selectedCity = null;
// //                         });
// //                       },
// //                       hint: 'Select State',
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             const SizedBox(width: 16),
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   _buildInputLabel('City'),
// //                   SizedBox(
// //                     height: 60, // Fixed height for dropdown
// //                     child: _buildDropdownField(
// //                       value: _selectedCity,
// //                       icon: Icons.location_city_outlined,
// //                       items: _selectedState != null
// //                           ? IndianLocations.getCitiesForState(_selectedState!)
// //                           : [],
// //                       onChanged: _selectedState != null
// //                           ? (value) => setState(() => _selectedCity = value)
// //                           : null,
// //                       hint: 'Select City',
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //         const SizedBox(height: 16),
// //         _buildInputLabel('About'),
// //         _buildTextField(
// //           controller: _aboutController,
// //           prefixIcon: Icons.info_outline,
// //           hintText: 'Enter description about your business...',
// //           maxLines: 3,
// //           validator: (value) {
// //             if (value == null || value.isEmpty) {
// //               return 'Description is required';
// //             }
// //             if (value.length < 50) {
// //               return 'Description must be at least 50 characters';
// //             }
// //             return null;
// //           },
// //         ),
// //       ],
// //     );
// //   }
// //
// //   void _showBackConfirmation() {
// //     if (_formHasData()) {
// //       showDialog(
// //         context: context,
// //         builder: (BuildContext context) {
// //           return AlertDialog(
// //             title: const Text('Confirm'),
// //             content: const Text(
// //                 'Are you sure you want to go back? All entered data will be lost.'),
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(12),
// //             ),
// //             actions: [
// //               TextButton(
// //                 onPressed: () => Navigator.pop(context),
// //                 child: const Text(
// //                   'Cancel',
// //                   style: TextStyle(color: Colors.grey),
// //                 ),
// //               ),
// //               TextButton(
// //                 onPressed: () {
// //                   Navigator.pop(context); // Close dialog
// //                   Navigator.pop(context); // Go back
// //                 },
// //                 child: const Text(
// //                   'Yes, go back',
// //                   style: TextStyle(color: Colors.red),
// //                 ),
// //               ),
// //             ],
// //           );
// //         },
// //       );
// //     } else {
// //       Navigator.pop(context);
// //     }
// //   }
// //
// //   bool _formHasData() {
// //     return _nameController.text.isNotEmpty ||
// //         _phoneController.text.isNotEmpty ||
// //         _emailController.text.isNotEmpty ||
// //         _websiteController.text.isNotEmpty ||
// //         _aboutController.text.isNotEmpty ||
// //         _selectedIndustry != null ||
// //         _selectedState != null ||
// //         _selectedCity != null ||
// //         _imageFile != null;
// //   }
// //
// //   Future<void> _handleSubmit() async {
// //     if (_validateForm()) {
// //       try {
// //         setState(() => _isLoading = true);
// //
// //         // Create updateData map from form controllers
// //         final Map<String, dynamic> updateData = {
// //           'name': _nameController.text.trim(),
// //           'number': _phoneController.text.trim(),
// //           'email': _emailController.text.trim(),
// //           'webUrl': _websiteController.text.trim(),
// //           'about': _aboutController.text.trim(),
// //           'occupation': _experienceYearController.text.trim(),
// //           "interest": _interestedAreaController.text.toString(),
// //           'state': _selectedState,
// //           'city': _selectedCity,
// //           'type': widget.type,
// //         };
// //
// //         // Add conditional fields based on type
// //         if (widget.type == 'business') {
// //           updateData['industry'] = _selectedIndustry;
// //         } else {
// //           updateData['gender'] = _selectedGender;
// //         }
// //
// //         if (_imageFile != null) {
// //           updateData["image"] = _imageFile!.path;
// //         }
// //
// //         // Handle image if selected
// //         // if (_imageFile != null) {
// //         //   // Convert image to base64 if needed
// //         //   List<int> imageBytes = await _imageFile!.readAsBytes();
// //         //   String base64Image = base64Encode(imageBytes);
// //         //   updateData['image'] = base64Image;
// //         // }
// //
// //         // Remove null values and empty strings
// //         updateData.removeWhere((key, value) =>
// //             value == null || (value is String && value.isEmpty));
// //
// //         // Call the API service
// //         final response = await SalesProfile.updateSalesProfileData(
// //           id: widget.profileData["id"],
// //           type: widget.type,
// //           updateData: updateData,
// //         );
// //
// //         print("Patch Response ........${response}");
// //
// //         // Handle response
// //         if (response == true) {
// //           // Success
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(content: Text('Profile updated successfully')),
// //           );
// //
// //           widget.action;
// //           Navigator.pop(context);
// //           Navigator.pushReplacement(
// //               context,
// //               MaterialPageRoute(
// //                   builder: (context) => DashboardScreen(
// //                       type: widget.type))); // Return true to indicate success
// //         } else {
// //           // Error
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(content: Text('Failed to update profile')),
// //           );
// //         }
// //       } catch (e) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('Error: ${e.toString()}')),
// //         );
// //       } finally {
// //         setState(() => _isLoading = false);
// //       }
// //     }
// //   }
// //
// // // Validation function
// //   bool _validateForm() {
// //     if (_nameController.text.trim().isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Please enter your name')),
// //       );
// //       return false;
// //     }
// //
// //     if (_phoneController.text.trim().isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Please enter your phone number')),
// //       );
// //       return false;
// //     }
// //
// //     if (_emailController.text.trim().isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Please enter your email')),
// //       );
// //       return false;
// //     }
// //
// //     if (widget.type == 'business' && _selectedIndustry == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Please select an industry')),
// //       );
// //       return false;
// //     }
// //
// //     if (_selectedState == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Please select a state')),
// //       );
// //       return false;
// //     }
// //
// //     if (_selectedCity == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Please select a city')),
// //       );
// //       return false;
// //     }
// //
// //     return true;
// //   }
// //
// //   Widget _buildNavigationButtons() {
// //     return Column(
// //       children: [
// //         SizedBox(
// //           width: double.infinity,
// //           height: 50,
// //           child: ElevatedButton(
// //             onPressed: _isLoading ? null : _handleSubmit,
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: Colors.amber,
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //               elevation: 2,
// //             ),
// //             child: _isLoading
// //                 ? const SizedBox(
// //                     height: 20,
// //                     width: 20,
// //                     child: CircularProgressIndicator(
// //                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
// //                       strokeWidth: 2,
// //                     ),
// //                   )
// //                 : const Text(
// //                     'Update',
// //                     style: TextStyle(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.white,
// //                     ),
// //                   ),
// //           ),
// //         ),
// //         const SizedBox(height: 16),
// //         SizedBox(
// //           width: double.infinity,
// //           height: 50,
// //           child: TextButton(
// //             onPressed: _isLoading ? null : () => _showBackConfirmation(),
// //             style: TextButton.styleFrom(
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //             ),
// //             child: const Text(
// //               'Back',
// //               style: TextStyle(
// //                 fontSize: 16,
// //                 color: Colors.black54,
// //               ),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:project_emergio/Views/dashboard/dashboard_screen.dart';
// import 'package:project_emergio/models/all%20profile%20model.dart';
// import 'package:project_emergio/services/sales_profile.dart';
// import 'dart:io';
// import '../../../Widgets/state_and_cities_widget.dart';
//
// class EditProfileScreen extends StatefulWidget {
//   final bool isEdit;
//   final String type;
//   final AdvisorExplr? advisor;
//   final VoidCallback action;
//
//   const EditProfileScreen(
//       {super.key,
//       required this.type,
//       required this.action,
//       required this.isEdit,
//       this.advisor});
//
//   @override
//   EditProfileScreenState createState() => EditProfileScreenState();
// }
//
// class EditProfileScreenState extends State<EditProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late final TextEditingController _nameController;
//   late final TextEditingController _phoneController;
//   late final TextEditingController _emailController;
//   late final TextEditingController _websiteController;
//   late final TextEditingController _aboutController;
//   late final TextEditingController _occupationController;
//   late final TextEditingController _experienceYearController;
//   late final TextEditingController _interestedAreaController;
//   String? _selectedIndustry;
//   String? _selectedState;
//   String? _selectedCity;
//   String? _selectedGender;
//   File? _imageFile;
//   String? _existingImageUrl;
//   final ImagePicker _picker = ImagePicker();
//   bool _isLoading = false;
//   bool _hasChanges = false;
//
//   // Validation patterns
//   final emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//   final phonePattern = RegExp(r'^[0-9]{10}$');
//   final urlPattern = RegExp(r'^(www\.)?[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$');
//
//   final List<String> _industryList = [
//     'Technology',
//     'Healthcare',
//     'Education',
//     'Retail',
//     'Manufacturing',
//     'Finance',
//     'Real Estate',
//     'Hospitality',
//     'Transportation',
//     'Construction',
//     'Agriculture',
//     'Entertainment',
//     'Energy',
//     'Telecommunications',
//     'Consulting'
//   ];
//
//   final List<String> _genderList = ['Male', 'Female', 'Other'];
//
//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.advisor!.name);
//     _phoneController =
//         TextEditingController(text: widget.advisor!.contactNumber);
//     print("number : ${widget.advisor?.id}");
//     _emailController = TextEditingController(text: widget.advisor!.user);
//     _websiteController = TextEditingController(text: widget.advisor!.url);
//     _aboutController = TextEditingController(text: widget.advisor!.description);
//     _occupationController =
//         TextEditingController(text: widget.advisor!.designation);
//
//     _experienceYearController = widget.type == "advisor"
//         ? TextEditingController(text: widget.advisor!.expertise)
//         : TextEditingController(text: "");
//
//     _interestedAreaController = widget.type == "advisor"
//         ? TextEditingController(text: widget.advisor!.interest)
//         : TextEditingController(text: "");
//
//     if (widget.type == 'business') {
//       _selectedIndustry = widget.advisor!.type;
//     } else {
//       _selectedGender = widget.advisor!.type;
//     }
//
//     _selectedState = widget.advisor!.state;
//     _selectedCity = widget.advisor!.location;
//     _existingImageUrl = widget.advisor!.imageUrl;
//
//     _setupChangeListeners();
//   }
//
//   /// Helper method to convert image file to base64
//   Future<String> _imageToBase64(File imageFile) async {
//     List<int> imageBytes = await imageFile.readAsBytes();
//     String base64Image = base64Encode(imageBytes);
//     return base64Image;
//   }
//
//   void _setupChangeListeners() {
//     void markAsChanged() {
//       if (mounted) {
//         setState(() => _hasChanges = true);
//       }
//     }
//
//     _nameController.addListener(markAsChanged);
//     _phoneController.addListener(markAsChanged);
//     _emailController.addListener(markAsChanged);
//     if (widget.type == 'business') {
//       _websiteController.addListener(markAsChanged);
//     } else {
//       _occupationController.addListener(markAsChanged);
//     }
//     _aboutController.addListener(markAsChanged);
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _phoneController.dispose();
//     _emailController.dispose();
//     _websiteController.dispose();
//     _aboutController.dispose();
//     _occupationController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       setState(() => _isLoading = true);
//       final XFile? pickedFile = await _picker.pickImage(
//         source: source,
//         maxWidth: 1000,
//         maxHeight: 1000,
//         imageQuality: 85,
//       );
//
//       if (pickedFile != null) {
//         setState(() {
//           _imageFile = File(pickedFile.path);
//           _hasChanges = true;
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Error picking image')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   void _showImagePickerModal() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(top: 8),
//                 height: 4,
//                 width: 40,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     const Text(
//                       'Change Profile Photo',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         _buildImagePickerOption(
//                           icon: Icons.photo_library,
//                           label: 'Gallery',
//                           onTap: () {
//                             Navigator.pop(context);
//                             _pickImage(ImageSource.gallery);
//                           },
//                         ),
//                         _buildImagePickerOption(
//                           icon: Icons.camera_alt,
//                           label: 'Camera',
//                           onTap: () {
//                             Navigator.pop(context);
//                             _pickImage(ImageSource.camera);
//                           },
//                         ),
//                       ],
//                     ),
//                     if (_imageFile != null || _existingImageUrl != null) ...[
//                       const SizedBox(height: 16),
//                       const Divider(),
//                       ListTile(
//                         contentPadding: EdgeInsets.zero,
//                         leading: Container(
//                           width: 48,
//                           height: 48,
//                           decoration: BoxDecoration(
//                             color: Colors.red.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: const Icon(
//                             Icons.delete_outline,
//                             color: Colors.red,
//                             size: 24,
//                           ),
//                         ),
//                         title: const Text(
//                           'Remove Current Photo',
//                           style: TextStyle(
//                             color: Colors.red,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         onTap: () {
//                           Navigator.pop(context);
//                           setState(() {
//                             _imageFile = null;
//                             _existingImageUrl = null;
//                             _hasChanges = true;
//                           });
//                         },
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildImagePickerOption({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Container(
//             width: 72,
//             height: 72,
//             decoration: BoxDecoration(
//               color: Colors.amber.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Icon(
//               icon,
//               size: 32,
//               color: Colors.amber,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProfileImagePicker() {
//     return GestureDetector(
//       onTap: _showImagePickerModal,
//       child: Center(
//         child: Container(
//           width: 120,
//           height: 120,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.2),
//                 blurRadius: 8,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: widget.advisor!.brandLogo != null
//               ? CircleAvatar(
//                   backgroundImage:
//                       NetworkImage(widget.advisor!.brandLogo.toString()),
//                 )
//               : const Icon(
//                   Icons.person,
//                   size: 40,
//                   color: Colors.grey,
//                 ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInputLabel(String label) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Text(
//         label,
//         style: const TextStyle(
//           fontSize: 16,
//           color: Colors.black54,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required IconData prefixIcon,
//     required String hintText,
//     TextInputType? keyboardType,
//     int maxLines = 1,
//     String? Function(String?)? validator,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         maxLines: maxLines,
//         validator: validator,
//         decoration: InputDecoration(
//           prefixIcon: Icon(prefixIcon, color: Colors.grey),
//           hintText: hintText,
//           hintStyle: const TextStyle(color: Colors.grey),
//           errorStyle: const TextStyle(color: Colors.red),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Colors.amber, width: 1),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Colors.red, width: 1),
//           ),
//           focusedErrorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Colors.red, width: 1),
//           ),
//           filled: true,
//           fillColor: Colors.white,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDropdownField({
//     required String? value,
//     required IconData icon,
//     required List<String> items,
//     required void Function(String?)? onChanged,
//     required String hint,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: DropdownButtonFormField<String>(
//         value: value,
//         icon: const Icon(Icons.arrow_drop_down),
//         isExpanded: true,
//         menuMaxHeight: 400.h,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon, color: Colors.grey),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Colors.amber, width: 1),
//           ),
//           filled: true,
//           fillColor: Colors.white,
//           hintText: hint,
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         ),
//         items: items.map((String item) {
//           return DropdownMenuItem<String>(
//             value: item,
//             child: Text(item, style: const TextStyle(fontSize: 14)),
//           );
//         }).toList(),
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please select an option';
//           }
//           return null;
//         },
//         onChanged: onChanged,
//       ),
//     );
//   }
//
//   void _showDiscardChangesDialog() {
//     if (_hasChanges) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Discard Changes?'),
//             content: const Text(
//                 'You have unsaved changes. Are you sure you want to leave?'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Cancel'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context); // Close dialog
//                   Navigator.pop(context); // Go back
//                 },
//                 child: const Text(
//                   'Discard',
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       Navigator.pop(context);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (_formHasData()) {
//           _showBackConfirmation();
//           return false;
//         }
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           leading: Container(
//             margin: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: IconButton(
//               icon: const Icon(Icons.arrow_back, color: Colors.black),
//               onPressed: () => _showBackConfirmation(),
//             ),
//           ),
//           title: Text(
//             'Edit ${widget.type} profile',
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.w500,
//               color: Colors.black,
//             ),
//           ),
//         ),
//         body: SafeArea(
//           child: Stack(
//             children: [
//               SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 10),
//                         _buildProfileImagePicker(),
//                         const SizedBox(height: 32),
//                         _buildInputFields(),
//                         const SizedBox(height: 32),
//                         _buildNavigationButtons(),
//                         const SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               if (_isLoading)
//                 Container(
//                   color: Colors.black.withOpacity(0.5),
//                   child: const Center(
//                     child: CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInputFields() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildInputLabel('Business Name'),
//         _buildTextField(
//           controller: _nameController,
//           prefixIcon: Icons.business,
//           hintText: 'Enter business name',
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Business name is required';
//             }
//             if (value.length < 2) {
//               return 'Business name must be at least 2 characters';
//             }
//             return null;
//           },
//         ),
//         const SizedBox(height: 16),
//         _buildInputLabel('Phone Number'),
//         _buildTextField(
//           controller: _phoneController,
//           prefixIcon: Icons.phone_outlined,
//           hintText: 'Enter phone number',
//           keyboardType: TextInputType.phone,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Phone number is required';
//             }
//             if (!phonePattern.hasMatch(value)) {
//               return 'Please enter a valid 10-digit phone number';
//             }
//             return null;
//           },
//         ),
//         const SizedBox(height: 16),
//         _buildInputLabel('Mail Id'),
//         _buildTextField(
//           controller: _emailController,
//           prefixIcon: Icons.mail_outline,
//           hintText: 'Enter email address',
//           keyboardType: TextInputType.emailAddress,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Email is required';
//             }
//             if (!emailPattern.hasMatch(value)) {
//               return 'Enter a valid email address';
//             }
//             return null;
//           },
//         ),
//         const SizedBox(height: 16),
//         _buildInputLabel('Industry'),
//         _buildDropdownField(
//           value: _selectedIndustry,
//           icon: Icons.business_outlined,
//           items: _industryList,
//           onChanged: (value) => setState(() => _selectedIndustry = value),
//           hint: 'Select Industry',
//         ),
//         const SizedBox(height: 16),
//         widget.type == "advisor"
//             ? _buildInputLabel('Year of Experience')
//             : _buildInputLabel('Business Website Url'),
//         widget.type == "advisor"
//             ? _buildTextField(
//                 controller: _experienceYearController,
//                 prefixIcon: Icons.work_outline,
//                 hintText: '',
//                 keyboardType: TextInputType.url,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Year of experience is required';
//                   }
//                   if (!urlPattern.hasMatch(value)) {
//                     return 'Enter a number';
//                   }
//                   return null;
//                 },
//               )
//             : _buildTextField(
//                 controller: _websiteController,
//                 prefixIcon: Icons.language_outlined,
//                 hintText: 'Enter website URL',
//                 keyboardType: TextInputType.text,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Website URL is required';
//                   }
//                   if (!urlPattern.hasMatch(value)) {
//                     return 'Enter a valid website URL';
//                   }
//                   return null;
//                 },
//               ),
//         const SizedBox(height: 16),
//         widget.type == "advisor"
//             ? _buildInputLabel('Area of interest')
//             : SizedBox.shrink(),
//         widget.type == "advisor"
//             ? _buildTextField(
//                 controller: _interestedAreaController,
//                 prefixIcon: Icons.interests_outlined,
//                 hintText: '',
//                 keyboardType: TextInputType.text,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Area of interest is required';
//                   }
//
//                   return null;
//                 },
//               )
//             : const SizedBox.shrink(),
//         Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildInputLabel('State'),
//                   SizedBox(
//                     height: 60, // Fixed height for dropdown
//                     child: _buildDropdownField(
//                       value: _selectedState,
//                       icon: Icons.location_on_outlined,
//                       items: IndianLocations.getStates(),
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedState = value;
//                           _selectedCity = null;
//                         });
//                       },
//                       hint: 'Select State',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildInputLabel('City'),
//                   SizedBox(
//                     height: 60, // Fixed height for dropdown
//                     child: _buildDropdownField(
//                       value: _selectedCity,
//                       icon: Icons.location_city_outlined,
//                       items: _selectedState != null
//                           ? IndianLocations.getCitiesForState(_selectedState!)
//                           : [],
//                       onChanged: _selectedState != null
//                           ? (value) => setState(() => _selectedCity = value)
//                           : null,
//                       hint: 'Select City',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         _buildInputLabel('About'),
//         _buildTextField(
//           controller: _aboutController,
//           prefixIcon: Icons.info_outline,
//           hintText: 'Enter description about your business...',
//           maxLines: 3,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Description is required';
//             }
//             if (value.length < 50) {
//               return 'Description must be at least 50 characters';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }
//
//   void _showBackConfirmation() {
//     if (_formHasData()) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Confirm'),
//             content: const Text(
//                 'Are you sure you want to go back? All entered data will be lost.'),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text(
//                   'Cancel',
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context); // Close dialog
//                   Navigator.pop(context); // Go back
//                 },
//                 child: const Text(
//                   'Yes, go back',
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       Navigator.pop(context);
//     }
//   }
//
//   bool _formHasData() {
//     return _nameController.text.isNotEmpty ||
//         _phoneController.text.isNotEmpty ||
//         _emailController.text.isNotEmpty ||
//         _websiteController.text.isNotEmpty ||
//         _aboutController.text.isNotEmpty ||
//         _selectedIndustry != null ||
//         _selectedState != null ||
//         _selectedCity != null ||
//         _imageFile != null;
//   }
//
//   Future<void> _handleSubmit() async {
//     if (_validateForm()) {
//       try {
//         setState(() => _isLoading = true);
//
//         // Create updateData map from form controllers
//         final Map<String, dynamic> updateData = {
//           'name': _nameController.text.trim(),
//           'number': _phoneController.text.trim(),
//           'email': _emailController.text.trim(),
//           'webUrl': _websiteController.text.trim(),
//           'about': _aboutController.text.trim(),
//           'occupation': _experienceYearController.text.trim(),
//           "interest": _interestedAreaController.text.toString(),
//           'state': _selectedState,
//           'city': _selectedCity,
//           'type': widget.type,
//         };
//
//         // Add conditional fields based on type
//         if (widget.type == 'business') {
//           updateData['industry'] = _selectedIndustry;
//         } else {
//           updateData['gender'] = _selectedGender;
//         }
//
//         if (_imageFile != null) {
//           updateData["image"] = _imageFile!.path;
//         }
//
//         // Handle image if selected
//         // if (_imageFile != null) {
//         //   // Convert image to base64 if needed
//         //   List<int> imageBytes = await _imageFile!.readAsBytes();
//         //   String base64Image = base64Encode(imageBytes);
//         //   updateData['image'] = base64Image;
//         // }
//
//         // Remove null values and empty strings
//         updateData.removeWhere((key, value) =>
//             value == null || (value is String && value.isEmpty));
//
//         // Call the API service
//         final response = await SalesProfile.updateSalesProfileData(
//           id: widget.advisor!.id,
//           type: widget.type,
//           updateData: updateData,
//         );
//
//         print("Patch Response ........${response}");
//
//         // Handle response
//         if (response == true) {
//           // Success
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Profile updated successfully')),
//           );
//
//           widget.action;
//           Navigator.pop(context);
//           Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => DashboardScreen(
//                       type: widget.type))); // Return true to indicate success
//         } else {
//           // Error
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Failed to update profile')),
//           );
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: ${e.toString()}')),
//         );
//       } finally {
//         setState(() => _isLoading = false);
//       }
//     }
//   }
//
// // Validation function
//   bool _validateForm() {
//     if (_nameController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter your name')),
//       );
//       return false;
//     }
//
//     if (_phoneController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter your phone number')),
//       );
//       return false;
//     }
//
//     if (_emailController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter your email')),
//       );
//       return false;
//     }
//
//     if (widget.type == 'business' && _selectedIndustry == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select an industry')),
//       );
//       return false;
//     }
//
//     if (_selectedState == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a state')),
//       );
//       return false;
//     }
//
//     if (_selectedCity == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a city')),
//       );
//       return false;
//     }
//
//     return true;
//   }
//
//   Widget _buildNavigationButtons() {
//     return Column(
//       children: [
//         SizedBox(
//           width: double.infinity,
//           height: 50,
//           child: ElevatedButton(
//             onPressed: _isLoading ? null : _handleSubmit,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.amber,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 2,
//             ),
//             child: _isLoading
//                 ? const SizedBox(
//                     height: 20,
//                     width: 20,
//                     child: CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                       strokeWidth: 2,
//                     ),
//                   )
//                 : const Text(
//                     'Update',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         SizedBox(
//           width: double.infinity,
//           height: 50,
//           child: TextButton(
//             onPressed: _isLoading ? null : () => _showBackConfirmation(),
//             style: TextButton.styleFrom(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text(
//               'Back',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.black54,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
