// import 'dart:io';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:project_emergio/controller/dashboard_controller.dart';
// import 'package:project_emergio/models/all%20profile%20model.dart';
// import 'package:project_emergio/models/places.dart';
// import 'package:project_emergio/services/profile%20forms/business/BusinessAddPage.dart';
// import 'package:project_emergio/services/profile%20forms/business/business%20get.dart';
//
// class BusinessInfoPage extends StatefulWidget {
//   final String type;
//   final bool isEdit;
//   final BusinessInvestorExplr? busines;
//   const BusinessInfoPage({super.key, required this.isEdit,required this.type,this.busines});
//
//   @override
//   _BusinessInfoPageState createState() => _BusinessInfoPageState();
// }
//
// class _BusinessInfoPageState extends State<BusinessInfoPage> {
//   final _formKey = GlobalKey<FormState>();
//   final Map<String, TextEditingController> _controllers = {
//     'businessName': TextEditingController(),
//     'yearEstablished': TextEditingController(),
//     'description': TextEditingController(),
//     'address1': TextEditingController(),
//     'pin': TextEditingController(),
//     'address2': TextEditingController(),
//     'numberOfEmployees': TextEditingController(),
//     'averageMonthlySales': TextEditingController(),
//     'askingPrice': TextEditingController(),
//     'mostReportedYearlySales': TextEditingController(),
//     'ebitda': TextEditingController(),
//     'preferredType': TextEditingController(),
//     'businessWebsite': TextEditingController(),
//     'topOfferings': TextEditingController(),
//     'keyFeatures': TextEditingController(),
//     'facilityDetails': TextEditingController(),
//     'fundingDetails': TextEditingController(),
//     'reason': TextEditingController(),
//     "minimumRange": TextEditingController(),
//     "maximumRange": TextEditingController(),
//   };
//
//   String _selectedIndustry = 'Fashion';
//   String _selectedState = 'Kerala';
//   String _selectedCity = 'Kakkanad';
//   String _selectedBusinessEntityType = '';
//   List<XFile>? _businessPhotos;
//   List<PlatformFile>? _businessDocuments;
//   PlatformFile? _businessProof;
//   bool _isSubmitting = false;
//   final DashboardController _controller = Get.put(DashboardController());
//
//   final List<Map<String, String>> _industries = [
//     {'value': 'Education', 'display': 'Education'},
//     {'value': 'Information Technology', 'display': 'IT'},
//     {'value': 'Healthcare', 'display': 'Healthcare'},
//     {'value': 'Fashion', 'display': 'Fashion'},
//     {'value': 'Food', 'display': 'Food'},
//     {'value': 'Automobile', 'display': 'Automobile'},
//     {'value': 'Banking', 'display': 'Banking'},
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _controllers['preferredType']!.text = 'Selling';
//
//     _fetchStates();
//     setTextFields();
//   }
//
//   void setTextFields() {
//     if (widget.busines != null) {
//       setState(() {
//         _controllers["askingPrice"] =
//             TextEditingController(text: widget.busines!.askingPrice);
//         _controllers["maximumRange"] =
//             TextEditingController(text: widget.busines!.rangeStarting);
//         _controllers["minimumRange"] =
//             TextEditingController(text: widget.busines!.rangeEnding);
//         _controllers["reason"] =
//             TextEditingController(text: widget.busines!.reason);
//         _controllers["fundingDetails"] =
//             TextEditingController(text: widget.busines!.income_source);
//         _controllers["facilityDetails"] =
//             TextEditingController(text: widget.busines!.facility);
//         _controllers["keyFeatures"] =
//             TextEditingController(text: widget.busines!.features);
//         _controllers["topOfferings"] =
//             TextEditingController(text: widget.busines!.topSelling);
//         _controllers["businessWebsite"] =
//             TextEditingController(text: widget.busines!.url);
//         _controllers["preferredType"] =
//             TextEditingController(text: widget.busines!.type_sale);
//         _controllers["ebitda"] =
//             TextEditingController(text: widget.busines!.ebitda);
//         _controllers["mostReportedYearlySales"] =
//             TextEditingController(text: widget.busines!.latest_yearly);
//         _controllers["averageMonthlySales"] =
//             TextEditingController(text: widget.busines!.avg_monthly);
//         _controllers["numberOfEmployees"] =
//             TextEditingController(text: widget.busines!.employees);
//         _controllers["address2"] =
//             TextEditingController(text: widget.busines!.address_2);
//         _controllers["pin"] = TextEditingController(text: widget.busines!.pin);
//         _controllers["address1"] =
//             TextEditingController(text: widget.busines!.address_1);
//         _controllers["description"] =
//             TextEditingController(text: widget.busines!.description);
//         _controllers["yearEstablished"] =
//             TextEditingController(text: widget.busines!.establish_yr);
//         _controllers["businessName"] =
//             TextEditingController(text: widget.busines!.name);
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _controllers.forEach((_, controller) => controller.dispose());
//     super.dispose();
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
//   String? _validateName(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Investor Name is required';
//     }
//     final namePattern = r'^[a-zA-Z\s]+$'; // Allows only letters and spaces
//     final regex = RegExp(namePattern);
//     if (!regex.hasMatch(value)) {
//       return 'Only letters and spaces are allowed';
//     }
//     if (value.length > 50) {
//       // Limit for the name
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
//   String? _validateDescription(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Description is required';
//     }
//     if (value.length < 50) {
//       return 'Description should be at least 50 characters long';
//     }
//     if (value.length > 1000) {
//       return 'Description should not exceed 1000 characters';
//     }
//     return null;
//   }
//
//   String? _validateMinmumRange(String? value) {
//     if (_controllers['minimumRange']!.text == "Investment" &&
//         (value == null || value.isEmpty)) {
//       return 'Minimum range is required';
//     }
//     return null;
//   }
//
//   String? _validateMaximumRange(String? value) {
//     final max = int.parse(_controllers['maximumRange']!.text);
//     final min = int.parse(_controllers['minimumRange']!.text);
//     if (_controllers['maximumRange']!.text == "Investment" &&
//         (value == null || value.isEmpty)) {
//       return 'Maximum range is required';
//     } else if (max <= min) {
//       return 'Maximum range should greater than minimum range';
//     }
//     return null;
//   }
//
//   String? _validateAddress(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Address is required';
//     }
//     if (value.length > 200) {
//       return 'Address should not exceed 200 characters';
//     }
//     return null;
//   }
//
//   String? _validatePinCode(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Pin Code is required';
//     }
//     if (!RegExp(r'^\d{6}$').hasMatch(value)) {
//       return 'Pin Code should be exactly 6 digits';
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
//       // 1 trillion limit
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
//     if (!RegExp(urlPattern).hasMatch(value)) {
//       return 'Please enter a valid URL';
//     }
//     if (value.length > 200) {
//       return 'URL should not exceed 200 characters';
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
//   InputDecoration _inputDecoration() {
//     return InputDecoration(
//         labelStyle: TextStyle(color: Color(0xff6C7278)),
//         border: OutlineInputBorder(),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15),
//           borderSide: BorderSide(color: Color.fromARGB(255, 224, 228, 230)),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15),
//           borderSide: BorderSide(color: Colors.red),
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
//   Widget _buildTextFormField(String key,
//       {String? Function(String?)? validator,
//         int? maxLines,
//         TextInputType? keyboardType}) {
//     return TextFormField(
//       controller: _controllers[key],
//       decoration: _inputDecoration(),
//       onChanged: (_) {},
//       validator: validator ??
//               (value) => value!.isEmpty ? 'This field is required' : null,
//       maxLines: maxLines,
//       keyboardType: keyboardType,
//     );
//   }
//
//   Widget _buildDropdownFormField(
//       String value, List<String> items, void Function(String?) onChanged) {
//     return DropdownButtonFormField<String>(
//       value: value,
//       onChanged: onChanged,
//       isExpanded: true,
//       items: items
//           .map((item) => DropdownMenuItem(
//           value: item,
//           child: Text(
//             item,
//             style: TextStyle(
//                 color: Color(0xff6C7278),
//                 fontWeight: FontWeight.w400,
//                 fontSize: 16),
//           )))
//           .toList(),
//       decoration: _inputDecoration(),
//       validator: (value) =>
//       value == null || value.isEmpty ? 'Please select an option' : null,
//     );
//   }
//
//   List<String> states = [];
//   void _fetchStates() {
//     for (var item in AllPlaces().states) {
//       states.add(item["name"]);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
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
//                   'Enter your Business Info',
//                   style: TextStyle(
//                       color: Color(0xff5A5A5A),
//                       fontWeight: FontWeight.w400,
//                       fontSize: h * 0.028),
//                 ),
//                 SizedBox(height: h * .03),
//                 _buildHintText('Business Name'),
//                 _buildTextFormField('businessName', validator: _validateName),
//                 SizedBox(height: 16.0),
//                 _buildHintText('Describe the business in a single line'),
//                 _buildTextFormField('Title', validator: _validateAddress),
//                 SizedBox(height: 16.0),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildHintText('Industry'),
//                           _buildDropdownFormField(
//                               _selectedIndustry,
//                               _industries.map((i) => i['value']!).toList(),
//                                   (value) =>
//                                   setState(() => _selectedIndustry = value!)),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: 16.0),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildHintText('Year Established'),
//                           _buildTextFormField('yearEstablished',
//                               keyboardType: TextInputType.number,
//                               validator: _validateYear),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16.0),
//                 _buildHintText('Address 1'),
//                 _buildTextFormField('address1', validator: _validateAddress),
//                 SizedBox(height: 16.0),
//                 _buildHintText('Address 2'),
//                 _buildTextFormField('address2',
//                     validator: (value) =>
//                     value!.isNotEmpty ? _validateAddress(value) : null),
//                 SizedBox(height: 16.0),
//
//                 _buildHintText('State'),
//                 DropdownSearch<String>(
//                   decoratorProps: DropDownDecoratorProps(
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(
//                             color: Color.fromARGB(255, 224, 228, 230)),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(
//                             color: Color.fromARGB(255, 224, 228, 230)),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(
//                             color: Color.fromARGB(255, 224, 228, 230)),
//                       ),
//                     ),
//                   ),
//                   items: (filter, infiniteScrollProps) =>
//                   states, // Assuming AllPlaces().places is a list of strings
//                   selectedItem: _selectedState.isEmpty ? null : _selectedState,
//
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       _selectedState = newValue ?? '';
//                     });
//                   },
//
//                   popupProps: PopupProps.menu(
//                     showSearchBox: true, // Enables the search box
//                     searchFieldProps: TextFieldProps(
//                       decoration: InputDecoration(
//                         hintText: 'Search states...',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: const BorderSide(color: Colors.grey),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: const BorderSide(
//                               color: Color.fromARGB(255, 224, 228, 230)),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),
//
//                 _buildHintText('City'),
//                 DropdownSearch<String>(
//                   decoratorProps: DropDownDecoratorProps(
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(
//                             color: Color.fromARGB(255, 224, 228, 230)),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(
//                             color: Color.fromARGB(255, 224, 228, 230)),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(
//                             color: Color.fromARGB(255, 224, 228, 230)),
//                       ),
//                     ),
//                   ),
//                   items: (filter, infiniteScrollProps) => AllPlaces()
//                       .places, // Assuming AllPlaces().places is a list of strings
//                   selectedItem: _selectedCity.isEmpty ? null : _selectedCity,
//
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       _selectedCity = newValue ?? '';
//                     });
//                   },
//
//                   popupProps: PopupProps.menu(
//                     showSearchBox: true, // Enables the search box
//
//                     searchFieldProps: TextFieldProps(
//                       decoration: InputDecoration(
//                         hintText: 'Search locations...',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(color: Colors.grey),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(
//                               color: Color.fromARGB(255, 224, 228, 230)),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 16.0),
//
//                 SizedBox(height: 16.0),
//                 _buildHintText('Pin Code'),
//                 _buildTextFormField('pin',
//                     keyboardType: TextInputType.number,
//                     validator: _validatePinCode),
//                 SizedBox(height: 16.0),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildHintText('Number of Employees'),
//                           _buildTextFormField('numberOfEmployees',
//                               keyboardType: TextInputType.number,
//                               validator: _validateEmployees),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: 10.0),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildHintText('Business Legal Entity Type'),
//                           _buildDropdownFormField(
//                               _selectedBusinessEntityType.isEmpty
//                                   ? "Private Limited Company"
//                                   : _selectedBusinessEntityType.toString(),
//                               [
//                                 'Proprietorship',
//                                 'Public Limited Company',
//                                 'Private Limited Company',
//                                 'Limited Liability Partnership',
//                                 'Limited Liability Company',
//                                 'C Corporation',
//                                 'S Corporation',
//                                 'Other'
//                               ],
//                                   (value) => setState(
//                                       () => _selectedBusinessEntityType = value!)),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16.0),
//                 _buildHintText('Average Monthly Revenue'),
//                 _buildTextFormField('averageMonthlySales',
//                     keyboardType: TextInputType.number,
//                     validator: (value) =>
//                         _validateSales(value, 'Average Monthly Revenue')),
//                 SizedBox(height: 16.0),
//                 _buildHintText('Last Yearly Revenue'),
//                 _buildTextFormField('mostReportedYearlySales',
//                     keyboardType: TextInputType.number,
//                     validator: (value) =>
//                         _validateSales(value, 'Last Yearly Revenue Sales')),
//                 SizedBox(height: 16.0),
//                 _buildHintText('EBITDA / Operating Profit Margin Percentage'),
//                 _buildTextFormField('ebitda',
//                     keyboardType: TextInputType.number,
//                     validator: _validateEbitda),
//                 SizedBox(height: 16.0),
//                 _buildHintText('Preferred Type of Selling'),
//                 _buildDropdownFormField(_controllers['preferredType']!.text,
//                     ['Investment', 'Selling'], (value) {
//                       setState(() {
//                         _controllers['preferredType']!.text = value!;
//                       });
//                     }),
//                 SizedBox(height: 16.0),
//                 _controllers["preferredType"]!.text == "Investment"
//                     ? Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildHintText('Minimum Investment Range'),
//                           _buildTextFormField('minimumRange',
//                               maxLines: null,
//                               validator: _validateMinmumRange),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildHintText('Maximum Investment Range'),
//                           _buildTextFormField('maximumRange',
//                               maxLines: null,
//                               validator: _validateMaximumRange),
//                         ],
//                       ),
//                     )
//                   ],
//                 )
//                     : _controllers["preferredType"]!.text == "Selling"
//                     ? Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildHintText('Asking Price of Business'),
//                     _buildTextFormField('askingPrice',
//                         keyboardType: TextInputType.number,
//                         validator: (value) =>
//                             _validateSales(value, 'askingPrice')),
//                   ],
//                 )
//                     : SizedBox.shrink(),
//                 SizedBox(height: 16.0),
//                 _buildHintText('Business Website URL'),
//                 _buildTextFormField('businessWebsite', validator: _validateUrl),
//                 SizedBox(height: 16.0),
//                 _buildHintText('Reason for sale'),
//                 _buildTextFormField('reason',
//                     maxLines: 4,
//                     validator: (value) => _validateTextArea(
//                         value, 'Reason for Selling',
//                         minLength: 50, maxLength: 500)),
//                 SizedBox(height: 16.0),
//                 _buildHintText('Description of the Business'),
//                 _buildTextFormField('description',
//                     maxLines: null, validator: _validateDescription),
//                 SizedBox(height: 16.0),
//                 _buildHintText(
//                     'What are the top selling offerings of the company, who are the customers?'),
//                 _buildTextFormField('topOfferings',
//                     maxLines: 4,
//                     validator: (value) => _validateTextArea(
//                         value, 'Top Offerings',
//                         minLength: 50, maxLength: 500)),
//                 SizedBox(height: 16.0),
//                 _buildHintText(
//                     'Highlight the business\'s key features, client base, revenue structure, revenue model, Founder\'s, industry, etc...'),
//                 _buildTextFormField('keyFeatures',
//                     maxLines: 4,
//                     validator: (value) => _validateTextArea(
//                         value, 'Key Features',
//                         minLength: 100, maxLength: 1000)),
//                 SizedBox(height: 16.0),
//                 _buildHintText(
//                     'Outline your facility, like its total floor area, number of levels, and leasing terms.'),
//                 _buildTextFormField('facilityDetails',
//                     maxLines: 4,
//                     validator: (value) => _validateTextArea(
//                         value, 'Facility Details',
//                         minLength: 50, maxLength: 500)),
//                 SizedBox(height: 16.0),
//                 _buildHintText(
//                     '''Summarize funding Source, outstanding debts, and
// the number of shareholder with their ownership %'''),
//                 _buildTextFormField('fundingDetails',
//                     maxLines: 4,
//                     validator: (value) => _validateTextArea(
//                         value, 'Funding Details',
//                         minLength: 100, maxLength: 1000)),
//                 SizedBox(height: 16.0),
//
//                 SizedBox(height: 16.0),
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
//                 _buildFileUploadRow(
//                     'Business Photos', _pickBusinessPhotos, _businessPhotos),
//                 SizedBox(height: 16.0),
//                 _buildFileUploadRow('Business Documents',
//                     _pickBusinessDocuments, _businessDocuments),
//                 SizedBox(height: 16.0),
//                 _buildFileUploadRow(
//                   'Business Proof',
//                   _pickBusinessProof,
//                   _businessProof != null ? [_businessProof!] : null,
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
//                     onPressed: widget.isEdit == true ? editForm : submitForm,
//                     child: _isSubmitting
//                         ? CircularProgressIndicator(color: Colors.white)
//                         : Text(widget.isEdit == true ? "Save changes" : 'Next',
//                         style: TextStyle(color: Colors.white)),
//                   ),
//                 ),
//                 SizedBox(height: 16.0),
//                 SizedBox(
//                   height: 50,
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                           side: BorderSide(
//                               color: Color.fromARGB(255, 224, 228, 230)),
//                           borderRadius: BorderRadius.circular(10)),
//                       backgroundColor: Colors.transparent,
//                     ),
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: Text('Back',
//                         style: TextStyle(color: Color(0xff6C7278))),
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
//     return Container(
//       decoration: BoxDecoration(
//           border:
//           Border.all(width: 1, color: Color.fromARGB(255, 224, 228, 230)),
//           borderRadius: BorderRadius.circular(15)),
//       height: 60,
//       child: Padding(
//         padding: const EdgeInsets.only(left: 10, right: 10),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               label,
//               style: TextStyle(color: Color(0xff6C7278)),
//             ),
//             SizedBox(width: MediaQuery.of(context).size.width * 0.17),
//             IconButton(
//                 onPressed: onPressed,
//                 icon: Icon(
//                   Icons.upload_file,
//                   color: Color(0xffFFCC00),
//                 )),
//             // ElevatedButton(
//             //   onPressed: onPressed,
//             //   child: Text('Upload file'),
//             //   style: ElevatedButton.styleFrom(
//             //     shape: RoundedRectangleBorder(
//             //       borderRadius: BorderRadius.circular(2),
//             //       side: BorderSide(color: Colors.black),
//             //     ),
//             //   ),
//             // ),
//             if (files != null && files.isNotEmpty)
//               Expanded(
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: files.map((file) {
//                       if (file is PlatformFile) {
//                         return Padding(
//                           padding: const EdgeInsets.only(left: 8.0),
//                           child: file.extension?.toLowerCase() == 'pdf'
//                               ? Icon(Icons.picture_as_pdf, color: Colors.red)
//                               : Image.file(
//                             File(file.path!),
//                             width: 50,
//                             height: 40,
//                             fit: BoxFit.cover,
//                           ),
//                         );
//                       } else if (file is XFile) {
//                         return Padding(
//                           padding: const EdgeInsets.only(left: 8.0),
//                           child: Image.file(
//                             File(file.path),
//                             width: 50,
//                             height: 40,
//                             fit: BoxFit.cover,
//                           ),
//                         );
//                       }
//                       return SizedBox(); // Return an empty widget if the file type is unknown
//                     }).toList(),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Widget _buildFileUploadRow(String label, VoidCallback onPressed, List<PlatformFile>? files) {
//   //   return Row(
//   //     crossAxisAlignment: CrossAxisAlignment.center,
//   //     mainAxisAlignment: MainAxisAlignment.center,
//   //     children: [
//   //       Text(label),
//   //       SizedBox(width: 17),
//   //       ElevatedButton(
//   //         onPressed: onPressed,
//   //         child: Text('Upload file'),
//   //         style: ElevatedButton.styleFrom(
//   //           shape: RoundedRectangleBorder(
//   //             borderRadius: BorderRadius.circular(2),
//   //             side: BorderSide(color: Colors.black),
//   //           ),
//   //         ),
//   //       ),
//   //       if (files != null && files.isNotEmpty)
//   //         Expanded(
//   //           child: SingleChildScrollView(
//   //             scrollDirection: Axis.horizontal,
//   //             child: Row(
//   //               children: files.map((file) {
//   //                 return Padding(
//   //                   padding: const EdgeInsets.only(left: 8.0),
//   //                   child: file.extension?.toLowerCase() == 'pdf'
//   //                       ? Icon(Icons.picture_as_pdf, color: Colors.red)
//   //                       : Image.file(
//   //                     File(file.path!),
//   //                     width: 50,
//   //                     height: 40,
//   //                     fit: BoxFit.cover,
//   //                   ),
//   //                 );
//   //               }).toList(),
//   //             ),
//   //           ),
//   //         ),
//   //     ],
//   //   );
//   // }
//
//   void submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       if (_businessPhotos == null ||
//           _businessPhotos!.length < 4 ||
//           _businessDocuments == null ||
//           _businessProof == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text(
//                   'Please select all required business files (4 photos, documents, and proof)')),
//         );
//         return;
//       }
//
//       setState(() => _isSubmitting = true);
//
//       final response = await BusinessAddPage.businessAddPage(
//           context: context,
//           name: _controllers['businessName']!.text,
//           singleLineDescription: _controllers['Title']!.text,
//           industry: _selectedIndustry,
//           establish_yr: _controllers['yearEstablished']!.text,
//           description: _controllers['description']!.text,
//           address_1: _controllers['address1']!.text,
//           address_2: _controllers['address2']!.text,
//           state: _selectedState,
//           pin: _controllers['pin']!.text,
//           city: _selectedCity,
//           employees: _controllers['numberOfEmployees']!.text,
//           entity: _selectedBusinessEntityType,
//           avg_monthly: _controllers['averageMonthlySales']!.text,
//           latest_yearly: _controllers['mostReportedYearlySales']!.text,
//           ebitda: _controllers['ebitda']!.text,
//           rate: _controllers['askingPrice']!.text,
//           type_sale: _controllers['preferredType']!.text,
//           url: _controllers['businessWebsite']!.text,
//           top_selling: _controllers['topOfferings']!.text,
//           features: _controllers['keyFeatures']!.text,
//           facility: _controllers['facilityDetails']!.text,
//           reason: _controllers['reason']!.text,
//           income_source: _controllers['fundingDetails']!.text,
//           image1: File(_businessPhotos![0].path),
//           image2: File(_businessPhotos![1].path),
//           image3: File(_businessPhotos![2].path),
//           image4: File(_businessPhotos![3].path),
//           doc1: File(_businessDocuments!.first.path!),
//           proof1: File(_businessProof!.path!),
//           minimumRange: _controllers['minimumRange']?.text ?? '',
//           maximumRange: _controllers['maximumRange']?.text ?? '',
//           askingPrice: _controllers["askingPrice"]?.text ?? "");
//
//       setState(() => _isSubmitting = false);
//       print(response);
//
//       if (response == true) {
//         _controller.fetchListings("business");
//         Navigator.pop(context);
//
//         // Navigator.pushReplacement(
//         //   context,
//         //   MaterialPageRoute(
//         //       builder: (context) => DashboardScreen(
//         //             type: "business",
//         //           )),
//         // );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             duration: Duration(milliseconds: 800),
//             content: Text('Failed to submit business information'),
//           ),
//         );
//       }
//     }
//   }
//
//   void editForm() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isSubmitting = true);
//       if (widget.busines != null) {
//         await BusinessGet.updateBusiness(
//             id: widget.busines!.id,
//             name: _controllers['businessName']!.text,
//             singleLineDescription: _controllers['Title']!.text,
//             industry: _selectedIndustry != widget.busines!.industry
//                 ? _selectedIndustry
//                 : widget.busines!.industry,
//             establish_yr: _controllers['yearEstablished']!.text,
//             description: _controllers['description']!.text,
//             address_1: _controllers['address1']!.text,
//             address_2: _controllers['address2']!.text,
//             state: _selectedState != widget.busines!.state
//                 ? _selectedState
//                 : widget.busines!.state,
//             pin: _controllers['pin']!.text,
//             city: _selectedCity != widget.busines!.city
//                 ? _selectedCity
//                 : widget.busines!.city,
//             employees: _controllers['numberOfEmployees']!.text,
//             entity: _selectedBusinessEntityType != ""
//                 ? _selectedBusinessEntityType
//                 : widget.busines!.entity,
//             avg_monthly: _controllers['averageMonthlySales']!.text,
//             latest_yearly: _controllers['mostReportedYearlySales']!.text,
//             ebitda: _controllers['ebitda']!.text,
//             rate: _controllers['askingPrice']!.text,
//             type_sale: _controllers['preferredType']!.text,
//             url: _controllers['businessWebsite']!.text,
//             topSelling: _controllers['topOfferings']!.text,
//             features: _controllers['keyFeatures']!.text,
//             facility: _controllers['facilityDetails']!.text,
//             reason: _controllers['reason']!.text,
//             income_source: _controllers['fundingDetails']!.text,
//             image1:
//             _businessPhotos != null ? File(_businessPhotos![0].path) : null,
//             image2:
//             _businessPhotos != null ? File(_businessPhotos![1].path) : null,
//             image3:
//             _businessPhotos != null ? File(_businessPhotos![2].path) : null,
//             image4:
//             _businessPhotos != null ? File(_businessPhotos![3].path) : null,
//             doc1: _businessDocuments != null
//                 ? File(_businessDocuments!.first.path!)
//                 : null,
//             proof1: _businessProof != null && _businessProof!.path != null
//                 ? File(_businessProof!.path!)
//                 : null,
//             minimumRange: _controllers['minimumRange']?.text ?? '',
//             maximumRange: _controllers['maximumRange']?.text ?? '',
//             askingPrice: _controllers["askingPrice"]?.text ?? "");
//
//         setState(() => _isSubmitting = false);
//
//         _controller.fetchListings("business");
//         Navigator.pop(context);
//
//     // } else {
//     //   ScaffoldMessenger.of(context).showSnackBar(
//     //     SnackBar(
//     //       duration: Duration(milliseconds: 800),
//     //       content: Text('Failed to submit business information'),
//     //     ),
//     //   );
//     // }
//     }
//     }
//     }
// }




import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_emergio/controller/dashboard_controller.dart';
import 'package:project_emergio/models/all%20profile%20model.dart';
import 'package:project_emergio/models/places.dart';
import 'package:project_emergio/services/profile%20forms/business/BusinessAddPage.dart';
import 'package:project_emergio/services/profile%20forms/business/business%20get.dart';

class BusinessInfoPage extends StatefulWidget {
  final String type;
  final bool isEdit;
  final BusinessInvestorExplr? busines;
  const BusinessInfoPage(
      {super.key, required this.isEdit, required this.type, this.busines});

  @override
  _BusinessInfoPageState createState() => _BusinessInfoPageState();
}

class _BusinessInfoPageState extends State<BusinessInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'businessName': TextEditingController(),
    'yearEstablished': TextEditingController(),
    'description': TextEditingController(),
    'address1': TextEditingController(),
    'pin': TextEditingController(),
    'address2': TextEditingController(),
    'numberOfEmployees': TextEditingController(),
    'averageMonthlySales': TextEditingController(),
    'askingPrice': TextEditingController(),
    'mostReportedYearlySales': TextEditingController(),
    'ebitda': TextEditingController(),
    'preferredType': TextEditingController(),
    'businessWebsite': TextEditingController(),
    'topOfferings': TextEditingController(),
    'keyFeatures': TextEditingController(),
    'facilityDetails': TextEditingController(),
    'fundingDetails': TextEditingController(),
    'reason': TextEditingController(),
    "minimumRange": TextEditingController(),
    "maximumRange": TextEditingController(),
  };

  String _selectedIndustry = 'Fashion';
  String _selectedState = 'Kerala';
  String _selectedCity = 'Kakkanad';
  String _selectedBusinessEntityType = '';
  List<XFile>? _businessPhotos;
  List<PlatformFile>? _businessDocuments;
  PlatformFile? _businessProof;
  bool _isSubmitting = false;
  final DashboardController _controller = Get.put(DashboardController());

  final List<Map<String, String>> _industries = [
    {'value': 'Education', 'display': 'Education'},
    {'value': 'Information Technology', 'display': 'IT'},
    {'value': 'Healthcare', 'display': 'Healthcare'},
    {'value': 'Fashion', 'display': 'Fashion'},
    {'value': 'Food', 'display': 'Food'},
    {'value': 'Automobile', 'display': 'Automobile'},
    {'value': 'Banking', 'display': 'Banking'},
  ];

  @override
  void initState() {
    super.initState();
    _controllers['preferredType']!.text = 'Selling';

    _fetchStates();
    setTextFields();
  }

  Future<List<File?>> prepareImageFiles(List<XFile>? photos) async {
    List<File?> imageFiles = [];

    if (photos != null && photos.isNotEmpty) {
      for (var photo in photos) {
        try {
          final file = File(photo.path);
          if (await file.exists()) {
            final fileSize = await file.length();
            // Check if file size is reasonable (e.g., less than 10MB)
            if (fileSize > 0 && fileSize < 10 * 1024 * 1024) {
              imageFiles.add(file);
              print('Added image file: ${file.path} (${fileSize} bytes)');
            } else {
              print('Warning: File size invalid: ${fileSize} bytes');
            }
          } else {
            print('Warning: File does not exist at path: ${photo.path}');
          }
        } catch (e) {
          print('Error processing image file: $e');
        }
      }
    }

    // Pad with nulls to ensure we have exactly 4 slots
    while (imageFiles.length < 4) {
      imageFiles.add(null);
    }

    return imageFiles;
  }

  void setTextFields() {
    if (widget.busines != null) {
      setState(() {
        _controllers["askingPrice"] =
            TextEditingController(text: widget.busines!.askingPrice);
        _controllers["maximumRange"] =
            TextEditingController(text: widget.busines!.rangeStarting);
        _controllers["minimumRange"] =
            TextEditingController(text: widget.busines!.rangeEnding);
        _controllers["reason"] =
            TextEditingController(text: widget.busines!.reason);
        _controllers["fundingDetails"] =
            TextEditingController(text: widget.busines!.income_source);
        _controllers["facilityDetails"] =
            TextEditingController(text: widget.busines!.facility);
        _controllers["keyFeatures"] =
            TextEditingController(text: widget.busines!.features);
        _controllers["topOfferings"] =
            TextEditingController(text: widget.busines!.topSelling);
        _controllers["businessWebsite"] =
            TextEditingController(text: widget.busines!.url);
        _controllers["preferredType"] =
            TextEditingController(text: widget.busines!.type_sale);
        _controllers["ebitda"] =
            TextEditingController(text: widget.busines!.ebitda);
        _controllers["mostReportedYearlySales"] =
            TextEditingController(text: widget.busines!.latest_yearly);
        _controllers["averageMonthlySales"] =
            TextEditingController(text: widget.busines!.avg_monthly);
        _controllers["numberOfEmployees"] =
            TextEditingController(text: widget.busines!.employees);
        _controllers["address2"] =
            TextEditingController(text: widget.busines!.address_2);
        _controllers["pin"] = TextEditingController(text: widget.busines!.pin);
        _controllers["address1"] =
            TextEditingController(text: widget.busines!.address_1);
        _controllers["description"] =
            TextEditingController(text: widget.busines!.description);
        _controllers["yearEstablished"] =
            TextEditingController(text: widget.busines!.establish_yr);
        _controllers["businessName"] =
            TextEditingController(text: widget.busines!.name);
      });
    }
  }

  @override
  void dispose() {
    _controllers.forEach((_ , controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _pickBusinessPhotos() async {
    try {
      final result = await ImagePicker().pickMultiImage();
      if (result != null && result.isNotEmpty) {
        for (var image in result) {
          // Verify the file exists and print its details
          final file = File(image.path);
          final fileSize = await file.length();
          print('Image selected:');
          print('Path: ${file.path}');
          print('Size: ${fileSize} bytes');
          print('Exists: ${await file.exists()}');
        }

        setState(() {
          _businessPhotos = result;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${result.length} images selected successfully'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error picking images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to select images. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
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

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    final namePattern = r'^[a-zA-Z\s]+$'; // Allows only letters and spaces
    final regex = RegExp(namePattern);
    if (!regex.hasMatch(value)) {
      return 'Only letters and spaces are allowed';
    }
    if (value.length > 50) {
      // Limit for the name
      return 'Name cannot exceed 50 characters';
    }
    return null;
  }

  String? validateRequiredState(String? value) {
    if (value == null || value.isEmpty) {
      return 'State is required';
    }
    return null;
  }

  String? validateRequiredCity(String? value) {
    if (value == null || value.isEmpty) {
      return 'City is required';
    }
    return null;
  }

  String? _validateYear(String? value) {
    if (value == null || value.isEmpty) {
      return null;
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

  String? _validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length < 10) {
      return 'Description should be at least 50 characters long';
    }
    if (value.length > 1000) {
      return 'Description should not exceed 1000 characters';
    }
    return null;
  }

  String? _validateMinmumRange(String? value) {
    if (_controllers['minimumRange']!.text == "Investment" &&
        (value == null || value.isEmpty)) {
      return 'Minimum range is required';
    }
    return null;
  }

  String? _validateMaximumRange(String? value) {
    final max = int.parse(_controllers['maximumRange']!.text);
    final min = int.parse(_controllers['minimumRange']!.text);
    if (_controllers['maximumRange']!.text == "Investment" &&
        (value == null || value.isEmpty)) {
      return 'Maximum range is required';
    } else if (max <= min) {
      return 'Maximum range should greater than minimum range';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    }
    if (value.length > 200) {
      return 'Address should not exceed 200 characters';
    }
    return null;
  }

  String? _validatePinCode(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'Pin Code should be exactly 6 digits';
    }
    return null;
  }

  String? _validateEmployees(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    int? employees = int.tryParse(value);
    if (employees == null || employees < 1) {
      return 'Please enter a valid number of employees';
    }
    if (employees > 1000000) {
      return 'Number of employees should not exceed 1,000,000';
    }
    return null;
  }

  String? _validateSales(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return null;
    }
    double? sales = double.tryParse(value);
    if (sales == null || sales < 0) {
      return 'Please enter a valid number for $fieldName';
    }
    if (sales > 1000000000000) {
      // 1 trillion limit
      return '$fieldName should not exceed 1 trillion';
    }
    return null;
  }

  String? _validateEbitda(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    double? ebitda = double.tryParse(value);
    if (ebitda == null) {
      return 'Please enter a valid number for EBITDA';
    }
    if (ebitda < 0 || ebitda > 100) {
      return 'EBITDA should be between 0 and 100';
    }
    return null;
  }

  String? _validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null;
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

  String? _validateTextArea(String? value, String fieldName,
      {int minLength = 50, int maxLength = 1000}) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length < minLength) {
      return '$fieldName should be at least $minLength characters long';
    }
    if (value.length > maxLength) {
      return '$fieldName should not exceed $maxLength characters';
    }
    return null;
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
        labelStyle: const TextStyle(color: Color(0xff6C7278)),
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide:
          const BorderSide(color: Color.fromARGB(255, 224, 228, 230)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red),
        ));
  }

  Widget _buildHintText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xff6C7278)),
      ),
    );
  }

  Widget _buildTextFormField(String key,
      {String? Function(String?)? validator,
        int? maxLines,
        TextInputType? keyboardType}) {
    return TextFormField(
      controller: _controllers[key],
      decoration: _inputDecoration(),
      onChanged: (_) {},
      validator: validator ??
              (value) => value!.isEmpty ? 'This field is required' : null,
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }

  Widget _buildDropdownFormField(
      String value, List<String> items, void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      isExpanded: true,
      items: items
          .map((item) => DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: const TextStyle(
                color: Color(0xff6C7278),
                fontWeight: FontWeight.w400,
                fontSize: 16),
          )))
          .toList(),
      decoration: _inputDecoration(),
      validator: (value) =>
      value == null || value.isEmpty ? 'Please select an option' : null,
    );
  }

  List<String> states = [];
  void _fetchStates() {
    for (var item in AllPlaces().states) {
      states.add(item["name"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter your Business Info',
                  style: TextStyle(
                      color: const Color(0xff5A5A5A),
                      fontWeight: FontWeight.w400,
                      fontSize: h * 0.028),
                ),
                SizedBox(height: h * .03),
                _buildHintText('Business Name'),
                _buildTextFormField('businessName', validator: _validateName),
                const SizedBox(height: 16.0),
                _buildHintText('Describe the business in a single line'),
                _buildTextFormField('Title', validator: _validateAddress),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHintText('Industry'),
                          _buildDropdownFormField(
                            _selectedIndustry,
                            _industries
                                .map((i) => i['value']!)
                                .cast<String>()
                                .toList(), // Cast to List<String>
                                (value) =>
                                setState(() => _selectedIndustry = value!),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHintText('Year Established'),
                          _buildTextFormField('yearEstablished',
                              keyboardType: TextInputType.number,
                              validator: _validateYear),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                _buildHintText('Address 1'),
                _buildTextFormField('address1',
                    validator: (value) =>
                    value!.isNotEmpty ? _validateAddress(value) : null),
                const SizedBox(height: 16.0),
                _buildHintText('Address 2'),
                _buildTextFormField('address2',
                    validator: (value) =>
                    value!.isNotEmpty ? _validateAddress(value) : null),
                const SizedBox(height: 16.0),

                _buildHintText('State'),
                DropdownSearch<String>(
                  validator: validateRequiredState,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 224, 228, 230)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 224, 228, 230)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 224, 228, 230)),
                      ),
                    ),
                  ),
                  items: (filter, infiniteScrollProps) => states,
                  selectedItem: _selectedState.isEmpty ? null : _selectedState,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedState = newValue!;
                    });
                  },
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        hintText: 'Search states...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 224, 228, 230)),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                _buildHintText('City'),
                DropdownSearch<String>(
                  validator: validateRequiredCity,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 224, 228, 230)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 224, 228, 230)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 224, 228, 230)),
                      ),
                    ),
                  ),
                  items: (filter, infiniteScrollProps) => AllPlaces().places,
                  selectedItem: _selectedCity.isEmpty ? null : _selectedCity,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCity = newValue ?? '';
                    });
                  },
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        hintText: 'Search locations...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 224, 228, 230)),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16.0),

                const SizedBox(height: 16.0),
                _buildHintText('Pin Code'),
                _buildTextFormField('pin',
                    keyboardType: TextInputType.number,
                    validator: _validatePinCode),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHintText('Number of Employees'),
                          _buildTextFormField('numberOfEmployees',
                              keyboardType: TextInputType.number,
                              validator: _validateEmployees),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHintText('Business Legal Entity Type'),
                          _buildDropdownFormField(
                              _selectedBusinessEntityType.isEmpty
                                  ? "Private Limited Company"
                                  : _selectedBusinessEntityType.toString(),
                              [
                                'Proprietorship',
                                'Public Limited Company',
                                'Private Limited Company',
                                'Limited Liability Partnership',
                                'Limited Liability Company',
                                'C Corporation',
                                'S Corporation',
                                'Other'
                              ],
                                  (value) => setState(
                                      () => _selectedBusinessEntityType = value!)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                _buildHintText('Average Monthly Revenue'),
                _buildTextFormField('averageMonthlySales',
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        _validateSales(value, 'Average Monthly Revenue')),
                const SizedBox(height: 16.0),
                _buildHintText('Last Yearly Revenue'),
                _buildTextFormField('mostReportedYearlySales',
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        _validateSales(value, 'Last Yearly Revenue Sales')),
                const SizedBox(height: 16.0),
                _buildHintText('EBITDA / Operating Profit Margin Percentage'),
                _buildTextFormField('ebitda',
                    keyboardType: TextInputType.number,
                    validator: _validateEbitda),
                const SizedBox(height: 16.0),
                _buildHintText('Preferred Type of Selling'),
                _buildDropdownFormField(_controllers['preferredType']!.text,
                    ['Investment', 'Selling'], (value) {
                      setState(() {
                        _controllers['preferredType']!.text = value!;
                      });
                    }),
                const SizedBox(height: 16.0),
                _controllers["preferredType"]!.text == "Investment"
                    ? Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHintText('Minimum Investment Range'),
                          _buildTextFormField('minimumRange',
                              maxLines: null,
                              validator: _validateMinmumRange),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHintText('Maximum Investment Range'),
                          _buildTextFormField('maximumRange',
                              maxLines: null,
                              validator: _validateMaximumRange),
                        ],
                      ),
                    )
                  ],
                )
                    : _controllers["preferredType"]!.text == "Selling"
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHintText('Asking Price of Business'),
                    _buildTextFormField('askingPrice',
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            _validateSales(value, 'askingPrice')),
                  ],
                )
                    : const SizedBox.shrink(),
                const SizedBox(height: 16.0),
                _buildHintText('Business Website URL'),
                _buildTextFormField('businessWebsite', validator: _validateUrl),
                const SizedBox(height: 16.0),
                _buildHintText('Reason for sale'),
                _buildTextFormField('reason',
                    maxLines: 4,
                    validator: (value) => _validateTextArea(
                        value, 'Reason for Selling',
                        minLength: 50, maxLength: 500)),
                const SizedBox(height: 16.0),
                _buildHintText('Description of the Business'),
                _buildTextFormField('description',
                    maxLines: null, validator: _validateDescription),
                const SizedBox(height: 16.0),
                _buildHintText(
                    'What are the top selling offerings of the company, who are the customers?'),
                _buildTextFormField('topOfferings',
                    maxLines: 4,
                    validator: (value) => _validateTextArea(
                        value, 'Top Offerings',
                        minLength: 50, maxLength: 500)),
                const SizedBox(height: 16.0),
                _buildHintText(
                    'Highlight the business\'s key features, client base, revenue structure, revenue model, Founder\'s, industry, etc...'),
                _buildTextFormField('keyFeatures',
                    maxLines: 4,
                    validator: (value) => _validateTextArea(
                        value, 'Key Features',
                        minLength: 100, maxLength: 1000)),
                const SizedBox(height: 16.0),
                _buildHintText(
                    'Outline your facility, like its total floor area, number of levels, and leasing terms.'),
                _buildTextFormField('facilityDetails',
                    maxLines: 4,
                    validator: (value) => _validateTextArea(
                        value, 'Facility Details',
                        minLength: 50, maxLength: 500)),
                const SizedBox(height: 16.0),
                _buildHintText(
                    '''Summarize funding Source, outstanding debts, and
the number of shareholder with their ownership %'''),
                _buildTextFormField('fundingDetails',
                    maxLines: 4,
                    validator: (value) => _validateTextArea(
                        value, 'Funding Details',
                        minLength: 100, maxLength: 1000)),
                const SizedBox(height: 16.0),

                const SizedBox(height: 16.0),
                Text(
                  'Uploads your Documents',
                  style: TextStyle(
                      color: const Color(0xff5A5A5A),
                      fontWeight: FontWeight.w400,
                      fontSize: h * 0.028),
                ),
                // SizedBox(height: 8.0),
                // Text(
                //   'Please provide the names of documents for verification purposes. These names will be publicly visible but will only be accessible to introduced members.',
                //   style: TextStyle(fontSize: 12.0),
                // ),
                const SizedBox(height: 16.0),
                _buildFileUploadRow(
                    'Business Photos', _pickBusinessPhotos, _businessPhotos),
                const SizedBox(height: 16.0),
                _buildFileUploadRow('Business Documents',
                    _pickBusinessDocuments, _businessDocuments),
                const SizedBox(height: 16.0),
                _buildFileUploadRow(
                  'Business Proof',
                  _pickBusinessProof,
                  _businessProof != null ? [_businessProof!] : null,
                ),
                const SizedBox(height: 32.0),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: const Color(0xffFFCC00),
                    ),
                    onPressed: widget.isEdit == true ? editForm : submitForm,
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(widget.isEdit == true ? "Save changes" : 'Next',
                        style: const TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Color.fromARGB(255, 224, 228, 230)),
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Back',
                        style: TextStyle(color: Color(0xff6C7278))),
                  ),
                ),
                const SizedBox(height: 32.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileUploadRow(
      String label, VoidCallback onPressed, List<dynamic>? files) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              width: 1, color: const Color.fromARGB(255, 224, 228, 230)),
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
              style: const TextStyle(color: Color(0xff6C7278)),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.17),
            IconButton(
                onPressed: onPressed,
                icon: const Icon(
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
                          child: file.extension?.toLowerCase() == 'pdf'
                              ? const Icon(Icons.picture_as_pdf,
                              color: Colors.red)
                              : Image.file(
                            File(file.path!),
                            width: 50,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        );
                      } else if (file is XFile) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Image.file(
                            File(file.path),
                            width: 50,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                      return const SizedBox(); // Return an empty widget if the file type is unknown
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_businessPhotos == null || _businessPhotos!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one business photo'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      setState(() => _isSubmitting = true);

      try {
        // Process image files
        final imageFiles = await prepareImageFiles(_businessPhotos);

        // Verify we have at least one valid image
        if (!imageFiles.any((file) => file != null)) {
          throw Exception('No valid image files were processed');
        }

        // Process document file
        File? documentFile;
        if (_businessDocuments != null &&
            _businessDocuments!.isNotEmpty &&
            _businessDocuments!.first.path != null) {
          final docFile = File(_businessDocuments!.first.path!);
          if (await docFile.exists()) {
            documentFile = docFile;
          }
        }

        // Process proof file
        File? proofFile;
        if (_businessProof != null && _businessProof!.path != null) {
          final pFile = File(_businessProof!.path!);
          if (await pFile.exists()) {
            proofFile = pFile;
          }
        }

        print('Submitting form with:');
        print('Number of valid images: ${imageFiles.where((f) => f != null).length}');
        print('Document file: ${documentFile?.path ?? 'None'}');
        print('Proof file: ${proofFile?.path ?? 'None'}');

        // Submit the form
        await BusinessAddPage.businessAddPage(
          context: context,
          name: _controllers['businessName']?.text ?? '',
          singleLineDescription: _controllers['single_desc']?.text ?? '',
          industry: _selectedIndustry,
          establish_yr: _controllers['yearEstablished']?.text ?? '',
          description: _controllers['description']?.text ?? '',
          address_1: _controllers['address1']?.text ?? '',
          address_2: _controllers['address2']?.text ?? '',
          state: _selectedState,
          pin: _controllers['pin']?.text ?? '',
          city: _selectedCity,
          employees: _controllers['numberOfEmployees']?.text ?? '',
          entity: _selectedBusinessEntityType,
          avg_monthly: _controllers['averageMonthlySales']?.text ?? '',
          latest_yearly: _controllers['mostReportedYearlySales']?.text ?? '',
          ebitda: _controllers['ebitda']?.text ?? '',
          rate: _controllers['askingPrice']?.text ?? '',
          type_sale: _controllers['preferredType']?.text ?? '',
          url: _controllers['businessWebsite']?.text ?? '',
          top_selling: _controllers['topOfferings']?.text ?? '',
          features: _controllers['keyFeatures']?.text ?? '',
          facility: _controllers['facilityDetails']?.text ?? '',
          reason: _controllers['reason']?.text ?? '',
          income_source: _controllers['fundingDetails']?.text ?? '',
          image1: imageFiles[0],
          image2: imageFiles[1],
          image3: imageFiles[2],
          image4: imageFiles[3],
          doc1: documentFile,
          proof1: proofFile,
          minimumRange: _controllers['minimumRange']?.text ?? '',
          maximumRange: _controllers['maximumRange']?.text ?? '',
          askingPrice: _controllers['askingPrice']?.text ?? '',
        );

        print('Form submitted successfully');
        setState(() => _isSubmitting = false);
        _controller.fetchListings("business");
        Navigator.pop(context);

      } catch (e, stackTrace) {
        print('Error submitting form: $e');
        print('Stack trace: $stackTrace');
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit: ${e.toString()}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void editForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      try {
        if (widget.busines != null) {
          // Prepare image files with null safety
          List<File?> images = [];
          if (_businessPhotos != null) {
            for (var photo in _businessPhotos!) {
              images.add(File(photo.path));
            }
          }

          // Pad the images array with nulls if less than 4 images
          while (images.length < 4) {
            images.add(null);
          }

          final response = await BusinessGet.updateBusiness(
            id: widget.busines!.id,
            name: _controllers["businessName"]?.text ?? "",
            singleLineDescription: _controllers["Title"]?.text ?? "",
            industry: _selectedIndustry != widget.busines!.industry
                ? _selectedIndustry
                : widget.busines!.industry,
            establish_yr: _controllers["yearEstablished"]?.text ?? "",
            description: _controllers["description"]?.text ?? "",
            address_1: _controllers["address1"]?.text ?? "",
            address_2: _controllers["address2"]?.text ?? "",
            state: _selectedState != widget.busines!.state
                ? _selectedState
                : widget.busines!.state,
            pin: _controllers["pin"]?.text ?? "",
            city: _selectedCity != widget.busines!.city
                ? _selectedCity
                : widget.busines!.city,
            employees: _controllers["numberOfEmployees"]?.text ?? "",
            entity: _selectedBusinessEntityType != ""
                ? _selectedBusinessEntityType
                : widget.busines!.entity,
            avg_monthly: _controllers["averageMonthlySales"]?.text ?? "",
            latest_yearly: _controllers["mostReportedYearlySales"]?.text ?? "",
            ebitda: _controllers["ebitda"]?.text ?? "",
            rate: _controllers["askingPrice"]?.text ?? "",
            type_sale: _controllers["preferredType"]?.text ?? "",
            url: _controllers["businessWebsite"]?.text ?? "",
            topSelling: _controllers["topOfferings"]?.text ?? "",
            features: _controllers["keyFeatures"]?.text ?? "",
            facility: _controllers["facilityDetails"]?.text ?? "",
            reason: _controllers["reason"]?.text ?? "",
            income_source: _controllers["fundingDetails"]?.text ?? "",
            image1: images.length > 0 ? images[0] : null,
            image2: images.length > 1 ? images[1] : null,
            image3: images.length > 2 ? images[2] : null,
            image4: images.length > 3 ? images[3] : null,
            doc1: _businessDocuments?.isNotEmpty == true
                ? File(_businessDocuments!.first.path!)
                : null,
            proof1: _businessProof?.path != null
                ? File(_businessProof!.path!)
                : null,
            minimumRange: _controllers["minimumRange"]?.text ?? "",
            maximumRange: _controllers["maximumRange"]?.text ?? "",
            askingPrice: _controllers["askingPrice"]?.text ?? "",
          );

          // if (response == true) {
          //   setState(() => _isSubmitting = false);
          //   _controller.fetchListings("business");
          //   Navigator.pop(context);
          // } else {
          //   throw Exception('Update failed');
          // }
        }
      } catch (e) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update business information: ${e.toString()}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
