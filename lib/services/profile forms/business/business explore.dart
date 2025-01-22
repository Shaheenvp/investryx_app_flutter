import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import for secure storage
import '../../api_list.dart';

class BusinessExplore {
  static var client = http.Client();
  static final storage = FlutterSecureStorage(); // Initialize secure storage

  static Future<List<BusinessExplr>?> fetchBusinessExplore() async {
    try {
      final token = await storage.read(key: 'token'); // Read token from secure storage
      if (token == null) {
        log('Error: Token not found in secure storage');
        return null;
      }

      var response = await client.get(
        Uri.parse('${ApiList.businessAddPage!}${0}'),
        headers: {
          'token': token, // Add token to headers
        },
      );
      print('Error: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;
        List<BusinessExplr> businesses =
        data.map((json) => BusinessExplr.fromJson(json)).toList();
        return businesses;
      } else {
        log('Failed to fetch business listings: ${response.statusCode}');
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

class BusinessExplr {
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
  // final String? user;

  BusinessExplr({
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
    // this.user,
    required this.postedTime,
    required this.topSelling,
  });

  factory BusinessExplr.fromJson(Map<String, dynamic> json) {
    return BusinessExplr(
      imageUrl:
      validateUrl(json['image1']) ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
      image2: validateUrl(json['image2']) ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
      image3: validateUrl(json['image3']) ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
      image4: validateUrl(json['image4']),
      id: json['id']?.toString() ?? 'N/A',
      name: json['name']?.toString() ?? 'N/A',
      industry: json['industry']?.toString() ?? 'N/A',
      establish_yr: json['establish_yr']?.toString() ?? 'N/A',
      description: json['description']?.toString() ?? 'N/A',
      address_1: json['address_1']?.toString() ?? 'N/A',
      address_2: json['address_2']?.toString() ?? 'N/A',
      pin: json['pin']?.toString() ?? 'N/A',
      city: json['city']?.toString() ?? 'N/A',
      state: json['state']?.toString() ?? 'N/A',
      employees: json['employees']?.toString() ?? 'N/A',
      entity: json['entity']?.toString() ?? 'N/A',
      avg_monthly: json['avg_monthly']?.toString() ?? 'N/A',
      latest_yearly: json['latest_yearly']?.toString() ?? 'N/A',
      ebitda: json['ebitda']?.toString() ?? 'N/A',
      rate: json['range_starting']?.toString() ?? 'N/A',
      type_sale: json['type_sale']?.toString() ?? 'N/A',
      url: json['url']?.toString() ?? 'N/A',
      features: json['features']?.toString() ?? 'N/A',
      facility: json['facility']?.toString() ?? 'N/A',
      income_source: json['income_source']?.toString() ?? 'N/A',
      reason: json['reason']?.toString() ?? 'N/A',
      postedTime: json['listed_on']?.toString() ?? 'N/A',
      topSelling: json['top_selling']?.toString() ?? 'N/A',
      // user: json['user']['id']?.toString() ,
    );
  }

  static String? validateUrl(String? urls) {
    const String baseUrl = ApiList.imageBaseUrl;

    if (urls == null || urls.isEmpty) {
      return null;
    }

    Uri? uri;
    try {
      uri = Uri.parse(urls);
      if (!uri.hasScheme) {
        urls = urls.startsWith('/') ? urls.substring(1) : urls;
        urls = baseUrl + urls;
        uri = Uri.parse(urls);
      }
      if (uri.hasScheme && (uri.hasAuthority || uri.host.isNotEmpty)) {
        return urls;
      }
    } catch (e) {
      return null;
    }
    return null;
    }
}
