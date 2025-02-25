import 'dart:io';

import 'package:get/get.dart';

import '../models/all profile model.dart';
import '../services/profile forms/advisor/advisor get.dart';

class AdvisorController extends GetxController {
  var advisor = Rxn<AdvisorExplr>(); // Rxn allows null values

  @override
  void onInit() {
    super.onInit();
    fetchAdvisor();
  }

  void fetchAdvisor() async {
    try {
      var fetchedAdvisor = await AdvisorFetchPage.fetchAdvisorData();
      if (fetchedAdvisor != null && fetchedAdvisor.isNotEmpty) {
        advisor.value = fetchedAdvisor[0];
      } else {
        advisor.value = null;
      }
    } catch (e) {
      print('Error fetching advisor: $e');
    }
  }

  // Future<void> updateAdvisor({
  //   required String advisorId,
  //   required String advisorName,
  //   required String designation,
  //   required String businessWebsite,
  //   required String state,
  //   required String city,
  //   required String contactNumber,
  //   required String describeExpertise,
  //   required String areaOfInterest,
  //   required List<File> brandLogo,
  //   required List<File> businessPhotos,
  //   required File businessProof,
  //   required List<File> businessDocuments,
  // }) async {
  //   try {
  //     bool success = await AdvisorFetchPage.updateAdvisorProfile(
  //       advisorId: int.parse(advisorId),
  //       advisorName: advisorName,
  //       designation: designation,
  //       businessWebsite: businessWebsite,
  //       state: state,
  //       city: city,
  //       contactNumber: contactNumber,
  //       describeExpertise: describeExpertise,
  //       areaOfInterest: areaOfInterest,
  //       brandLogo: brandLogo,
  //       businessPhotos: businessPhotos,
  //       businessProof: businessProof,
  //       businessDocuments: businessDocuments,
  //     );
  //
  //     if (success) {
  //       fetchAdvisor(); // Update local advisor data
  //       Get.snackbar('Success', 'Advisor updated successfully');
  //     } else {
  //       Get.snackbar('Error', 'Failed to update advisor');
  //     }
  //   } catch (e) {
  //     Get.snackbar('Error', 'Error: ${e.toString()}');
  //     print('Error: $e');
  //   }
  // }
}
