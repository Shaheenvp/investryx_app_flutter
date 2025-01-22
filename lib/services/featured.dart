import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/all profile model.dart';
import 'api_list.dart';

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Add this import
import 'api_list.dart';

class Featured {
  static var client = http.Client();
  static final storage = FlutterSecureStorage(); // Create an instance of FlutterSecureStorage

  // Method for fetching featured data
  static Future<Map<String, dynamic>?> fetchFeaturedData(String type) async {
    try {
      // Retrieve the token from secure storage
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: Token not found in secure storage');
        return null;
      }

      var response = await client.get(
        Uri.parse('${ApiList.featured!}?type=$type'),
        headers: {
          'token': token, // Add the Authorization header
        },
      );

      log('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;
        List<FeaturedDetails> featuredItems =
        data.map((json) => FeaturedDetails.fromJson(json)).toList();
        List<BusinessInvestorExplr> featuredAllItems =
        data.map((json) => BusinessInvestorExplr.fromJson(json)).toList();
        List<FranchiseExplr> featuredFranchiseItems =
        data.map((json) => FranchiseExplr.fromJson(json)).toList();
        log('Featured items fetched successfully');
        return {
          "featured": featuredItems,
          "featuredAll": featuredAllItems,
          "featuredFranchiseItems": featuredFranchiseItems
        };
      } else {
        log('Failed to fetch featured data: ${response.statusCode}');
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

  // Method for fetching featured items
  static Future<Map<String, dynamic>?> fetchFeaturedLists(
      {required String profile}) async {
    try {
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');

      if (token == null) {
        log('Error: Token not found in secure storage');
        return null;
      }



      final Uri url;
      if (profile == "") {
        url = Uri.parse(ApiList.featured!);
      } else {
        url = Uri.parse("${ApiList.featured}?type=$profile");
      }

      var response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          // 'token': token, // Pass the token in the header
        },
      );
      print('Response of featured: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;

        List<BusinessInvestorExplr> businessFeatured =
        data.map((json) => BusinessInvestorExplr.fromJson(json)).toList();
        List<BusinessInvestorExplr> investorFeatured =
        data.map((json) => BusinessInvestorExplr.fromJson(json)).toList();
        List<FranchiseExplr> franchiseFeatured =
        data.map((json) => FranchiseExplr.fromJson(json)).toList();

        return {
          "business_data": businessFeatured,
          "investor_data": investorFeatured,
          "franchise_data": franchiseFeatured
        };
      } else {
        log('Failed to fetch featured data: ${response.statusCode}');
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

  // Method for fetching featured advisor data
  static Future<List<AdvisorExplr>?> fetchFeaturedAdvisorData() async {
    try {
      // Retrieve the token from secure storage
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: Token not found in secure storage');
        return null;
      }

      var response = await client.get(
        Uri.parse('${ApiList.featured!}?type=advisor'),
        headers: {
          'token': token,
        },
      );

      log('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;
        List<AdvisorExplr> featuredItems =
        data.map((json) => AdvisorExplr.fromJson(json)).toList();
        print('Featured advisor items fetched successfully  ${featuredItems.length}');
        return featuredItems;
      } else {
        log('Failed to fetch featured advisor data: ${response.statusCode}');
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


  // Method for fetching all advisor data
  static Future<List<AdvisorExplr>?> fetchAllAdvisorData() async {
    try {
      // Retrieve the token from secure storage
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: Token not found in secure storage');
        return null;
      }

      var response = await client.get(
        Uri.parse('${ApiList.advisorAddPage}0'),
        headers: {
          'token': token, // Add the Authorization header
        },
      );

      log('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;
        List<AdvisorExplr> advisorLists =
        data.map((json) => AdvisorExplr.fromJson(json)).toList();
        print('Featured all advisor items fetched successfully  ${advisorLists.length}');
        return advisorLists;
      } else {
        log('Failed to fetch featured advisor data: ${response.statusCode}');
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

class FeaturedDetails {
  final String id;
  final String imageUrl;
  final String name;
  final String city;
  final String postedTime;
  final String type;

  FeaturedDetails({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.city,
    required this.postedTime,
    required this.type,
  });

  factory FeaturedDetails.fromJson(Map<String, dynamic> json) {
    return FeaturedDetails(
      id: json['id'].toString(),
      imageUrl: validateUrl(json['image']) ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
      name: json['name'] ?? 'N/A',
      city: json['city'] ?? json['locations_available'],
      postedTime: json['listed_on'] ?? 'N/A',
      type: json['entity_type'].toString(),
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
