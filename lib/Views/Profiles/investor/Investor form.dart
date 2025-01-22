import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:project_emergio/Views/dashboard/dashboard_screen.dart';
import 'package:project_emergio/controller/dashboard_controller.dart';
import 'package:project_emergio/generated/constants.dart';
import 'package:project_emergio/models/all%20profile%20model.dart';
import 'package:project_emergio/services/profile%20forms/investor/investor%20add.dart';
import '../../../models/places.dart';
import 'investment listing.dart';

class InvestorFormScreen extends StatefulWidget {
  final bool isEdit;
  final String type;
  final BusinessInvestorExplr? investor;
  const InvestorFormScreen({super.key, required this.isEdit, this.investor, required this.type});

  @override
  State<InvestorFormScreen> createState() => _InvestorFormScreenState();
}

class _InvestorFormScreenState extends State<InvestorFormScreen> {
  final _formKey = GlobalKey<FormState>(); // Add GlobalKey for the form

  final _investorNameController = TextEditingController();
  String _selectedIndustry = '';
  String _selectedState = 'Kerala';
  String _selectedCity = 'kakkanad';

  final _locationsIntrestedController = TextEditingController();
  final _investmentRangefromController = TextEditingController();
  final _investmentRangeToController = TextEditingController();
  final _aspectsEvaluatingController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _businessWebsiteController = TextEditingController();
  final _aboutCompanyController = TextEditingController();
  final _describeYourselfController = TextEditingController();
  final _preferenceController = TextEditingController();

  final DashboardController _controller = Get.put(DashboardController());

  List<XFile>? _businessPhotos;
  List<PlatformFile>? _businessDocuments;
  PlatformFile? _businessProof;

  bool _isSubmitting = false;

  @override
  void dispose() {
    _investorNameController.dispose();
    _locationsIntrestedController.dispose();
    _investmentRangefromController.dispose();
    _investmentRangeToController.dispose();
    _aspectsEvaluatingController.dispose();
    _companyNameController.dispose();
    _businessWebsiteController.dispose();
    _aboutCompanyController.dispose();

    super.dispose();
  }

// Add a new validation method for names
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Investor Name is required';
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
// Similarly update other validation methods
  String? _validateLimitedLength(
      String? value, String fieldName, int maxLength) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (value.length > maxLength) {
      return '$fieldName cannot exceed $maxLength characters';
    }
    return null;
  }

  String? _validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final urlPattern =
        r'^(https?:\/\/)?([a-zA-Z0-9\-]+\.)+[a-zA-Z]{2,6}(\/[^\s]*)?$'; // Updated regex
    final regex = RegExp(urlPattern);
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid URL (e.g., http://example.com or https://www.example.com)';
    }
    if (value.length > 100) {
      // Limit for the URL
      return 'URL cannot exceed 100 characters';
    }
    return null;
  }

  Future<void> _pickBusinessPhotos() async {
    final result = await ImagePicker().pickMultiImage();
    if (result != null) {
      setState(() {
        _businessPhotos = result;
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

  InputDecoration _inputDecoration() {
    return InputDecoration(
        labelStyle: AppTheme.bodyMediumTitleText(greyTextColor!),
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor!),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: errorIconColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: errorIconColor),
        ));
  }

  Widget _buildHintText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: AppTheme.bodyMediumTitleText(greyTextColor!)),
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedIndustry = 'Fashion';
    _selectedState = '';
    _selectedCity = '';
    _fetchStates();
    // Initialize _selectedPreferences to match the number of preferences
    _selectedPreferences = List.generate(_preferences.length, (index) => false);
    setTextFields();
  }

  void setTextFields() {
    if (widget.investor != null) {
      setPreferences();

      setState(() {
        _describeYourselfController.text =
            widget.investor!.profileSummary ?? "";
        _investmentRangeToController.text = widget.investor!.rangeEnding ?? "";
        _investmentRangefromController.text =
            widget.investor!.rangeStarting ?? "";
        _aboutCompanyController.text = widget.investor!.description ?? "";
        _aspectsEvaluatingController.text =
            widget.investor!.evaluatingAspects ?? "";
        _businessWebsiteController.text = widget.investor!.url ?? "";
        _companyNameController.text = widget.investor!.companyName ?? "";
        _investorNameController.text = widget.investor!.name ?? "";
        preferencesLists = [...widget.investor!.preference ?? []];
        _selectedCity = widget.investor!.city ?? "Kakkanad";
        _selectedState = widget.investor!.state ?? "Kerala";
        _locationsIntrestedController.text =
            widget.investor!.locationIntrested ?? "";
        _selectedIndustry = widget.investor!.industry ?? "Fashion";
        _selectedPreferences = _selectedPreferences;
      });
    }
  }

  void setPreferences() {
    if (widget.investor != null && widget.investor!.preference != null) {
      for (int i = 0; i < widget.investor!.preference!.length; i++) {
        setState(() {
          if (_selectedPreferences[i]) _preferences[i];
        });
      }
    }

  }

  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _validateNumber(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number for $fieldName';
    }
    return null;
  }

  Widget _buildSelectedImages() {
    if (_businessPhotos == null || _businessPhotos!.isEmpty) {
      return const Text('');
    }
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8.0),
      itemCount: _businessPhotos!.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemBuilder: (context, index) {
        final file = _businessPhotos![index];
        return Image.file(
          File(file.path!),
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget _buildSelectedDocuments() {
    if (_businessDocuments == null || _businessDocuments!.isEmpty) {
      return const Text('');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _businessDocuments!.map((file) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(file.name),
        );
      }).toList(),
    );
  }

  // Widget _buildSelectedProof() {
  //   if (_businessProof == null) {
  //     return const Text('');
  //   }
  //   return Text(_businessProof!.name);
  // }

  final List<String> _preferences = [
    'Buying a business',
    'Investing in a business',
    'Lending to a business',
    'Buying business assets'
  ];
  // Initialize _selectedPreferences as a list of booleans matching _preferences length
  late List<bool> _selectedPreferences;
  List<String> preferencesLists = [];

  // Function to handle checkbox changes
  void _onPreferenceChanged(bool? isSelected, int index) {
    setState(() {
      _selectedPreferences[index] = isSelected ?? false;
    });

    final selectedPreferences = [
      for (int i = 0; i < _preferences.length; i++)
        if (_selectedPreferences[i]) _preferences[i]
    ];

    setState(() {
      preferencesLists = selectedPreferences;
    });
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
        title: Text(
          'Investor Information',
          style: AppTheme.mediumHeadingText(lightTextColor),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey, // Assign the form key
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHintText('Investor Name'),
                    TextFormField(
                      controller: _investorNameController,
                      decoration: _inputDecoration(),
                      validator: _validateName,
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHintText('Industry'),
                              DropdownButtonFormField<String>(
                                value: _selectedIndustry,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedIndustry = value!;
                                  });
                                },
                                items: [
                                  'Education',
                                  'Information Technology',
                                  'Healthcare',
                                  'Fashion',
                                  'Food',
                                  'Automobile',
                                  'Banking'
                                ]
                                    .map((industry) => DropdownMenuItem(
                                  value: industry,
                                  child: Text(
                                    industry,
                                    style: AppTheme.bodyMediumTitleText(
                                        greyTextColor!)
                                        .copyWith(
                                        fontWeight:
                                        FontWeight.normal),
                                  ),
                                ))
                                    .toList(),
                                decoration: _inputDecoration(),
                                validator: (value) =>
                                    _validateNotEmpty(value, 'Industry'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16.0),
                      ],
                    ),
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

                    const SizedBox(height: 16.0),
                    _buildHintText('Describe yourself'),
                    TextFormField(
                      controller: _describeYourselfController,
                      maxLines: null,
                      decoration: _inputDecoration(),
                      validator: (value) => _validateLimitedLength(
                          value, 'Description', 100), // Set limit as needed
                    ),
                    const SizedBox(height: 16.0),
                    _buildHintText('Choose your preferences'),
                    // Generate a checkbox for each preference
                    ..._preferences.asMap().entries.map((entry) {
                      int index = entry.key;
                      String preference = entry.value;
                      return CheckboxListTile(
                        activeColor: buttonColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        title: Text(preference,
                            style:
                            AppTheme.bodyMediumTitleText(greyTextColor!)),
                        value: _selectedPreferences[index],
                        onChanged: (isSelected) =>
                            _onPreferenceChanged(isSelected, index),
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    }).toList(),

                    const SizedBox(height: 16.0),

                    const SizedBox(height: 16.0),
                    _buildHintText('Location you are interested in'),
                    TextFormField(
                      controller: _locationsIntrestedController,
                      maxLines: null,
                      decoration: _inputDecoration(),
                      validator: (value) => _validateLimitedLength(value,
                          'Location Interested', 100), // Set limit as needed
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHintText('Minimum investment range'),
                              TextFormField(
                                controller: _investmentRangefromController,
                                keyboardType: TextInputType.number,
                                decoration: _inputDecoration(),
                                validator: (value) => _validateNumber(
                                    value, 'Investment Range From'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHintText('Investment Range To'),
                              TextFormField(
                                controller: _investmentRangeToController,
                                keyboardType: TextInputType.number,
                                decoration: _inputDecoration(),
                                validator: (value) => _validateNumber(
                                    value, 'Investment Range To'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    _buildHintText(
                        'Aspects you consider when evaluating a business'),
                    TextFormField(
                      controller: _aspectsEvaluatingController,
                      decoration: _inputDecoration(),
                      validator: (value) => _validateLimitedLength(
                          value, 'Aspects Evaluating', 150), // Limit as needed
                    ),
                    const SizedBox(height: 16.0),
                    _buildHintText('Your Company Name'),
                    TextFormField(
                      controller: _companyNameController,
                      decoration: _inputDecoration(),
                      validator: (value) => _validateLimitedLength(
                          value, 'Company Name', 50), // Limit as needed
                    ),
                    const SizedBox(height: 16.0),
                    _buildHintText('Company Website URL'),
                    TextFormField(
                      controller: _businessWebsiteController,
                      decoration: _inputDecoration(),
                      validator: _validateUrl,
                    ),
                    const SizedBox(height: 16.0),
                    _buildHintText('About Your Company'),
                    TextFormField(
                      maxLines: 5,
                      controller: _aboutCompanyController,
                      decoration: _inputDecoration(),
                      validator: (value) => _validateLimitedLength(
                          value, 'About Company', 250), // Limit as needed
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Uploads your Documents',
                      style: AppTheme.bodyMediumTitleText(greyTextColor!)
                          .copyWith(fontSize: h * 0.028),
                    ),

                    const SizedBox(height: 16.0),
                    _buildFileUploadRow('Business Photos', _pickBusinessPhotos,
                        _businessPhotos),
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
                          backgroundColor: buttonColor,
                        ),
                        onPressed: () async {
                          widget.isEdit == true ? editForm() : submitForm();
                        },
                        child: Text(
                          widget.isEdit == true ? "Save changes" : 'Next',
                          style: AppTheme.bodyMediumTitleText(Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32.0),
                  ],
                ),
              ),
            ),
          ),
          if (_isSubmitting)
            Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Lottie.asset(
                    'assets/loading.json',
                    height: 80.h,
                    width: 120.w,
                    fit: BoxFit.cover,
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildFileUploadRow(
      String label, VoidCallback onPressed, List<dynamic>? files) {
    return Container(
      decoration: BoxDecoration(
          border:
          Border.all(width: 1, color: const Color.fromARGB(255, 224, 228, 230)),
          borderRadius: BorderRadius.circular(15)),
      height: 60,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
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
                              ? const Icon(Icons.picture_as_pdf, color: Colors.red)
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
      if (preferencesLists.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your preferences')),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      try {
        // Initialize all parameters as null
        File? imageFile1, imageFile2, imageFile3, imageFile4, docFile, proofFile;

        // Set file parameters only if files are selected
        if (_businessPhotos != null && _businessPhotos!.isNotEmpty) {
          if (_businessPhotos!.length >= 1) imageFile1 = File(_businessPhotos![0].path);
          if (_businessPhotos!.length >= 2) imageFile2 = File(_businessPhotos![1].path);
          if (_businessPhotos!.length >= 3) imageFile3 = File(_businessPhotos![2].path);
          if (_businessPhotos!.length >= 4) imageFile4 = File(_businessPhotos![3].path);
        }

        if (_businessDocuments != null && _businessDocuments!.isNotEmpty) {
          docFile = File(_businessDocuments![0].path!);
        }

        if (_businessProof != null && _businessProof!.path != null) {
          proofFile = File(_businessProof!.path!);
        }

        // Call the API with all parameters, including null values for missing files
        final response = await InvestorAddPage.investorAddPage(
          name: _investorNameController.text.trim(),
          companyName: _companyNameController.text.trim(),
          industry: _selectedIndustry,
          description: _aboutCompanyController.text.trim(),
          state: _selectedState,
          city: _selectedCity,
          url: _businessWebsiteController.text.trim(),
          rangeStarting: _investmentRangefromController.text.trim(),
          rangeEnding: _investmentRangeToController.text.trim(),
          evaluatingAspects: _aspectsEvaluatingController.text.trim(),
          locationInterested: _locationsIntrestedController.text.trim(),
          summary: _describeYourselfController.text.trim(),
          preferences: preferencesLists,
          image1: imageFile1,
          image2: imageFile2,
          image3: imageFile3,
          image4: imageFile4,
          doc1: docFile,
          proof1: proofFile,
        );

        setState(() {
          _isSubmitting = false;
        });

        if (response == true) {
          _controller.fetchListings("investor");
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(milliseconds: 1500),
              content: Text('Failed to submit investor information'),
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isSubmitting = false;
        });
        print('Error submitting form: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(milliseconds: 1500),
            content: Text('Error submitting form: ${e.toString()}'),
          ),
        );
      }
    }
  }

  void editForm() async {
    if (widget.investor != null && _formKey.currentState!.validate()) {
      if (preferencesLists.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your preferences')),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      try {
        // Initialize all parameters as null
        File? imageFile1, imageFile2, imageFile3, imageFile4, docFile, proofFile;

        // Set file parameters only if files are selected
        if (_businessPhotos != null && _businessPhotos!.isNotEmpty) {
          if (_businessPhotos!.length >= 1) imageFile1 = File(_businessPhotos![0].path);
          if (_businessPhotos!.length >= 2) imageFile2 = File(_businessPhotos![1].path);
          if (_businessPhotos!.length >= 3) imageFile3 = File(_businessPhotos![2].path);
          if (_businessPhotos!.length >= 4) imageFile4 = File(_businessPhotos![3].path);
        }

        if (_businessDocuments != null && _businessDocuments!.isNotEmpty) {
          docFile = File(_businessDocuments![0].path!);
        }

        if (_businessProof != null && _businessProof!.path != null) {
          proofFile = File(_businessProof!.path!);
        }

        final response = await InvestorAddPage.updateInvestor(
          investorId: widget.investor!.id,
          name: _investorNameController.text.trim(),
          companyName: _companyNameController.text.trim(),
          industry: _selectedIndustry,
          description: _aboutCompanyController.text.trim(),
          state: _selectedState,
          city: _selectedCity,
          url: _businessWebsiteController.text.trim(),
          rangeStarting: _investmentRangefromController.text.trim(),
          rangeEnding: _investmentRangeToController.text.trim(),
          evaluatingAspects: _aspectsEvaluatingController.text.trim(),
          locationInterested: _locationsIntrestedController.text.trim(),
          summary: _describeYourselfController.text.trim(),
          preferences: preferencesLists,
          image1: imageFile1,
          image2: imageFile2,
          image3: imageFile3,
          image4: imageFile4,
          doc1: docFile,
          proof1: proofFile,
        );

        setState(() {
          _isSubmitting = false;
        });

        if (response == true) {
          _controller.fetchListings("investor");
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(milliseconds: 1500),
              content: Text('Failed to update investor information'),
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isSubmitting = false;
        });
        print('Error updating form: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(milliseconds: 1500),
            content: Text('Error updating form: ${e.toString()}'),
          ),
        );
      }
    }
  }

}
