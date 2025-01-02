// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:lottie/lottie.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../services/user profile and personal info.dart';
// import 'package:project_emergio/Views/Auth%20Screens/login.dart'; // Ensure this import is correct
//
// class ProfileController extends GetxController {
//   var profileImageUrl = Rxn<String>();
//   var firstName = ''.obs;
//   var phoneNumber = ''.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchUserProfile();
//   }
//
//   Future<void> fetchUserProfile() async {
//     UserProfileAndImage? profile = await UserProfile.fetchUserProfileData();
//     if (profile != null) {
//       firstName.value = profile.profile.firstName;
//       profileImageUrl.value = profile.image?.image; // URL from profile data
//       phoneNumber.value = profile.profile.username;
//     }
//   }
//
//   void updateProfileImage(String newImageUrl) {
//     profileImageUrl.value = newImageUrl;
//   }
//
//   Future<void> showLogoutDialog(BuildContext context) {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(6.0),
//                 child: Lottie.asset(
//                   'assets/logout_confirmation.json',
//                   height: 40.h,
//                   width: 60.w,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               SizedBox(height: 30.h),
//               Text('Confirm Logout',
//                   style:
//                       TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
//               SizedBox(height: 10.h),
//               Text('Are you sure you want to log out?'),
//             ],
//           ),
//           actions: [
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Logout', style: TextStyle(color: Colors.red)),
//               onPressed: () async {
//                 Navigator.of(context).pop(); // Close the dialog
//                 await logout(); // Call the logout method
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> logout() async {
//     // Create an instance of FlutterSecureStorage
//     final FlutterSecureStorage storage = FlutterSecureStorage();
//
//     // Remove the token from Flutter Secure Storage
//     await storage.delete(key: 'token');
//
//     // Sign out from Google
//     await GoogleSignIn().signOut();
//
//     // Navigate to SignInPage
//     Get.offAll(() => SignInPage());
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Views/digilocker/digilocker_verification_screen.dart';
import '../generated/constants.dart';
import '../services/user profile and personal info.dart';
import 'package:project_emergio/Views/Auth%20Screens/login.dart';

class ProfileController extends GetxController {
  // Observable variables
  var profileImageUrl = Rxn<String>();
  var firstName = ''.obs;
  var phoneNumber = ''.obs;
  var isVerified = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      UserProfileAndImage? profile = await UserProfile.fetchUserProfileData();

      if (profile != null) {
        print('Debug: Received profile data - verified status: ${profile.profile.verified}');

        // Update basic profile information
        firstName.value = profile.profile.firstName;
        profileImageUrl.value = profile.image?.image;
        phoneNumber.value = profile.profile.username;

        // Update verification status from UserProfileData
        isVerified.value = profile.profile.verified;
        print('Debug: Updated isVerified.value to: ${isVerified.value}');

        // Store in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isVerified', profile.profile.verified);
      } else {
        print('Debug: Profile data is null');
        await checkVerificationStatus(); // Fallback to cached status
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      await checkVerificationStatus(); // Fallback to cached status
    }
  }

  Future<void> checkVerificationStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final status = prefs.getBool('isVerified') ?? false;
      print('Debug: Cached verification status: $status');
      isVerified.value = status;
    } catch (e) {
      print('Error checking verification status: $e');
      isVerified.value = false;
    }
  }

  Future<void> updateVerificationStatus(bool status) async {
    try {
      print('Debug: Updating verification status to: $status');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isVerified', status);
      isVerified.value = status;
    } catch (e) {
      print('Error updating verification status: $e');
      // If SharedPreferences fails, at least update the UI
      isVerified.value = status;
    }
  }

  void updateProfileImage(String newImageUrl) {
    profileImageUrl.value = newImageUrl;
  }

  void showVerificationBenefits(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Container(
            width: 300.w,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: primaryYellow.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Icon
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 70.w,
                      height: 70.w,
                      decoration: BoxDecoration(
                        color: lightYellow,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Icon(
                      Icons.verified_user,
                      color: primaryYellow,
                      size: 40.w,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Title
                Text(
                  'Get Verified!',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 8.h),

                Text(
                  'Verify your profile to unlock benefits',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),

                // Benefits Grid
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCompactBenefit(
                      Icons.verified,
                      'Verified Badge',
                    ),
                    SizedBox(width: 12.w),
                    _buildCompactBenefit(
                      Icons.trending_up,
                      'Higher Visibility',
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCompactBenefit(
                      Icons.handshake,
                      'More Responses',
                    ),
                    SizedBox(width: 12.w),
                    _buildCompactBenefit(
                      Icons.security,
                      'Build Trust',
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Later',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          startVerification(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFCC00),
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Verify Now',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactBenefit(IconData icon, String title) {
    return Container(
      width: 120.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: lightYellow.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: primaryYellow.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: primaryYellow,
            size: 24.w,
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void startVerification(BuildContext context) {
    Get.to(() => DigiLockerVerificationScreen(
      type: 'user',
      phone: phoneNumber.value,
      email: '',
      website: '',
      about: '',
      industry: '',
      state: '',
      city: '',
    ))?.then((value) {
      checkVerificationStatus();
    });
  }

  void showVerificationDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          'Profile Verification',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Lottie.asset(
              'assets/verification_animation.json',
              height: 100.h,
              width: 100.w,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 15.h),
            Text(
              'Verify your profile with Aadhaar to:',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 15.h),
            _buildBenefitRow(Icons.verified_user, 'Get verified badge'),
            _buildBenefitRow(Icons.trending_up, 'Increase visibility'),
            _buildBenefitRow(Icons.handshake, 'Get more responses from buyers'),
            _buildBenefitRow(Icons.business_center, 'Higher chance with investors'),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Later'),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            onPressed: () => _startVerification(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff6B89B7),
            ),
            child: Text(
              'Verify Now',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: const Color(0xff6B89B7)),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _startVerification(BuildContext context) async {
    Get.back(); // Close the current dialog

    // Show loading dialog
    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20.h),
            Text('Processing verification...'),
          ],
        ),
      ),
      barrierDismissible: false,
    );

    try {
      await Future.delayed(Duration(seconds: 2));
      Get.back(); // Close loading dialog

      // Update verification status
      await updateVerificationStatus(true);

      // Show success dialog
      Get.dialog(
        AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 50.sp),
              SizedBox(height: 20.h),
              Text('Verification Successful!'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      );
    } catch (e) {
      Get.back(); // Close loading dialog

      // Show error dialog
      Get.dialog(
        AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error, color: Colors.red, size: 50.sp),
              SizedBox(height: 20.h),
              Text('Verification failed. Please try again.'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      );
    }
  }

  Future<void> showLogoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Lottie.asset(
                  'assets/logout_confirmation.json',
                  height: 40.h,
                  width: 60.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 30.h),
              Text('Confirm Logout',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
              SizedBox(height: 10.h),
              Text('Are you sure you want to log out?'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(context).pop();
                await logout();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> logout() async {
    final FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
    await GoogleSignIn().signOut();
    Get.offAll(() => SignInPage());
  }

}