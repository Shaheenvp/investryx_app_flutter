import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import for secure storage
import 'package:project_emergio/models/all%20profile%20model.dart';
import '../../api_list.dart';
import 'package:path/path.dart';

class BusinessGet {
  static var client = http.Client();
  static final storage = FlutterSecureStorage(); // Initialize secure storage

  static Future<List<BusinessInvestorExplr>?> fetchBusinessListings() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: Token not found in secure storage');
        return null;
      }

      var response = await client.get(
        Uri.parse('${ApiList.businessAddPage!}1'),
        headers: {
          'token': token,
        },
      );
      log(
          'Response of fetching my business listing: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;
        List<BusinessInvestorExplr> businesses =
        data.map((json) => BusinessInvestorExplr.fromJson(json)).toList();
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

  static Future<Business?> fetchSingleBusiness(String businessId) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: Token not found in secure storage');
        return null;
      }

      var response = await client.get(
        Uri.parse('${ApiList.businessAddPage!}$businessId'),
        headers: {
          'token': token,
        },
      );
      log('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data is List) {
          // If the response is a list, find the business with the matching ID
          var businessData = data.firstWhere(
                  (item) => item['id'].toString() == businessId,
              orElse: () => null);
          if (businessData != null) {
            return Business.fromJson(businessData);
          } else {
            log('Business not found in the response list');
            return null;
          }
        } else if (data is Map<String, dynamic>) {
          // If the response is a single object, use it directly
          return Business.fromJson(data);
        } else {
          log('Unexpected response format');
          return null;
        }
      } else {
        log('Failed to fetch business: ${response.statusCode}');
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

  static Future<void> deleteBusiness(String businessId) async {
    try {
      final token =
      await storage.read(key: 'token'); // Read token from secure storage
      if (token == null) {
        log('Error: Token not found in secure storage');
        return;
      }

      var response = await client.delete(
        Uri.parse('${ApiList.businessAddPage!}$businessId'),
        headers: {
          'token': token,
        },
      );
      print("response of delete post ${response.body}");
      if (response.statusCode == 200) {
        print('Business deleted successfully');

        Get.snackbar("Success!", "Deleted successfully");

      } else {
        log('Failed to delete Business: ${response.statusCode}');
        throw Exception('Failed to delete Business');
      }
    } on SocketException catch (e) {
      log('SocketException: ${e.message}');
      throw Exception('No Internet connection');
    } on http.ClientException catch (e) {
      log('ClientException: ${e.message}');
      throw Exception('Client error');
    } catch (e) {
      log('Unexpected error: $e');
      throw Exception('Unexpected error');
    }
  }

  static Future<void> deleteBusinessProfile(String businessId) async {
    try {
      final token =
      await storage.read(key: 'token'); // Read token from secure storage
      if (token == null) {
        log('Error: Token not found in secure storage');
        return;
      }

      var response = await client.delete(
        Uri.parse('${ApiList.businessAddPage!}${0}'),
        headers: {
          'token': token,
        },
      );
      log('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        log('Business deleted successfully');
      } else {
        log('Failed to delete Business: ${response.statusCode}');
        throw Exception('Failed to delete Business');
      }
    } on SocketException catch (e) {
      log('SocketException: ${e.message}');
      throw Exception('No Internet connection');
    } on http.ClientException catch (e) {
      log('ClientException: ${e.message}');
      throw Exception('Client error');
    } catch (e) {
      log('Unexpected error: $e');
      throw Exception('Unexpected error');
    }
  }

  static Future<void> updateBusiness({
    required String id,
    required String name,
    String? singleLineDescription,
    String? industry,
    String? establish_yr,
    String? description,
    String? address_1,
    String? address_2,
    String? pin,
    String? city,
    String? state,
    String? employees,
    String? entity,
    String? avg_monthly,
    String? latest_yearly,
    String? ebitda,
    String? rate,
    String? type_sale,
    String? url,
    String? features,
    String? facility,
    String? income_source,
    String? reason,
    String? topSelling,
    File? image1,
    File? image2,
    File? image3,
    File? image4,
    File? doc1,
    File? proof1,
    String? askingPrice,
    String? maximumRange,
    String? minimumRange,

  }) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: Token not found in secure storage');
        return;
      }

      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse('${ApiList.businessAddPage!}$id'),
      );

      // Add all the text fields
      request.fields['name'] = name;
      request.fields['single_desc'] = singleLineDescription ?? '';
      request.fields['industry'] = industry ?? '';
      request.fields['establish_yr'] = establish_yr ?? '';
      request.fields['description'] = description ?? '';
      request.fields['address_1'] = address_1 ?? '';
      request.fields['address_2'] = address_2 ?? '';
      request.fields['pin'] = pin ?? '';
      request.fields['city'] = city ?? "";
      request.fields['state'] = state ?? '';
      request.fields['employees'] = employees ?? '';
      request.fields['entity'] = entity ?? '';
      request.fields['avg_monthly'] = avg_monthly ?? '';
      request.fields['latest_yearly'] = latest_yearly ?? '';
      request.fields['ebitda'] = ebitda ?? '';
      request.fields['rate'] = rate ?? '';
      request.fields['type_sale'] = type_sale ?? '';
      request.fields['url'] = url ?? '';
      request.fields['features'] = features ?? '';
      request.fields['facility'] = facility ?? '';
      request.fields['income_source'] = income_source ?? '';
      request.fields['reason'] = reason ?? '';
      request.fields['top_selling'] = topSelling ?? "";
      request.fields["asking_price"] = askingPrice ?? "";

      // Add image files to the request
      if (image1 != null && image1.existsSync()) {
        request.files.add(await http.MultipartFile.fromPath(
          'image1',
          image1.path,
          filename: basename(image1.path),
        ));
      }
      if (image2 != null && image2.existsSync()) {
        request.files.add(await http.MultipartFile.fromPath(
          'image2',
          image2.path,
          filename: basename(image2.path),
        ));
      }
      if (image3 != null && image3.existsSync()) {
        request.files.add(await http.MultipartFile.fromPath(
          'image3',
          image3.path,
          filename: basename(image3.path),
        ));
      }
      if (image4 != null && image4.existsSync()) {
        request.files.add(await http.MultipartFile.fromPath(
          'image4',
          image4.path,
          filename: basename(image4.path),
        ));
      }

      // Add document and proof files
      if (doc1 != null && doc1.existsSync()) {
        request.files.add(await http.MultipartFile.fromPath(
          'doc1',
          doc1.path,
          filename: basename(doc1.path),
        ));
      }
      if (proof1 != null && proof1.existsSync()) {
        request.files.add(await http.MultipartFile.fromPath(
          'proof1',
          proof1.path,
          filename: basename(proof1.path),
        ));
      }

      request.headers['token'] = token;

      var response = await request.send();
      print('Response of update business post: ${response.statusCode},  ');

      if (response.statusCode == 201) {
        log('Business updated successfully!');
        var responseString = await response.stream.bytesToString();
        print('Response: $responseString');
      } else {
        log('Failed to update Business: ${response.statusCode}');
        throw Exception('Failed to update Business');
      }
    } on SocketException catch (e) {
      log('SocketException: ${e.message}');
      throw Exception('No Internet connection');
    } on http.ClientException catch (e) {
      log('ClientException: ${e.message}');
      throw Exception('Client error');
    } catch (e) {
      log('Unexpected error: $e');
      throw Exception('Unexpected error');
    }
  }
}

class Business {
  final String id;
  final String imageUrl;
  final String image2;
  final String image3;
  final String image4;
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
  final String? businessDocument;
  final String? businessProof;
  // final String? user;

  Business({
    required this.imageUrl,
    required this.image2,
    required this.image3,
    required this.image4,
    required this.name,
    this.industry,
    required this.id,
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
    required this.postedTime,
    required this.topSelling,
    this.businessDocument,
    this.businessProof,
    // this.user,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      imageUrl:
      validateUrl(json['image1']) ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
      image2:
      validateUrl(json['image2']) ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
      image3:
      validateUrl(json['image3']) ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
      image4:
      validateUrl(json['image4']) ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
      name: json['name']?.toString() ?? 'N/A',
      id: json['id']?.toString() ?? 'N/A',
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
      // user: json['user']['id'].toString(),
      businessDocument:
      validateUrl(json['doc1']) ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
      businessProof:
      validateUrl(json['proof1']) ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
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
