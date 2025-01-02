import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';  // Import Flutter Secure Storage
import 'package:project_emergio/services/api_list.dart';

class InvestorExplore {
  static var client = http.Client();
  static final storage = FlutterSecureStorage();  // Initialize Flutter Secure Storage

  static Future<List<InvestorExplr>?> fetchInvestorData() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: token not found in Flutter Secure Storage');
        return null;
      }

      var response = await client.get(
        Uri.parse('${ApiList.investorAddPage!}${0}'),  // Assuming '0' is a placeholder or specific endpoint
        headers: {
          'token':  token,  // Add token to request headers
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;
        List<InvestorExplr> investors = data.map((json) => InvestorExplr.fromJson(json)).toList();
        return investors;
      } else {
        log('Failed to fetch investor data: ${response.statusCode}');
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

class InvestorExplr {
  final String id;
  final String imageUrl;
  final String image2;
  final String image3;
  final String? image4;
  final String name;
  final String city;
  final String postedTime;
  final String? state;
  final String? industry;
  final String? description;
  final String? url;
  final String? rangeStarting;
  final String? locationIntrested;
  final String? rangeEnding;
  final String? evaluatingAspects;
  final String? companyName;

  InvestorExplr({
    required this.id,
    required this.imageUrl,
    required this.image2,
    required this.image3,
    this.image4,
    required this.name,
    required this.city,
    required this.postedTime,
    this.state,
    this.industry,
    this.description,
    this.url,
    this.rangeStarting,
    this.rangeEnding,
    this.evaluatingAspects,
    this.companyName,
    this.locationIntrested,
  });

  factory InvestorExplr.fromJson(Map<String, dynamic> json) {
    return InvestorExplr(
      id: json['id'].toString(),
      imageUrl: validateUrl(json['image1']) ?? 'https://via.placeholder.com/400x200',
      image2: validateUrl(json['image2']) ?? 'https://via.placeholder.com/400x200',
      image3: validateUrl(json['image3']) ?? 'https://via.placeholder.com/400x200',
      image4: validateUrl(json['image4']),
      name: json['name'] ?? 'N/A',
      city: json['city'] ?? 'N/A',
      postedTime: json['listed_on'] ?? 'N/A',
      state: json['state'],
      industry: json['industry'],
      description: json['description'],
      url: json['url'],
      rangeStarting: json['range_starting']?.toString(),
      rangeEnding: json['range_ending']?.toString(),
      evaluatingAspects: json['evaluating_aspects'],
      companyName: json['company'],
      locationIntrested: json['location_interested'],
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
