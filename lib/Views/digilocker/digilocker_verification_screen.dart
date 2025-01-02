import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:project_emergio/Views/dashboard/dashboard_screen.dart';
import 'package:project_emergio/generated/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/aadhaar_details_post_service.dart';
import '../Profiles/investor/investor_profile_add_screen.dart';
import '../personal information screen.dart';
import '../profile page.dart';

class DigiLockerVerificationScreen extends StatefulWidget {
  final File? profileImage;
  final String type;
  final String? phone;
  final String? email;
  final String? website;
  final String ?about;
  final String ?industry;
  final String ?state;
  final String ?city;


  const DigiLockerVerificationScreen({
    Key? key,
    this.profileImage,
    required this.type,
     this.phone,
     this.email,
    this.website,
     this.about,
     this.industry,
     this.state,
     this.city,
  }) : super(key: key);

  @override
  State<DigiLockerVerificationScreen> createState() =>
      _DigiLockerVerificationScreenState();
}

class _DigiLockerVerificationScreenState
    extends State<DigiLockerVerificationScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  // API related variables
  final String _apiToken =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTczMjUyMzYyNywianRpIjoiZmIyMzJmYzItZmY0MS00NzQwLWI0ZWItOTYyMjYzNmE3OGVlIiwidHlwZSI6ImFjY2VzcyIsImlkZW50aXR5IjoiZGV2LnNoYWhlZW5Ac3VyZXBhc3MuaW8iLCJuYmYiOjE3MzI1MjM2MjcsImV4cCI6MTczNTExNTYyNywiZW1haWwiOiJzaGFoZWVuQHN1cmVwYXNzLmlvIiwidGVuYW50X2lkIjoibWFpbiIsInVzZXJfY2xhaW1zIjp7InNjb3BlcyI6WyJ1c2VyIl19fQ.-ZDagres4QGAZFWcldoanH6hRFdXuzIQgYhaxcZMCHo';
  String? _clientId;
  Map<String, dynamic>? _generateOtpResponse;
  Map<String, dynamic>? _verifyOtpResponse;
  Map<String, dynamic>? _faceMatchResponse;
  String? _profileImage;
  File? _selfieImage;

  int currentStep = 0;
  bool isLoading = false;
  bool hasCheckedPrerequisites = false;
  bool isResendingOtp = false;

  late AnimationController _snackbarAnimationController;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _snackbarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _snackbarAnimationController.dispose();
    _removeSnackbar();
    super.dispose();
  }

  void _showCustomSnackbar({
    required String message,
    required bool isError,
    Duration duration = const Duration(seconds: 3),
  }) {
    _removeSnackbar();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: SafeArea(
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _snackbarAnimationController,
              curve: Curves.fastOutSlowIn,
            )),
            child: Container(
              margin: EdgeInsets.all(16.w),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: isError
                        ? Color(0xFFFFEBEE)  // Light red background
                        : Color(0xFFE8F5E9), // Light green background
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isError
                          ? Color(0xFFEF5350).withOpacity(0.5)  // Red border
                          : Color(0xFF66BB6A).withOpacity(0.5), // Green border
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: Offset(0, 4),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _removeSnackbar,
                      borderRadius: BorderRadius.circular(12.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 16.h,
                        ),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: isError
                                    ? Color(0xFFEF5350).withOpacity(0.1)
                                    : Color(0xFF66BB6A).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                isError
                                    ? Icons.error_outline_rounded
                                    : Icons.check_circle_outline_rounded,
                                color: isError
                                    ? Color(0xFFEF5350)
                                    : Color(0xFF66BB6A),
                                size: 22.w,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                message,
                                style: TextStyle(
                                  color: isError
                                      ? Color(0xFFD32F2F)
                                      : Color(0xFF2E7D32),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            IconButton(
                              icon: Icon(
                                Icons.close_rounded,
                                color: isError
                                    ? Color(0xFFEF5350)
                                    : Color(0xFF66BB6A),
                                size: 20.w,
                              ),
                              onPressed: _removeSnackbar,
                              splashRadius: 20.r,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _snackbarAnimationController.forward();

    Future.delayed(duration, () {
      if (_overlayEntry != null) {
        _snackbarAnimationController.reverse().then((_) {
          _removeSnackbar();
        });
      }
    });
  }
  void _removeSnackbar() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 20.w),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        margin: EdgeInsets.all(16.w),
        duration: const Duration(seconds: 3),
        dismissDirection: DismissDirection.horizontal,
        elevation: 4,
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 20.w),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        margin: EdgeInsets.all(16.w),
        duration: const Duration(seconds: 1),
        dismissDirection: DismissDirection.horizontal,
        elevation: 4,
      ),
    );
  }

  // Validation methods
  bool get isAadhaarValid => _aadhaarController.text.replaceAll(' ', '').length == 12;
  bool get isOtpValid => _otpController.text.length == 6;

  Map<String, String> _extractAadhaarDetails() {
    if (_verifyOtpResponse == null || _verifyOtpResponse!['data'] == null) {
      throw Exception('Aadhaar verification data not available');
    }

    final userData = _verifyOtpResponse!['data'];

    // Extract the full name
    String fullName = userData['full_name'] ?? '';

    // Extract care_of detail
    String careOf = userData['care_of'] ?? '';

    // Extract and format address
    final address = userData['address'];
    List addressParts = [
      address['house'] ?? '',
      address['street'] ?? '',
      address['landmark'] ?? '',
      address['loc'] ?? '',
      address['vtc'] ?? '',
      address['subdist'] ?? '',
      address['dist'] ?? '',
      address['state'] ?? '',
      address['country'] ?? '',
      address['zip'] ?? '', // Postal code
    ].where((part) => part != '' && part != 'XYZ').toList(); // Filter out empty and XYZ values

    String fullAddress = addressParts.join(', ');

    // Prepare result map
    Map<String, String> details = {
      'firstName': fullName,
      'dob': userData['dob'] ?? '',
      'email': userData['email_hash'] ?? '', // Use email hash from response
      'phone': userData['reference_id'] ?? '', // Use reference ID as phone
      'gender': userData['gender'] == 'M' ? 'Male' : (userData['gender'] == 'F' ? 'Female' : 'Other'),
      'address': fullAddress,
      'profileImage': userData['profile_image'] ?? '',
      'aadhaarNumber': userData['aadhaar_number'] ?? '',
      'careOf': careOf,
    };

    return details;
  }
  void _showNameMismatchDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Column(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48.w,
              ),
              SizedBox(height: 16.h),
              Text(
                'Name Mismatch',
                style: TextStyle(
                  color: lightTextColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'The name you entered does not match with your Aadhaar card details.',
                style: TextStyle(
                  color: greyTextColor,
                  fontSize: 16.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'Please update your profile with the exact name as mentioned in your Aadhaar card.',
                style: TextStyle(
                  color: greyTextColor,
                  fontSize: 14.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to form
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16.sp,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                // Navigate back to form with all data
                final aadhaarDetails = _verifyOtpResponse?['data'];
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddInvestorProfileScreen(
                      initialName: aadhaarDetails?['full_name'] ?? '',
                      initialPhone: widget.phone ?? '',  // Make sure these properties exist
                      initialEmail: widget.email ?? '',
                      initialWebsite: widget.website ?? '',
                      initialAbout: widget.about ?? '',
                      initialIndustry: widget.industry,
                      initialState: widget.state,
                      initialCity: widget.city,
                      initialImage: widget.profileImage,
                      isFromDigilocker: true,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Update Profile',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// API Methods
  Future<void> generateOtp() async {
    if (!isAadhaarValid) {
      _showErrorSnackbar('Please enter a valid 12-digit Aadhaar number');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://sandbox.surepass.io/api/v1/aadhaar-v2/generate-otp'),
        headers: {
          'Authorization': 'Bearer $_apiToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id_number': _aadhaarController.text.replaceAll(' ', ''),
        }),
      );

      print('Generate OTP Response: ${response.body}');
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          _clientId = responseData['data']['client_id'];
          _generateOtpResponse = responseData;
          if (!isResendingOtp) {
            currentStep++;
          }
        });
        _showSuccessSnackbar('OTP sent successfully');
      } else {
        throw Exception(responseData['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      print('Error in Generate OTP: $e');
      _showErrorSnackbar(e.toString());
    } finally {
      setState(() {
        isLoading = false;
        isResendingOtp = false;
      });
    }
  }

  Future<void> verifyOtp() async {
    if (!isOtpValid) {
      _showErrorSnackbar('Please enter a valid 6-digit OTP');
      return;
    }

    if (_clientId == null) {
      _showErrorSnackbar('Please generate OTP first');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://sandbox.surepass.io/api/v1/aadhaar-v2/submit-otp'),
        headers: {
          'Authorization': 'Bearer $_apiToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'client_id': _clientId,
          'otp': _otpController.text,
        }),
      );

      print('Verify OTP Response: ${response.body}');
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          _verifyOtpResponse = responseData;
          _profileImage = responseData['data']['profile_image'];
          currentStep++;
        });
        _showSuccessSnackbar('OTP verified successfully');
      } else {
        throw Exception(responseData['message'] ?? 'OTP verification failed');
      }
    } catch (e) {
      print('Error in Verify OTP: $e');
      _showErrorSnackbar(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> takeSelfie() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 80,
        maxHeight: 1000,
        maxWidth: 1000,
      );

      if (image != null) {
        setState(() {
          _selfieImage = File(image.path);
        });
      } else {
        // User cancelled the picker
        _showErrorSnackbar('Selfie capture cancelled');
      }
    } catch (e) {
      print('Error taking selfie: $e');
      _showErrorSnackbar('Failed to capture selfie. Please try again.');
    }
  }

// Inside _DigiLockerVerificationScreenState class
  Future<void> performFaceMatch() async {
    if (_selfieImage == null || _profileImage == null) {
      _showErrorSnackbar('Please take a selfie first');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://sandbox.surepass.io/api/v1/face/face-match'),
      );

      request.headers['Authorization'] = 'Bearer $_apiToken';
      request.fields['selfie_2_link'] = _profileImage!;

      var selfieStream = http.ByteStream(_selfieImage!.openRead());
      var selfieLength = await _selfieImage!.length();
      var selfieMultipart = http.MultipartFile(
        'selfie',
        selfieStream,
        selfieLength,
        filename: 'selfie.jpg',
      );
      request.files.add(selfieMultipart);

      final streamedResponse = await request.send();
      final faceMatchResponse = await http.Response.fromStream(streamedResponse);
      final faceMatchData = jsonDecode(faceMatchResponse.body);

      print('Face Match Response: ${faceMatchResponse.body}');

      setState(() {
        _faceMatchResponse = faceMatchData;
      });

      if (faceMatchResponse.statusCode == 200 &&
          (faceMatchData['data']['match_status'] ?? false)) {

        final aadhaarDetails = await _extractAadhaarDetails();

        final postResponse = await AadhaarDetailsPostService.aadhaarDetailsPost(
          firstName: aadhaarDetails['firstName']!,
          dob: aadhaarDetails['dob']!,
          email: aadhaarDetails['email']!,
          phone: aadhaarDetails['phone']!,
          gender: aadhaarDetails['gender']!,
          profileImage: aadhaarDetails['profileImage']!,
          address: aadhaarDetails['address']!,
        );

        if (postResponse == 201) {
          // Show success animation dialog
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Container(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.verified_user,
                          color: Colors.green,
                          size: 40.w,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'Verification Successful!',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Your profile has been verified successfully',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Save verification status
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('isVerified', true);

                            // Navigate to ProfileScreen with verified badge
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => ProfileScreen()),
                                  (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Done',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (postResponse == 422) {
          // Name mismatch - navigate to personal information screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PersonalInformationScreen(
                onUpdate: (newImage) {
                  // Handle image update if needed
                },
                initialName: aadhaarDetails['firstName'], // Pass Aadhaar name
                isFromDigilocker: true,
              ),
            ),
          );
        }
      } else {
        throw Exception('Face verification failed. Please try again with a clearer selfie.');
      }
    } catch (e) {
      print('Error in verification process: $e');
      _showErrorSnackbar(e.toString());
      setState(() {
        _selfieImage = null;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  String _getButtonText() {
    switch (currentStep) {
      case 0:
        return 'Start Verification';
      case 1:
        return 'Verify Aadhaar';
      case 2:
        return 'Verify OTP';
      case 3:
        return _selfieImage == null ? 'Take Selfie' : 'Complete Verification';
      default:
        return 'Continue';
    }
  }

  String _getLoadingText() {
    switch (currentStep) {
      case 0:
        return 'Preparing verification...';
      case 1:
        return 'Verifying Aadhaar number...';
      case 2:
        return 'Verifying OTP...';
      case 3:
        return 'Processing verification...';
      default:
        return 'Processing...';
    }
  }

  // Button Action Handler
  void onNextButtonPressed() async {
    if (currentStep == 0 && !hasCheckedPrerequisites) {
      _showErrorSnackbar('Please confirm the prerequisites');
      return;
    }

    if (isLoading) return;

    switch (currentStep) {
      case 0:
        setState(() {
          currentStep++;
        });
        break;

      case 1:
        await generateOtp();
        break;

      case 2:
        await verifyOtp();
        break;

      case 3:
        if (_selfieImage == null) {
          await takeSelfie();
        } else {
          await performFaceMatch();
        }
        break;
    }
  }

  // UI Building Methods
  Widget _buildStepIndicator() {
    final List<String> steps = ['Start', 'Aadhaar', 'OTP', 'Selfie'];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Stack(
        children: [
          Positioned(
            top: 15.h,
            left: 40.w,
            right: 40.w,
            child: Container(
              height: 3.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    buttonColor,
                    buttonColor,
                    currentStep >= 1
                        ? buttonColor
                        : greyTextColor!.withOpacity(0.3),
                    currentStep >= 2
                        ? buttonColor
                        : greyTextColor!.withOpacity(0.3),
                    currentStep >= 3
                        ? buttonColor
                        : greyTextColor!.withOpacity(0.3),
                  ],
                  stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(steps.length, (index) {
              bool isCompleted = index < currentStep;
              bool isCurrent = index == currentStep;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? buttonColor
                          : (isCompleted
                              ? buttonColor.withOpacity(0.8)
                              : backgroundColor),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCurrent
                            ? buttonColor
                            : (isCompleted
                                ? buttonColor
                                : greyTextColor!.withOpacity(0.3)),
                        width: 2,
                      ),
                      boxShadow: isCurrent
                          ? [
                              BoxShadow(
                                color: buttonColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              )
                            ]
                          : null,
                    ),
                    child: Center(
                      child: isCompleted
                          ? Icon(Icons.check,
                              color: backgroundColor, size: 16.w)
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                color:
                                    isCurrent ? backgroundColor : greyTextColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    steps[index],
                    style: TextStyle(
                      color: isCurrent ? buttonColor : greyTextColor,
                      fontSize: 12.sp,
                      fontWeight:
                          isCurrent ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPrerequisitesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to Aadhaar Verification',
          style: AppTheme.headingText(lightTextColor)
              .copyWith(fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24.h),
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: buttonColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: buttonColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Before you begin, please ensure:',
                style: AppTheme.mediumTitleText(lightTextColor)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16.h),
              _buildPrerequisiteItem(
                icon: Icons.phone_android,
                title: 'Mobile Number Access',
                description:
                    'You have access to the mobile number linked with your Aadhaar',
              ),
              SizedBox(height: 16.h),
              _buildPrerequisiteItem(
                icon: Icons.credit_card,
                title: 'Aadhaar Card',
                description:
                    'Your 12-digit Aadhaar number is readily available',
              ),
              SizedBox(height: 16.h),
              _buildPrerequisiteItem(
                icon: Icons.camera_alt,
                title: 'Camera Ready',
                description:
                    'Your device camera is working for the selfie verification',
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        CheckboxListTile(
          value: hasCheckedPrerequisites,
          onChanged: (value) {
            setState(() {
              hasCheckedPrerequisites = value ?? false;
            });
          },
          title: Text(
            'I confirm that I have all the prerequisites ready',
            style: AppTheme.bodyMediumTitleText(lightTextColor),
          ),
          activeColor: buttonColor,
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
    );
  }

  Widget _buildPrerequisiteItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: buttonColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: buttonColor, size: 20.w),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.mediumTitleText(lightTextColor)
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 4.h),
              Text(
                description,
                style: AppTheme.bodyMediumTitleText(greyTextColor!),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAadhaarStep() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: boxShadowColor,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(Icons.credit_card, size: 48.w, color: buttonColor),
              SizedBox(height: 16.h),
              Text(
                'Enter Aadhaar Details',
                style: AppTheme.mediumHeadingText(lightTextColor)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 24.h),
            TextFormField(
              controller: _aadhaarController,
              keyboardType: TextInputType.number,
              maxLength: 14, // Increased to account for spaces
              decoration: InputDecoration(
                labelText: 'Aadhaar Number',
                hintText: 'XXXX XXXX XXXX',
                prefixIcon: Icon(Icons.numbers, color: buttonColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                errorText: _aadhaarController.text.isNotEmpty && !isAadhaarValid
                    ? 'Please enter a valid Aadhaar number'
                    : null,
              ),
              onChanged: (value) {
                value = value.replaceAll(' ', ''); // Remove existing spaces
                if (value.length > 12) {
                  value = value.substring(0, 12); // Limit to 12 digits
                }

                String formattedValue = '';
                for (int i = 0; i < value.length; i++) {
                  if (i > 0 && i % 4 == 0) {
                    formattedValue += ' ';
                  }
                  formattedValue += value[i];
                }

                // Update the text field with formatted value
                _aadhaarController.value = TextEditingValue(
                  text: formattedValue,
                  selection: TextSelection.collapsed(offset: formattedValue.length),
                );
              },
            ),
            SizedBox(height: 16.h),
              _buildInfoBox(
                'Important',
                [
                  'Enter the 12-digit Aadhaar number linked with your mobile',
                  'Double-check the number before proceeding',
                  'Your data is encrypted and secure',
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOtpStep() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: boxShadowColor,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(Icons.message, size: 48.w, color: buttonColor),
              SizedBox(height: 16.h),
              Text(
                'OTP Verification',
                style: AppTheme.mediumHeadingText(lightTextColor)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8.h),
              Text(
                'Enter the OTP sent to your Aadhaar-linked mobile',
                style: AppTheme.bodyMediumTitleText(greyTextColor!),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: AppTheme.headingText(lightTextColor),
                decoration: InputDecoration(
                  hintText: '······',
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  errorText: _otpController.text.isNotEmpty && !isOtpValid
                      ? 'Please enter a valid 6-digit OTP'
                      : null,
                ),
                onChanged: (value) {
                  setState(() {}); // Rebuild to show/hide error text
                },
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Did not receive OTP?',
                    style: AppTheme.bodyMediumTitleText(greyTextColor!),
                  ),
                  TextButton(
                    onPressed: isResendingOtp
                        ? null
                        : () {
                            setState(() {
                              isResendingOtp = true;
                            });
                            generateOtp();
                          },
                    child: Text(
                      'Resend OTP',
                      style: AppTheme.bodyMediumTitleText(
                        isResendingOtp ? greyTextColor! : buttonColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              _buildInfoBox(
                'Important',
                [
                  'OTP is valid for 10 minutes',
                  'Make sure to check your SMS inbox',
                  'Do not share OTP with anyone',
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelfieStep() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: boxShadowColor,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => takeSelfie(),
                child: Container(
                  width: 200.w,
                  height: 200.w,
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: buttonColor, width: 2),
                  ),
                  child: _selfieImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Image.file(
                            _selfieImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 48.w,
                              color: buttonColor,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Take Selfie',
                              style: AppTheme.mediumTitleText(buttonColor),
                            ),
                          ],
                        ),
                ),
              ),
              SizedBox(height: 24.h),
              _buildInfoBox(
                'Selfie Guidelines',
                [
                  'Ensure good lighting',
                  'Look directly at the camera',
                  'Keep a neutral expression',
                  'Remove any face coverings',
                ],
              ),
              if (_selfieImage != null) ...[
                SizedBox(height: 16.h),
                TextButton(
                  onPressed: takeSelfie,
                  child: Text(
                    'Retake Selfie',
                    style: AppTheme.bodyMediumTitleText(buttonColor),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBox(String title, List<String> points) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: buttonColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.mediumTitleText(lightTextColor)
                .copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          ...points.map((point) => Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, size: 16.w, color: buttonColor),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        point,
                        style: AppTheme.bodyMediumTitleText(greyTextColor!),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (currentStep) {
      case 0:
        return _buildPrerequisitesStep();
      case 1:
        return _buildAadhaarStep();
      case 2:
        return _buildOtpStep();
      case 3:
        return _buildSelfieStep();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentStep > 0) {
          setState(() {
            currentStep--;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: lightTextColor),
            onPressed: () {
              if (currentStep > 0) {
                setState(() {
                  currentStep--;
                });
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: Text(
            'DigiLocker Verification',
            style: AppTheme.titleText(lightTextColor)
                .copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _buildStepIndicator(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: _buildCurrentStep(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : onNextButtonPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? SizedBox(
                                    width: 24.w,
                                    height: 24.w,
                                    child: CircularProgressIndicator(
                                      color: backgroundColor,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    _getButtonText(),
                                    style: AppTheme.mediumTitleText(
                                            backgroundColor)
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: buttonColor),
                          SizedBox(height: 16.h),
                          Text(
                            _getLoadingText(),
                            style: AppTheme.mediumTitleText(lightTextColor),
                          ),
                        ],
                      ),
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
