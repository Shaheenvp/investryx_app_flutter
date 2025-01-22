// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../api_list.dart';
//
// class FranchiseFetchPage {
//   static var client = http.Client();
//
//   static Future<List<Franchise>?> fetchFranchiseData() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final userId = prefs.getInt('userId');
//       if (userId == null) {
//         log('Error: userId not found in SharedPreferences');
//         return null;
//       }
//
//       var response = await client.get(Uri.parse('${ApiList.franchiseAddPage}$userId'));
//
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body) as List;
//         List<Franchise> franchises = data.map((json) => Franchise.fromJson(json)).toList();
//         return franchises;
//       } else {
//         log('Failed to fetch franchise data: ${response.statusCode}');
//         return null;
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
//   }
//
//   static Future<void> deleteFranchise(String id) async {
//     try {
//       var response = await client.delete(Uri.parse('${ApiList.franchiseAddPage}/$id'));
//
//       if (response.statusCode != 200) {
//         throw Exception('Failed to delete franchise');
//       }
//     } on SocketException catch (e) {
//       log('SocketException: ${e.message}');
//       throw e;
//     } on http.ClientException catch (e) {
//       log('ClientException: ${e.message}');
//       throw e;
//     } catch (e) {
//       log('Unexpected error: $e');
//       throw e;
//     }
//   }
// }
//
//
// class Franchise {
//   final String imageUrl;
//   final String id;
//   final String brandName;
//   final String city;
//   final String postedTime;
//   final String? state;
//   final String? industry;
//   final String? description;
//   final String? url;
//   final String? initialInvestment;
//   final String? projectedRoi;
//   final String? iamOffering;
//   final String? currentNumberOfOutlets;
//   final String? franchiseTerms;
//   final String? locationsAvailable;
//   final String? kindOfSupport;
//   final String? allProducts;
//   final String? brandStartOperation;
//   final String? spaceRequiredMin;
//   final String? spaceRequiredMax;
//   final String? totalInvestmentFrom;
//   final String? totalInvestmentTo;
//   final String? brandFee;
//   final String? avgNoOfStaff;
//   final String? avgMonthlySales;
//   final String? avgEBITDA;
//   final String? companyName; // Added companyName field
//
//   Franchise({
//     required this.imageUrl,
//     required this.brandName,
//     required this.city,
//     required this.postedTime,
//     required this.id,
//     this.state,
//     this.industry,
//     this.description,
//     this.url,
//     this.initialInvestment,
//     this.projectedRoi,
//     this.iamOffering,
//     this.currentNumberOfOutlets,
//     this.franchiseTerms,
//     this.locationsAvailable,
//     this.kindOfSupport,
//     this.allProducts,
//     this.brandStartOperation,
//     this.spaceRequiredMin,
//     this.spaceRequiredMax,
//     this.totalInvestmentFrom,
//     this.totalInvestmentTo,
//     this.brandFee,
//     this.avgNoOfStaff,
//     this.avgMonthlySales,
//     this.avgEBITDA,
//     this.companyName,
//   });
//
//
//   factory Franchise.fromJson(Map<String, dynamic> json) {
//     return Franchise(
//       imageUrl: validateUrl(json['logo']) ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
//       brandName: json['name'] ?? 'N/A',
//       city: json['city'] ?? 'N/A',
//       postedTime: json['listed_on'] ?? 'N/A',
//       state: json['state'],
//       industry: json['industry'],
//       description: json['description'],
//       url: json['url'],
//       initialInvestment: json['initial']?.toString(),
//       projectedRoi: json['proj_ROI']?.toString(),
//       iamOffering: json['offering']?.toString(),
//       currentNumberOfOutlets: json['total_outlets']?.toString(),
//       franchiseTerms: json['yr_period']?.toString(),
//       locationsAvailable: json['locations_available'],
//       kindOfSupport: json['supports'],
//       allProducts: json['services'],
//       brandStartOperation: json['establish_yr']?.toString(),
//       spaceRequiredMin: json['min_space']?.toString(),
//       spaceRequiredMax: json['max_space']?.toString(),
//       totalInvestmentFrom: json['min_range']?.toString(),
//       totalInvestmentTo: json['max_range']?.toString(),
//       brandFee: json['brand_fee']?.toString(),
//       avgNoOfStaff: json['staff']?.toString(),
//       avgMonthlySales: json['avg_monthly_sales']?.toString(),
//       avgEBITDA: json['ebitda']?.toString(),
//       companyName: json['company'],
//       id: json['id']!.toString(),
//     );
//   }
//
//   static String? validateUrl(String? url) {
//     const String baseUrl = 'https://suhail101.pythonanywhere.com/';
//
//     if (url == null || url.isEmpty) {
//       return null;
//     }
//
//     Uri? uri;
//     try {
//       uri = Uri.parse(url);
//       if (!uri.hasScheme) {
//         // If the URL doesn't have a scheme, assume it's a relative path and append the base URL.
//         url = url.startsWith('/') ? url.substring(1) : url;
//         url = baseUrl + url;
//         uri = Uri.parse(url);
//       }
//       if (uri.hasScheme && (uri.hasAuthority || uri.host.isNotEmpty)) {
//         return url;
//       }
//     } catch (e) {
//       return null;
//     }
//     return null;
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import Flutter Secure Storage
import 'package:project_emergio/models/all%20profile%20model.dart';
import '../../api_list.dart';

class FranchiseFetchPage {
  static var client = http.Client();
  static final storage = FlutterSecureStorage(); // Initialize Flutter Secure Storage

  static Future<List<FranchiseExplr>?> fetchFranchiseData() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: token not found in Flutter Secure Storage');
        return null;
      }

      var response = await client.get(
        Uri.parse('${ApiList.franchiseAddPage!}${1}'),
        headers: {'token': token}, // Add token to request headers
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;
        List<FranchiseExplr> franchises =
        data.map((json) => FranchiseExplr.fromJson(json)).toList();
        return franchises;
      } else {
        log('Failed to fetch franchise data: ${response.statusCode}');
        return null;
      }
    } on SocketException catch (e) {
      log('SocketException: ${e.message}');
      return null;
    } on http.ClientException catch (e) {
      log('ClientException: ${e.message}');
      return null;
    } catch (e) {
      log('Unexpected error: $e');
      return null;
    }
  }

  static Future<void> deleteFranchise(String id) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: token not found in Flutter Secure Storage');
        throw Exception('Token not found');
      }

      var response = await client.delete(
        Uri.parse('${ApiList.franchiseAddPage!}$id'),
        headers: {'token': token}, // Add token to request headers
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete franchise');
      }
    } on SocketException catch (e) {
      log('SocketException: ${e.message}');
      throw e;
    } on http.ClientException catch (e) {
      log('ClientException: ${e.message}');
      throw e;
    } catch (e) {
      log('Unexpected error: $e');
      throw e;
    }
  }

  static Future<void> deleteFranchiseProfile() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: token not found in Flutter Secure Storage');
        throw Exception('Token not found');
      }

      var response = await client.delete(
        Uri.parse('${ApiList.franchiseAddPage!}${0}'),
        headers: {'token':  token}, // Add token to request headers
      );

      print('Response: ${response.statusCode} - ${response.body}');
      if (response.statusCode != 200) {
        throw Exception('Failed to delete franchise profile');
      }
    } on SocketException catch (e) {
      log('SocketException: ${e.message}');
      throw e;
    } on http.ClientException catch (e) {
      log('ClientException: ${e.message}');
      throw e;
    } catch (e) {
      log('Unexpected error: $e');
      throw e;
    }
  }
}

class Franchise {
  final String imageUrl;
  final String image2;
  final String image3;
  final String image4;
  final String id;
  final String brandName;
  final String city;
  final String postedTime;
  final String? state;
  final String? industry;
  final String? description;
  final String? url;
  final String? initialInvestment;
  final String? projectedRoi;
  final String? iamOffering;
  final String? currentNumberOfOutlets;
  final String? franchiseTerms;
  final String? locationsAvailable;
  final String? kindOfSupport;
  final String? allProducts;
  final String? brandStartOperation;
  final String? spaceRequiredMin;
  final String? spaceRequiredMax;
  final String? totalInvestmentFrom;
  final String? totalInvestmentTo;
  final String? brandFee;
  final String? avgNoOfStaff;
  final String? avgMonthlySales;
  final String? avgEBITDA;
  final String? companyName;
  final String? businessPhotos; // Now a single URL of business photos
  final String? businessProof; // URL of business proof
  final String? businessDocuments; // Now a single URL of business documents

  Franchise({
    required this.imageUrl,
    required this.image2,
    required this.image3,
    required this.image4,
    required this.brandName,
    required this.city,
    required this.postedTime,
    required this.id,
    this.state,
    this.industry,
    this.description,
    this.url,
    this.initialInvestment,
    this.projectedRoi,
    this.iamOffering,
    this.currentNumberOfOutlets,
    this.franchiseTerms,
    this.locationsAvailable,
    this.kindOfSupport,
    this.allProducts,
    this.brandStartOperation,
    this.spaceRequiredMin,
    this.spaceRequiredMax,
    this.totalInvestmentFrom,
    this.totalInvestmentTo,
    this.brandFee,
    this.avgNoOfStaff,
    this.avgMonthlySales,
    this.avgEBITDA,
    this.companyName,
    this.businessPhotos,
    this.businessProof,
    this.businessDocuments,
  });

  factory Franchise.fromJson(Map<String, dynamic> json) {
    return Franchise(
      imageUrl:
      validateUrl(json['image1']) ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
      image2: validateUrl(json['image2']) ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
      image3: validateUrl(json['image3']) ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
      image4: validateUrl(json['image4']) ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
      brandName: json['name'] ?? 'N/A',
      city: json['city'] ?? 'N/A',
      postedTime: json['listed_on'] ?? 'N/A',
      state: json['state'],
      industry: json['industry'],
      description: json['description'],
      url: json['url'],
      initialInvestment: json['initial']?.toString(),
      projectedRoi: json['proj_ROI']?.toString(),
      iamOffering: json['offering']?.toString(),
      currentNumberOfOutlets: json['total_outlets']?.toString(),
      franchiseTerms: json['yr_period']?.toString(),
      locationsAvailable: json['locations_available'],
      kindOfSupport: json['supports'],
      allProducts: json['services'],
      brandStartOperation: json['establish_yr']?.toString(),
      spaceRequiredMin: json['min_space']?.toString(),
      spaceRequiredMax: json['max_space']?.toString(),
      totalInvestmentFrom: json['range_starting']?.toString(),
      totalInvestmentTo: json['range_ending']?.toString(),
      brandFee: json['brand_fee']?.toString(),
      avgNoOfStaff: json['staff']?.toString(),
      avgMonthlySales: json['avg_monthly_sales']?.toString(),
      avgEBITDA: json['ebitda']?.toString(),
      companyName: json['company'],
      id: json['id']!.toString(),
      // Validating single URL for business photos
      businessPhotos: validateUrl(json['logo']) ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',

      // Validating single URL for business proof
      businessProof: validateUrl(json['proof1']) ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',

      // Validating single URL for business documents
      businessDocuments: validateUrl(json['doc1']) ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
    );
  }

  static String? validateUrl(String? url) {
    const String baseUrl = ApiList.imageBaseUrl;

    if (url == null || url.isEmpty) {
      return null;
    }

    Uri? uri;
    try {
      uri = Uri.parse(url);
      if (!uri.hasScheme) {
        url = url.startsWith('/') ? url.substring(1) : url;
        url = baseUrl + url;
        uri = Uri.parse(url);
      }
      if (uri.hasScheme && (uri.hasAuthority || uri.host.isNotEmpty)) {
        return url;
      }
    } catch (e) {
      return null;
    }
    return null;
    }
}
