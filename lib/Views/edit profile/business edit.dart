// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:project_emergio/Views/Profiles/business%20listing%20page.dart';
// import 'package:project_emergio/services/profile%20forms/business/business%20get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../detail page/business deatil page.dart';
//
// class EditBusinessScreen extends StatefulWidget {
//   final String id;
//   final String imageUrl;
//   final String name;
//   final String? industry;
//   final String? establishYear;
//   final String? description;
//   final String? address1;
//   final String? address2;
//   final String? pin;
//   final String city;
//   final String? state;
//   final String? employees;
//   final String? entity;
//   final String? avgMonthly;
//   final String? latestYearly;
//   final String? ebitda;
//   final String? rate;
//   final String? typeSale;
//   final String? url;
//   final String? features;
//   final String? facility;
//   final String? incomeSource;
//   final String? reason;
//   final String postedTime;
//   final String topSelling;
//
//   EditBusinessScreen({
//     required this.id,
//     required this.imageUrl,
//     required this.name,
//     this.industry,
//     this.establishYear,
//     this.description,
//     this.address1,
//     this.address2,
//     this.pin,
//     required this.city,
//     this.state,
//     this.employees,
//     this.entity,
//     this.avgMonthly,
//     this.latestYearly,
//     this.ebitda,
//     this.rate,
//     this.typeSale,
//     this.url,
//     this.features,
//     this.facility,
//     this.incomeSource,
//     this.reason,
//     required this.postedTime,
//     required this.topSelling,
//   });
//
//   @override
//   _EditBusinessScreenState createState() => _EditBusinessScreenState();
// }
//
// class _EditBusinessScreenState extends State<EditBusinessScreen> {
//   late TextEditingController _nameController;
//   late TextEditingController _industryController;
//   late TextEditingController _establishYearController;
//   late TextEditingController _descriptionController;
//   late TextEditingController _address1Controller;
//   late TextEditingController _address2Controller;
//   late TextEditingController _pinController;
//   late TextEditingController _cityController;
//   late TextEditingController _stateController;
//   late TextEditingController _employeesController;
//   late TextEditingController _entityController;
//   late TextEditingController _avgMonthlyController;
//   late TextEditingController _latestYearlyController;
//   late TextEditingController _ebitdaController;
//   late TextEditingController _rateController;
//   late TextEditingController _typeSaleController;
//   late TextEditingController _urlController;
//   late TextEditingController _featuresController;
//   late TextEditingController _facilityController;
//   late TextEditingController _incomeSourceController;
//   late TextEditingController _reasonController;
//   late TextEditingController _topSellingController;
//
//   // State variables to hold selected files
//   File? image1;
//   File? doc1;
//   File? proof1;
//
//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.name);
//     _industryController = TextEditingController(text: widget.industry);
//     _establishYearController = TextEditingController(text: widget.establishYear);
//     _descriptionController = TextEditingController(text: widget.description);
//     _address1Controller = TextEditingController(text: widget.address1);
//     _address2Controller = TextEditingController(text: widget.address2);
//     _pinController = TextEditingController(text: widget.pin);
//     _cityController = TextEditingController(text: widget.city);
//     _stateController = TextEditingController(text: widget.state);
//     _employeesController = TextEditingController(text: widget.employees);
//     _entityController = TextEditingController(text: widget.entity);
//     _avgMonthlyController = TextEditingController(text: widget.avgMonthly);
//     _latestYearlyController = TextEditingController(text: widget.latestYearly);
//     _ebitdaController = TextEditingController(text: widget.ebitda);
//     _rateController = TextEditingController(text: widget.rate);
//     _typeSaleController = TextEditingController(text: widget.typeSale);
//     _urlController = TextEditingController(text: widget.url);
//     _featuresController = TextEditingController(text: widget.features);
//     _facilityController = TextEditingController(text: widget.facility);
//     _incomeSourceController = TextEditingController(text: widget.incomeSource);
//     _reasonController = TextEditingController(text: widget.reason);
//     _topSellingController = TextEditingController(text: widget.topSelling);
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _industryController.dispose();
//     _establishYearController.dispose();
//     _descriptionController.dispose();
//     _address1Controller.dispose();
//     _address2Controller.dispose();
//     _pinController.dispose();
//     _cityController.dispose();
//     _stateController.dispose();
//     _employeesController.dispose();
//     _entityController.dispose();
//     _avgMonthlyController.dispose();
//     _latestYearlyController.dispose();
//     _ebitdaController.dispose();
//     _rateController.dispose();
//     _typeSaleController.dispose();
//     _urlController.dispose();
//     _featuresController.dispose();
//     _facilityController.dispose();
//     _incomeSourceController.dispose();
//     _reasonController.dispose();
//     _topSellingController.dispose();
//     super.dispose();
//   }
//
//   // Methods to pick files
//   Future<void> pickImage1() async {
//     final result = await FilePicker.platform.pickFiles(type: FileType.image);
//     if (result != null) {
//       setState(() {
//         image1 = File(result.files.single.path!);
//       });
//     }
//   }
//
//   Future<void> pickDoc1() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'doc'],
//     );
//     if (result != null) {
//       setState(() {
//         doc1 = File(result.files.single.path!);
//       });
//     }
//   }
//
//   Future<void> pickProof1() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'doc'],
//     );
//     if (result != null) {
//       setState(() {
//         proof1 = File(result.files.single.path!);
//       });
//     }
//   }
//
//   Future<void> _submitForm() async {
//     try {
//       // Create an updated instance of Business with all required fields
//       // Business updatedBusiness = Business(
//       //   id: widget.id,
//       //   imageUrl: image1 != null ? image1!.path : widget.imageUrl ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
//       //   name: _nameController.text.isNotEmpty ? _nameController.text : 'N/A', // Default value if empty
//       //   industry: _industryController.text.isNotEmpty ? _industryController.text : null,
//       //   establish_yr: _establishYearController.text.isNotEmpty ? _establishYearController.text : null,
//       //   description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
//       //   address_1: _address1Controller.text.isNotEmpty ? _address1Controller.text : null,
//       //   address_2: _address2Controller.text.isNotEmpty ? _address2Controller.text : null,
//       //   pin: _pinController.text.isNotEmpty ? _pinController.text : null,
//       //   city: _cityController.text.isNotEmpty ? _cityController.text : 'N/A', // Default value if empty
//       //   state: _stateController.text.isNotEmpty ? _stateController.text : null,
//       //   employees: _employeesController.text.isNotEmpty ? _employeesController.text : null,
//       //   entity: _entityController.text.isNotEmpty ? _entityController.text : null,
//       //   avg_monthly: _avgMonthlyController.text.isNotEmpty ? _avgMonthlyController.text : null,
//       //   latest_yearly: _latestYearlyController.text.isNotEmpty ? _latestYearlyController.text : null,
//       //   ebitda: _ebitdaController.text.isNotEmpty ? _ebitdaController.text : null,
//       //   rate: _rateController.text.isNotEmpty ? _rateController.text : null,
//       //   type_sale: _typeSaleController.text.isNotEmpty ? _typeSaleController.text : null,
//       //   url: _urlController.text.isNotEmpty ? _urlController.text : null,
//       //   features: _featuresController.text.isNotEmpty ? _featuresController.text : null,
//       //   facility: _facilityController.text.isNotEmpty ? _facilityController.text : null,
//       //   income_source: _incomeSourceController.text.isNotEmpty ? _incomeSourceController.text : null,
//       //   reason: _reasonController.text.isNotEmpty ? _reasonController.text : null,
//       //   postedTime: widget.postedTime, // Use the original posted time
//       //   topSelling: _topSellingController.text.isNotEmpty ? _topSellingController.text : 'N/A', // Default value if empty
//       // );
//
//       // await BusinessGet.updateBusiness(
//       //     id: widget.id,
//       //     imageUrl:  widget.imageUrl,
//       //     name: _nameController.text,
//       //     city: _cityController.text,
//       //     postedTime: widget.postedTime,
//       //     topSelling: _topSellingController.text,
//       //     ebitda: _ebitdaController.text,
//       //     industry: _industryController.text,
//       //     state: _stateController.text,
//       //     income_source: _incomeSourceController.text,
//       //     reason: _reasonController.text,
//       //     address_2: _address2Controller.text,
//       //     address_1: _address1Controller.text,
//       //     pin: _pinController.text,
//       //     features: _featuresController.text,
//       //     facility: _facilityController.text,
//       //     url: _urlController.text,
//       //     type_sale: _typeSaleController.text,
//       //     rate: _rateController.text,
//       //     latest_yearly: _latestYearlyController.text,
//       //     avg_monthly: _avgMonthlyController.text,
//       //     entity: _entityController.text,
//       //     employees: _employeesController.text,
//       //     description: _descriptionController.text,
//       //     establish_yr: _establishYearController.text,
//       //     image1: image1!,
//       //     doc1: doc1!,
//       //     proof1: proof1!);
//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Business updated successfully')),
//       );
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BusinessListingsScreen()));
//       // Navigate back
//
//     } catch (e) {
//       log('Error updating business: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to update business')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Business'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextField(
//                 controller: _nameController,
//                 decoration: InputDecoration(labelText: 'Business Name'),
//               ),
//               TextField(
//                 controller: _industryController,
//                 decoration: InputDecoration(labelText: 'Industry'),
//               ),
//               TextField(
//                 controller: _establishYearController,
//                 decoration: InputDecoration(labelText: 'Establish Year'),
//               ),
//               TextField(
//                 controller: _descriptionController,
//                 decoration: InputDecoration(labelText: 'Description'),
//                 maxLines: 3,
//               ),
//               TextField(
//                 controller: _address1Controller,
//                 decoration: InputDecoration(labelText: 'Address 1'),
//               ),
//               TextField(
//                 controller: _address2Controller,
//                 decoration: InputDecoration(labelText: 'Address 2'),
//               ),
//               TextField(
//                 controller: _pinController,
//                 decoration: InputDecoration(labelText: 'PIN'),
//               ),
//               TextField(
//                 controller: _cityController,
//                 decoration: InputDecoration(labelText: 'City'),
//               ),
//               TextField(
//                 controller: _stateController,
//                 decoration: InputDecoration(labelText: 'State'),
//               ),
//               TextField(
//                 controller: _employeesController,
//                 decoration: InputDecoration(labelText: 'Number of Employees'),
//               ),
//               TextField(
//                 controller: _entityController,
//                 decoration: InputDecoration(labelText: 'Business Entity'),
//               ),
//               TextField(
//                 controller: _avgMonthlyController,
//                 decoration: InputDecoration(labelText: 'Average Monthly Revenue'),
//               ),
//               TextField(
//                 controller: _latestYearlyController,
//                 decoration: InputDecoration(labelText: 'Latest Yearly Revenue'),
//               ),
//               TextField(
//                 controller: _ebitdaController,
//                 decoration: InputDecoration(labelText: 'EBITDA'),
//               ),
//               TextField(
//                 controller: _rateController,
//                 decoration: InputDecoration(labelText: 'Rate'),
//               ),
//               TextField(
//                 controller: _typeSaleController,
//                 decoration: InputDecoration(labelText: 'Type of Sale'),
//               ),
//               TextField(
//                 controller: _urlController,
//                 decoration: InputDecoration(labelText: 'Website URL'),
//               ),
//               TextField(
//                 controller: _featuresController,
//                 decoration: InputDecoration(labelText: 'Features'),
//               ),
//               TextField(
//                 controller: _facilityController,
//                 decoration: InputDecoration(labelText: 'Facility'),
//               ),
//               TextField(
//                 controller: _incomeSourceController,
//                 decoration: InputDecoration(labelText: 'Income Source'),
//               ),
//               TextField(
//                 controller: _reasonController,
//                 decoration: InputDecoration(labelText: 'Reason for Selling'),
//               ),
//               TextField(
//                 controller: _topSellingController,
//                 decoration: InputDecoration(labelText: 'Top Selling Points'),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: pickImage1,
//                 child: Text('Pick Image'),
//               ),
//               if (image1 != null) Text('Selected Image: ${image1!.path}'),
//               SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: pickDoc1,
//                 child: Text('Pick Document'),
//               ),
//               if (doc1 != null) Text('Selected Document: ${doc1!.path}'),
//               SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: pickProof1,
//                 child: Text('Pick Proof'),
//               ),
//               if (proof1 != null) Text('Selected Proof: ${proof1!.path}'),
//               SizedBox(height: 20),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     try {
//                       final prefs = await SharedPreferences.getInstance();
//                       final userId = prefs.getInt('userId');
//
//                       // Call the updateBusiness method which returns void
//                       await BusinessGet.updateBusiness(
//                         id: widget.id,
//                         imageUrl: widget.imageUrl,
//                         name: _nameController.text,
//                         city: _cityController.text,
//                         postedTime: widget.postedTime,
//                         topSelling: _topSellingController.text,
//                         ebitda: _ebitdaController.text,
//                         industry: _industryController.text,
//                         state: _stateController.text,
//                         income_source: _incomeSourceController.text,
//                         reason: _reasonController.text,
//                         address_2: _address2Controller.text,
//                         address_1: _address1Controller.text,
//                         pin: _pinController.text,
//                         features: _featuresController.text,
//                         facility: _facilityController.text,
//                         url: _urlController.text,
//                         type_sale: _typeSaleController.text,
//                         rate: _rateController.text,
//                         latest_yearly: _latestYearlyController.text,
//                         avg_monthly: _avgMonthlyController.text,
//                         entity: _entityController.text,
//                         employees: _employeesController.text,
//                         description: _descriptionController.text,
//                         establish_yr: _establishYearController.text,
//                         image1: image1!,
//                         doc1: doc1!,
//                         proof1: proof1!,
//                       );
//
//                       // Assuming updateBusiness has no direct feedback, consider it successful
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         content: Text('Investment information updated successfully'),
//                         duration: Duration(seconds: 2),
//                       ));
//
//                     } catch (e) {
//                       // Handle any exceptions
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         content: Text('An error occurred: $e'),
//                         duration: Duration(seconds: 2),
//                       ));
//                     }
//                   },
//
//                   child: Text('Submit'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project_emergio/services/profile%20forms/business/BusinessAddPage.dart';
import 'package:project_emergio/services/profile%20forms/business/business%20get.dart';

class EditBusinessScreen extends StatefulWidget {
  final String businessId;

  const EditBusinessScreen({Key? key, required this.businessId}) : super(key: key);

  @override
  _EditBusinessScreenState createState() => _EditBusinessScreenState();
}

class _EditBusinessScreenState extends State<EditBusinessScreen> {
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
  };

  String _selectedIndustry = 'Fashion';
  String _selectedState = 'Kerala';
  String _selectedCity = 'Kakkanad';
  String _selectedBusinessEntityType = 'Entity Type 1';
  List<PlatformFile>? _businessPhotos;
  List<PlatformFile>? _businessDocuments;
  PlatformFile? _businessProof;
  bool _isSubmitting = false;

  // New variables to store fetched image URLs
  String? _fetchedBusinessPhotos;
  String? _fetchedBusinessProof;
  String? _fetchedBusinessDocuments;

  // New variables for the four images
  String? _fetchedImage1;
  String? _fetchedImage2;
  String? _fetchedImage3;
  String? _fetchedImage4;

  bool _isLoading = true;
  Business? _business;



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
    _fetchBusinessData();
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }


  Future<void> _fetchBusinessData() async {
    setState(() => _isLoading = true);
    try {
      Business? fetchedBusiness = await BusinessGet.fetchSingleBusiness(widget.businessId);
      print('businessid:${widget.businessId}');
      if (fetchedBusiness != null) {
        setState(() {
          _business = fetchedBusiness;
          _populateFields();
        });
      } else {
        Get.snackbar('Error', 'Failed to fetch business data');
      }
    } catch (e) {
      print('Error fetching business data: $e');
      Get.snackbar('Error', 'Failed to fetch business data');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _populateFields() {
    if (_business != null) {
      // Populate the text controllers using _controllers map
      _controllers['businessName']?.text = _business!.name ?? '';
      _controllers['yearEstablished']?.text = _business!.establish_yr ?? '';
      _controllers['description']?.text = _business!.description ?? '';
      _controllers['address1']?.text = _business!.address_1 ?? '';
      _controllers['pin']?.text = _business!.pin ?? '';
      _controllers['address2']?.text = _business!.address_2 ?? '';
      _controllers['numberOfEmployees']?.text = _business!.employees?.toString() ?? '';
      _controllers['averageMonthlySales']?.text = _business!.avg_monthly?.toString() ?? '';
      _controllers['askingPrice']?.text = _business!.rate?.toString() ?? '';
      _controllers['mostReportedYearlySales']?.text = _business!.latest_yearly?.toString() ?? '';
      _controllers['ebitda']?.text = _business!.ebitda?.toString() ?? '';
      _controllers['preferredType']?.text = _business!.type_sale ?? '';
      _controllers['businessWebsite']?.text = _business!.url ?? '';
      _controllers['topOfferings']?.text = _business!.topSelling ?? '';
      _controllers['keyFeatures']?.text = _business!.features ?? '';
      _controllers['facilityDetails']?.text = _business!.facility ?? '';
      _controllers['fundingDetails']?.text = _business!.income_source ?? '';
      _controllers['reason']?.text = _business!.reason ?? '';

      // Store fetched image URLs
      _fetchedBusinessPhotos = _business!.imageUrl;
      _fetchedBusinessProof = _business!.businessProof;
      _fetchedBusinessDocuments = _business!.businessDocument;

      // Populate the four image fields
      _fetchedImage1 = _business!.imageUrl;
      _fetchedImage2 = _business!.image2;
      _fetchedImage3 = _business!.image3;
      _fetchedImage4 = _business!.image4;
    }
  }

  Future<void> _updateBusiness() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Use fetched URLs if no new files are selected
        List<File> businessPhotoFiles = _businessPhotos?.map((file) => File(file.path!)).toList() ?? [];
        File? businessProofFile = _businessProof != null ? File(_businessProof!.path!) : null;
        List<File> businessDocumentFiles = _businessDocuments?.map((file) => File(file.path!)).toList() ?? [];

        // Use fetched URLs if files are not selected
        if (_fetchedBusinessPhotos != null && businessPhotoFiles.isEmpty) {
          businessPhotoFiles.add(File(_fetchedBusinessPhotos!));
        }
        if (_fetchedBusinessProof != null && businessProofFile == null) {
          businessProofFile = File(_fetchedBusinessProof!);
        }
        if (_fetchedBusinessDocuments != null && businessDocumentFiles.isEmpty) {
          businessDocumentFiles.add(File(_fetchedBusinessDocuments!));
        }

        // Handle the four images
        List<String> imageUrls = [_fetchedImage1, _fetchedImage2, _fetchedImage3, _fetchedImage4]
            .where((url) => url != null)
            .map((url) => url!)
            .toList();
        if (businessPhotoFiles.isEmpty && imageUrls.isNotEmpty) {
          businessPhotoFiles = imageUrls.map((url) => File(url)).toList();
        }

        await BusinessGet.updateBusiness(
          name: _controllers['businessName']?.text ?? '',
          id: _business!.id,
          // proof1: businessProofFile!,
          // doc1: businessDocumentFiles.first,
          image1: businessPhotoFiles.isNotEmpty ? businessPhotoFiles[0] : File(_fetchedImage1!),
          image2: businessPhotoFiles.length > 1 ? businessPhotoFiles[1] : (_fetchedImage2 != null ? File(_fetchedImage2!) : null),
          image3: businessPhotoFiles.length > 2 ? businessPhotoFiles[2] : (_fetchedImage3 != null ? File(_fetchedImage3!) : null),
          image4: businessPhotoFiles.length > 3 ? businessPhotoFiles[3] : (_fetchedImage4 != null ? File(_fetchedImage4!) : null),
          doc1: businessDocumentFiles.first,
          proof1: businessProofFile!,
          city: _selectedCity ?? '',
          topSelling: _controllers['topOfferings']?.text ?? '',
          description: _controllers['description']?.text ?? '',
          industry: _selectedIndustry ?? '',
          state: _selectedState ?? '',
          url: _controllers['businessWebsite']?.text ?? '',
          address_1: _controllers['address1']?.text ?? '',
          address_2: _controllers['address2']?.text ?? '',
          avg_monthly: _controllers['averageMonthlySales']?.text ?? '',
          ebitda: _controllers['ebitda']?.text ?? '',
          employees: _controllers['numberOfEmployees']?.text ?? '',
          entity: _business!.entity ?? '',
          establish_yr: _controllers['yearEstablished']?.text ?? '',
          facility: _controllers['facilityDetails']?.text ?? '',
          features: _controllers['keyFeatures']?.text ?? '',
          income_source: _business!.income_source ?? '',
          latest_yearly: _controllers['mostReportedYearlySales']?.text ?? '',
          pin: _controllers['pin']?.text ?? '',
          rate: _business!.rate ?? '',
          reason: _controllers['reason']?.text ?? '',
          type_sale: _controllers['preferredType']?.text ?? '',
        );

        // Show success or error messages
        Get.snackbar('Success', 'Business updated successfully',
          backgroundColor: Colors.black45,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BusinessListingsScreen()));

      } catch (e) {
        Get.snackbar('Error', 'Failed to update business: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      Get.snackbar(
        'Error',
        'Please correct the errors in the form',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }



  Future<void> _pickBusinessPhotos() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        _businessPhotos = result.files;
      });
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
      return 'Investor Name is required';
    }
    final namePattern = r'^[a-zA-Z\s]+$'; // Allows only letters and spaces
    final regex = RegExp(namePattern);
    if (!regex.hasMatch(value)) {
      return 'Only letters and spaces are allowed';
    }
    if (value.length > 50) { // Limit for the name
      return 'Name cannot exceed 50 characters';
    }
    return null;
  }

  String? _validateYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Year is required';
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
      return 'Description is required';
    }
    if (value.length < 50) {
      return 'Description should be at least 50 characters long';
    }
    if (value.length > 1000) {
      return 'Description should not exceed 1000 characters';
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
      return 'Pin Code is required';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'Pin Code should be exactly 6 digits';
    }
    return null;
  }

  String? _validateEmployees(String? value) {
    if (value == null || value.isEmpty) {
      return 'Number of Employees is required';
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
      return '$fieldName is required';
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
      return 'EBITDA is required';
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
      return 'Company Website URL is required';
    }
    final urlPattern =
        r'^(https?:\/\/)?([\w-]+\.)+[\w-]{2,4}(\.[\w-]{2,4})?(\/[\w-]*)*\/?$';
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
      return '$fieldName is required';
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
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    );
  }

  Widget _buildHintText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: TextStyle(fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildTextFormField(String key,
      {String? Function(String?)? validator,
        int? maxLines,
        TextInputType? keyboardType}) {
    return TextFormField(
      controller: _controllers[key],
      decoration: _inputDecoration(),
      validator: validator ?? (value) => value!.isEmpty ? 'This field is required' : null,
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }

  Widget _buildDropdownFormField(
      String value, List<String> items, void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      items: items
          .map((item) => DropdownMenuItem(
          value: item, child: Text(item, style: TextStyle(fontSize: 12))))
          .toList(),
      decoration: _inputDecoration(),
      validator: (value) => value == null || value.isEmpty ? 'Please select an option' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_outlined),
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
                Text('Business Information',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: h * 0.025)),
                SizedBox(height: h * .03),
                _buildHintText('Business Name'),
                _buildTextFormField('businessName',
                    validator: _validateName
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHintText('Industry'),
                          _buildDropdownFormField(
                              _selectedIndustry,
                              _industries.map((i) => i['value']!).toList(),
                                  (value) =>
                                  setState(() => _selectedIndustry = value!)),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.0),
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
                SizedBox(height: 16.0),
                _buildHintText('Description of the Business'),
                _buildTextFormField('description',
                    maxLines: null, validator: _validateDescription),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHintText('State'),
                          _buildDropdownFormField(
                              _selectedState,
                              [
                                'Andhra Pradesh',
                                'Arunachal Pradesh',
                                'Assam',
                                'Bihar',
                                'Chhattisgarh',
                                'Goa',
                                'Gujarat',
                                'Haryana',
                                'Himachal Pradesh',
                                'Jharkhand',
                                'Karnataka',
                                'Kerala',
                                'Madhya Pradesh',
                                'Maharashtra',
                                'Manipur',
                                'Meghalaya',
                                'Mizoram',
                                'Nagaland',
                                'Odisha',
                                'Punjab',
                                'Rajasthan',
                                'Sikkim',
                                'Tamil Nadu',
                                'Telangana',
                                'Tripura',
                                'Uttar Pradesh',
                                'Uttarakhand',
                                'West Bengal'
                              ],
                                  (value) =>
                                  setState(() => _selectedState = value!)),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHintText('City'),
                          _buildDropdownFormField(
                              _selectedCity,
                              ['Kochi', 'Kakkanad', 'Palarivattom'],
                                  (value) =>
                                  setState(() => _selectedCity = value!)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                _buildHintText('Pin Code'),
                _buildTextFormField('pin',
                    keyboardType: TextInputType.number,
                    validator: _validatePinCode),
                SizedBox(height: 16.0),
                _buildHintText('Address 1'),
                _buildTextFormField('address1', validator: _validateAddress),
                SizedBox(height: 16.0),
                _buildHintText('Address 2'),
                _buildTextFormField('address2',
                    validator: (value) =>
                    value!.isNotEmpty ? _validateAddress(value) : null),
                SizedBox(height: 16.0),
                _buildHintText('Number of Employees'),
                _buildTextFormField('numberOfEmployees',
                    keyboardType: TextInputType.number,
                    validator: _validateEmployees),
                SizedBox(height: 16.0),
                _buildHintText('Business Legal Entity Type'),
                _buildDropdownFormField(
                    _selectedBusinessEntityType,
                    ['Entity Type 1', 'Entity Type 2', 'Entity Type 3'],
                        (value) =>
                        setState(() => _selectedBusinessEntityType = value!)),
                SizedBox(height: 16.0),
                _buildHintText(
                    'What is your average monthly sales figure at the moment?'),
                _buildTextFormField('averageMonthlySales',
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        _validateSales(value, 'Average Monthly Sales')),
                SizedBox(height: 16.0),
                _buildHintText('What was your most reported yearly sales?'),
                _buildTextFormField('mostReportedYearlySales',
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        _validateSales(value, 'Most Reported Yearly Sales')),
                SizedBox(height: 16.0),
                _buildHintText('EBITDA / Operating Profit Margin Percentage'),
                _buildTextFormField('ebitda',
                    keyboardType: TextInputType.number,
                    validator: _validateEbitda),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHintText('Asking Price'),
                          _buildTextFormField('askingPrice',
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  _validateSales(value, 'Asking Price')),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHintText('Preferred Type of Selling'),
                          _buildDropdownFormField(
                              _controllers['preferredType']!.text,
                              ['Franchise', 'Investment', 'Selling'],
                                  (value) => setState(() =>
                              _controllers['preferredType']!.text =
                              value!)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                _buildHintText('Business Website URL'),
                _buildTextFormField('businessWebsite', validator: _validateUrl),
                SizedBox(height: 16.0),
                _buildHintText(
                    'What are the top selling offerings of the company, who are the customers?'),
                _buildTextFormField('topOfferings',
                    maxLines: 4,
                    validator: (value) => _validateTextArea(
                        value, 'Top Offerings',
                        minLength: 50, maxLength: 500)),
                SizedBox(height: 16.0),
                _buildHintText(
                    'Outline the business\'s key features, including its client base, revenue structure, founder background, industry competition, revenues, etc.'),
                _buildTextFormField('keyFeatures',
                    maxLines: 4,
                    validator: (value) => _validateTextArea(
                        value, 'Key Features',
                        minLength: 100, maxLength: 1000)),
                SizedBox(height: 16.0),
                _buildHintText(
                    'Provide details about your facility, like its total floor area, number of levels, and leasing terms.'),
                _buildTextFormField('facilityDetails',
                    maxLines: 4,
                    validator: (value) => _validateTextArea(
                        value, 'Facility Details',
                        minLength: 50, maxLength: 500)),
                SizedBox(height: 16.0),
                _buildHintText('What is the reason for selling this business'),
                _buildTextFormField('reason',
                    maxLines: 4,
                    validator: (value) => _validateTextArea(
                        value, 'Reason for Selling',
                        minLength: 50, maxLength: 500)),
                SizedBox(height: 16.0),
                _buildHintText(
                    'Detail the current funding sources for the business, including any outstanding debts or loans, as well as the total count of shareholders or owners, specifying their ownership percentages.'),
                _buildTextFormField('fundingDetails',
                    maxLines: 4,
                    validator: (value) => _validateTextArea(
                        value, 'Funding Details',
                        minLength: 100, maxLength: 1000)),
                SizedBox(height: 16.0),
                Text(
                  'Photos, Documents & Proof',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Please provide the names of documents for verification purposes. These names will be publicly visible but will only be accessible to introduced members.',
                  style: TextStyle(fontSize: 12.0),
                ),
                SizedBox(height: 16.0),
                _buildBusinessPhotosSection(),
                _buildFileUploadRow('Business Documents', _pickBusinessDocuments, _businessDocuments, _fetchedBusinessDocuments),
                _buildFileUploadRow('Business Proof', _pickBusinessProof, _businessProof != null ? [_businessProof!] : null, _fetchedBusinessProof),
                SizedBox(height: 32.0),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Color(0xff003C82),
                    ),
                    onPressed: _updateBusiness,
                    child: _isSubmitting
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Verify Business', style: TextStyle(color: Colors.white)),
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


  Widget _buildBusinessPhotosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Business Photos', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildImagePreview(0)),
            SizedBox(width: 8),
            Expanded(child: _buildImagePreview(1)),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildImagePreview(2)),
            SizedBox(width: 8),
            Expanded(child: _buildImagePreview(3)),
          ],
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: _pickBusinessPhotos,
          child: Text('Upload Business Photos'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
              side: BorderSide(color: Colors.black),
            ),
          ),
        ),
        if (_businessPhotos != null && _businessPhotos!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text('${_businessPhotos!.length} new photo(s) selected'),
          ),
      ],
    );
  }

  Widget _buildImagePreview(int index) {
    String label = 'Image ${index + 1}';
    String? fetchedImageUrl;
    switch (index) {
      case 0:
        fetchedImageUrl = _fetchedImage1;
        break;
      case 1:
        fetchedImageUrl = _fetchedImage2;
        break;
      case 2:
        fetchedImageUrl = _fetchedImage3;
        break;
      case 3:
        fetchedImageUrl = _fetchedImage4;
        break;
    }

    return Column(
      children: [
        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: _businessPhotos != null && index < _businessPhotos!.length
              ? Image.file(
            File(_businessPhotos![index].path!),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(child: Text('Error loading new image'));
            },
          )
              : (fetchedImageUrl != null
              ? Image.network(
            fetchedImageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(child: Text('Error loading fetched image'));
            },
          )
              : Center(child: Text('No image'))),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildFileUploadRow(String label, VoidCallback onPressed, List<PlatformFile>? files, String? fetchedUrl) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label),
        SizedBox(width: 17),
        ElevatedButton(
          onPressed: onPressed,
          child: Text('Upload file'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
              side: BorderSide(color: Colors.black),
            ),
          ),
        ),
        if (files != null && files.isNotEmpty)
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: files.map((file) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: file.extension?.toLowerCase() == 'pdf'
                        ? Icon(Icons.picture_as_pdf, color: Colors.red)
                        : Image.file(
                      File(file.path!),
                      width: 50,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        else if (fetchedUrl != null)
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: fetchedUrl.toLowerCase().endsWith('.pdf')
                        ? Icon(Icons.picture_as_pdf, color: Colors.red)
                        : Image.network(
                      fetchedUrl,
                      width: 50,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

}
