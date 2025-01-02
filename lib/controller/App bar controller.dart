import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AppbarController extends GetxController {
  void switchToBusinessProfile() {
    // Your logic for switching to the business profile
    Get.snackbar(
      'Profile Switch',
      'Switched to Business Profile',
      backgroundColor: Colors.black54, //
      duration: Duration(seconds: 2), // Customize background color
      colorText: Colors.white, // Customize text color
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 8,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );
  }

  void switchToFranchiseProfile() {
    Get.snackbar(
      'Profile Switch',
      'Switched to Franchise Profile',
      backgroundColor: Colors.black54, //
      duration: Duration(seconds: 2), // Customize background color
      colorText: Colors.white, // Customize text color
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 8,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );
  }

  void switchToInvestorProfile() {
    Get.snackbar(
      'Profile Switch',
      'Switched to Investor Profile',
      backgroundColor: Colors.black54, //
      duration: Duration(seconds: 2), // Customize background color
      colorText: Colors.white, // Customize text color
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 8,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );
  }

  void switchToAdvisorProfile() {
    Get.snackbar(
      'Profile Switch',
      'Switched to Advisor Profile',
      backgroundColor: Colors.black54, //
      duration: Duration(seconds: 2), // Customize background color
      colorText: Colors.white, // Customize text color
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 8,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );
  }
}
