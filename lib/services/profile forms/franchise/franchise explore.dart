import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import Flutter Secure Storage
import '../../api_list.dart';

class FranchiseExplore {
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
        Uri.parse('${ApiList.franchiseAddPage!}${0}'),
        headers: {'token': token},
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
}

class FranchiseExplr {
  final String imageUrl;
  final String image2;
  final String image3;
  final String? image4;
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

  FranchiseExplr({
    required this.imageUrl,
    required this.image2,
    required this.image3,
    this.image4,
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
  });

  factory FranchiseExplr.fromJson(Map<String, dynamic> json) {
    return FranchiseExplr(
      imageUrl:
      validateUrl(json['image1']) ?? 'https://via.placeholder.com/400x200',
      image2: validateUrl(json['image2']) ?? 'https://via.placeholder.com/400x200',
      image3: validateUrl(json['image3']) ?? 'https://via.placeholder.com/400x200',
      image4: validateUrl(json['image4']),
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
