import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_list.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RecentActivities {
  static var client = http.Client();
  final storage = FlutterSecureStorage();

  // Method to add item to recent activities
  static Future<bool?> recentActivities({
    required String productId,
  }) async {
    // Retrieve the token from secure storage
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null) {
      log('Error: Token not found in secure storage');
      return false;
    }

    var body = jsonEncode({
      "productId": productId,
    });

    try {
      var response = await client.post(
        Uri.parse(ApiList.recentActivities!),
        headers: {
          'Content-Type': 'application/json',
          'token': token, // Passing the token in the header
        },
        body: body,
      );
      print('Response: ${response.statusCode} - ${response.body}');
      Map<String, dynamic> responseBody = json.decode(response.body);
      bool status = responseBody['status'];
      if (status) {
        return status;
      } else {
        log('Failed to add item to recent activities: ${response.statusCode}');
        return false;
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

  // Method for fetching recent activities
  static Future<List<Recent>?> fetchRecentActivities() async {
    try {
      // Retrieve the token from secure storage
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');

      if (token == null) {
        log('Error: Token not found in secure storage');
        return null;
      }
      print(token);

      var response = await client.get(
        Uri.parse(ApiList.recentActivities!),
        headers: {
          'token': token,
        },
      );
      print('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;
        List<Recent> recentItems =
        data.map((json) => Recent.fromJson(json)).toList();
        return recentItems;
      } else {
        log('Failed to fetch recent activities data: ${response.statusCode}');
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

class Recent {
  final String id;
  final String imageUrl;
  final String image2;
  final String image3;
  final String? image4;
  final String name;
  final String? industry;
  final String? establish_yr;
  final String? description;
  final String? address_1;
  final String? address_2;
  final String? pin;
  final String city;
  final String? state;
  final String? title;
  final String? employees;
  final String? entity;
  final String? avg_monthly;
  final String? latest_yearly;
  final String? ebitda;
  final String? rate;
  final String? type_sale;
  final String? url;
  final String? features;
  final String? facility;
  final String? income_source;
  final String? reason;
  final String postedTime;
  final String topSelling;
  final String? rangeStarting;
  final String? locationIntrested;
  final String? rangeEnding;
  final String? evaluatingAspects;
  final String? companyName;
  final String? brandName;
  final String? initialInvestment;
  final String? iamOffering;
  final String? currentNumberOfOutlets;
  final String? franchiseTerms;
  final String? locationsAvailable;
  final String? projectedRoi;
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
  final String? entityType;
  final String? established_year;

  final String? user;

  final String? designation;
  final String? location;

  final String? expertise;

  final String? contactNumber;
  final String? interest;

  final List<String>? brandLogo;
  final List<String>? businessPhotos;
  final String? businessProof;
  final List<String>? businessDocuments;

  Recent({
    required this.id,
    required this.imageUrl,
    required this.image2,
    required this.image3,
    this.image4,
    required this.name,
    this.industry,
    this.establish_yr,
    this.description,
    this.address_1,
    this.address_2,
    this.pin,
    required this.city,
    this.state,
    this.employees,
    this.entity,
    this.title,
    this.avg_monthly,
    this.latest_yearly,
    this.ebitda,
    this.rate,
    this.type_sale,
    this.url,
    this.features,
    this.facility,
    this.income_source,
    this.reason,
    this.evaluatingAspects,
    this.companyName,
    this.rangeStarting,
    this.rangeEnding,
    this.locationsAvailable,
    this.brandName,
    this.locationIntrested,
    required this.postedTime,
    required this.topSelling,
    this.entityType,
    this.established_year,
    this.franchiseTerms,
    this.iamOffering,
    this.initialInvestment,
    this.allProducts,
    this.avgMonthlySales,
    this.avgNoOfStaff,
    this.brandFee,
    this.brandStartOperation,
    this.currentNumberOfOutlets,
    this.kindOfSupport,
    this.projectedRoi,
    this.spaceRequiredMax,
    this.spaceRequiredMin,
    this.totalInvestmentFrom,
    this.totalInvestmentTo,
    this.brandLogo,
    this.businessDocuments,
    this.businessPhotos,
    this.businessProof,
    this.contactNumber,
    this.designation,
    this.expertise,
    this.interest,
    this.location,
    this.user,
  });

  factory Recent.fromJson(Map<String, dynamic> json) {
    String determinedType = '';

    determinedType = json['entity_type'];

    return Recent(
      id: json['id']?.toString() ?? 'N/A',
      imageUrl:
      validateUrl(json['image1']) ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
      image2:
      validateUrl(json['image2']) ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
      image3:
      validateUrl(json['image3']) ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
      image4: validateUrl(json['image4']),
      name: json['name']?.toString() ?? 'N/A',
      title: json['title']?.toString() ?? 'N/A',
      industry: json['industry']?.toString(),
      establish_yr: json['establish_yr']?.toString(),
      description: json['description']?.toString(),
      address_1: json['address_1']?.toString(),
      address_2: json['address_2']?.toString(),
      pin: json['pin']?.toString(),
      city: json['city']?.toString() ?? 'N/A',
      state: json['state']?.toString(),
      employees: json['employees']?.toString(),
      entity: json['entity']?.toString(),
      avg_monthly: json['avg_monthly']?.toString(),
      latest_yearly: json['latest_yearly']?.toString(),
      ebitda: json['ebitda']?.toString(),
      rate: json['range_starting']?.toString(),
      type_sale: json['type_sale']?.toString(),
      url: json['url']?.toString(),
      features: json['features']?.toString(),
      facility: json['facility']?.toString(),
      income_source: json['income_source']?.toString(),
      reason: json['reason']?.toString(),
      postedTime: json['listed_on']?.toString() ?? 'N/A',
      topSelling: json['top_selling']?.toString() ?? 'N/A',
      locationIntrested: json['location_interested']?.toString(),
      rangeStarting: json['range_starting']?.toString(),
      rangeEnding: json['range_ending']?.toString(),
      companyName: json['company']?.toString(),
      evaluatingAspects: json['evaluating_aspects']?.toString(),
      brandName: json['brand_name']?.toString(),
      entityType: json["entity_type"] ?? "",
      established_year: json["established_year"] ?? "",
      franchiseTerms: json['yr_period']?.toString(),
      iamOffering: json['offering']?.toString(),
      initialInvestment: json['initial']?.toString(),
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

      projectedRoi: json['proj_ROI']?.toString(),

      currentNumberOfOutlets: json['total_outlets']?.toString(),

      locationsAvailable: json['locations_available'],
      designation: json['designation'] ?? 'N/A',
      location: json['city'] ?? 'N/A',

      expertise: json['expertise'],

      contactNumber: json['number'],
      interest: json['interest'],

      user: json['user']?.toString() ?? '', // Ensure id is a String
      brandLogo: json['brandLogo'] != null
          ? List<String>.from(json['brandLogo'])
          : null,
      businessPhotos: json['businessPhotos'] != null
          ? List<String>.from(json['businessPhotos'])
          : null,
      businessProof: json['businessProof'],
      businessDocuments: json['businessDocuments'] != null
          ? List<String>.from(json['businessDocuments'])
          : null,
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
