// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lottie/lottie.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../services/profile forms/advisor/advisor get.dart';
//
//
//
// class UpdateAdvisorPage extends StatefulWidget {
//   final String advisorId;
//
//   UpdateAdvisorPage({required this.advisorId});
//
//   @override
//   _UpdateAdvisorPageState createState() => _UpdateAdvisorPageState();
// }
//
// class _UpdateAdvisorPageState extends State<UpdateAdvisorPage> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _designationController;
//   late TextEditingController _websiteController;
//   late TextEditingController _stateController;
//   late TextEditingController _cityController;
//   late TextEditingController _contactNumberController;
//   late TextEditingController _descriptionController;
//   late TextEditingController _interestController;
//
//   List<File> _brandLogo = [];
//   List<File> _businessPhotos = [];
//   File? _businessProof;
//   List<File> _businessDocuments = [];
//
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeControllers();
//     _fetchAdvisorDetails();
//   }
//
//   void _initializeControllers() {
//     _nameController = TextEditingController();
//     _designationController = TextEditingController();
//     _websiteController = TextEditingController();
//     _stateController = TextEditingController();
//     _cityController = TextEditingController();
//     _contactNumberController = TextEditingController();
//     _descriptionController = TextEditingController();
//     _interestController = TextEditingController();
//   }
//
//   Future<void> _fetchAdvisorDetails() async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       final advisorData = await AdvisorFetchPage.fetchAdvisorData();
//       final advisor = advisorData?.firstWhere((a) => a.id == widget.advisorId);
//
//       if (advisor != null) {
//         _nameController.text = advisor.name;
//         _designationController.text = advisor.designation ?? '';
//         _websiteController.text = advisor.url ?? '';
//         _stateController.text = advisor.state ?? '';
//         _cityController.text = advisor.location;
//         _contactNumberController.text = advisor.contactNumber ?? '';
//         _descriptionController.text = advisor.description ?? '';
//         _interestController.text = advisor.interest ?? '';
//       }
//     } catch (e) {
//       print('Error fetching advisor details: $e');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _pickFiles(List<File> filesList) async {
//     FilePickerResult? result =
//     await FilePicker.platform.pickFiles(allowMultiple: true);
//     if (result != null) {
//       setState(() {
//         filesList.addAll(result.paths.map((path) => File(path!)).toList());
//       });
//     }
//   }
//
//   Future<void> _pickFile(Function(File) onFilePicked) async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//     if (result != null) {
//       setState(() {
//         onFilePicked(File(result.files.single.path!));
//       });
//     }
//   }
//
//   Future<void> _updateAdvisor() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getInt('userId');
//
//     if (_formKey.currentState!.validate()) {
//       if (_businessProof == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Please pick business proof')));
//         return;
//       }
//
//       setState(() {
//         _isLoading = true;
//       });
//
//       try {
//         bool success = await AdvisorFetchPage.updateAdvisorProfile(
//           advisorId: int.parse(widget.advisorId),
//           advisorName: _nameController.text,
//           designation: _designationController.text,
//           businessWebsite: _websiteController.text,
//           state: _stateController.text,
//           city: _cityController.text,
//           contactNumber: _contactNumberController.text,
//           describeExpertise: _descriptionController.text,
//           areaOfInterest: _interestController.text,
//           brandLogo: _brandLogo,
//           businessPhotos: _businessPhotos,
//           businessProof: _businessProof!,
//           businessDocuments: _businessDocuments,
//         );
//
//         if (success) {
//           ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Advisor updated successfully')));
//           Navigator.pop(context);
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Failed to update advisor')));
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Error: ${e.toString()}')));
//         print('Error: $e'); // Debug log
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Update Advisor'),
//       ),
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: ListView(
//                 children: [
//                   TextFormField(
//                     controller: _nameController,
//                     decoration: InputDecoration(labelText: 'Advisor Name'),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter the advisor name';
//                       }
//                       return null;
//                     },
//                   ),
//                   TextFormField(
//                     controller: _designationController,
//                     decoration: InputDecoration(labelText: 'Designation'),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter the designation';
//                       }
//                       return null;
//                     },
//                   ),
//                   TextFormField(
//                     controller: _websiteController,
//                     decoration: InputDecoration(labelText: 'Business Website'),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter the business website';
//                       }
//                       return null;
//                     },
//                   ),
//                   TextFormField(
//                     controller: _stateController,
//                     decoration: InputDecoration(labelText: 'State'),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter the state';
//                       }
//                       return null;
//                     },
//                   ),
//                   TextFormField(
//                     controller: _cityController,
//                     decoration: InputDecoration(labelText: 'City'),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter the city';
//                       }
//                       return null;
//                     },
//                   ),
//                   TextFormField(
//                     controller: _contactNumberController,
//                     decoration: InputDecoration(labelText: 'Contact Number'),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter the contact number';
//                       }
//                       return null;
//                     },
//                   ),
//                   TextFormField(
//                     controller: _descriptionController,
//                     decoration:
//                     InputDecoration(labelText: 'Describe Expertise'),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please describe your expertise';
//                       }
//                       return null;
//                     },
//                   ),
//                   TextFormField(
//                     controller: _interestController,
//                     decoration: InputDecoration(labelText: 'Area of Interest'),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter the area of interest';
//                       }
//                       return null;
//                     },
//                   ),
//                   ElevatedButton(
//                     onPressed: () => _pickFiles(_brandLogo),
//                     child: Text('Pick Brand Logos'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () => _pickFiles(_businessPhotos),
//                     child: Text('Pick Business Photos'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () => _pickFile((file) => _businessProof = file),
//                     child: Text('Pick Business Proof'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () => _pickFiles(_businessDocuments),
//                     child: Text('Pick Business Documents'),
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _updateAdvisor,
//                     child: Text('Update Advisor'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (_isLoading)
//             Center(
//               child: Lottie.asset(
//                 'assets/loading.json',
//                 height: 100.h,
//                 width: 150.w,
//                 fit: BoxFit.cover,
//               ),
//             )
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../Widgets/edit shimmer loader widget.dart';
import '../../models/all profile model.dart';
import '../../services/profile forms/advisor/advisor get.dart';

class UpdateAdvisorScreen extends StatefulWidget {
  final String advisorId;
  const UpdateAdvisorScreen({Key? key, required this.advisorId}) : super(key: key);

  @override
  State<UpdateAdvisorScreen> createState() => _UpdateAdvisorScreenState();
}

class _UpdateAdvisorScreenState extends State<UpdateAdvisorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _advisorNameController = TextEditingController();
  final _designationController = TextEditingController();
  final _businessWebsiteController = TextEditingController();
  String? _selectedState;
  String? _selectedCity;
  final _contactNumberController = TextEditingController();
  final _describeExpertiseInController = TextEditingController();
  final _areaOfInterestController = TextEditingController();

  List<PlatformFile>? _brandLogo;
  List<PlatformFile>? _businessPhotos;
  List<PlatformFile>? _businessDocuments;
  PlatformFile? _businessProof;

  // New variables to store fetched image URLs
  String? _fetchedBrandLogo;
  String? _fetchedBusinessPhotos;
  String? _fetchedBusinessProof;
  String? _fetchedBusinessDocuments;

  bool _isLoading = true;
  AdvisorExplr? _advisor;

  // Map of states and their corresponding cities
  final Map<String, List<String>> _stateCityMap = {
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur'],
    'Karnataka': ['Bangalore', 'Mysore', 'Hubli'],
    'Tamil Nadu': ['Chennai', 'Coimbatore', 'Madurai'],
  };

  @override
  void initState() {
    super.initState();
    _fetchAdvisorData();
  }

  @override
  void dispose() {
    _advisorNameController.dispose();
    _designationController.dispose();
    _businessWebsiteController.dispose();
    _contactNumberController.dispose();
    _describeExpertiseInController.dispose();
    _areaOfInterestController.dispose();
    super.dispose();
  }

  Future<void> _fetchAdvisorData() async {
    setState(() => _isLoading = true);
    try {
      List<AdvisorExplr>? advisors = await AdvisorFetchPage.fetchAdvisorData();
      if (advisors != null && advisors.isNotEmpty) {
        _advisor = advisors.firstWhere((advisor) => advisor.id == widget.advisorId);
        _populateFields();
      }
    } catch (e) {
      print('Error fetching advisor data: $e');
      Get.snackbar('Error', 'Failed to fetch advisor data');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _populateFields() {
    if (_advisor != null) {
      _advisorNameController.text = _advisor!.name;
      _designationController.text = _advisor!.designation ?? '';
      _businessWebsiteController.text = _advisor!.url ?? '';
      _selectedState = _advisor!.state;
      _selectedCity = _advisor!.location;
      _contactNumberController.text = _advisor!.contactNumber ?? '';
      _describeExpertiseInController.text = _advisor!.description ?? '';
      _areaOfInterestController.text = _advisor!.interest ?? '';

      // Store fetched image URLs
      _fetchedBrandLogo = _advisor!.imageUrl;
      // _fetchedBusinessPhotos = _advisor!.businessPhotos;
      _fetchedBusinessProof = _advisor!.businessProof;
      // _fetchedBusinessDocuments = _advisor!.businessDocuments;
    }
  }

  Future<void> _updateAdvisor() async {
    if (_formKey.currentState!.validate()) {
      try {
        bool success = await AdvisorFetchPage.updateAdvisorProfile(
          advisorId: int.parse(widget.advisorId),
          advisorName: _advisorNameController.text,
          designation: _designationController.text,
          businessWebsite: _businessWebsiteController.text,
          state: _selectedState!,
          city: _selectedCity!,
          contactNumber: _contactNumberController.text,
          describeExpertise: _describeExpertiseInController.text,
          areaOfInterest: _areaOfInterestController.text,
          brandLogo: _brandLogo?.map((file) => File(file.path!)).toList(),
          businessPhotos: _businessPhotos?.map((file) => File(file.path!)).toList(),
          businessProof: _businessProof != null ? File(_businessProof!.path!) : null,
          businessDocuments: _businessDocuments?.map((file) => File(file.path!)).toList(),
        );

        if (success) {
          Get.snackbar('Success', 'Advisor profile updated successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          Navigator.pop(context);
        } else {
          Get.snackbar('Error', 'Failed to update advisor profile',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e) {
        print('Error updating advisor profile: $e');
        Get.snackbar('Error', 'An unexpected error occurred',
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
  Future<void> _pickBrandLogo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        _brandLogo = result.files;
        _fetchedBrandLogo = null; // Clear fetched logo when new one is picked
      });
    }
  }

  Future<void> _pickBusinessPhotos() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        _businessPhotos = result.files;
        _fetchedBusinessPhotos = null; // Clear fetched photos when new ones are picked
      });
    }
  }

  Future<void> _pickBusinessDocuments() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        _businessDocuments = result.files;
        _fetchedBusinessDocuments = null; // Clear fetched documents when new ones are picked
      });
    }
  }

  Future<void> _pickBusinessProof() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        _businessProof = result.files.single;
        _fetchedBusinessProof = null; // Clear fetched proof when new one is picked
      });
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    if (value.length > 50) {
      return 'Name should not exceed 50 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name should only contain letters and spaces';
    }
    return null;
  }

  String? _validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Company Website URL is required';
    }
    final urlPattern = r'^(https?:\/\/)?([\w-]+\.)+[\w-]{2,4}(\.[\w-]{2,4})?(\/[\w-]*)*\/?$';
    final regex = RegExp(urlPattern);
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid URL (e.g., example.com or http://example.com)';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a contact number';
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit contact number';
    }
    return null;
  }

  String? _validateText(String? value, int maxLength) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    if (value.length > maxLength) {
      return 'Text should not exceed $maxLength characters';
    }
    return null;
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
      ),
    );
  }

  Widget _buildHintText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    if (_isLoading) {
      return EditScreenShimmerWidget();
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_outlined),
        ),
        title: Text('Update Advisor'),
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
                  'Advisor Information',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: h * 0.025),
                ),
                SizedBox(height: h * .03),
                _buildHintText('Advisor Name'),
                TextFormField(
                  controller: _advisorNameController,
                  decoration: _inputDecoration(),
                  validator: _validateName,
                ),
                SizedBox(height: 16.0),
                _buildHintText('Designation'),
                TextFormField(
                  controller: _designationController,
                  decoration: _inputDecoration(),
                  validator: _validateName,
                ),
                SizedBox(height: 16.0),
                _buildHintText('Company Website URL'),
                TextFormField(
                  controller: _businessWebsiteController,
                  decoration: _inputDecoration(),
                  validator: _validateUrl,
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHintText('State'),
                          DropdownButtonFormField<String>(
                            value: _selectedState,
                            hint: Text('Select a state'),
                            onChanged: (value) {
                              setState(() {
                                _selectedState = value;
                                _selectedCity = null; // Reset city when state changes
                              });
                            },
                            items: _stateCityMap.keys
                                .map((state) => DropdownMenuItem(
                              value: state,
                              child: Text(state),
                            ))
                                .toList(),
                            decoration: _inputDecoration(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a state';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHintText('City'),
                          DropdownButtonFormField<String>(
                            value: _selectedCity,
                            hint: Text('Select a city'),
                            onChanged: (value) {
                              setState(() {
                                _selectedCity = value;
                              });
                            },
                            items: _selectedState != null
                                ? _stateCityMap[_selectedState]!
                                .map((city) => DropdownMenuItem(
                              value: city,
                              child: Text(city),
                            ))
                                .toList()
                                : [],
                            decoration: _inputDecoration(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a city';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                _buildHintText('Contact Number'),
                TextFormField(
                  controller: _contactNumberController,
                  decoration: _inputDecoration(),
                  keyboardType: TextInputType.phone,
                  validator: _validatePhoneNumber,
                ),
                SizedBox(height: 16.0),
                _buildHintText('Describe where you are expertised in'),
                TextFormField(
                  controller: _describeExpertiseInController,
                  maxLines: 4,
                  decoration: _inputDecoration(),
                  validator: (value) => _validateText(value, 500),
                ),
                SizedBox(height: 16.0),
                _buildHintText('Area of interest'),
                TextFormField(
                  controller: _areaOfInterestController,
                  maxLines: 4,
                  decoration: _inputDecoration(),
                  validator: (value) => _validateText(value, 500),
                ),
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
                Center(
                  child: Container(
                    height: 200,
                    width: 360,
                    decoration: BoxDecoration(border: Border.all(color: Colors.black26)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildFileUploadRow('Brand Logo', _pickBrandLogo, _brandLogo, _fetchedBrandLogo),
                        _buildFileUploadRow('Business Photos', _pickBusinessPhotos, _businessPhotos, _fetchedBusinessPhotos),
                        _buildFileUploadRow('Business Proof', _pickBusinessProof, _businessProof != null ? [_businessProof!] : null, _fetchedBusinessProof),
                        _buildFileUploadRow('Brochures and\ndocuments', _pickBusinessDocuments, _businessDocuments, _fetchedBusinessDocuments),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32.0),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Color(0xff003C82),
                    ),
                    onPressed: _updateAdvisor,
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
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
        if (fetchedUrl != null)
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
          )
        else if (files != null && files.isNotEmpty)
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
          ),
      ],
    );
  }
}