import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/all profile model.dart';
import 'api_list.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RecommendedAds {
  static var client = http.Client();
  static final storage =
  FlutterSecureStorage(); // Create a secure storage instance

  // Method for fetching recommended items
  static Future<Map<String, dynamic>?> fetchRecommended() async {
    try {
      // Retrieve the token from Flutter secure storage
      String? token = await storage.read(key: 'token');

      if (token == null) {
        log('Error: Token not found in secure storage');
        return {
          "status": "loggedout"
        }; // Handle the case where the token is missing
      }

      var response = await client.get(
        Uri.parse('${ApiList.recommended}'),
        headers: {
          'Content-Type': 'application/json',
          'token': token,
        },
      );

      print(
          'Response: fetching recommended $token ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        if (decodedResponse is Map<String, dynamic> &&
            decodedResponse.containsKey('status') &&
            decodedResponse['status'] == false) {
          if (decodedResponse['message'] == "User doesnot exist") {
            return {"status": "loggedout"};
          }

          return {"error": decodedResponse['message']};
        } else {
          var data = jsonDecode(response.body) as List;
          List<ProductDetails> recommendedItems =
          data.map((json) => ProductDetails.fromJson(json)).toList();
          List<BusinessInvestorExplr> recommendedAllItems =
          data.map((json) => BusinessInvestorExplr.fromJson(json)).toList();
          List<FranchiseExplr> recommendedFranchiseItems =
          data.map((json) => FranchiseExplr.fromJson(json)).toList();
          List<AdvisorExplr> recommendedAdvisorItems =
          data.map((json) => AdvisorExplr.fromJson(json)).toList();

          List<ProductDetails> businessRecommended = recommendedItems
              .where((product) => product.type == "business")
              .toList();
          List<ProductDetails> investorRecommended = recommendedItems
              .where((product) => product.type == "investor")
              .toList();
          List<ProductDetails> franchiseRecommended = recommendedItems
              .where((product) => product.type == "franchise")
              .toList();
          List<ProductDetails> advisorRecommended = recommendedItems
              .where((product) => product.type == "advisor")
              .toList();

          List<BusinessInvestorExplr> businessData = recommendedAllItems
              .where((data) => data.entityType == "business")
              .toList();
          List<BusinessInvestorExplr> investorData = recommendedAllItems
              .where((data) => data.entityType == "investor")
              .toList();
          List<FranchiseExplr> franchiseData = recommendedFranchiseItems
              .where((data) => data.entityType == "franchise")
              .toList();

          List<AdvisorExplr> advisorData = recommendedAdvisorItems
              .where((data) => data.type == "advisor")
              .toList();

          return {
            "recommended": recommendedItems,
            "recommendedAll": recommendedAllItems,
            "recommendedFranchiseItems": recommendedFranchiseItems,
            "business_recommended": businessRecommended,
            "investor_recommended": investorRecommended,
            "franchise_recommended": franchiseRecommended,
            "advisor_recommended": advisorRecommended,
            "business_data": businessData,
            "investor_data": investorData,
            "franchise_data": franchiseData,
            "advisor_data": advisorData
          };
        }
      } else {
        log('Failed to fetch recommended data: ${response.statusCode}');
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



class ProductDetails {
  final String id;
  final String imageUrl;
  final String title;
  final String singleLineDescription;
  final String postedTime;
  final String type;
  final String? contactNumber;
  final String? interest;
  final String? expertise;
  final String? experience;
  final String? description;
  final String? url;
  final String? city;
  final String? state;

  ProductDetails({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.type,
    this.interest,
    required this.singleLineDescription,
    required this.postedTime,
    this.expertise,
    this.experience,
    this.description,
    this.url,
    this.contactNumber,
    this.city,
    this.state,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      type: json['entity_type'].toString(),
      id: json['id'].toString(),
      imageUrl:
      validateUrl(json['image1']) ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
      title: json['title'] ?? 'N/A',
      singleLineDescription: json['single_desc'] ?? 'N/A',
      postedTime: json['listed_on'] ?? 'N/A',
      description: json['description'],
      interest: json['interest'],
      contactNumber: json['number'],
      expertise: json['industry'],
      experience: json['experience'],
      url: json['email'],
      state: json['state'],
      city: json['city'] ?? 'N/A',

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
