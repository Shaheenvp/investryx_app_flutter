// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:project_emergio/controller/dashboard_controller.dart';
// import 'package:project_emergio/models/all%20profile%20model.dart';
// import 'dart:io';
//
// import '../../../services/profile forms/franchise/franchise add.dart';
//
// class FranchiseFormScreen extends StatefulWidget {
//   final String type;
//   final bool isEdit;
//   final FranchiseExplr? franchise;
//   const FranchiseFormScreen({Key? key, required this.isEdit, this.franchise, required this.type})
//       : super(key: key);
//
//   @override
//   State<FranchiseFormScreen> createState() => _FranchiseFormScreenState();
// }
//
// class _FranchiseFormScreenState extends State<FranchiseFormScreen> {
//   final _formKey = GlobalKey<FormState>();
//
//   final _brandNameController = TextEditingController();
//   String _selectedIndustry = 'Fashion';
//   final _businessWebsiteController = TextEditingController();
//   final _initialInvestmentController = TextEditingController();
//   final _projectedRoiController = TextEditingController();
//   String _iamOffering = 'offer 1';
//   final _currentNumberOfOutletsController = TextEditingController();
//   final _franchiseTermsController = TextEditingController();
//   final _aboutYourBrandController = TextEditingController();
//   final _locationsAvailableController = TextEditingController();
//   final _kindOfSupportController = TextEditingController();
//   final _allProductsController = TextEditingController();
//   final _brandStartOperationController = TextEditingController();
//   final _spaceRequiredMinController = TextEditingController();
//   final _spaceRequiredMaxController = TextEditingController();
//   final _totalInvestmentFromController = TextEditingController();
//   final _totalInvestmentToController = TextEditingController();
//   final _brandFeeController = TextEditingController();
//   final _avgNoOfStaffController = TextEditingController();
//   final _avgMonthlySalesController = TextEditingController();
//   final _avgEBITDAController = TextEditingController();
//
//   List<PlatformFile>? _brandLogo;
//   List<XFile>? _businessPhotos;
//   List<PlatformFile>? _businessDocuments;
//   PlatformFile? _businessProof;
//
//   final DashboardController _controller = Get.put(DashboardController());
//
//   @override
//   initState() {
//     super.initState();
//     setTextFields();
//   }
//
//   void setTextFields() {
//     if (widget.franchise != null) {
//       _brandNameController.text = widget.franchise!.brandName;
//       _selectedIndustry = 'Fashion';
//       _businessWebsiteController.text = widget.franchise!.url ?? "";
//       _initialInvestmentController.text =
//           widget.franchise!.initialInvestment ?? "";
//       _projectedRoiController.text = widget.franchise!.projectedRoi ?? "";
//       String _iamOffering = 'offer 1';
//       _currentNumberOfOutletsController.text =
//           widget.franchise!.currentNumberOfOutlets ?? "";
//       _franchiseTermsController.text = widget.franchise!.franchiseTerms ?? "";
//       _aboutYourBrandController.text = widget.franchise!.description ?? "";
//       _locationsAvailableController.text =
//           widget.franchise!.locationsAvailable ?? "";
//       _kindOfSupportController.text = widget.franchise!.kindOfSupport ?? "";
//       _allProductsController.text = widget.franchise!.allProducts ?? "";
//       _brandStartOperationController.text =
//           widget.franchise!.brandStartOperation ?? "";
//       _spaceRequiredMinController.text =
//           widget.franchise!.spaceRequiredMin ?? "";
//       _spaceRequiredMaxController.text =
//           widget.franchise!.spaceRequiredMax ?? "";
//       _totalInvestmentFromController.text =
//           widget.franchise!.totalInvestmentFrom ?? "";
//       _totalInvestmentToController.text =
//           widget.franchise!.totalInvestmentTo ?? "";
//       _brandFeeController.text = widget.franchise!.brandFee ?? "";
//       _avgNoOfStaffController.text = widget.franchise!.avgNoOfStaff ?? "";
//       _avgMonthlySalesController.text = widget.franchise!.avgMonthlySales ?? "";
//       _avgEBITDAController.text = widget.franchise!.avgEBITDA ?? "";
//       _iamOffering = widget.franchise!.iamOffering ?? "offer 1";
//       _selectedIndustry = widget.franchise!.industry ?? "Fashion";
//     }
//   }
//
//   @override
//   void dispose() {
//     _brandNameController.dispose();
//     _businessWebsiteController.dispose();
//     _initialInvestmentController.dispose();
//     _projectedRoiController.dispose();
//     _currentNumberOfOutletsController.dispose();
//     _franchiseTermsController.dispose();
//     _aboutYourBrandController.dispose();
//     _locationsAvailableController.dispose();
//     _kindOfSupportController.dispose();
//     _allProductsController.dispose();
//     _brandStartOperationController.dispose();
//     _spaceRequiredMinController.dispose();
//     _spaceRequiredMaxController.dispose();
//     _totalInvestmentFromController.dispose();
//     _totalInvestmentToController.dispose();
//     _brandFeeController.dispose();
//     _avgNoOfStaffController.dispose();
//     _avgMonthlySalesController.dispose();
//     _avgEBITDAController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _pickBrandLogo() async {
//     final result = await FilePicker.platform.pickFiles(allowMultiple: true);
//     if (result != null) {
//       setState(() {
//         _brandLogo = result.files;
//       });
//     }
//   }
//
//   Future<void> _pickBusinessPhotos() async {
//     final result = await ImagePicker().pickMultiImage();
//     if (result != null) {
//       setState(() {
//         _businessPhotos = result;
//       });
//     }
//   }
//
//   Future<void> _pickBusinessDocuments() async {
//     final result = await FilePicker.platform.pickFiles(allowMultiple: true);
//     if (result != null) {
//       setState(() {
//         _businessDocuments = result.files;
//       });
//     }
//   }
//
//   Future<void> _pickBusinessProof() async {
//     final result = await FilePicker.platform.pickFiles(allowMultiple: false);
//     if (result != null) {
//       setState(() {
//         _businessProof = result.files.single;
//       });
//     }
//   }
//
//   InputDecoration _inputDecoration() {
//     return InputDecoration(
//         labelStyle: TextStyle(color: Color(0xff6C7278)),
//         border: OutlineInputBorder(),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15),
//           borderSide: BorderSide(color: Color.fromARGB(255, 224, 228, 230)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15),
//           borderSide: BorderSide(color: Colors.grey),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15),
//           borderSide: BorderSide(color: Colors.red),
//         ));
//   }
//
//   Widget _buildHintText(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0),
//       child: Text(
//         text,
//         style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w400,
//             color: Color(0xff6C7278)),
//       ),
//     );
//   }
//
//   String? _validateName(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Brand Name is required';
//     }
//     final namePattern = r'^[a-zA-Z\s]+$';
//     final regex = RegExp(namePattern);
//     if (!regex.hasMatch(value)) {
//       return 'Only letters and spaces are allowed';
//     }
//     if (value.length > 50) {
//       return 'Name cannot exceed 50 characters';
//     }
//     return null;
//   }
//
//   String? _validateYear(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Year is required';
//     }
//     if (!RegExp(r'^\d{4}$').hasMatch(value)) {
//       return 'Year should be exactly 4 digits';
//     }
//     int year = int.parse(value);
//     int currentYear = DateTime.now().year;
//     if (year < 1800 || year > currentYear) {
//       return 'Please enter a valid year between 1800 and $currentYear';
//     }
//     return null;
//   }
//
//   String? _validateTextArea(String? value, String fieldName,
//       {int minLength = 50, int maxLength = 1000}) {
//     if (value == null || value.isEmpty) {
//       return '$fieldName is required';
//     }
//     if (value.length < minLength) {
//       return '$fieldName should be at least $minLength characters long';
//     }
//     if (value.length > maxLength) {
//       return '$fieldName should not exceed $maxLength characters';
//     }
//     return null;
//   }
//
//   String? _validateEmployees(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Number of Employees is required';
//     }
//     int? employees = int.tryParse(value);
//     if (employees == null || employees < 1) {
//       return 'Please enter a valid number of employees';
//     }
//     if (employees > 1000000) {
//       return 'Number of employees should not exceed 1,000,000';
//     }
//     return null;
//   }
//
//   String? _validateSales(String? value, String fieldName) {
//     if (value == null || value.isEmpty) {
//       return '$fieldName is required';
//     }
//     double? sales = double.tryParse(value);
//     if (sales == null || sales < 0) {
//       return 'Please enter a valid number for $fieldName';
//     }
//     if (sales > 1000000000000) {
//       return '$fieldName should not exceed 1 trillion';
//     }
//     return null;
//   }
//
//   String? _validateEbitda(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'EBITDA is required';
//     }
//     double? ebitda = double.tryParse(value);
//     if (ebitda == null) {
//       return 'Please enter a valid number for EBITDA';
//     }
//     if (ebitda < 0 || ebitda > 100) {
//       return 'EBITDA should be between 0 and 100';
//     }
//     return null;
//   }
//
//   String? _validateUrl(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Company Website URL is required';
//     }
//     final urlPattern =
//         r'^(https?:\/\/)?([\w-]+\.)+[\w-]{2,4}(\.[\w-]{2,4})?(\/[\w\-\/]*)?$';
//
//     if (!RegExp(urlPattern).hasMatch(value)) {
//       return 'Please enter a valid URL';
//     }
//     if (value.length > 200) {
//       return 'URL should not exceed 200 characters';
//     }
//     return null;
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
//           icon: Icon(Icons.arrow_back_outlined, color: Color(0xff5A5A5A)),
//         ),
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding:
//                 const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Enter your Brand Information',
//                   style: TextStyle(
//                       color: Color(0xff5A5A5A),
//                       fontWeight: FontWeight.w400,
//                       fontSize: h * 0.028),
//                 ),
//                 SizedBox(height: 25.0),
//                 _buildHintText('Brand Name'),
//                 TextFormField(
//                   controller: _brandNameController,
//                   decoration: _inputDecoration(),
//                   validator: _validateName,
//                 ),
//                 SizedBox(height: 20.0),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildHintText('Industry'),
//                           DropdownButtonFormField<String>(
//                             value: _selectedIndustry,
//                             onChanged: (value) {
//                               setState(() {
//                                 _selectedIndustry = value!;
//                               });
//                             },
//                             items: [
//                               'Education',
//                               'Information Technology',
//                               'Healthcare',
//                               'Fashion',
//                               'Food',
//                               'Automobile',
//                               'Banking'
//                             ]
//                                 .map((industry) => DropdownMenuItem(
//                                       value: industry,
//                                       child: Text(
//                                         industry,
//                                         style: TextStyle(
//                                             color: Color(0xff6C7278),
//                                             fontWeight: FontWeight.w400,
//                                             fontSize: 16),
//                                       ),
//                                     ))
//                                 .toList(),
//                             decoration: _inputDecoration(),
//                             validator: (value) => value == null || value.isEmpty
//                                 ? 'Industry is required'
//                                 : null,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20.0),
//                 _buildHintText('Business Website URL'),
//                 TextFormField(
//                   controller: _businessWebsiteController,
//                   decoration: _inputDecoration(),
//                   validator: _validateUrl,
//                 ),
//                 SizedBox(height: 20.0),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildHintText('I am offering'),
//                           DropdownButtonFormField<String>(
//                             value: _iamOffering,
//                             onChanged: (value) {
//                               setState(() {
//                                 _iamOffering = value!;
//                               });
//                             },
//                             items: ['offer 1', 'offer 2', 'offer 3']
//                                 .map((industry) => DropdownMenuItem(
//                                       value: industry,
//                                       child: Text(industry,
//                                           style: TextStyle(
//                                               color: Color(0xff6C7278),
//                                               fontWeight: FontWeight.w400,
//                                               fontSize: 16)),
//                                     ))
//                                 .toList(),
//                             decoration: _inputDecoration(),
//                             validator: (value) => value == null || value.isEmpty
//                                 ? 'Offering is required'
//                                 : null,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20.0),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildHintText('Initial Investment'),
//                           TextFormField(
//                             controller: _initialInvestmentController,
//                             keyboardType: TextInputType.number,
//                             decoration: _inputDecoration(),
//                             validator: (value) =>
//                                 _validateSales(value, 'Initial Investment'),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: 16.0),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildHintText('Projected ROI'),
//                           TextFormField(
//                             controller: _projectedRoiController,
//                             keyboardType: TextInputType.number,
//                             decoration: _inputDecoration(),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Projected ROI is required';
//                               }
//                               double? roi = double.tryParse(value);
//                               if (roi == null || roi < 0 || roi > 100) {
//                                 return 'Projected ROI should be between 0 and 100';
//                               }
//                               return null;
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20.0),
//                 _buildHintText('Locations available for franchises'),
//                 TextFormField(
//                   controller: _locationsAvailableController,
//                   maxLines: null,
//                   decoration: _inputDecoration(),
//                   validator: (value) => _validateTextArea(
//                       value, 'Locations available',
//                       minLength: 10, maxLength: 500),
//                 ),
//                 SizedBox(height: 20.0),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildHintText('Current number of\noutlets'),
//                           TextFormField(
//                             controller: _currentNumberOfOutletsController,
//                             keyboardType: TextInputType.number,
//                             decoration: _inputDecoration(),
//                             validator: _validateEmployees,
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: 16.0),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildHintText('Franchise terms\n(Year period)'),
//                           TextFormField(
//                             controller: _franchiseTermsController,
//                             keyboardType: TextInputType.number,
//                             decoration: _inputDecoration(),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Franchise terms are required';
//                               }
//                               int? terms = int.tryParse(value);
//                               if (terms == null || terms <= 0) {
//                                 return 'Please enter a valid number of years';
//                               }
//                               if (terms > 100) {
//                                 return 'Franchise terms should not exceed 100 years';
//                               }
//                               return null;
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20.0),
//                 _buildHintText('About your brand'),
//                 TextFormField(
//                   controller: _aboutYourBrandController,
//                   maxLines: 4,
//                   decoration: _inputDecoration(),
//                   validator: (value) =>
//                       _validateTextArea(value, 'About your brand'),
//                 ),
//                 SizedBox(height: 20.0),
//                 _buildHintText('Space Required'),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           TextFormField(
//                             controller: _spaceRequiredMinController,
//                             keyboardType: TextInputType.number,
//                             decoration: _inputDecoration().copyWith(
//                                 hintText: 'Min',
//                                 hintStyle: TextStyle(
//                                     fontWeight: FontWeight.w400,
//                                     color: Color(
//                                         0xff6C7278)) // Set the hint text here
//                                 ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Minimum space is required';
//                               }
//                               int? space = int.tryParse(value);
//                               if (space == null || space <= 0) {
//                                 return 'Please enter a valid space requirement';
//                               }
//                               if (space > 1000000) {
//                                 return 'Minimum space should not exceed 1,000,000 sq ft';
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
//                           TextFormField(
//                             controller: _spaceRequiredMaxController,
//                             keyboardType: TextInputType.number,
//                             decoration: _inputDecoration().copyWith(
//                                 hintText: 'Max',
//                                 hintStyle: TextStyle(
//                                     fontWeight: FontWeight.w400,
//                                     color: Color(
//                                         0xff6C7278)) // Set the hint text here
//                                 ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Maximum space is required';
//                               }
//                               int? space = int.tryParse(value);
//                               if (space == null || space <= 0) {
//                                 return 'Please enter a valid space requirement';
//                               }
//                               if (space > 1000000) {
//                                 return 'Maximum space should not exceed 1,000,000 sq ft';
//                               }
//                               return null;
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20.0),
//                 _buildHintText('Total Investment Needed (INR)'),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           TextFormField(
//                             controller: _totalInvestmentFromController,
//                             keyboardType: TextInputType.number,
//                             decoration: _inputDecoration().copyWith(
//                                 hintText: 'From',
//                                 hintStyle: TextStyle(
//                                     fontWeight: FontWeight.w400,
//                                     color: Color(
//                                         0xff6C7278)) // Set the hint text here
//                                 ),
//                             validator: (value) =>
//                                 _validateSales(value, 'Minimum investment'),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: 16.0),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           TextFormField(
//                             controller: _totalInvestmentToController,
//                             keyboardType: TextInputType.number,
//                             decoration: _inputDecoration().copyWith(
//                                 hintText: 'To',
//                                 hintStyle: TextStyle(
//                                     fontWeight: FontWeight.w400,
//                                     color: Color(
//                                         0xff6C7278)) // Set the hint text here
//                                 ),
//                             validator: (value) =>
//                                 _validateSales(value, 'Maximum investment'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20.0),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildHintText('\nBrand fee'),
//                           TextFormField(
//                             controller: _brandFeeController,
//                             keyboardType: TextInputType.number,
//                             decoration: _inputDecoration(),
//                             validator: (value) =>
//                                 _validateSales(value, 'Brand fee'),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: 16.0),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildHintText('Average number of staff required'),
//                           TextFormField(
//                             controller: _avgNoOfStaffController,
//                             keyboardType: TextInputType.number,
//                             decoration: _inputDecoration(),
//                             validator: _validateEmployees,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20.0),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildHintText(
//                               'Average Monthly Sales per franchisee'),
//                           TextFormField(
//                             controller: _avgMonthlySalesController,
//                             keyboardType: TextInputType.number,
//                             decoration: _inputDecoration(),
//                             validator: (value) =>
//                                 _validateSales(value, 'Average Monthly Sales'),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: 16.0),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildHintText('Average EBITDA per franchise'),
//                           TextFormField(
//                             controller: _avgEBITDAController,
//                             keyboardType: TextInputType.number,
//                             decoration: _inputDecoration(),
//                             validator: _validateEbitda,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20.0),
//                 _buildHintText('When did your brand start operations?'),
//                 TextFormField(
//                   controller: _brandStartOperationController,
//                   decoration: _inputDecoration(),
//                   validator: _validateYear,
//                 ),
//                 SizedBox(height: 20.0),
//                 _buildHintText(
//                     'What kind of support can the franchisee expect from you?'),
//                 TextFormField(
//                   controller: _kindOfSupportController,
//                   maxLines: 4,
//                   decoration: _inputDecoration(),
//                   validator: (value) =>
//                       _validateTextArea(value, 'Kind of support'),
//                 ),
//                 SizedBox(height: 20.0),
//                 _buildHintText(
//                     'Mention all products/services your brand provides'),
//                 TextFormField(
//                   controller: _allProductsController,
//                   maxLines: 4,
//                   decoration: _inputDecoration(),
//                   validator: (value) => _validateTextArea(
//                       value, 'Products/services',
//                       minLength: 10, maxLength: 500),
//                 ),
//                 SizedBox(height: 20.0),
//                 Text(
//                   'Uploads your Documents',
//                   style: TextStyle(
//                       color: Color(0xff5A5A5A),
//                       fontWeight: FontWeight.w400,
//                       fontSize: h * 0.028),
//                 ),
//                 // SizedBox(height: 8.0),
//                 // Text(
//                 //   'Please provide the names of documents for verification purposes. These names will be publicly visible but will only be accessible to introduced members.',
//                 //   style: TextStyle(fontSize: 12.0),
//                 // ),
//                 SizedBox(height: 16.0),
//                 Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       _buildFileUploadRow(
//                           'Brand Logo', _pickBrandLogo, _brandLogo),
//                       _buildFileUploadRow('Business Photos',
//                           _pickBusinessPhotos, _businessPhotos),
//                       _buildFileUploadRow('Business Proof', _pickBusinessProof,
//                           _businessProof != null ? [_businessProof!] : null),
//                       // _buildFileUploadRow('Brochures and\ndocuments',
//                       //     _pickBusinessDocuments, _businessDocuments),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 32.0),
//                 SizedBox(
//                   height: 50,
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10)),
//                       backgroundColor: Color(0xffFFCC00),
//                     ),
//                     onPressed: () {
//                       widget.isEdit == true ? editForm() : _submitForm();
//                     },
//                     child: Text(
//                       'Verify',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 SizedBox(
//                   height: 50,
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                           side: BorderSide(
//                               color: Color.fromARGB(255, 224, 228, 230),
//                               width: 1),
//                           borderRadius: BorderRadius.circular(10)),
//                       backgroundColor: Colors.white,
//                     ),
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: Text(
//                       'Back',
//                       style: TextStyle(
//                         color: Color(0xff5A5A5A),
//                         fontSize: 16,
//                       ),
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
//   Widget _buildFileUploadRow(
//       String label, VoidCallback onPressed, List<dynamic>? files) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Container(
//         decoration: BoxDecoration(
//             border:
//                 Border.all(width: 1, color: Color.fromARGB(255, 224, 228, 230)),
//             borderRadius: BorderRadius.circular(15)),
//         height: 60,
//         child: Padding(
//           padding: const EdgeInsets.only(left: 10, right: 10),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(color: Color(0xff6C7278)),
//               ),
//               SizedBox(width: MediaQuery.of(context).size.width * 0.17),
//               IconButton(
//                   onPressed: onPressed,
//                   icon: Icon(
//                     Icons.upload_file,
//                     color: Color(0xffFFCC00),
//                   )),
//               if (files != null && files.isNotEmpty)
//                 Expanded(
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: files.map((file) {
//                         if (file is PlatformFile) {
//                           return Padding(
//                             padding: const EdgeInsets.only(left: 8.0),
//                             child: file.extension?.toLowerCase() == 'pdf'
//                                 ? Icon(Icons.picture_as_pdf, color: Colors.red)
//                                 : Image.file(
//                                     File(file.path!),
//                                     width: 50,
//                                     height: 40,
//                                     fit: BoxFit.cover,
//                                   ),
//                           );
//                         } else if (file is XFile) {
//                           return Padding(
//                             padding: const EdgeInsets.only(left: 8.0),
//                             child: Image.file(
//                               File(file.path),
//                               width: 50,
//                               height: 40,
//                               fit: BoxFit.cover,
//                             ),
//                           );
//                         }
//                         return SizedBox(); // Return an empty widget if the file type is unknown
//                       }).toList(),
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
//   void _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       if (_brandLogo == null || _businessProof == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text('Please select brand logo and business proof')),
//         );
//         return;
//       }
//
//       if (_businessPhotos == null || _businessPhotos!.length < 4) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Please select at least 4 business photos')),
//         );
//         return;
//       }
//
//       var success = await FranchiseAddPage.franchiseAddPage(
//         brandName: _brandNameController.text,
//         industry: _selectedIndustry,
//         businessWebsite: _businessWebsiteController.text,
//         initialInvestment: _initialInvestmentController.text,
//         projectedRoi: _projectedRoiController.text,
//         iamOffering: _iamOffering,
//         currentNumberOfOutlets: _currentNumberOfOutletsController.text,
//         franchiseTerms: _franchiseTermsController.text,
//         aboutYourBrand: _aboutYourBrandController.text,
//         locationsAvailable: _locationsAvailableController.text,
//         kindOfSupport: _kindOfSupportController.text,
//         allProducts: _allProductsController.text,
//         brandStartOperation: _brandStartOperationController.text,
//         spaceRequiredMin: _spaceRequiredMinController.text,
//         spaceRequiredMax: _spaceRequiredMaxController.text,
//         totalInvestmentFrom: _totalInvestmentFromController.text,
//         totalInvestmentTo: _totalInvestmentToController.text,
//         brandFee: _brandFeeController.text,
//         avgNoOfStaff: _avgNoOfStaffController.text,
//         avgMonthlySales: _avgMonthlySalesController.text,
//         avgEBITDA: _avgEBITDAController.text,
//         brandLogo: File(_brandLogo!.first.path!),
//         businessPhoto: File(_businessPhotos![0].path),
//         image2: File(_businessPhotos![1].path),
//         image3: File(_businessPhotos![2].path),
//         image4: File(_businessPhotos![3].path),
//         businessDocuments:
//             _businessDocuments?.map((file) => File(file.path!)).toList() ?? [],
//         businessProof: File(_businessProof!.path!),
//       );
//
//       if (success == true) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Form submitted successfully!')),
//         );
//
//         _controller.fetchListings("franchise");
//         Navigator.pop(context);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to submit form. Please try again. ')),
//         );
//       }
//     }
//   }
//
//   void editForm() async {
//     if (widget.franchise != null) {
//       if (_formKey.currentState!.validate()) {
//         var success = await FranchiseAddPage.updateFranchise(
//           franchiseId: widget.franchise!.id,
//           brandName: _brandNameController.text,
//           industry: _selectedIndustry,
//           businessWebsite: _businessWebsiteController.text,
//           initialInvestment: _initialInvestmentController.text,
//           projectedRoi: _projectedRoiController.text,
//           iamOffering: _iamOffering,
//           currentNumberOfOutlets: _currentNumberOfOutletsController.text,
//           franchiseTerms: _franchiseTermsController.text,
//           aboutYourBrand: _aboutYourBrandController.text,
//           locationsAvailable: _locationsAvailableController.text,
//           kindOfSupport: _kindOfSupportController.text,
//           allProducts: _allProductsController.text,
//           brandStartOperation: _brandStartOperationController.text,
//           spaceRequiredMin: _spaceRequiredMinController.text,
//           spaceRequiredMax: _spaceRequiredMaxController.text,
//           totalInvestmentFrom: _totalInvestmentFromController.text,
//           totalInvestmentTo: _totalInvestmentToController.text,
//           brandFee: _brandFeeController.text,
//           avgNoOfStaff: _avgNoOfStaffController.text,
//           avgMonthlySales: _avgMonthlySalesController.text,
//           avgEBITDA: _avgEBITDAController.text,
//           brandLogo: _brandLogo != null ? File(_brandLogo!.first.path!) : null,
//           image1:
//               _businessPhotos != null ? File(_businessPhotos![0].path) : null,
//           image2:
//               _businessPhotos != null ? File(_businessPhotos![1].path) : null,
//           image3:
//               _businessPhotos != null ? File(_businessPhotos![2].path) : null,
//           image4:
//               _businessPhotos != null ? File(_businessPhotos![3].path) : null,
//           doc1: _businessDocuments != null
//               ? File(_businessDocuments!.first.path!)
//               : null,
//           proof1: _businessProof != null && _businessProof!.path != null
//               ? File(_businessProof!.path!)
//               : null,
//         );
//
//         if (success == true) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Form submitted successfully!')),
//           );
//
//           _controller.fetchListings("franchise");
//           Navigator.pop(context);
//           // Navigator.pushReplacement(
//           //   context,
//           //   MaterialPageRoute(
//           //     builder: (context) => DashboardScreen(type: "franchise",),
//           //   ),
//           // );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//                 content: Text('Failed to submit form. Please try again. ')),
//           );
//         }
//       }
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:project_emergio/controller/dashboard_controller.dart';
import 'package:project_emergio/models/all%20profile%20model.dart';
import 'dart:io';

import '../../../services/profile forms/franchise/franchise add.dart';

class FranchiseFormScreen extends StatefulWidget {
  final String type;
  final bool isEdit;
  final FranchiseExplr? franchise;
  const FranchiseFormScreen(
      {Key? key, required this.isEdit, this.franchise, required this.type})
      : super(key: key);

  @override
  State<FranchiseFormScreen> createState() => _FranchiseFormScreenState();
}

class _FranchiseFormScreenState extends State<FranchiseFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _brandNameController = TextEditingController();
  String _selectedIndustry = 'Retail';
  final TextEditingController _otherIndustryController =
      TextEditingController();
  final _businessWebsiteController = TextEditingController();
  final _initialInvestmentController = TextEditingController();
  final _projectedRoiController = TextEditingController();
  String _iamOffering = 'Franchise Opportunity';
  final _currentNumberOfOutletsController = TextEditingController();
  final _franchiseTermsController = TextEditingController();
  final _aboutYourBrandController = TextEditingController();
  final _locationsAvailableController = TextEditingController();
  final _kindOfSupportController = TextEditingController();
  final _allProductsController = TextEditingController();
  final _brandStartOperationController = TextEditingController();
  final _spaceRequiredMinController = TextEditingController();
  final _spaceRequiredMaxController = TextEditingController();
  final _totalInvestmentFromController = TextEditingController();
  final _totalInvestmentToController = TextEditingController();
  final _brandFeeController = TextEditingController();
  final _avgNoOfStaffController = TextEditingController();
  final _avgMonthlySalesController = TextEditingController();
  final _avgEBITDAController = TextEditingController();

  List<PlatformFile>? _brandLogo;
  List<XFile>? _businessPhotos;
  List<PlatformFile>? _businessDocuments;
  PlatformFile? _businessProof;

  final DashboardController _controller = Get.put(DashboardController());

  // Comprehensive list of industries
  final List<String> _industries = [
    'Retail',
    'Food & Beverage',
    'Education & Training',
    'Healthcare & Wellness',
    'Fashion & Apparel',
    'Technology & Software',
    'Automotive',
    'Real Estate',
    'Beauty & Personal Care',
    'Home Services',
    'Entertainment & Recreation',
    'Travel & Tourism',
    'Financial Services',
    'Logistics & Transportation',
    'Manufacturing',
    'Agriculture',
    'Construction',
    'Media & Communications',
    'Professional Services',
    'Sports & Fitness',
    'Pet Care & Services',
    'Arts & Crafts',
    'Child Care & Services',
    'Environmental Services',
    'Other'
  ];

  bool get _isOtherIndustry => _selectedIndustry == 'Other';

  @override
  void initState() {
    super.initState();
    setTextFields();
  }

  void setTextFields() {
    if (widget.franchise != null) {
      _brandNameController.text = widget.franchise!.brandName;
      if (_industries.contains(widget.franchise!.industry)) {
        _selectedIndustry = widget.franchise!.industry ?? 'Retail';
      } else {
        _selectedIndustry = 'Other';
        _otherIndustryController.text = widget.franchise!.industry ?? '';
      }
      _businessWebsiteController.text = widget.franchise!.url ?? "";
      _initialInvestmentController.text =
          widget.franchise!.initialInvestment ?? "";
      _projectedRoiController.text = widget.franchise!.projectedRoi ?? "";
      _iamOffering = widget.franchise!.iamOffering ?? 'offer 1';
      _currentNumberOfOutletsController.text =
          widget.franchise!.currentNumberOfOutlets ?? "";
      _franchiseTermsController.text = widget.franchise!.franchiseTerms ?? "";
      _aboutYourBrandController.text = widget.franchise!.description ?? "";
      _locationsAvailableController.text =
          widget.franchise!.locationsAvailable ?? "";
      _kindOfSupportController.text = widget.franchise!.kindOfSupport ?? "";
      _allProductsController.text = widget.franchise!.allProducts ?? "";
      _brandStartOperationController.text =
          widget.franchise!.brandStartOperation ?? "";
      _spaceRequiredMinController.text =
          widget.franchise!.spaceRequiredMin ?? "";
      _spaceRequiredMaxController.text =
          widget.franchise!.spaceRequiredMax ?? "";
      _totalInvestmentFromController.text =
          widget.franchise!.totalInvestmentFrom ?? "";
      _totalInvestmentToController.text =
          widget.franchise!.totalInvestmentTo ?? "";
      _brandFeeController.text = widget.franchise!.brandFee ?? "";
      _avgNoOfStaffController.text = widget.franchise!.avgNoOfStaff ?? "";
      _avgMonthlySalesController.text = widget.franchise!.avgMonthlySales ?? "";
      _avgEBITDAController.text = widget.franchise!.avgEBITDA ?? "";
    }
  }

  @override
  void dispose() {
    _brandNameController.dispose();
    _otherIndustryController.dispose();
    _businessWebsiteController.dispose();
    _initialInvestmentController.dispose();
    _projectedRoiController.dispose();
    _currentNumberOfOutletsController.dispose();
    _franchiseTermsController.dispose();
    _aboutYourBrandController.dispose();
    _locationsAvailableController.dispose();
    _kindOfSupportController.dispose();
    _allProductsController.dispose();
    _brandStartOperationController.dispose();
    _spaceRequiredMinController.dispose();
    _spaceRequiredMaxController.dispose();
    _totalInvestmentFromController.dispose();
    _totalInvestmentToController.dispose();
    _brandFeeController.dispose();
    _avgNoOfStaffController.dispose();
    _avgMonthlySalesController.dispose();
    _avgEBITDAController.dispose();
    super.dispose();
  }

  Future<void> _pickBrandLogo() async {
    // If logo already exists, show warning
    if (_brandLogo != null && _brandLogo!.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Only 1 brand logo is allowed. Please remove the existing one first.')),
      );
      return;
    }

    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result != null) {
      setState(() {
        _brandLogo = result.files;
      });
    }
  }

  Future<void> _pickBusinessPhotos() async {
    // Check if we already have 4 images
    if (_businessPhotos != null && _businessPhotos!.length >= 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Maximum 4 business photos allowed')),
      );
      return;
    }

    final result = await ImagePicker().pickMultiImage();
    if (result != null) {
      setState(() {
        if (_businessPhotos == null) {
          // If no photos yet, initialize with the new ones (up to 4)
          _businessPhotos = result.take(4).toList();
        } else {
          // Add new photos but respect the limit of 4 total
          final remainingSlots = 4 - _businessPhotos!.length;
          if (remainingSlots > 0) {
            _businessPhotos!.addAll(result.take(remainingSlots));
          }
        }
      });

      // Show feedback if some photos were not added due to the limit
      if (result.length > 4 - (_businessPhotos?.length ?? 0)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Only added photos up to the maximum of 4')),
        );
      }
    }
  }

  Future<void> _pickBusinessDocuments() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        _businessDocuments = result.files;
      });
    }
  }

  Future<void> _pickBusinessProof() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result != null) {
      setState(() {
        _businessProof = result.files.single;
      });
    }
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      labelStyle: TextStyle(color: Color(0xff6C7278)),
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Color.fromARGB(255, 224, 228, 230)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.red),
      ),
    );
  }

  Widget _buildHintText(String text, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        isRequired ? '$text *' : text,
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xff6C7278)),
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Brand Name is required';
    }
    final namePattern = r'^[a-zA-Z\s]+$';
    final regex = RegExp(namePattern);
    if (!regex.hasMatch(value)) {
      return 'Only letters and spaces are allowed';
    }
    if (value.length > 50) {
      return 'Name cannot exceed 50 characters';
    }
    return null;
  }

  String? _validateIndustry(String? value) {
    if (value == 'Other') {
      if (_otherIndustryController.text.trim().isEmpty) {
        return 'Please specify the industry';
      }
    }
    return null;
  }

  String? _validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    final urlPattern =
        r'^(https?:\/\/)?([\w-]+\.)+[\w-]{2,4}(\.[\w-]{2,4})?(\/[\w\-\/]*)?$';
    if (!RegExp(urlPattern).hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    if (value.length > 200) {
      return 'URL should not exceed 200 characters';
    }
    return null;
  }

  String? _validateYear(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    if (!RegExp(r'^\d{4}$').hasMatch(value)) {
      return 'Year should be exactly 4 digits';
    }
    int year = int.parse(value);
    int currentYear = DateTime.now().year;
    if (year < 1800 || year > currentYear) {
      return 'Please enter a valid year between 1800 and $currentYear';
    }
    return null;
  }

  String? _validateTextArea(String? value, String fieldName,
      {int minLength = 50, int maxLength = 1000}) {
    bool isRequired = fieldName == 'About your brand';

    if (value == null || value.isEmpty) {
      return isRequired ? '$fieldName is required' : null;
    }

    if (value.length < minLength) {
      return '$fieldName should be at least $minLength characters long';
    }
    if (value.length > maxLength) {
      return '$fieldName should not exceed $maxLength characters';
    }
    return null;
  }

  String? _validateSales(String? value, String fieldName) {
    bool isRequired = fieldName == 'Initial Investment' ||
        fieldName == 'Minimum investment' ||
        fieldName == 'Maximum investment';

    if (value == null || value.isEmpty) {
      return isRequired ? '$fieldName is required' : null;
    }

    double? sales = double.tryParse(value);
    if (sales == null || sales < 0) {
      return 'Please enter a valid number for $fieldName';
    }
    if (sales > 1000000000000) {
      return '$fieldName should not exceed 1 trillion';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_outlined, color: Color(0xff5A5A5A)),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter your Brand Information',
                  style: TextStyle(
                      color: Color(0xff5A5A5A),
                      fontWeight: FontWeight.w400,
                      fontSize: h * 0.028),
                ),
                SizedBox(height: 25.0),

                // Brand Name (Required)
                _buildHintText('Brand Name', isRequired: true),
                TextFormField(
                  controller: _brandNameController,
                  decoration: _inputDecoration(),
                  validator: _validateName,
                ),
                SizedBox(height: 20.0),

                // Industry (Required)
                _buildHintText('Industry', isRequired: true),
                DropdownButtonFormField<String>(
                  value: _selectedIndustry,
                  onChanged: (value) {
                    setState(() {
                      _selectedIndustry = value!;
                      if (value != 'Other') {
                        _otherIndustryController.clear();
                      }
                    });
                  },
                  items: _industries
                      .map((industry) => DropdownMenuItem(
                            value: industry,
                            child: Text(industry),
                          ))
                      .toList(),
                  decoration: _inputDecoration(),
                  validator: _validateIndustry,
                ),

                if (_isOtherIndustry) ...[
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _otherIndustryController,
                    decoration: _inputDecoration().copyWith(
                      hintText: 'Please specify your industry',
                    ),
                    validator: (value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Please specify your industry';
                      }
                      return null;
                    },
                  ),
                ],

                SizedBox(height: 20.0),

                // Initial Investment (Required)
                _buildHintText('Initial Investment', isRequired: true),
                TextFormField(
                  controller: _initialInvestmentController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(),
                  validator: (value) =>
                      _validateSales(value, 'Initial Investment'),
                ),
                SizedBox(height: 20.0),

                // About Your Brand (Required)
                _buildHintText('About your Brand', isRequired: true),
                TextFormField(
                  controller: _aboutYourBrandController,
                  maxLines: 4,
                  decoration: _inputDecoration(),
                  validator: (value) =>
                      _validateTextArea(value, 'About your brand'),
                ),
                SizedBox(height: 20.0),

                // Total Investment Needed (Required)
                _buildHintText('Total Investment Needed (INR)',
                    isRequired: true),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _totalInvestmentFromController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration().copyWith(
                            hintText: 'From',
                            hintStyle: TextStyle(color: Color(0xff6C7278))),
                        validator: (value) =>
                            _validateSales(value, 'Minimum investment'),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: TextFormField(
                        controller: _totalInvestmentToController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration().copyWith(
                            hintText: 'To',
                            hintStyle: TextStyle(color: Color(0xff6C7278))),
                        validator: (value) =>
                            _validateSales(value, 'Maximum investment'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),

                // Optional Fields Below

                _buildHintText('Business Website URL'),
                TextFormField(
                  controller: _businessWebsiteController,
                  decoration: _inputDecoration(),
                  validator: _validateUrl,
                ),
                SizedBox(height: 20.0),

                _buildHintText('I am offering'),
                DropdownButtonFormField<String>(
                  value: _iamOffering,
                  onChanged: (value) {
                    setState(() {
                      _iamOffering = value!;
                    });
                  },
                  items: ['Franchise Opportunity', 'Dealership Opportunity', 'Reseller Opportunity', 'Distributor Opportunity','Sales Partner Opportunity']
                      .map((offer) => DropdownMenuItem(
                            value: offer,
                            child: Text(offer),
                          ))
                      .toList(),
                  decoration: _inputDecoration(),
                ),
                SizedBox(height: 20.0),

                _buildHintText('Current number of outlets'),
                TextFormField(
                  controller: _currentNumberOfOutletsController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(),
                ),
                SizedBox(height: 20.0),

                _buildHintText('Franchise terms (Year period)'),
                TextFormField(
                  controller: _franchiseTermsController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(),
                ),
                SizedBox(height: 20.0),

                _buildHintText('Locations available for franchises'),
                TextFormField(
                  controller: _locationsAvailableController,
                  maxLines: null,
                  decoration: _inputDecoration(),
                ),
                SizedBox(height: 20.0),

                _buildHintText('Space Required'),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _spaceRequiredMinController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration().copyWith(
                            hintText: 'Min',
                            hintStyle: TextStyle(color: Color(0xff6C7278))),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: TextFormField(
                        controller: _spaceRequiredMaxController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration().copyWith(
                            hintText: 'Max',
                            hintStyle: TextStyle(color: Color(0xff6C7278))),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),

                _buildHintText('Brand fee'),
                TextFormField(
                  controller: _brandFeeController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(),
                ),
                SizedBox(height: 20.0),

                _buildHintText('Average number of staff required'),
                TextFormField(
                  controller: _avgNoOfStaffController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(),
                ),
                SizedBox(height: 20.0),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHintText('Average Monthly Sales'),
                          TextFormField(
                            controller: _avgMonthlySalesController,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHintText('Average EBITDA'),
                          TextFormField(
                            controller: _avgEBITDAController,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),

                _buildHintText('When did your brand start operations?'),
                TextFormField(
                  controller: _brandStartOperationController,
                  decoration: _inputDecoration(),
                  keyboardType: TextInputType.number,
                  validator: _validateYear,
                ),
                SizedBox(height: 20.0),

                _buildHintText(
                    'What kind of support can the franchisee expect?'),
                TextFormField(
                  controller: _kindOfSupportController,
                  maxLines: 4,
                  decoration: _inputDecoration(),
                ),
                SizedBox(height: 20.0),

                _buildHintText(
                    'Mention all products/services your brand provides'),
                TextFormField(
                  controller: _allProductsController,
                  maxLines: 4,
                  decoration: _inputDecoration(),
                ),
                SizedBox(height: 32.0),

                // Document Upload Section
                Text(
                  'Upload your Documents',
                  style: TextStyle(
                      color: Color(0xff5A5A5A),
                      fontWeight: FontWeight.w400,
                      fontSize: h * 0.028),
                ),
                SizedBox(height: 16.0),

                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildFileUploadRow(
                          'Brand Logo', _pickBrandLogo, _brandLogo),
                      _buildFileUploadRow('Business Photos',
                          _pickBusinessPhotos, _businessPhotos),
                      _buildFileUploadRow('Business Proof', _pickBusinessProof,
                          _businessProof != null ? [_businessProof!] : null),
                    ],
                  ),
                ),
                SizedBox(height: 32.0),

                // Submit Buttons
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Color(0xffFFCC00),
                    ),
                    onPressed: () {
                      widget.isEdit ? editForm() : _submitForm();
                    },
                    child: Text(
                      'Verify',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Color.fromARGB(255, 224, 228, 230),
                              width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Back',
                      style: TextStyle(
                        color: Color(0xff5A5A5A),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Only get files that actually exist
        List<File> uploadFiles = [];
        File? brandLogoFile;
        File? businessProofFile;

        // Handle brand logo if exists (optional)
        if (_brandLogo != null && _brandLogo!.isNotEmpty && _brandLogo!.first.path != null) {
          try {
            final file = File(_brandLogo!.first.path!);
            if (await file.exists()) {
              brandLogoFile = file;
            }
          } catch (e) {
            print('Error with brand logo: $e');
          }
        }

        // Handle business photos if exist (optional)
        if (_businessPhotos != null) {
          for (var photo in _businessPhotos!) {
            try {
              final file = File(photo.path);
              if (await file.exists()) {
                uploadFiles.add(file);
              }
            } catch (e) {
              print('Error with business photo: $e');
              continue;
            }
          }
        }

        // Handle business proof if exists
        if (_businessProof != null && _businessProof!.path != null) {
          try {
            final file = File(_businessProof!.path!);
            if (await file.exists()) {
              businessProofFile = file;
            }
          } catch (e) {
            print('Error with business proof: $e');
          }
        }

        var success = await FranchiseAddPage.franchiseAddPage(
          brandName: _brandNameController.text,
          industry: _selectedIndustry == 'Other'
              ? _otherIndustryController.text
              : _selectedIndustry,
          businessWebsite: _businessWebsiteController.text,
          initialInvestment: _initialInvestmentController.text,
          projectedRoi: _projectedRoiController.text,
          iamOffering: _iamOffering,
          currentNumberOfOutlets: _currentNumberOfOutletsController.text,
          franchiseTerms: _franchiseTermsController.text,
          aboutYourBrand: _aboutYourBrandController.text,
          locationsAvailable: _locationsAvailableController.text,
          kindOfSupport: _kindOfSupportController.text,
          allProducts: _allProductsController.text,
          brandStartOperation: _brandStartOperationController.text,
          spaceRequiredMin: _spaceRequiredMinController.text,
          spaceRequiredMax: _spaceRequiredMaxController.text,
          totalInvestmentFrom: _totalInvestmentFromController.text,
          totalInvestmentTo: _totalInvestmentToController.text,
          brandFee: _brandFeeController.text,
          avgNoOfStaff: _avgNoOfStaffController.text,
          avgMonthlySales: _avgMonthlySalesController.text,
          avgEBITDA: _avgEBITDAController.text,
          brandLogo: brandLogoFile,
          businessPhoto: uploadFiles.isNotEmpty ? uploadFiles[0] : null,
          image2: uploadFiles.length > 1 ? uploadFiles[1] : null,
          image3: uploadFiles.length > 2 ? uploadFiles[2] : null,
          image4: uploadFiles.length > 3 ? uploadFiles[3] : null,
          businessDocuments: [], // Adjust as needed
          businessProof: businessProofFile,
        );

        if (success!) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Form submitted successfully!')),
          );
          _controller.fetchListings("franchise");
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit form. Please try again.')),
          );
        }
      } catch (e) {
        print('Error submitting form: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing form: ${e.toString()}')),
        );
      }
    }
  }

  void editForm() async {
    if (_formKey.currentState!.validate()) {
      // Prepare files with null safety
      File? brandLogoFile;
      if (_brandLogo != null && _brandLogo!.isNotEmpty && _brandLogo!.first.path != null) {
        brandLogoFile = File(_brandLogo!.first.path!);
      }

      // Create a list to store business photos
      List<File?> businessPhotos = [];
      if (_businessPhotos != null) {
        businessPhotos = _businessPhotos!.map((photo) => File(photo.path)).toList();
      }

      // Prepare business proof
      File? businessProofFile;
      if (_businessProof != null && _businessProof!.path != null) {
        businessProofFile = File(_businessProof!.path!);
      }

      // Prepare business documents
      File? businessDocFile;
      if (_businessDocuments != null &&
          _businessDocuments!.isNotEmpty &&
          _businessDocuments!.first.path != null) {
        businessDocFile = File(_businessDocuments!.first.path!);
      }

      var success = await FranchiseAddPage.updateFranchise(
        franchiseId: widget.franchise!.id,
        brandName: _brandNameController.text,
        industry: _selectedIndustry == 'Other'
            ? _otherIndustryController.text
            : _selectedIndustry,
        businessWebsite: _businessWebsiteController.text,
        initialInvestment: _initialInvestmentController.text,
        projectedRoi: _projectedRoiController.text,
        iamOffering: _iamOffering,
        currentNumberOfOutlets: _currentNumberOfOutletsController.text,
        franchiseTerms: _franchiseTermsController.text,
        aboutYourBrand: _aboutYourBrandController.text,
        locationsAvailable: _locationsAvailableController.text,
        kindOfSupport: _kindOfSupportController.text,
        allProducts: _allProductsController.text,
        brandStartOperation: _brandStartOperationController.text,
        spaceRequiredMin: _spaceRequiredMinController.text,
        spaceRequiredMax: _spaceRequiredMaxController.text,
        totalInvestmentFrom: _totalInvestmentFromController.text,
        totalInvestmentTo: _totalInvestmentToController.text,
        brandFee: _brandFeeController.text,
        avgNoOfStaff: _avgNoOfStaffController.text,
        avgMonthlySales: _avgMonthlySalesController.text,
        avgEBITDA: _avgEBITDAController.text,
        brandLogo: brandLogoFile,
        image1: businessPhotos.isNotEmpty ? businessPhotos[0] : null,
        image2: businessPhotos.length > 1 ? businessPhotos[1] : null,
        image3: businessPhotos.length > 2 ? businessPhotos[2] : null,
        image4: businessPhotos.length > 3 ? businessPhotos[3] : null,
        doc1: businessDocFile,
        proof1: businessProofFile,
      );

      if (success!) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Form updated successfully!')),
        );
        _controller.fetchListings("franchise");
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update form. Please try again.')),
        );
      }
    }
  }

  Widget _buildFileUploadRow(
      String label, VoidCallback onPressed, List<dynamic>? files) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
            border:
            Border.all(width: 1, color: Color.fromARGB(255, 224, 228, 230)),
            borderRadius: BorderRadius.circular(15)),
        height: 60,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(color: Color(0xff6C7278)),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.17),
              IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.upload_file,
                    color: Color(0xffFFCC00),
                  )),
              if (files != null && files.isNotEmpty)
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: files.map((file) {
                        if (file is PlatformFile) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Stack(
                              children: [
                                file.extension?.toLowerCase() == 'pdf'
                                    ? Icon(Icons.picture_as_pdf, color: Colors.red)
                                    : Image.file(
                                  File(file.path!),
                                  width: 50,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  right: -10,
                                  top: -10,
                                  child: IconButton(
                                    icon: Icon(Icons.cancel, color: Colors.red, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        // Remove this file
                                        if (label == 'Brand Logo') {
                                          _brandLogo = null;
                                        } else if (label == 'Business Proof') {
                                          _businessProof = null;
                                        } else if (label == 'Business Documents') {
                                          _businessDocuments?.remove(file);
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (file is XFile) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Stack(
                              children: [
                                Image.file(
                                  File(file.path),
                                  width: 50,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  right: -10,
                                  top: -10,
                                  child: IconButton(
                                    icon: Icon(Icons.cancel, color: Colors.red, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        // Remove this photo from business photos
                                        if (label == 'Business Photos') {
                                          _businessPhotos?.remove(file);
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return SizedBox();
                      }).toList(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
