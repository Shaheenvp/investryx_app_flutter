// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:project_emergio/services/profile%20forms/franchise/franchise%20get.dart';
// import 'dart:io';
// import '../../services/profile forms/franchise/franchise add.dart';
//
//
// class FranchiseEditScreen extends StatefulWidget {
//   final String franchiseId;
//
//   const FranchiseEditScreen({Key? key, required this.franchiseId}) : super(key: key);
//
//   @override
//   State<FranchiseEditScreen> createState() => _FranchiseEditScreenState();
// }
//
// class _FranchiseEditScreenState extends State<FranchiseEditScreen> {
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
//   List<PlatformFile>? _businessPhotos;
//   List<PlatformFile>? _businessDocuments;
//   PlatformFile? _businessProof;
//
//   // New variables to store fetched image URLs
//   String? _fetchedBrandLogo;
//   String? _fetchedBusinessPhotos;
//   String? _fetchedBusinessProof;
//   String? _fetchedBusinessDocuments;
//
//   String? _fetchedImage1;
//   String? _fetchedImage2;
//   String? _fetchedImage3;
//   String? _fetchedImage4;
//
//   bool _isLoading = true;
//   Franchise? _franchise;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchFranchiseData();
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
//   Future<void> _fetchFranchiseData() async {
//     setState(() => _isLoading = true);
//     try {
//       List<Franchise>? franchise = await FranchiseFetchPage.fetchFranchiseData();
//       if (franchise != null && franchise.isNotEmpty) {
//         _franchise = franchise.firstWhere((franchises) => franchises.id == widget.franchiseId);
//         _populateFields();
//       }
//     } catch (e) {
//       print('Error fetching Franchise data: $e');
//       Get.snackbar('Error', 'Failed to fetch Franchise data');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   void _populateFields() {
//     if (_franchise != null) {
//       _brandNameController.text = _franchise!.brandName;
//       _selectedIndustry = _franchise!.industry ?? 'Fashion'; // Assuming 'Fashion' is the default
//       _businessWebsiteController.text = _franchise!.url ?? '';
//       _initialInvestmentController.text = _franchise!.initialInvestment?.toString() ?? '';
//       _projectedRoiController.text = _franchise!.projectedRoi?.toString() ?? '';
//       _iamOffering = _franchise!.iamOffering ?? 'offer 1'; // Assuming 'offer 1' is the default
//       _currentNumberOfOutletsController.text = _franchise!.currentNumberOfOutlets?.toString() ?? '';
//       _franchiseTermsController.text = _franchise!.franchiseTerms?.toString() ?? '';
//       _aboutYourBrandController.text = _franchise!.description ?? '';
//       _locationsAvailableController.text = _franchise!.locationsAvailable ?? '';
//       _kindOfSupportController.text = _franchise!.kindOfSupport ?? '';
//       _allProductsController.text = _franchise!.allProducts ?? '';
//       _brandStartOperationController.text = _franchise!.brandStartOperation?.toString() ?? '';
//       _spaceRequiredMinController.text = _franchise!.spaceRequiredMin?.toString() ?? '';
//       _spaceRequiredMaxController.text = _franchise!.spaceRequiredMax?.toString() ?? '';
//       _totalInvestmentFromController.text = _franchise!.totalInvestmentFrom?.toString() ?? '';
//       _totalInvestmentToController.text = _franchise!.totalInvestmentTo?.toString() ?? '';
//       _brandFeeController.text = _franchise!.brandFee?.toString() ?? '';
//       _avgNoOfStaffController.text = _franchise!.avgNoOfStaff?.toString() ?? '';
//       _avgMonthlySalesController.text = _franchise!.avgMonthlySales?.toString() ?? '';
//       _avgEBITDAController.text = _franchise!.avgEBITDA?.toString() ?? '';
//
//       // Store fetched image URLs
//       _fetchedBrandLogo = _franchise!.imageUrl;
//       _fetchedBusinessPhotos = _franchise!.businessPhotos;
//       _fetchedBusinessProof = _franchise!.businessProof;
//       _fetchedBusinessDocuments = _franchise!.businessDocuments;
//
//       // Store fetched image URLs
//       _fetchedBrandLogo = _franchise!.imageUrl;
//       _fetchedBusinessPhotos = _franchise!.businessPhotos;
//       _fetchedBusinessProof = _franchise!.businessProof;
//       _fetchedBusinessDocuments = _franchise!.businessDocuments;
//
//       // Store individual image URLs
//       _fetchedImage1 = _franchise!.imageUrl;
//       _fetchedImage2 = _franchise!.image2;
//       _fetchedImage3 = _franchise!.image3;
//       _fetchedImage4 = _franchise!.image4;
//     }
//   }
//
//   Future<void> _updateFranchise() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         // Prepare the files, using null if no new file is selected
//         File? brandLogoFile = _brandLogo?.isNotEmpty == true ? File(_brandLogo!.first.path!) : null;
//
//         List<File?> businessPhotoFiles = [null, null, null, null];
//         if (_businessPhotos != null) {
//           for (int i = 0; i < _businessPhotos!.length && i < 4; i++) {
//             businessPhotoFiles[i] = File(_businessPhotos![i].path!);
//           }
//         }
//
//         File? businessProofFile = _businessProof != null ? File(_businessProof!.path!) : null;
//         File? businessDocumentFile = _businessDocuments?.isNotEmpty == true ? File(_businessDocuments!.first.path!) : null;
//
//         bool? success = await FranchiseAddPage.updateFranchise(
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
//           brandLogo: brandLogoFile,
//           image1: businessPhotoFiles[0] ?? File(''),
//           image2: businessPhotoFiles[1],
//           image3: businessPhotoFiles[2],
//           image4: businessPhotoFiles[3],
//           doc1: businessDocumentFile ?? File(''),
//           proof1: businessProofFile ?? File(''),
//           franchiseId: widget.franchiseId,
//         );
//
//         if (success == true) {
//           Get.snackbar(
//             'Success',
//             'Franchise profile updated successfully',
//             backgroundColor: Colors.black45,
//             colorText: Colors.white,
//             snackPosition: SnackPosition.BOTTOM,
//           );
//           // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FranchiseListingsScreen()));
//         } else {
//           Get.snackbar(
//             'Error',
//             'Failed to update Franchise profile',
//             backgroundColor: Colors.black45,
//             colorText: Colors.white,
//             snackPosition: SnackPosition.BOTTOM,
//           );
//         }
//       } catch (e) {
//         print('Error updating Franchise profile: $e');
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
//     final result = await FilePicker.platform.pickFiles(allowMultiple: true);
//     if (result != null) {
//       setState(() {
//         _businessPhotos = result.files;
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
//         r'^(https?:\/\/)?([\w-]+\.)+[\w-]{2,4}(\.[\w-]{2,4})?(\/[\w-]*)*\/?$';
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
//           icon: Icon(Icons.arrow_back_outlined),
//         ),
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Franchise Information',
//                   style: TextStyle(
//                       fontWeight: FontWeight.w700, fontSize: h * 0.025),
//                 ),
//                 SizedBox(height: h * .03),
//                 _buildHintText('Brand Name'),
//                 TextFormField(
//                   controller: _brandNameController,
//                   decoration: _inputDecoration(),
//                   validator: _validateName,
//                 ),
//                 SizedBox(height: 16.0),
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
//                               value: industry,
//                               child: Text(industry),
//                             ))
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
//                 SizedBox(height: 16.0),
//                 _buildHintText('Business Website URL'),
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
//                 SizedBox(height: 16.0),
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
//                               value: industry,
//                               child: Text(industry),
//                             ))
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
//                 SizedBox(height: 16.0),
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
//                 SizedBox(height: 16.0),
//                 _buildHintText('About your brand'),
//                 TextFormField(
//                   controller: _aboutYourBrandController,
//                   maxLines: 4,
//                   decoration: _inputDecoration(),
//                   validator: (value) =>
//                       _validateTextArea(value, 'About your brand'),
//                 ),
//                 SizedBox(height: 16.0),
//                 _buildHintText('Locations available for franchises'),
//                 TextFormField(
//                   controller: _locationsAvailableController,
//                   maxLines: null,
//                   decoration: _inputDecoration(),
//                   validator: (value) => _validateTextArea(
//                       value, 'Locations available',
//                       minLength: 10, maxLength: 500),
//                 ),
//                 SizedBox(height: 16.0),
//                 _buildHintText(
//                     'What kind of support can the franchisee expect from you?'),
//                 TextFormField(
//                   controller: _kindOfSupportController,
//                   maxLines: 4,
//                   decoration: _inputDecoration(),
//                   validator: (value) =>
//                       _validateTextArea(value, 'Kind of support'),
//                 ),
//                 SizedBox(height: 16.0),
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
//                 SizedBox(height: 16.0),
//                 _buildHintText('When did your brand start operations?'),
//                 TextFormField(
//                   controller: _brandStartOperationController,
//                   decoration: _inputDecoration(),
//                   validator: _validateYear,
//                 ),
//                 SizedBox(height: 16.0),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildHintText('Space Required\n(min)'),
//                           TextFormField(
//                             controller: _spaceRequiredMinController,
//                             keyboardType: TextInputType.number,
//                             decoration: _inputDecoration(),
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
//                           _buildHintText('(max)'),
//                           TextFormField(
//                             controller: _spaceRequiredMaxController,
//                             keyboardType: TextInputType.number,
//                             decoration: _inputDecoration(),
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
//                 SizedBox(height: 16.0),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildHintText('Total Investment Needed\n(INR)'),
//                           TextFormField(
//                             controller: _totalInvestmentFromController,
//                             keyboardType: TextInputType.number,
//                             decoration: _inputDecoration(),
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
//                           _buildHintText('(TO)'),
//                           TextFormField(
//                             controller: _totalInvestmentToController,
//                             keyboardType: TextInputType.number,
//                             decoration: _inputDecoration(),
//                             validator: (value) =>
//                                 _validateSales(value, 'Maximum investment'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16.0),
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
//                 SizedBox(height: 16.0),
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
//                         _buildBusinessPhotosSection(),
//                         // SizedBox(height: 16.0),
//                         _buildFileUploadRow('Brand Logo', _pickBrandLogo, _brandLogo, _fetchedBrandLogo),
//                         _buildFileUploadRow('Business Proof', _pickBusinessProof, _businessProof != null ? [_businessProof!] : null, _fetchedBusinessProof),
//                         _buildFileUploadRow('Brochures and\ndocuments', _pickBusinessDocuments, _businessDocuments, _fetchedBusinessDocuments),
//                 SizedBox(height: 32.0),
//                 SizedBox(
//                   height: 50,
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10)),
//                       backgroundColor: Color(0xff003C82),
//                     ),
//                     onPressed: () {
//                      _updateFranchise();
//                     },
//                     child: Text(
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
//       children: [
//         Expanded(
//           flex: 2,
//           child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
//         ),
//         ElevatedButton(
//           onPressed: onPressed,
//           child: Text('Upload'),
//           style: ElevatedButton.styleFrom(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(2),
//               side: BorderSide(color: Colors.black),
//             ),
//           ),
//         ),
//         SizedBox(width: 8),
//         Expanded(
//           flex: 3,
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: [
//                 if (files != null && files.isNotEmpty)
//                   ...files.map((file) => _buildFilePreview(file))
//                 else if (fetchedUrl != null)
//                   _buildFetchedFilePreview(fetchedUrl),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFilePreview(PlatformFile file) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 8.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: file.extension?.toLowerCase() == 'pdf'
//                 ? Icon(Icons.picture_as_pdf, color: Colors.red)
//                 : Image.file(
//               File(file.path!),
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) {
//                 return Icon(Icons.error);
//               },
//             ),
//           ),
//           SizedBox(height: 4),
//           Text(
//             file.name.length > 10 ? '${file.name.substring(0, 7)}...' : file.name,
//             style: TextStyle(fontSize: 10),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFetchedFilePreview(String fetchedUrl) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 8.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: fetchedUrl.toLowerCase().endsWith('.pdf')
//                 ? Icon(Icons.picture_as_pdf, color: Colors.red)
//                 : Image.network(
//               fetchedUrl,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) {
//                 return Icon(Icons.error);
//               },
//             ),
//           ),
//           SizedBox(height: 4),
//           Text(
//             'Fetched',
//             style: TextStyle(fontSize: 10),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
// }
