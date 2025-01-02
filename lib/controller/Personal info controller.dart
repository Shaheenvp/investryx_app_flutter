import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import '../services/user profile and personal info.dart';


class PersonalInfoController extends GetxController {
  var isLoading = true.obs;
  var imageFile = Rxn<File>();
  var networkImageUrl = Rxn<String>();
  var nameController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var phoneController = TextEditingController().obs;
  var whatsappController = TextEditingController().obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    isLoading(true);
    UserProfileAndImage? profile = await UserProfile.fetchUserProfileData();
    if (profile != null) {
      nameController.value.text = profile.profile.firstName;
      emailController.value.text = profile.profile.email;
      phoneController.value.text = profile.profile.username;
      whatsappController.value.text = profile.profile.username;
      if (profile.image != null && profile.image!.image.isNotEmpty) {
        networkImageUrl.value = profile.image!.image;
      }
    }
    isLoading(false);
  }

  // Method to pick an image
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final fileExtension = path.extension(pickedFile.path).toLowerCase();
      if (fileExtension == '.jpeg' || fileExtension == '.jpg' || fileExtension == '.png') {
        imageFile.value = File(pickedFile.path);
      } else {
        Get.snackbar(
          'Invalid File',
          'Please select a valid image file (JPEG/PNG).',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 8,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        );
      }
    }
  }

  Future<void> updateUserProfile() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading(true);

    final token = await UserProfile.storage.read(key: 'token');

    if (token != null) {
      final (success, message) = await UserProfile.updateUserProfileData(
        token,
        nameController.value.text,
        emailController.value.text,
        phoneController.value.text,
        imageFile.value,
      );

      Get.snackbar(
        success ? 'Success' : 'Error',
        message,
        backgroundColor: success ? Colors.black54 : Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      );
    } else {
      Get.snackbar(
        'Error',
        'Token not found',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      );
    }

    isLoading(false);
  }

  // Validator functions
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  String? validateEmail(String? value) {
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

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number cannot be empty';
    }
    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
      return 'Enter a valid phone number (10-15 digits)';
    }
    return null;
  }
}
