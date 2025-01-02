// // import 'dart:io';
// // import 'package:file_picker/file_picker.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import '../../services/profile forms/advisor/advisor add.dart';
// //
// // class AdvisorFormScreen extends StatefulWidget {
// //   const AdvisorFormScreen({super.key});
// //
// //   @override
// //   State<AdvisorFormScreen> createState() => _AdvisorFormScreenState();
// // }
// //
// // class _AdvisorFormScreenState extends State<AdvisorFormScreen> {
// //   final _formKey = GlobalKey<FormState>(); // Form key to validate and save form
// //   final _advisorNameController = TextEditingController();
// //   final _designationController = TextEditingController();
// //   final _businessWebsiteController = TextEditingController();
// //   String _selectedState = '';
// //   String _selectedCity = '';
// //   final _contactNumberController = TextEditingController();
// //   final _describeExpertiseInController = TextEditingController();
// //   final _areaOfInterestController = TextEditingController();
// //
// //   List<PlatformFile>? _brandLogo;
// //   List<PlatformFile>? _businessPhotos;
// //   List<PlatformFile>? _businessDocuments;
// //   PlatformFile? _businessProof;
// //
// //   @override
// //   void dispose() {
// //     _advisorNameController.dispose();
// //     _designationController.dispose();
// //     _businessWebsiteController.dispose();
// //     _contactNumberController.dispose();
// //     _describeExpertiseInController.dispose();
// //     _areaOfInterestController.dispose();
// //     super.dispose();
// //   }
// //
// //   Future<void> _pickBrandLogo() async {
// //     final result = await FilePicker.platform.pickFiles(allowMultiple: true);
// //     if (result != null) {
// //       setState(() {
// //         _brandLogo = result.files;
// //       });
// //     }
// //   }
// //
// //   Future<void> _pickBusinessPhotos() async {
// //     final result = await FilePicker.platform.pickFiles(allowMultiple: true);
// //     if (result != null) {
// //       setState(() {
// //         _businessPhotos = result.files;
// //       });
// //     }
// //   }
// //
// //   Future<void> _pickBusinessDocuments() async {
// //     final result = await FilePicker.platform.pickFiles(allowMultiple: true);
// //     if (result != null) {
// //       setState(() {
// //         _businessDocuments = result.files;
// //       });
// //     }
// //   }
// //
// //   Future<void> _pickBusinessProof() async {
// //     final result = await FilePicker.platform.pickFiles(allowMultiple: false);
// //     if (result != null) {
// //       setState(() {
// //         _businessProof = result.files.single;
// //       });
// //     }
// //   }
// //
// //   String? _validateUrl(String? value) {
// //     if (value == null || value.trim().isEmpty) {
// //       return 'Company Website URL is required';
// //     }
// //     final urlPattern = r'^(https?:\/\/)?([\w-]+\.)+[\w-]{2,4}(\.[\w-]{2,4})?(\/[\w-]*)*\/?$';
// //     final regex = RegExp(urlPattern);
// //     if (!regex.hasMatch(value)) {
// //       return 'Please enter a valid URL (e.g., example.com or http://example.com)';
// //     }
// //     return null;
// //   }
// //
// //
// //   InputDecoration _inputDecoration() {
// //     return InputDecoration(
// //       border: OutlineInputBorder(),
// //       enabledBorder: OutlineInputBorder(
// //         borderSide: BorderSide(color: Colors.grey),
// //       ),
// //       focusedBorder: OutlineInputBorder(
// //         borderSide: BorderSide(color: Colors.blue),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildHintText(String text) {
// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 8.0),
// //       child: Text(
// //         text,
// //         style: TextStyle(fontWeight: FontWeight.w500),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _selectedState = 'State 1';
// //     _selectedCity = 'City 1';
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final h = MediaQuery.of(context).size.height;
// //     final w = MediaQuery.of(context).size.width;
// //     return Scaffold(
// //       appBar: AppBar(
// //         leading: IconButton(
// //           onPressed: () {
// //             Navigator.pop(context);
// //           },
// //           icon: Icon(Icons.arrow_back_outlined),
// //         ),
// //       ),
// //       body: SingleChildScrollView(
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Form(
// //             key: _formKey, // Assign form key to Form widget
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   'Advisor Information',
// //                   style: TextStyle(fontWeight: FontWeight.w700, fontSize: h * 0.025),
// //                 ),
// //                 SizedBox(height: h * .03),
// //                 _buildHintText('Advisor Name'),
// //                 TextFormField(
// //                   controller: _advisorNameController,
// //                   decoration: _inputDecoration(),
// //                   validator: (value) {
// //                     if (value == null || value.isEmpty) {
// //                       return 'Please enter the advisor name';
// //                     }
// //                     return null;
// //                   },
// //                 ),
// //                 SizedBox(height: 16.0),
// //                 _buildHintText('Designation'),
// //                 TextFormField(
// //                   controller: _designationController,
// //                   decoration: _inputDecoration(),
// //                   validator: (value) {
// //                     if (value == null || value.isEmpty) {
// //                       return 'Please enter the designation';
// //                     }
// //                     return null;
// //                   },
// //                 ),
// //                 SizedBox(height: 16.0),
// //                 _buildHintText('Company Website URL'),
// //                 TextFormField(
// //                   controller: _businessWebsiteController,
// //                   decoration: _inputDecoration(),
// //                   validator: _validateUrl,
// //                 ),
// //                 SizedBox(height: 16.0),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           _buildHintText('State'),
// //                           DropdownButtonFormField<String>(
// //                             value: _selectedState,
// //                             onChanged: (value) {
// //                               setState(() {
// //                                 _selectedState = value!;
// //                               });
// //                             },
// //                             items: ['State 1', 'State 2', 'State 3']
// //                                 .map((state) => DropdownMenuItem(
// //                               value: state,
// //                               child: Text(state),
// //                             ))
// //                                 .toList(),
// //                             decoration: _inputDecoration(),
// //                             validator: (value) {
// //                               if (value == null || value.isEmpty) {
// //                                 return 'Please select a state';
// //                               }
// //                               return null;
// //                             },
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                     SizedBox(width: 16.0),
// //                     Expanded(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           _buildHintText('City'),
// //                           DropdownButtonFormField<String>(
// //                             value: _selectedCity,
// //                             onChanged: (value) {
// //                               setState(() {
// //                                 _selectedCity = value!;
// //                               });
// //                             },
// //                             items: ['City 1', 'City 2', 'City 3']
// //                                 .map((city) => DropdownMenuItem(
// //                               value: city,
// //                               child: Text(city),
// //                             ))
// //                                 .toList(),
// //                             decoration: _inputDecoration(),
// //                             validator: (value) {
// //                               if (value == null || value.isEmpty) {
// //                                 return 'Please select a city';
// //                               }
// //                               return null;
// //                             },
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 SizedBox(height: 16.0),
// //                 _buildHintText('Contact Number'),
// //                 TextFormField(
// //                   controller: _contactNumberController,
// //                   maxLines: null,
// //                   decoration: _inputDecoration(),
// //                   keyboardType: TextInputType.phone,
// //                   validator: (value) {
// //                     if (value == null || value.isEmpty) {
// //                       return 'Please enter a contact number';
// //                     }
// //                     if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
// //                       return 'Please enter a valid contact number';
// //                     }
// //                     return null;
// //                   },
// //                 ),
// //                 SizedBox(height: 16.0),
// //                 _buildHintText('Describe where you are expertised in'),
// //                 TextFormField(
// //                   controller: _describeExpertiseInController,
// //                   maxLines: 4,
// //                   decoration: _inputDecoration(),
// //                   validator: (value) {
// //                     if (value == null || value.isEmpty) {
// //                       return 'Please describe your expertise';
// //                     }
// //                     return null;
// //                   },
// //                 ),
// //                 SizedBox(height: 16.0),
// //                 _buildHintText('Area of interest'),
// //                 TextFormField(
// //                   controller: _areaOfInterestController,
// //                   maxLines: 4,
// //                   decoration: _inputDecoration(),
// //                   validator: (value) {
// //                     if (value == null || value.isEmpty) {
// //                       return 'Please enter your area of interest';
// //                     }
// //                     return null;
// //                   },
// //                 ),
// //                 SizedBox(height: 16.0),
// //                 Text(
// //                   'Photos, Documents & Proof',
// //                   style: TextStyle(
// //                     fontSize: 16.0,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 SizedBox(height: 8.0),
// //                 Text(
// //                   'Please provide the names of documents for verification purposes. These names will be publicly visible but will only be accessible to introduced members.',
// //                   style: TextStyle(fontSize: 12.0),
// //                 ),
// //                 SizedBox(height: 16.0),
// //                 Center(
// //                   child: Container(
// //                     height: 200,
// //                     width: 360,
// //                     decoration: BoxDecoration(border: Border.all(color: Colors.black26)),
// //                     child: Column(
// //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                       children: [
// //                         Row(
// //                           crossAxisAlignment: CrossAxisAlignment.center,
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             Text('Brand Logo'),
// //                             SizedBox(width: w * 0.17),
// //                             ElevatedButton(
// //                               onPressed: _pickBrandLogo,
// //                               child: Text('Upload file'),
// //                               style: ElevatedButton.styleFrom(
// //                                 shape: RoundedRectangleBorder(
// //                                   borderRadius: BorderRadius.circular(2),
// //                                   side: BorderSide(color: Colors.black),
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                         Row(
// //                           crossAxisAlignment: CrossAxisAlignment.center,
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             Text('Business Photos'),
// //                             SizedBox(width: w * 0.17),
// //                             ElevatedButton(
// //                               onPressed: _pickBusinessPhotos,
// //                               child: Text('Upload file'),
// //                               style: ElevatedButton.styleFrom(
// //                                 shape: RoundedRectangleBorder(
// //                                   borderRadius: BorderRadius.circular(2),
// //                                   side: BorderSide(color: Colors.black),
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                         Row(
// //                           crossAxisAlignment: CrossAxisAlignment.center,
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             Text('Business Proof'),
// //                             SizedBox(width: w * 0.2),
// //                             ElevatedButton(
// //                               onPressed: _pickBusinessProof,
// //                               child: Text('Upload file'),
// //                               style: ElevatedButton.styleFrom(
// //                                 shape: RoundedRectangleBorder(
// //                                   borderRadius: BorderRadius.circular(2),
// //                                   side: BorderSide(color: Colors.black),
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                         Row(
// //                           crossAxisAlignment: CrossAxisAlignment.center,
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             Text('Brochures and\ndocuments'),
// //                             SizedBox(width: w * 0.1),
// //                             ElevatedButton(
// //                               onPressed: _pickBusinessDocuments,
// //                               child: Text('Upload file'),
// //                               style: ElevatedButton.styleFrom(
// //                                 shape: RoundedRectangleBorder(
// //                                   borderRadius: BorderRadius.circular(2),
// //                                   side: BorderSide(color: Colors.black),
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(height: 32.0),
// //                 SizedBox(
// //                   height: 50,
// //                   width: double.infinity,
// //                   child: ElevatedButton(
// //                     style: ElevatedButton.styleFrom(
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(10),
// //                       ),
// //                       backgroundColor: Color(0xff003C82),
// //                     ),
// //                     onPressed: () {
// //                       if (_formKey.currentState!.validate()) {
// //                         // Only submit if form is valid
// //                         _submitForm();
// //                       } else {
// //                         Get.snackbar(
// //                           'Error',
// //                           'Please correct the errors in the form',
// //                           backgroundColor: Colors.red,
// //                           colorText: Colors.white,
// //                           snackPosition: SnackPosition.BOTTOM,
// //                           borderRadius: 8,
// //                           margin: EdgeInsets.all(10),
// //                           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// //                         );
// //                       }
// //                     },
// //                     child: Text(
// //                       'Verify',
// //                       style: TextStyle(color: Colors.white),
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(height: 32.0),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Future<void> _submitForm() async {
// //     try {
// //       // Call the API to add advisor
// //       bool success = await AdvisorAddPage.advisorAddPage(
// //         advisorName: _advisorNameController.text.trim(),
// //         designation: _designationController.text.trim(),
// //         businessWebsite: _businessWebsiteController.text.trim(),
// //         state: _selectedState,
// //         city: _selectedCity,
// //         contactNumber: _contactNumberController.text.trim(),
// //         describeExpertise: _describeExpertiseInController.text.trim(),
// //         areaOfInterest: _areaOfInterestController.text.trim(),
// //         brandLogo: _brandLogo?.map((file) => File(file.path!)).toList() ?? [],
// //         businessPhotos: _businessPhotos?.map((file) => File(file.path!)).toList() ?? [],
// //         businessDocuments: _businessDocuments?.map((file) => File(file.path!)).toList() ?? [],
// //         businessProof: File(_businessProof!.path!),
// //       );
// //
// //       if (success) {
// //         Get.snackbar(
// //           'Success',
// //           'Advisor Profile Created successfully',
// //           backgroundColor: Colors.black54,
// //           colorText: Colors.white,
// //           snackPosition: SnackPosition.BOTTOM,
// //           borderRadius: 8,
// //           margin: EdgeInsets.all(10),
// //           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// //         );
// //         Navigator.pop(context);
// //       } else {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('Failed to add advisor')),
// //         );
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('An error occurred: $e')),
// //       );
// //     }
// //   }
// // }
//
//
//
// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:get/get.dart';
// import '../../../services/profile forms/advisor/advisor add.dart';
// import '../../Auth Screens/login.dart';
//
// class AdvisorFormScreen extends StatefulWidget {
//   const AdvisorFormScreen({super.key});
//
//   @override
//   State<AdvisorFormScreen> createState() => _AdvisorFormScreenState();
// }
//
// class _AdvisorFormScreenState extends State<AdvisorFormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _advisorNameController = TextEditingController();
//   final _designationController = TextEditingController();
//   final _businessWebsiteController = TextEditingController();
//   String? _selectedState;
//   String? _selectedCity;
//   final _contactNumberController = TextEditingController();
//   final _describeExpertiseInController = TextEditingController();
//   final _areaOfInterestController = TextEditingController();
//
//   List<PlatformFile>? _brandLogo;
//   List<PlatformFile>? _businessPhotos;
//   List<PlatformFile>? _businessDocuments;
//   PlatformFile? _businessProof;
//
//   // Map of states and their corresponding cities
//   final Map<String, List<String>> _stateCityMap = {
//     'Maharashtra': ['Mumbai', 'Pune', 'Nagpur'],
//     'Karnataka': ['Bangalore', 'Mysore', 'Hubli'],
//     'Tamil Nadu': ['Chennai', 'Coimbatore', 'Madurai'],
//   };
//
//   @override
//   void dispose() {
//     _advisorNameController.dispose();
//     _designationController.dispose();
//     _businessWebsiteController.dispose();
//     _contactNumberController.dispose();
//     _describeExpertiseInController.dispose();
//     _areaOfInterestController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _pickBrandLogo() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       allowMultiple: true,
//     );
//     if (result != null) {
//       setState(() {
//         _brandLogo = result.files;
//       });
//     }
//   }
//
//   Future<void> _pickBusinessPhotos() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       allowMultiple: true,
//     );
//     if (result != null) {
//       setState(() {
//         _businessPhotos = result.files;
//       });
//     }
//   }
//
//   Future<void> _pickBusinessDocuments() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'doc', 'docx'],
//       allowMultiple: true,
//     );
//     if (result != null) {
//       setState(() {
//         _businessDocuments = result.files;
//       });
//     }
//   }
//
//   Future<void> _pickBusinessProof() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
//       allowMultiple: false,
//     );
//     if (result != null) {
//       setState(() {
//         _businessProof = result.files.single;
//       });
//     }
//   }
//
//   String? _validateName(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'This field is required';
//     }
//     if (value.length > 50) {
//       return 'Name should not exceed 50 characters';
//     }
//     if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
//       return 'Name should only contain letters and spaces';
//     }
//     return null;
//   }
//
//   String? _validateUrl(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Company Website URL is required';
//     }
//     final urlPattern = r'^(https?:\/\/)?([\w-]+\.)+[\w-]{2,4}(\.[\w-]{2,4})?(\/[\w-]*)*\/?$';
//     final regex = RegExp(urlPattern);
//     if (!regex.hasMatch(value)) {
//       return 'Please enter a valid URL (e.g., example.com or http://example.com)';
//     }
//     return null;
//   }
//
//   String? _validatePhoneNumber(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter a contact number';
//     }
//     if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
//       return 'Please enter a valid 10-digit contact number';
//     }
//     return null;
//   }
//
//   String? _validateText(String? value, int maxLength) {
//     if (value == null || value.trim().isEmpty) {
//       return 'This field is required';
//     }
//     if (value.length > maxLength) {
//       return 'Text should not exceed $maxLength characters';
//     }
//     return null;
//   }
//
//   InputDecoration _inputDecoration() {
//     return InputDecoration(
//       border: OutlineInputBorder(),
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.grey),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.blue),
//       ),
//     );
//   }
//
//   Widget _buildHintText(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0),
//       child: Text(
//         text,
//         style: TextStyle(fontWeight: FontWeight.w500),
//       ),
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize with null values
//     _selectedState = null;
//     _selectedCity = null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(Icons.arrow_back_outlined),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Advisor Information',
//                   style: TextStyle(fontWeight: FontWeight.w700, fontSize: h * 0.025),
//                 ),
//                 SizedBox(height: h * .03),
//                 _buildHintText('Advisor Name'),
//                 TextFormField(
//                   controller: _advisorNameController,
//                   decoration: _inputDecoration(),
//                   validator: _validateName,
//                 ),
//                 SizedBox(height: 16.0),
//                 _buildHintText('Designation'),
//                 TextFormField(
//                   controller: _designationController,
//                   decoration: _inputDecoration(),
//                   validator: _validateName,
//                 ),
//                 SizedBox(height: 16.0),
//                 _buildHintText('Company Website URL'),
//                 TextFormField(
//                   controller: _businessWebsiteController,
//                   decoration: _inputDecoration(),
//                   validator: _validateUrl,
//                 ),
//                 SizedBox(height: 16.0),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildHintText('State'),
//                           DropdownButtonFormField<String>(
//                             value: _selectedState,
//                             hint: Text('Select a state'),
//                             onChanged: (value) {
//                               setState(() {
//                                 _selectedState = value;
//                                 _selectedCity = null; // Reset city when state changes
//                               });
//                             },
//                             items: _stateCityMap.keys
//                                 .map((state) => DropdownMenuItem(
//                               value: state,
//                               child: Text(state),
//                             ))
//                                 .toList(),
//                             decoration: _inputDecoration(),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please select a state';
//                               }
//                               return null;
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: 16.0),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildHintText('City'),
//                           DropdownButtonFormField<String>(
//                             value: _selectedCity,
//                             hint: Text('Select a city'),
//                             onChanged: (value) {
//                               setState(() {
//                                 _selectedCity = value;
//                               });
//                             },
//                             items: _selectedState != null
//                                 ? _stateCityMap[_selectedState]!
//                                 .map((city) => DropdownMenuItem(
//                               value: city,
//                               child: Text(city),
//                             ))
//                                 .toList()
//                                 : [],
//                             decoration: _inputDecoration(),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please select a city';
//                               }
//                               return null;
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16.0),
//                 _buildHintText('Contact Number'),
//                 TextFormField(
//                   controller: _contactNumberController,
//                   decoration: _inputDecoration(),
//                   keyboardType: TextInputType.phone,
//                   validator: _validatePhoneNumber,
//                 ),
//                 SizedBox(height: 16.0),
//                 _buildHintText('Describe where you are expertised in'),
//                 TextFormField(
//                   controller: _describeExpertiseInController,
//                   maxLines: 4,
//                   decoration: _inputDecoration(),
//                   validator: (value) => _validateText(value, 500),
//                 ),
//                 SizedBox(height: 16.0),
//                 _buildHintText('Area of interest'),
//                 TextFormField(
//                   controller: _areaOfInterestController,
//                   maxLines: 4,
//                   decoration: _inputDecoration(),
//                   validator: (value) => _validateText(value, 500),
//                 ),
//                 SizedBox(height: 16.0),
//                 Text(
//                   'Photos, Documents & Proof',
//                   style: TextStyle(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 8.0),
//                 Text(
//                   'Please provide the names of documents for verification purposes. These names will be publicly visible but will only be accessible to introduced members.',
//                   style: TextStyle(fontSize: 12.0),
//                 ),
//                 SizedBox(height: 16.0),
//                 Center(
//                   child: Container(
//                     height: 200,
//                     width: 360,
//                     decoration: BoxDecoration(border: Border.all(color: Colors.black26)),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         _buildFileUploadRow('Brand Logo', _pickBrandLogo, _brandLogo),
//                         _buildFileUploadRow('Business Photos', _pickBusinessPhotos, _businessPhotos),
//                         _buildFileUploadRow('Business Proof', _pickBusinessProof, _businessProof != null ? [_businessProof!] : null),
//                         _buildFileUploadRow('Brochures and\ndocuments', _pickBusinessDocuments, _businessDocuments),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 32.0),
//                 SizedBox(
//                   height: 50,
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       backgroundColor: Color(0xff003C82),
//                     ),
//                     onPressed: () {
//                       if (_formKey.currentState!.validate() && _businessProof != null) {
//                         _submitForm();
//                       } else {
//                         Get.snackbar(
//                           'Error',
//                           'Please correct the errors in the form and ensure all required documents are uploaded',
//                           backgroundColor: Colors.red,
//                           colorText: Colors.white,
//                           snackPosition: SnackPosition.BOTTOM,
//                           borderRadius: 8,
//                           margin: EdgeInsets.all(10),
//                           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                         );
//                       }
//                     },                    child: Text(
//                       'Verify',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 32.0),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFileUploadRow(String label, VoidCallback onPressed, List<PlatformFile>? files) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(label),
//         SizedBox(width: MediaQuery.of(context).size.width * 0.17),
//         ElevatedButton(
//           onPressed: onPressed,
//           child: Text('Upload file'),
//           style: ElevatedButton.styleFrom(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(2),
//               side: BorderSide(color: Colors.black),
//             ),
//           ),
//         ),
//         if (files != null && files.isNotEmpty)
//           Expanded(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: files.map((file) {
//                   return Padding(
//                     padding: const EdgeInsets.only(left: 8.0),
//                     child: file.extension?.toLowerCase() == 'pdf'
//                         ? Icon(Icons.picture_as_pdf, color: Colors.red)
//                         : Image.file(
//                       File(file.path!),
//                       width: 50,
//                       height: 40,
//                       fit: BoxFit.cover,
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
//   Future<void> _submitForm() async {
//     try {
//       if (_businessProof == null) {
//         Get.snackbar(
//           'Error',
//           'Please upload a business proof document',
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//         );
//         return;
//       }
//
//       Map<String, dynamic> result = await AdvisorAddPage.advisorAddPage(
//         advisorName: _advisorNameController.text.trim(),
//         designation: _designationController.text.trim(),
//         businessWebsite: _businessWebsiteController.text.trim(),
//         state: _selectedState!,
//         city: _selectedCity!,
//         contactNumber: _contactNumberController.text.trim(),
//         describeExpertise: _describeExpertiseInController.text.trim(),
//         areaOfInterest: _areaOfInterestController.text.trim(),
//         brandLogo: _brandLogo?.map((file) => File(file.path!)).toList() ?? [],
//         businessPhotos: _businessPhotos?.map((file) => File(file.path!)).toList() ?? [],
//         businessDocuments: _businessDocuments?.map((file) => File(file.path!)).toList() ?? [],
//         businessProof: File(_businessProof!.path!),
//       );
//
//       if (result['status'] == "loggedout") {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             duration: Duration(milliseconds: 1500),
//             content: Text('Your account has been blocked or deleted'),
//           ),
//         );
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage()));
//         await FlutterSecureStorage().delete(key: 'token');
//       } else if (result['status'] == true) {
//         Get.snackbar(
//           'Success',
//           'Advisor Profile Created successfully',
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//           borderRadius: 8,
//           margin: EdgeInsets.all(10),
//           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         );
//         Navigator.pop(context);
//       } else {
//         Get.snackbar(
//           'Error',
//           result['error'] ?? 'An unknown error occurred',
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//           borderRadius: 8,
//           margin: EdgeInsets.all(10),
//           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'An unexpected error occurred: $e',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         snackPosition: SnackPosition.BOTTOM,
//         borderRadius: 8,
//         margin: EdgeInsets.all(10),
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       );
//     }
//   }
// }