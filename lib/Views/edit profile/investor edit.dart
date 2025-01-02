// // import 'dart:io';
// // import 'package:file_picker/file_picker.dart';
// // import 'package:flutter/material.dart';
// // import 'package:project_emergio/Views/detail%20page/invester%20detail%20page.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // import '../../services/profile forms/investor/investor add.dart';
// //
// // class InvestorEditScreen extends StatefulWidget {
// //   final InvestorData investorData;
// //
// //   InvestorEditScreen({
// //     required this.investorData,
// //   });
// //
// //   @override
// //   State<InvestorEditScreen> createState() => _InvestorEditScreenState();
// // }
// //
// // class _InvestorEditScreenState extends State<InvestorEditScreen> {
// //   late TextEditingController _investorNameController;
// //   late TextEditingController _locationsIntrestedController;
// //   late TextEditingController _InvestmentRangefromController;
// //   late TextEditingController _InvestmentRangeToController;
// //   late TextEditingController _aspectsEvaluatingController;
// //   late TextEditingController _companyNameController;
// //   late TextEditingController _businessWebsiteController;
// //   late TextEditingController _aboutCompanyController;
// //
// //   File? _companyLogo;
// //   List<File> _businessDocuments = [];
// //   File? _businessProof;
// //
// //   bool _isSubmitting = false;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _investorNameController =
// //         TextEditingController(text: widget.investorData.name);
// //     _locationsIntrestedController =
// //         TextEditingController(text: widget.investorData.locationInterested);
// //     _InvestmentRangefromController =
// //         TextEditingController(text: widget.investorData.rangeStarting);
// //     _InvestmentRangeToController =
// //         TextEditingController(text: widget.investorData.rangeEnding);
// //     _aspectsEvaluatingController =
// //         TextEditingController(text: widget.investorData.evaluatingAspects);
// //     _companyNameController =
// //         TextEditingController(text: widget.investorData.companyName);
// //     _businessWebsiteController =
// //         TextEditingController(text: widget.investorData.url);
// //     _aboutCompanyController =
// //         TextEditingController(text: widget.investorData.description);
// //   }
// //
// //   @override
// //   void dispose() {
// //     _investorNameController.dispose();
// //     _locationsIntrestedController.dispose();
// //     _InvestmentRangefromController.dispose();
// //     _InvestmentRangeToController.dispose();
// //     _aspectsEvaluatingController.dispose();
// //     _companyNameController.dispose();
// //     _businessWebsiteController.dispose();
// //     _aboutCompanyController.dispose();
// //
// //     super.dispose();
// //   }
// //
// //   Future<void> _pickBusinessPhotos() async {
// //     final result = await FilePicker.platform.pickFiles(allowMultiple: true);
// //     if (result != null) {
// //       setState(() {
// //         _companyLogo = File(result.files.single.path!);
// //       });
// //     }
// //   }
// //
// //   Future<void> _pickDocument() async {
// //     FilePickerResult? result = await FilePicker.platform.pickFiles();
// //     if (result != null) {
// //       setState(() {
// //         _businessDocuments = result.paths.map((path) => File(path!)).toList();
// //       });
// //     }
// //   }
// //
// //   Future<void> _pickBusinessProof() async {
// //     final result = await FilePicker.platform.pickFiles(allowMultiple: false);
// //     if (result != null) {
// //       setState(() {
// //         _businessProof = File(result.files.single.path!);
// //       });
// //     }
// //   }
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
// //       body: Stack(
// //         children: [
// //           SingleChildScrollView(
// //             child: Padding(
// //               padding: const EdgeInsets.all(16.0),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     'Investor Information',
// //                     style: TextStyle(
// //                         fontWeight: FontWeight.w700, fontSize: h * 0.025),
// //                   ),
// //                   SizedBox(height: h * .03),
// //                   _buildHintText('Investor Name'),
// //                   TextFormField(
// //                     controller: _investorNameController,
// //                     decoration: _inputDecoration(),
// //                   ),
// //                   SizedBox(height: 16.0),
// //                   Row(
// //                     children: [
// //                       Expanded(
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             _buildHintText('Industry'),
// //                             DropdownButtonFormField<String>(
// //                               value: widget.investorData.industry,
// //                               onChanged: (value) {
// //                                 setState(() {
// //                                   widget.investorData.industry = value!;
// //                                 });
// //                               },
// //                               items: ['Fashion', 'Industry 2', 'Industry 3']
// //                                   .map((industry) => DropdownMenuItem(
// //                                         value: industry,
// //                                         child: Text(industry),
// //                                       ))
// //                                   .toList(),
// //                               decoration: _inputDecoration(),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       SizedBox(width: 16.0),
// //                     ],
// //                   ),
// //                   SizedBox(height: 16.0),
// //                   Row(
// //                     children: [
// //                       Expanded(
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             _buildHintText('State'),
// //                             DropdownButtonFormField<String>(
// //                               value: widget.investorData.state,
// //                               onChanged: (value) {
// //                                 setState(() {
// //                                   widget.investorData.state = value!;
// //                                 });
// //                               },
// //                               items: ['Kerala', 'State 2', 'State 3']
// //                                   .map((state) => DropdownMenuItem(
// //                                         value: state,
// //                                         child: Text(state),
// //                                       ))
// //                                   .toList(),
// //                               decoration: _inputDecoration(),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       SizedBox(width: 16.0),
// //                       Expanded(
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             _buildHintText('City'),
// //                             DropdownButtonFormField<String>(
// //                               value: widget.investorData.city,
// //                               onChanged: (value) {
// //                                 setState(() {
// //                                   widget.investorData.city = value!;
// //                                 });
// //                               },
// //                               items: ['Kakkanad', 'City 2', 'City 3']
// //                                   .map((city) => DropdownMenuItem(
// //                                         value: city,
// //                                         child: Text(city),
// //                                       ))
// //                                   .toList(),
// //                               decoration: _inputDecoration(),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   SizedBox(height: 16.0),
// //                   _buildHintText('Select location you are interested in'),
// //                   TextFormField(
// //                     controller: _locationsIntrestedController,
// //                     maxLines: null,
// //                     decoration: _inputDecoration(),
// //                   ),
// //                   SizedBox(height: 16.0),
// //                   Row(
// //                     children: [
// //                       Expanded(
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             _buildHintText('Investment Range'),
// //                             TextFormField(
// //                               controller: _InvestmentRangefromController,
// //                               keyboardType: TextInputType.number,
// //                               decoration: _inputDecoration(),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       SizedBox(width: 16.0),
// //                       Expanded(
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             _buildHintText('To'),
// //                             TextFormField(
// //                               controller: _InvestmentRangeToController,
// //                               keyboardType: TextInputType.number,
// //                               decoration: _inputDecoration(),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   SizedBox(height: 16.0),
// //                   _buildHintText(
// //                       'Aspects you consider when evaluating a business'),
// //                   TextFormField(
// //                     controller: _aspectsEvaluatingController,
// //                     decoration: _inputDecoration(),
// //                   ),
// //                   SizedBox(height: 16.0),
// //                   _buildHintText('Your Company Name'),
// //                   TextFormField(
// //                     controller: _companyNameController,
// //                     decoration: _inputDecoration(),
// //                   ),
// //                   SizedBox(height: 16.0),
// //                   _buildHintText('Company Website URL'),
// //                   TextFormField(
// //                     controller: _businessWebsiteController,
// //                     decoration: _inputDecoration(),
// //                   ),
// //                   SizedBox(height: 16.0),
// //                   _buildHintText('About Your Company'),
// //                   TextFormField(
// //                     maxLines: 5,
// //                     controller: _aboutCompanyController,
// //                     decoration: _inputDecoration(),
// //                   ),
// //                   SizedBox(height: 16.0),
// //                   Text(
// //                     'Upload your business logo',
// //                     style: TextStyle(fontWeight: FontWeight.w500),
// //                   ),
// //                   GestureDetector(
// //                     onTap: _pickBusinessPhotos,
// //                     child: Container(
// //                       margin: const EdgeInsets.only(top: 10, bottom: 10),
// //                       height: 150,
// //                       width: double.infinity,
// //                       color: Colors.grey[300],
// //                       child: _companyLogo == null
// //                           ? Icon(Icons.camera_alt, color: Colors.grey[700])
// //                           : Image.file(_companyLogo!, fit: BoxFit.cover),
// //                     ),
// //                   ),
// //                   SizedBox(height: 16.0),
// //                   Text(
// //                     'Upload your business documents',
// //                     style: TextStyle(fontWeight: FontWeight.w500),
// //                   ),
// //                   GestureDetector(
// //                     onTap: _pickDocument,
// //                     child: Container(
// //                       margin: const EdgeInsets.only(top: 10, bottom: 10),
// //                       height: 150,
// //                       width: double.infinity,
// //                       color: Colors.grey[300],
// //                       child: _businessDocuments.isEmpty
// //                           ? Icon(Icons.file_upload, color: Colors.grey[700])
// //                           : ListView.builder(
// //                               scrollDirection: Axis.horizontal,
// //                               itemCount: _businessDocuments.length,
// //                               itemBuilder: (context, index) {
// //                                 return Padding(
// //                                   padding: const EdgeInsets.all(8.0),
// //                                   child: Image.file(
// //                                     _businessDocuments[index],
// //                                     fit: BoxFit.cover,
// //                                   ),
// //                                 );
// //                               },
// //                             ),
// //                     ),
// //                   ),
// //                   SizedBox(height: 16.0),
// //                   Text(
// //                     'Business Proof',
// //                     style: TextStyle(fontWeight: FontWeight.w500),
// //                   ),
// //                   GestureDetector(
// //                     onTap: _pickBusinessProof,
// //                     child: Container(
// //                       margin: const EdgeInsets.only(top: 10, bottom: 10),
// //                       height: 150,
// //                       width: double.infinity,
// //                       color: Colors.grey[300],
// //                       child: _businessProof == null
// //                           ? Icon(Icons.file_upload, color: Colors.grey[700])
// //                           : Image.file(_businessProof!, fit: BoxFit.cover),
// //                     ),
// //                   ),
// //                   SizedBox(height: 16.0),
// //                   Center(
// //                     child: ElevatedButton(
// //                       onPressed: _isSubmitting
// //                           ? null
// //                           : () async {
// //                               final prefs =
// //                                   await SharedPreferences.getInstance();
// //                               final userId = prefs.getInt('userId');
// //
// //                               bool? success =
// //                                   await InvestorAddPage.updateInvestor(
// //                                       investorId: widget.investorData.id,
// //                                       name: _investorNameController.text,
// //                                       companyName: _companyNameController.text,
// //                                       industry: widget.investorData.industry!,
// //                                       description: _aboutCompanyController.text,
// //                                       state: widget.investorData.state!,
// //                                       city: widget.investorData.city!,
// //                                       url: _businessWebsiteController.text,
// //                                       rangeStarting:
// //                                           _InvestmentRangefromController.text,
// //                                       rangeEnding:
// //                                           _InvestmentRangeToController.text,
// //                                       evaluatingAspects:
// //                                           _aspectsEvaluatingController.text,
// //                                       locationInterested:
// //                                           _locationsIntrestedController.text,
// //                                       image1: _companyLogo!,
// //                                       doc1: _businessDocuments[0],
// //                                       proof1: _businessProof!);
// //                               if (success == true) {
// //                                 ScaffoldMessenger.of(context)
// //                                     .showSnackBar(SnackBar(
// //                                   content: Text(
// //                                       'Investment information updated successfully'),
// //                                   duration: Duration(seconds: 2),
// //                                 ));
// //                               } else {
// //                                 ScaffoldMessenger.of(context)
// //                                     .showSnackBar(SnackBar(
// //                                   content: Text(
// //                                       'Failed to update Investment information'),
// //                                   duration: Duration(seconds: 2),
// //                                 ));
// //                               }
// //                             },
// //                       child: _isSubmitting
// //                           ? CircularProgressIndicator()
// //                           : Text('Submit'),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //           if (_isSubmitting)
// //             Container(
// //               color: Colors.black.withOpacity(0.5),
// //               child: Center(
// //                 child: CircularProgressIndicator(),
// //               ),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// //
//
// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:lottie/lottie.dart';
// import 'package:project_emergio/Views/Profiles/investor/investment%20listing.dart';
// import 'package:project_emergio/services/profile%20forms/investor/investor%20add.dart';
// import 'package:project_emergio/services/profile%20forms/investor/investor%20get.dart';
//
// class InvestorEditScreen extends StatefulWidget {
//   final String investorId;
//
//   const InvestorEditScreen({super.key, required this.investorId});
//
//   @override
//   State<InvestorEditScreen> createState() => _InvestorEditScreenState();
// }
//
// class _InvestorEditScreenState extends State<InvestorEditScreen> {
//   final _formKey = GlobalKey<FormState>(); // Add GlobalKey for the form
//   final _investorNameController = TextEditingController();
//   String? _selectedIndustry;
//   String? _selectedState;
//   String? _selectedCity;
//   final _locationsIntrestedController = TextEditingController();
//   final _InvestmentRangefromController = TextEditingController();
//   final _InvestmentRangeToController = TextEditingController();
//   final _aspectsEvaluatingController = TextEditingController();
//   final _companyNameController = TextEditingController();
//   final _businessWebsiteController = TextEditingController();
//   final _aboutCompanyController = TextEditingController();
//
//   List<PlatformFile>? _businessPhotos;
//   List<PlatformFile>? _businessDocuments;
//   PlatformFile? _businessProof;
//
//   // New variables to store fetched image URLs
//   String? _fetchedBusinessPhotos;
//   String? _fetchedBusinessProof;
//   String? _fetchedBusinessDocuments;
//
//   String? _fetchedImage1;
//   String? _fetchedImage2;
//   String? _fetchedImage3;
//   String? _fetchedImage4;
//
//
//   bool _isLoading = true;
//   // Investor? _investor;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchInvestorData();
//   }
//
//
//   @override
//   void dispose() {
//     _investorNameController.dispose();
//     _locationsIntrestedController.dispose();
//     _InvestmentRangefromController.dispose();
//     _InvestmentRangeToController.dispose();
//     _aspectsEvaluatingController.dispose();
//     _companyNameController.dispose();
//     _businessWebsiteController.dispose();
//     _aboutCompanyController.dispose();
//
//     super.dispose();
//   }
//
//   Future<void> _fetchInvestorData() async {
//     setState(() => _isLoading = true);
//     try {
//       List<Investor>? investors = await InvestorFetchPage.fetchInvestorData();
//       if (investors != null && investors.isNotEmpty) {
//         _investor = investors.firstWhere((investor) => investor.id == widget.investorId);
//         _populateFields();
//       } else {
//         Get.snackbar('Error', 'No investor data found');
//       }
//     } catch (e) {
//       print('Error fetching investor data: $e');
//       Get.snackbar('Error', 'Failed to fetch investor data');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   void _populateFields() {
//     if (_investor != null) {
//       _investorNameController.text = _investor!.name ?? '';
//       _InvestmentRangefromController.text = _investor!.rangeStarting?.toString() ?? '';
//       _InvestmentRangeToController.text = _investor!.rangeEnding?.toString() ?? '';
//       _businessWebsiteController.text = _investor!.url ?? '';
//       _selectedState = _investor!.state;
//       _selectedCity = _investor!.city;
//       _selectedIndustry = _investor!.industry;
//       _locationsIntrestedController.text = _investor!.locationIntrested ?? '';
//       _aspectsEvaluatingController.text = _investor!.evaluatingAspects ?? '';
//       _companyNameController.text = _investor!.companyName ?? '';
//       _aboutCompanyController.text = _investor!.description ?? '';
//
//       // Populate image URLs
//       _fetchedBusinessPhotos = _investor!.imageUrl;
//       _fetchedImage1 = _investor!.imageUrl;
//       _fetchedImage2 = _investor!.image2;
//       _fetchedImage3 = _investor!.image3;
//       _fetchedImage4 = _investor!.image4;
//
//       // Populate document and proof URLs
//       _fetchedBusinessDocuments = _investor!.businessDocument;
//       _fetchedBusinessProof = _investor!.businessProof;
//
//       setState(() {}); // Trigger a rebuild to reflect the changes
//     }
//   }
//
//   Future<void> _updateInvestor() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         // Prepare the files, using null if no new file is selected
//         List<File?> businessPhotoFiles = [];
//         if (_businessPhotos != null) {
//           businessPhotoFiles = _businessPhotos!.map((file) => File(file.path!)).toList();
//         }
//         File? businessProofFile = _businessProof != null ? File(_businessProof!.path!) : null;
//         List<File?> businessDocumentFiles = [];
//         if (_businessDocuments != null) {
//           businessDocumentFiles = _businessDocuments!.map((file) => File(file.path!)).toList();
//         }
//
//         // Use fetched URLs if files are not selected
//         if (_fetchedBusinessPhotos != null && businessPhotoFiles.isEmpty) {
//           businessPhotoFiles.add(File(_fetchedBusinessPhotos!));
//         }
//         if (_fetchedBusinessProof != null && businessProofFile == null) {
//           businessProofFile = File(_fetchedBusinessProof!);
//         }
//         if (_fetchedBusinessDocuments != null && businessDocumentFiles.isEmpty) {
//           businessDocumentFiles.add(File(_fetchedBusinessDocuments!));
//         }
//
//         // Proceed with the update using either new or existing files
//         bool? success = await InvestorAddPage.updateInvestor(
//           companyName: _companyNameController.text,
//           url: _businessWebsiteController.text,
//           state: _selectedState ?? '',
//           rangeStarting: _InvestmentRangefromController.text,
//           rangeEnding: _InvestmentRangeToController.text,
//           locationInterested: _locationsIntrestedController.text,
//           industry: _selectedIndustry ?? '',
//           evaluatingAspects: _aspectsEvaluatingController.text,
//           description: _aboutCompanyController.text,
//           city: _selectedCity ?? '',
//           name: _investorNameController.text,
//           investorId: widget.investorId,
//           image1: businessPhotoFiles.isNotEmpty ? businessPhotoFiles[0]! : File(''),
//           image2: businessPhotoFiles.length > 1 ? businessPhotoFiles[1] : null,
//           image3: businessPhotoFiles.length > 2 ? businessPhotoFiles[2] : null,
//           image4: businessPhotoFiles.length > 3 ? businessPhotoFiles[3] : null,
//           doc1: businessDocumentFiles.isNotEmpty ? businessDocumentFiles[0]! : File(''),
//           proof1: businessProofFile ?? File(''),
//         );
//
//         if (success == true) {
//           Get.snackbar(
//             'Success',
//             'Investor profile updated successfully',
//             backgroundColor: Colors.black45,
//             colorText: Colors.white,
//             snackPosition: SnackPosition.BOTTOM,
//           );
//           // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InvestorListingsScreen()));
//         } else {
//           Get.snackbar(
//             'Error',
//             'Failed to update Investor profile',
//             backgroundColor: Colors.black45,
//             colorText: Colors.white,
//             snackPosition: SnackPosition.BOTTOM,
//           );
//         }
//       } catch (e) {
//         print('Error updating Investor profile: $e');
//         Get.snackbar(
//           'Error',
//           'An unexpected error occurred',
//           backgroundColor: Colors.black45,
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       }
//     } else {
//       Get.snackbar(
//         'Error',
//         'Please correct the errors in the form',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }
//
// // Add a new validation method for names
//   String? _validateName(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Investor Name is required';
//     }
//     final namePattern = r'^[a-zA-Z\s]+$'; // Allows only letters and spaces
//     final regex = RegExp(namePattern);
//     if (!regex.hasMatch(value)) {
//       return 'Only letters and spaces are allowed';
//     }
//     if (value.length > 50) { // Limit for the name
//       return 'Name cannot exceed 50 characters';
//     }
//     return null;
//   }
//
// // Similarly update other validation methods
//   String? _validateLimitedLength(String? value, String fieldName, int maxLength) {
//     if (value == null || value.trim().isEmpty) {
//       return '$fieldName is required';
//     }
//     if (value.length > maxLength) {
//       return '$fieldName cannot exceed $maxLength characters';
//     }
//     return null;
//   }
//
//   String? _validateUrl(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Company Website URL is required';
//     }
//     final urlPattern = r'^(https?:\/\/)?([a-zA-Z0-9\-]+\.)+[a-zA-Z]{2,6}(\/[^\s]*)?$'; // Updated regex
//     final regex = RegExp(urlPattern);
//     if (!regex.hasMatch(value)) {
//       return 'Please enter a valid URL (e.g., http://example.com or https://www.example.com)';
//     }
//     if (value.length > 100) { // Limit for the URL
//       return 'URL cannot exceed 100 characters';
//     }
//     return null;
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
//         _fetchedBusinessPhotos = null; // Clear fetched photos when new ones are picked
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
//         _fetchedBusinessDocuments = null; // Clear fetched documents when new ones are picked
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
//         _fetchedBusinessProof = null; // Clear fetched proof when new one is picked
//       });
//     }
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
//
//   String? _validateNotEmpty(String? value, String fieldName) {
//     if (value == null || value.trim().isEmpty) {
//       return '$fieldName is required';
//     }
//     return null;
//   }
//
//   String? _validateNumber(String? value, String fieldName) {
//     if (value == null || value.trim().isEmpty) {
//       return '$fieldName is required';
//     }
//     if (double.tryParse(value) == null) {
//       return 'Please enter a valid number for $fieldName';
//     }
//     return null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final h = MediaQuery
//         .of(context)
//         .size
//         .height;
//     final w = MediaQuery
//         .of(context)
//         .size
//         .width;
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(Icons.arrow_back_outlined),
//         ),
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey, // Assign the form key
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Investor Information',
//                       style: TextStyle(
//                           fontWeight: FontWeight.w700, fontSize: h * 0.025),
//                     ),
//                     SizedBox(height: h * .03),
//                     _buildHintText('Investor Name'),
//                     TextFormField(
//                       controller: _investorNameController,
//                       decoration: _inputDecoration(),
//                       validator: _validateName,
//                     ),
//                     SizedBox(height: 16.0),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _buildHintText('Industry'),
//                               DropdownButtonFormField<String>(
//                                 value: _selectedIndustry,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _selectedIndustry = value!;
//                                   });
//                                 },
//                                 items: ['Education', 'Information Technology', 'Healthcare','Fashion','Food','Automobile','Banking']
//
//                                     .map((industry) =>
//                                     DropdownMenuItem(
//                                       value: industry,
//                                       child: Text(industry),
//                                     ))
//                                     .toList(),
//                                 decoration: _inputDecoration(),
//                                 validator: (value) =>
//                                     _validateNotEmpty(value, 'Industry'),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(width: 16.0),
//                       ],
//                     ),
//                     SizedBox(height: 16.0),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _buildHintText('State'),
//                               DropdownButtonFormField<String>(
//                                 value: _selectedState,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _selectedState = value!;
//                                   });
//                                 },
//                                 items: ['AndhraPradesh', 'ArunachalPradesh', 'Assam', 'Bihar', 'Chhattisgarh', 'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand', 'Karnataka', 'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur', 'Meghalaya', 'Mizoram', 'Nagaland', 'Odisha', 'Punjab', 'Rajasthan', 'Sikkim', 'Tamil Nadu', 'Telangana', 'Tripura', 'UttarPradesh', 'Uttarakhand', 'WestBengal']
//                                     .map((state) =>
//                                     DropdownMenuItem(
//                                       value: state,
//                                       child: Text(state),
//                                     ))
//                                     .toList(),
//                                 decoration: _inputDecoration(),
//                                 validator: (value) =>
//                                     _validateNotEmpty(value, 'State'),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(width: 16.0),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _buildHintText('City'),
//                               DropdownButtonFormField<String>(
//                                 value: _selectedCity,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _selectedCity = value!;
//                                   });
//                                 },
//                                 items: ['Kochi', 'Kakkanad', 'Palarivattom']
//                                     .map((city) =>
//                                     DropdownMenuItem(
//                                       value: city,
//                                       child: Text(city),
//                                     ))
//                                     .toList(),
//                                 decoration: _inputDecoration(),
//                                 validator: (value) =>
//                                     _validateNotEmpty(value, 'City'),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 16.0),
//                     _buildHintText('Select location you are interested in'),
//                     TextFormField(
//                       controller: _locationsIntrestedController,
//                       maxLines: null,
//                       decoration: _inputDecoration(),
//                       validator: (value) => _validateLimitedLength(value, 'Location Interested', 100), // Set limit as needed
//                     ),
//                     SizedBox(height: 16.0),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _buildHintText('Investment Range From'),
//                               TextFormField(
//                                 controller: _InvestmentRangefromController,
//                                 keyboardType: TextInputType.number,
//                                 decoration: _inputDecoration(),
//                                 validator: (value) => _validateNumber(value, 'Investment Range From'),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(width: 16.0),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _buildHintText('Investment Range To'),
//                               TextFormField(
//                                 controller: _InvestmentRangeToController,
//                                 keyboardType: TextInputType.number,
//                                 decoration: _inputDecoration(),
//                                 validator: (value) => _validateNumber(value, 'Investment Range To'),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 16.0),
//                     _buildHintText(
//                         'Aspects you consider when evaluating a business'),
//                     TextFormField(
//                       controller: _aspectsEvaluatingController,
//                       decoration: _inputDecoration(),
//                       validator: (value) => _validateLimitedLength(value, 'Aspects Evaluating', 150), // Limit as needed
//                     ),
//                     SizedBox(height: 16.0),
//                     _buildHintText('Your Company Name'),
//                     TextFormField(
//                       controller: _companyNameController,
//                       decoration: _inputDecoration(),
//                       validator: (value) => _validateLimitedLength(value, 'Company Name', 50), // Limit as needed
//                     ),
//                     SizedBox(height: 16.0),
//                     _buildHintText('Company Website URL'),
//                     TextFormField(
//                       controller: _businessWebsiteController,
//                       decoration: _inputDecoration(),
//                       validator: _validateUrl,
//                     ),
//
//                     SizedBox(height: 16.0),
//                     _buildHintText('About Your Company'),
//                     TextFormField(
//                       maxLines: 5,
//                       controller: _aboutCompanyController,
//                       decoration: _inputDecoration(),
//                       validator: (value) => _validateLimitedLength(value, 'About Company', 250), // Limit as needed
//                     ),
//                     SizedBox(height: 16.0),
//                     Text(
//                       'Photos, Documents & Proof',
//                       style: TextStyle(
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 8.0),
//                     Text(
//                       'Please provide the names of documents for verification purposes. These names will be publicly visible but will only be accessible to introduced members.',
//                       style: TextStyle(fontSize: 12.0),
//                     ),
//                     SizedBox(height: 16.0),
//
//                             _buildBusinessPhotosSection(),
//                             _buildFileUploadRow('Business Documents', _pickBusinessDocuments, _businessDocuments, _fetchedBusinessDocuments),
//                             _buildFileUploadRow('Business Proof', _pickBusinessProof, _businessProof != null ? [_businessProof!] : null, _fetchedBusinessProof),
//                     SizedBox(height: 32.0),
//                     SizedBox(
//                       height: 50,
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                           backgroundColor: Color(0xff003C82),
//                         ),
//                         onPressed: ()  {
//                           _updateInvestor();
//                         },
//                         child: Text(
//                           'Verify',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 32.0),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           // if (_isSubmitting)
//           //   Container(
//           //       color: Colors.black.withOpacity(0.5),
//           //       child: Center(
//           //         child: Lottie.asset(
//           //           'assets/loading.json',
//           //           height: 80.h,
//           //           width: 120.w,
//           //           fit: BoxFit.cover,
//           //         ),
//           //       )
//           //   ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBusinessPhotosSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Business Photos', style: TextStyle(fontWeight: FontWeight.bold)),
//         SizedBox(height: 8),
//         Row(
//           children: [
//             Expanded(child: _buildImagePreview(0)),
//             SizedBox(width: 8),
//             Expanded(child: _buildImagePreview(1)),
//           ],
//         ),
//         SizedBox(height: 8),
//         Row(
//           children: [
//             Expanded(child: _buildImagePreview(2)),
//             SizedBox(width: 8),
//             Expanded(child: _buildImagePreview(3)),
//           ],
//         ),
//         SizedBox(height: 16),
//         ElevatedButton(
//           onPressed: _pickBusinessPhotos,
//           child: Text('Upload Business Photos'),
//           style: ElevatedButton.styleFrom(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(2),
//               side: BorderSide(color: Colors.black),
//             ),
//           ),
//         ),
//         if (_businessPhotos != null && _businessPhotos!.isNotEmpty)
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Text('${_businessPhotos!.length} new photo(s) selected'),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildImagePreview(int index) {
//     String label = 'Image ${index + 1}';
//     String? fetchedImageUrl;
//     switch (index) {
//       case 0:
//         fetchedImageUrl = _fetchedImage1;
//         break;
//       case 1:
//         fetchedImageUrl = _fetchedImage2;
//         break;
//       case 2:
//         fetchedImageUrl = _fetchedImage3;
//         break;
//       case 3:
//         fetchedImageUrl = _fetchedImage4;
//         break;
//     }
//
//     return Column(
//       children: [
//         Container(
//           height: 100,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey),
//             borderRadius: BorderRadius.circular(4),
//           ),
//           child: _businessPhotos != null && index < _businessPhotos!.length
//               ? Image.file(
//             File(_businessPhotos![index].path!),
//             fit: BoxFit.cover,
//             errorBuilder: (context, error, stackTrace) {
//               return Center(child: Text('Error loading new image'));
//             },
//           )
//               : (fetchedImageUrl != null
//               ? Image.network(
//             fetchedImageUrl,
//             fit: BoxFit.cover,
//             errorBuilder: (context, error, stackTrace) {
//               return Center(child: Text('Error loading fetched image'));
//             },
//           )
//               : Center(child: Text('No image'))),
//         ),
//         SizedBox(height: 4),
//         Text(label, style: TextStyle(fontSize: 12)),
//       ],
//     );
//   }
//
//   Widget _buildFileUploadRow(String label, VoidCallback onPressed, List<PlatformFile>? files, String? fetchedUrl) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(label),
//         SizedBox(width: 17),
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
//           )
//         else if (fetchedUrl != null)
//           Expanded(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 8.0),
//                     child: fetchedUrl.toLowerCase().endsWith('.pdf')
//                         ? Icon(Icons.picture_as_pdf, color: Colors.red)
//                         : Image.network(
//                       fetchedUrl,
//                       width: 50,
//                       height: 40,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Icon(Icons.error);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
// }
//
