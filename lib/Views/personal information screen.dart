import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_emergio/Views/profile%20page.dart';
import 'package:project_emergio/generated/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:shimmer/shimmer.dart';
import '../controller/Personal info controller.dart';

class PersonalInformationScreen extends StatelessWidget {
  final PersonalInfoController controller = Get.put(PersonalInfoController());
  final Function(File?) onUpdate;
  final String? initialName;
  final bool isFromDigilocker;

  PersonalInformationScreen({
    required this.onUpdate,
    this.initialName,
    this.isFromDigilocker = false,
  }) {
    if (initialName != null) {
      controller.nameController.value.text = initialName!;
    }
  }

  Future<void> _handleProfileUpdate(BuildContext context) async {
    if (controller.formKey.currentState!.validate()) {
      final initialSnackBars = Get.isSnackbarOpen;
      await controller.updateUserProfile();
      final wasSuccessful = !initialSnackBars && Get.isSnackbarOpen;

      if (wasSuccessful && isFromDigilocker) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isVerified', true);
        await Future.delayed(const Duration(milliseconds: 500));

        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen()),
                (route) => false,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isFromDigilocker) {
          return await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              title: Text(
                'Update Required',
                style: AppTheme.mediumHeadingText(lightTextColor),
              ),
              content: Text(
                'Your name must match your Aadhaar card details for verification. Do you want to discard changes?',
                style: AppTheme.mediumTitleText(greyTextColor!),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    'Stay',
                    style: AppTheme.mediumTitleText(buttonColor),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Discard',
                    style: AppTheme.mediumTitleText(whiteTextColor),
                  ),
                ),
              ],
            ),
          ) ?? false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: transparentColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: lightTextColor),
            onPressed: () {
              if (isFromDigilocker) {
                Navigator.maybePop(context);
              } else {
                Get.back();
              }
            },
          ),
          title: Text(
            'Personal Information',
            style: AppTheme.mediumHeadingText(lightTextColor),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return _buildShimmerPlaceholder();
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20.h),
                _buildProfileImage(),
                SizedBox(height: 32.h),
                _buildForm(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: buttonColor,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 60.r,
              backgroundColor: borderColor,
              backgroundImage: controller.imageFile.value != null
                  ? FileImage(controller.imageFile.value!)
                  : controller.networkImageUrl.value != null &&
                  controller.networkImageUrl.value!.isNotEmpty
                  ? NetworkImage(controller.networkImageUrl.value!)
                  : const AssetImage('assets/profile_picture.jpg')
              as ImageProvider,
            ),
          ),
          if (!isFromDigilocker)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: buttonColor,
                  border: Border.all(
                    color: backgroundColor,
                    width: 2,
                  ),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.camera_alt,
                    size: 20.sp,
                    color: lightTextColor,
                  ),
                  onPressed: () async {
                    await controller.pickImage();
                    onUpdate(controller.imageFile.value);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Builder(
      builder: (context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isFromDigilocker) ...[
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: buttonColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(
                      color: buttonColor,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: buttonColor),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          'Please update your name to match your Aadhaar card details for verification',
                          style: AppTheme.mediumSmallText(buttonColor),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
              ],
              _buildInputField(
                'Name',
                controller.nameController.value,
                controller.validateName,
                enabled: true,
              ),
              SizedBox(height: 16.h),
              _buildInputField(
                'Email',
                controller.emailController.value,
                controller.validateEmail,
                enabled: !isFromDigilocker,
              ),
              SizedBox(height: 16.h),
              _buildInputField(
                'Phone Number',
                controller.phoneController.value,
                controller.validatePhoneNumber,
                enabled: !isFromDigilocker,
              ),
              SizedBox(height: 16.h),
              _buildInputField(
                'WhatsApp Number',
                controller.whatsappController.value,
                controller.validatePhoneNumber,
                enabled: !isFromDigilocker,
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                  ),
                  onPressed: () => _handleProfileUpdate(context),
                  child: Text(
                    'Update Profile',
                    style: AppTheme.mediumTitleText(lightTextColor),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildInputField(
      String label,
      TextEditingController controller,
      String? Function(String?) validator, {
        bool enabled = true,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.mediumTitleText(greyTextColor!),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          validator: validator,
          enabled: enabled,
          style: AppTheme.mediumTitleText(lightTextColor),
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled ? backgroundColor : Colors.grey[100],
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: buttonColor),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor!),
            ),
            errorStyle: AppTheme.smallText(errorIconColor),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerPlaceholder() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const SizedBox(height: 50.0),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[300],
          ),
        ),
        const SizedBox(height: 16.0),
        _buildShimmerTextField(),
        const SizedBox(height: 16.0),
        _buildShimmerTextField(),
        const SizedBox(height: 16.0),
        _buildShimmerTextField(),
        const SizedBox(height: 16.0),
        _buildShimmerTextField(),
        const SizedBox(height: 16.0),
        _buildShimmerTextField(),
        const SizedBox(height: 16.0),
        _buildShimmerButton(),
      ],
    );
  }

  Widget _buildShimmerTextField() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildShimmerButton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 50,
        width: 150,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          'Update',
          style: AppTheme.titleText(lightTextColor),
        ),
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    if (value.length > 50) {
      return 'Email cannot be longer than 50 characters';
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
      return 'Enter a valid email address with a proper domain';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number cannot be empty';
    }
    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
      return 'Enter a valid phone number (10-15 digits)';
    }
    return null;
    }
}
