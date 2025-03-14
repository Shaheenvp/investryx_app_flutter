// import 'dart:developer';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import Flutter Secure Storage
// import 'package:path/path.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import '../../api_list.dart';
//
// class FranchiseAddPage {
//   static var client = http.Client();
//   static final storage = FlutterSecureStorage(); // Initialize Flutter Secure Storage
//
//   static Future<bool?> franchiseAddPage({
//     required String brandName,
//     required String industry,
//     required String businessWebsite,
//     required String initialInvestment,
//     required String projectedRoi,
//     required String iamOffering,
//     required String currentNumberOfOutlets,
//     required String franchiseTerms,
//     required String aboutYourBrand,
//     required String locationsAvailable,
//     required String kindOfSupport,
//     required String allProducts,
//     required String brandStartOperation,
//     required String spaceRequiredMin,
//     required String spaceRequiredMax,
//     required String totalInvestmentFrom,
//     required String totalInvestmentTo,
//     required String brandFee,
//     required String avgNoOfStaff,
//     required String avgMonthlySales,
//     required String avgEBITDA,
//     File? brandLogo,
//     File? businessPhoto,
//     File? image2,
//     File? image3,
//     File? image4,
//     required List<File> businessDocuments,
//     File? businessProof,
//   }) async {
//     try {
//       final token = await storage.read(key: 'token');
//       if (token == null) {
//         log('Error: token not found in Flutter Secure Storage');
//         return false;
//       }
//
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse(ApiList.franchiseAddPage!),
//       )..headers['token'] = token;
//
//       // Add fields
//       request.fields.addAll({
//         'name': brandName,
//         'industry': industry,
//         'url': businessWebsite,
//         'initial': initialInvestment,
//         'proj_ROI': projectedRoi,
//         'offering': iamOffering,
//         'total_outlets': currentNumberOfOutlets,
//         'yr_period': franchiseTerms,
//         'description': aboutYourBrand,
//         'locations_available': locationsAvailable,
//         'supports': kindOfSupport,
//         'services': allProducts,
//         'establish_yr': brandStartOperation,
//         'min_space': spaceRequiredMin,
//         'max_space': spaceRequiredMax,
//         'range_starting': totalInvestmentFrom,
//         'range_ending': totalInvestmentTo,
//         'brand_fee': brandFee,
//         'staff': avgNoOfStaff,
//         'avg_monthly_sales': avgMonthlySales,
//         'ebitda': avgEBITDA,
//       });
//
//       // Add files if they exist
//       if (brandLogo != null) {
//         request.files.add(await http.MultipartFile.fromPath(
//           'logo',
//           brandLogo.path,
//           filename: basename(brandLogo.path),
//         ));
//       }
//
//       if (businessPhoto != null) {
//         request.files.add(await http.MultipartFile.fromPath(
//           'image1',
//           businessPhoto.path,
//           filename: basename(businessPhoto.path),
//         ));
//       }
//
//       for (var doc in businessDocuments) {
//         request.files.add(await http.MultipartFile.fromPath(
//           'doc',
//           doc.path,
//           filename: basename(doc.path),
//         ));
//       }
//
//       if (businessProof != null) {
//         request.files.add(await http.MultipartFile.fromPath(
//           'proof1',
//           businessProof.path,
//           filename: basename(businessProof.path),
//         ));
//       }
//
//       var response = await request.send();
//       if (response.statusCode == 201) {
//         log('Franchise information uploaded successfully!');
//         return true;
//       } else {
//         log('Failed to upload franchise information: ${response.statusCode}');
//         return false;
//       }
//     } catch (e) {
//       log('Unexpected error: $e');
//       return null;
//     }
//   }
//
//
//   static Future<bool?> updateFranchise({
//     String? franchiseId,
//     String? brandName,
//     String? industry,
//     String? businessWebsite,
//     String? initialInvestment,
//     String? projectedRoi,
//     String? iamOffering,
//     String? currentNumberOfOutlets,
//     String? franchiseTerms,
//     String? aboutYourBrand,
//     String? locationsAvailable,
//     String? kindOfSupport,
//     String? allProducts,
//     String? brandStartOperation,
//     String? spaceMin,
//     String? spaceMax,
//     String? totalInvestmentFrom,
//     String? totalInvestmentTo,
//     String? brandFee,
//     String? avgNoOfStaff,
//     String? avgMonthlySales,
//     String? avgEBITDA,
//     File? brandLogo,
//     File? image1,
//     File? image2,
//     File? image3,
//     File? image4,
//     File? doc1,
//     File? proof1,
//     String? spaceRequiredMax,
//     String? spaceRequiredMin
//   }) async {
//     try {
//       final token = await storage.read(key: 'token');
//       if (token == null) {
//         log('Error: token not found in Flutter Secure Storage');
//         return false;
//       }
//
//       // Create multipart request
//       var request = http.MultipartRequest(
//           'PATCH', Uri.parse('${ApiList.franchiseAddPage!}$franchiseId'))
//         ..headers['token'] = token; // Add token to request headers
//
//       // Add form fields
//       request.fields['name'] = brandName ?? "";
//       request.fields['industry'] = industry ?? "";
//       request.fields['url'] = businessWebsite ?? "";
//       request.fields['initial'] = initialInvestment ?? "";
//       request.fields['proj_ROI'] = projectedRoi ?? "";
//       request.fields['offering'] = iamOffering ?? "";
//       request.fields['total_outlets'] = currentNumberOfOutlets ?? "";
//       request.fields['yr_period'] = franchiseTerms ?? "";
//       request.fields['description'] = aboutYourBrand ?? "";
//       request.fields['locations_available'] = locationsAvailable ?? "";
//       request.fields['supports'] = kindOfSupport ?? "";
//       request.fields['services'] = allProducts ?? "";
//       request.fields['establish_yr'] = brandStartOperation ?? "";
//       request.fields['min_space'] = spaceRequiredMin ?? "";
//       request.fields['max_space'] = spaceRequiredMax ?? "";
//       request.fields['range_starting'] = totalInvestmentFrom ?? "";
//       request.fields['range_ending'] = totalInvestmentTo ?? "";
//       request.fields['brand_fee'] = brandFee ?? "";
//       request.fields['staff'] = avgNoOfStaff ?? "";
//       request.fields['avg_monthly_sales'] = avgMonthlySales ?? "";
//       request.fields['ebitda'] = avgEBITDA ?? "";
//
//       // Add files to the request
//       if (brandLogo != null) {
//         request.files.add(await http.MultipartFile.fromPath(
//             'logo', brandLogo.path,
//             filename: basename(brandLogo.path)));
//       }
//
//       // Add image1 (required)
//       if (image1 != null && image1.existsSync()) {
//         request.files.add(await http.MultipartFile.fromPath(
//           'image1',
//           image1.path,
//           filename: basename(image1.path),
//         ));
//       }
//       if (image2 != null && image2.existsSync()) {
//         request.files.add(await http.MultipartFile.fromPath(
//           'image2',
//           image2.path,
//           filename: basename(image2.path),
//         ));
//       }
//       if (image3 != null && image3.existsSync()) {
//         request.files.add(await http.MultipartFile.fromPath(
//           'image3',
//           image3.path,
//           filename: basename(image3.path),
//         ));
//       }
//       if (image4 != null && image4.existsSync()) {
//         request.files.add(await http.MultipartFile.fromPath(
//           'image4',
//           image4.path,
//           filename: basename(image4.path),
//         ));
//       }
//
//       // Add document and proof files
//       if (doc1 != null && doc1.existsSync()) {
//         request.files.add(await http.MultipartFile.fromPath(
//           'doc1',
//           doc1.path,
//           filename: basename(doc1.path),
//         ));
//       }
//       if (proof1 != null && proof1.existsSync()) {
//         request.files.add(await http.MultipartFile.fromPath(
//           'proof1',
//           proof1.path,
//           filename: basename(proof1.path),
//         ));
//       }
//
//       // Send the request
//       var response = await request.send();
//
//       // Handle the response
//       if (response.statusCode == 201) {
//         log('Franchise information updated successfully!');
//         var responseString = await response.stream.bytesToString();
//         log('Response: $responseString');
//         return true;
//       } else {
//         log('Failed to update franchise information: ${response.statusCode}');
//         return false;
//       }
//     } on SocketException catch (e) {
//       log('SocketException: ${e.message}');
//       return null;
//     } on http.ClientException catch (e) {
//       log('ClientException: ${e.message}');
//       return null;
//     } catch (e) {
//       log('Unexpected error: $e');
//       return null;
//     }
//     }
// }



import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../api_list.dart';

class FranchiseAddPage {
  static var client = http.Client();
  static final storage = FlutterSecureStorage();

  static Future<bool?> franchiseAddPage({
    required String brandName,
    required String industry,
    required String businessWebsite,
    required String initialInvestment,
    required String projectedRoi,
    required String iamOffering,
    required String currentNumberOfOutlets,
    required String franchiseTerms,
    required String aboutYourBrand,
    required String locationsAvailable,
    required String kindOfSupport,
    required String allProducts,
    required String brandStartOperation,
    required String spaceRequiredMin,
    required String spaceRequiredMax,
    required String totalInvestmentFrom,
    required String totalInvestmentTo,
    required String brandFee,
    required String avgNoOfStaff,
    required String avgMonthlySales,
    required String avgEBITDA,
    File? brandLogo,
    File? businessPhoto,
    File? image2,
    File? image3,
    File? image4,
    required List<File> businessDocuments,
    File? businessProof,
  }) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: token not found in Flutter Secure Storage');
        return false;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiList.franchiseAddPage!),
      )..headers['token'] = token;

      // Add fields
      request.fields.addAll({
        'name': brandName,
        'industry': industry,
        'url': businessWebsite,
        'initial': initialInvestment,
        'proj_ROI': projectedRoi,
        'offering': iamOffering,
        'total_outlets': currentNumberOfOutlets,
        'yr_period': franchiseTerms,
        'description': aboutYourBrand,
        'location_interested': locationsAvailable,
        'supports': kindOfSupport,
        'services': allProducts,
        'establish_yr': brandStartOperation,
        'min_space': spaceRequiredMin,
        'max_space': spaceRequiredMax,
        'range_starting': totalInvestmentFrom,
        'range_ending': totalInvestmentTo,
        'brand_fee': brandFee,
        'staff': avgNoOfStaff,
        'avg_monthly_sales': avgMonthlySales,
        'ebitda': avgEBITDA,
      });

      // Add files if they exist
      if (brandLogo != null && await brandLogo.exists()) {
        log('Adding brand logo: ${brandLogo.path}');
        request.files.add(await http.MultipartFile.fromPath(
          'logo',
          brandLogo.path,
          filename: basename(brandLogo.path),
        ));
      } else {
        log('Brand logo is null or does not exist');
      }

      // Add business photo (image1)
      if (businessPhoto != null && await businessPhoto.exists()) {
        log('Adding business photo: ${businessPhoto.path}');
        request.files.add(await http.MultipartFile.fromPath(
          'image1',
          businessPhoto.path,
          filename: basename(businessPhoto.path),
        ));
      } else {
        log('Business photo is null or does not exist');
      }

      // Add additional business photos (image2, image3, image4)
      if (image2 != null && await image2.exists()) {
        log('Adding image2: ${image2.path}');
        request.files.add(await http.MultipartFile.fromPath(
          'image2',
          image2.path,
          filename: basename(image2.path),
        ));
      }

      if (image3 != null && await image3.exists()) {
        log('Adding image3: ${image3.path}');
        request.files.add(await http.MultipartFile.fromPath(
          'image3',
          image3.path,
          filename: basename(image3.path),
        ));
      }

      if (image4 != null && await image4.exists()) {
        log('Adding image4: ${image4.path}');
        request.files.add(await http.MultipartFile.fromPath(
          'image4',
          image4.path,
          filename: basename(image4.path),
        ));
      }

      // Add business documents
      for (var i = 0; i < businessDocuments.length; i++) {
        var doc = businessDocuments[i];
        if (await doc.exists()) {
          log('Adding doc${i+1}: ${doc.path}');
          request.files.add(await http.MultipartFile.fromPath(
            'doc${i+1}',
            doc.path,
            filename: basename(doc.path),
          ));
        }
      }

      // Add business proof
      if (businessProof != null && await businessProof.exists()) {
        log('Adding business proof: ${businessProof.path}');
        request.files.add(await http.MultipartFile.fromPath(
          'proof1',
          businessProof.path,
          filename: basename(businessProof.path),
        ));
      } else {
        log('Business proof is null or does not exist');
      }

      log('Sending request to: ${ApiList.franchiseAddPage}');
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      log('Response status code: ${response.statusCode}');
      log('Response body: $responseBody');

      if (response.statusCode == 201) {
        log('Franchise information uploaded successfully!');
        return true;
      } else {
        log('Failed to upload franchise information: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log('Unexpected error: $e');
      return null;
    }
  }

  static Future<bool?> updateFranchise({
    String? franchiseId,
    String? brandName,
    String? industry,
    String? businessWebsite,
    String? initialInvestment,
    String? projectedRoi,
    String? iamOffering,
    String? currentNumberOfOutlets,
    String? franchiseTerms,
    String? aboutYourBrand,
    String? locationsAvailable,
    String? kindOfSupport,
    String? allProducts,
    String? brandStartOperation,
    String? spaceMin,
    String? spaceMax,
    String? totalInvestmentFrom,
    String? totalInvestmentTo,
    String? brandFee,
    String? avgNoOfStaff,
    String? avgMonthlySales,
    String? avgEBITDA,
    File? brandLogo,
    File? image1,
    File? image2,
    File? image3,
    File? image4,
    File? doc1,
    File? proof1,
    String? spaceRequiredMax,
    String? spaceRequiredMin
  }) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: token not found in Flutter Secure Storage');
        return false;
      }

      // Create multipart request
      var request = http.MultipartRequest(
          'PATCH', Uri.parse('${ApiList.businessAddPage!}$franchiseId'))
        ..headers['token'] = token;

      // Add form fields
      request.fields['name'] = brandName ?? "";
      request.fields['industry'] = industry ?? "";
      request.fields['url'] = businessWebsite ?? "";
      request.fields['initial'] = initialInvestment ?? "";
      request.fields['proj_ROI'] = projectedRoi ?? "";
      request.fields['offering'] = iamOffering ?? "";
      request.fields['total_outlets'] = currentNumberOfOutlets ?? "";
      request.fields['yr_period'] = franchiseTerms ?? "";
      request.fields['description'] = aboutYourBrand ?? "";
      request.fields['locations_available'] = locationsAvailable ?? "";
      request.fields['supports'] = kindOfSupport ?? "";
      request.fields['services'] = allProducts ?? "";
      request.fields['establish_yr'] = brandStartOperation ?? "";
      request.fields['min_space'] = spaceRequiredMin ?? "";
      request.fields['max_space'] = spaceRequiredMax ?? "";
      request.fields['range_starting'] = totalInvestmentFrom ?? "";
      request.fields['range_ending'] = totalInvestmentTo ?? "";
      request.fields['brand_fee'] = brandFee ?? "";
      request.fields['staff'] = avgNoOfStaff ?? "";
      request.fields['avg_monthly_sales'] = avgMonthlySales ?? "";
      request.fields['ebitda'] = avgEBITDA ?? "";

      // Add files to the request
      if (brandLogo != null && await brandLogo.exists()) {
        log('Adding brand logo: ${brandLogo.path}');
        request.files.add(await http.MultipartFile.fromPath(
            'logo',
            brandLogo.path,
            filename: basename(brandLogo.path)
        ));
      }

      if (image1 != null && await image1.exists()) {
        log('Adding image1: ${image1.path}');
        request.files.add(await http.MultipartFile.fromPath(
          'image1',
          image1.path,
          filename: basename(image1.path),
        ));
      }

      if (image2 != null && await image2.exists()) {
        log('Adding image2: ${image2.path}');
        request.files.add(await http.MultipartFile.fromPath(
          'image2',
          image2.path,
          filename: basename(image2.path),
        ));
      }

      if (image3 != null && await image3.exists()) {
        log('Adding image3: ${image3.path}');
        request.files.add(await http.MultipartFile.fromPath(
          'image3',
          image3.path,
          filename: basename(image3.path),
        ));
      }

      if (image4 != null && await image4.exists()) {
        log('Adding image4: ${image4.path}');
        request.files.add(await http.MultipartFile.fromPath(
          'image4',
          image4.path,
          filename: basename(image4.path),
        ));
      }

      if (doc1 != null && await doc1.exists()) {
        log('Adding doc1: ${doc1.path}');
        request.files.add(await http.MultipartFile.fromPath(
          'doc1',
          doc1.path,
          filename: basename(doc1.path),
        ));
      }

      if (proof1 != null && await proof1.exists()) {
        log('Adding proof1: ${proof1.path}');
        request.files.add(await http.MultipartFile.fromPath(
          'proof1',
          proof1.path,
          filename: basename(proof1.path),
        ));
      }

      // Send the request
      log('Sending update request to: ${ApiList.franchiseAddPage}$franchiseId');
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      log('Response status code: ${response.statusCode}');
      log('Response body: $responseBody');

      // Handle the response
      if (response.statusCode == 201) {
        log('Franchise information updated successfully!');
        return true;
      } else {
        log('Failed to update franchise information: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log('Unexpected error: $e');
      return null;
    }
  }
}