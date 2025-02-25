import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import '../../../models/all profile model.dart';
import '../../api_list.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class AdvisorFetchPage {
  static var client = http.Client();
  static final storage = FlutterSecureStorage(); // Initialize secure storage

  static Future<List<AdvisorExplr>?> fetchAdvisorData() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: token not found in secure storage');
        return null;
      }

      var response = await client.get(
        Uri.parse('${ApiList.advisorAddPage!}${1}'),
        headers: {'token': token},
      );

      log('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;
        List<AdvisorExplr> advisors = data.map((json) => AdvisorExplr(
          title: json['title']?.toString() ?? 'N/A',
          singleLineDescription: json['single_desc']?.toString() ?? 'N/A',
          imageUrl: validateUrl(json['logo']) ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
          id: json['id']?.toString() ?? '',
          user: json['user']?.toString() ?? '',
          name: json['name'] ?? 'N/A',
          verified: json['verified'] ?? '',
          designation: json['designation'] ?? 'Expert',
          location: json['city'] ?? 'N/A',
          postedTime: json['listed_on'] ?? 'N/A',
          state: json['state'] ?? '',
          expertise: json['experience'] ?? '', // Changed from expertise to experience
          url: json['email'] ?? '',
          type: json['industry'] ?? '', // Changed from type to industry
          contactNumber: json['number'] ?? '',
          interest: json['interest'] ?? '',
          description: json['description'] ?? '', // Changed from about to description
          businessPhotos: json['image1'] != null ? [validateUrl(json['image1']) ?? ''] : [],
          businessProof: validateUrl(json['proof1']) ?? '',
          businessDocuments: json['doc1'] != null ? [validateUrl(json['doc1']) ?? ''] : [],
          brandLogo: json['logo'] != null ? [validateUrl(json['logo']) ?? ''] : [],
        )).toList();
        return advisors;
      } else {
        log('Failed to fetch advisor data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('Unexpected error: $e');
      return null;
    }
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

  static Future<void> deleteAdvisorProfile(String id) async {
    try {
      final token = await storage.read(key: 'token');

      if (token == null) {
        log('Error: token not found in secure storage');
        return;
      }

      if (id == null) {
        id = "0";
      }

      var response = await client.delete(
          Uri.parse('${ApiList.advisorAddPage!}${id}'),
          headers: {
            'token': token,
          });

      print('Response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        log('Advisor deleted successfully');
      } else {
        log('Failed to delete Advisor: ${response.statusCode}');
        throw Exception('Failed to delete Advisor');
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

  static Future<bool> updateAdvisorProfile({
    required int advisorId,
    required String advisorName,
    required String designation,
    required String contactNumber,
    required String email,
    required String industry,
    required String experience,
    required String areaOfInterest,
    required String state,
    required String city,
    required String description,
    List<File>? brandLogo,
    List<File>? businessPhotos,
    File? businessProof,
    List<File>? businessDocuments,
  }) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) return false;

      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse('${ApiList.advisorAddPage!}$advisorId'),
      );

      request.headers['token'] = token;

      // Updated field names to match API expectations
      request.fields.addAll({
        'name': advisorName,
        'designation': designation,
        'number': contactNumber,
        'email': email,
        'industry': industry, // Changed from type
        'experience': experience, // Changed from expertise
        'interest': areaOfInterest,
        'state': state,
        'city': city,
        'description': description, // Changed from about
      });

      // Handle logo upload
      if (brandLogo?.isNotEmpty ?? false) {
        request.files.add(await http.MultipartFile.fromPath(
          'logo',
          brandLogo!.first.path,
          filename: basename(brandLogo.first.path),
        ));
      }

      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      log('Update response: ${response.statusCode} - $responseString');

      if (response.statusCode == 201) { // Changed from 200 to 201
        var jsonResponse = jsonDecode(responseString);
        return jsonResponse['status'] == true;
      }
      return false;
    } catch (e) {
      log('Error updating advisor profile: $e');
      return false;
    }
  }
}


class Advisor {
  final String imageUrl;
  final String id;
  final String name;
  final String? designation;
  final String location;
  final String postedTime;
  final String? state;
  final String? url;
  final String? contactNumber;
  final String? interest;
  final String? description;
  final String? brandLogo; // Now a single URL of brand logo
  final String? businessPhotos; // Now a single URL of business photos
  final String? businessProof; // URL of business proof
  final String? businessDocuments; // Now a single URL of business documents

  Advisor({
    required this.imageUrl,
    required this.id,
    required this.name,
    required this.location,
    required this.postedTime,
    this.designation,
    this.state,
    this.url,
    this.contactNumber,
    this.interest,
    this.description,
    this.brandLogo,
    this.businessPhotos,
    this.businessProof,
    this.businessDocuments,
  });

  factory Advisor.fromJson(Map<String, dynamic> json) {
    return Advisor(
      imageUrl: validateUrl(json['logo']) ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
      name: json['name'] ?? 'N/A',
      designation: json['designation'] ?? 'N/A',
      location: json['city'] ?? 'N/A',
      postedTime: json['listed_on'] ?? 'N/A',
      state: json['state'],
      url: json['email'],
      contactNumber: json['number'],
      interest: json['interest'],
      description: json['description'],
      id: json['id']?.toString() ?? '', // Ensure id is a String

      // Validating single URL for business photos
      businessPhotos: validateUrl(json['image1']) ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',

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
        // If the URL doesn't have a scheme, assume it's a relative path and append the base URL.
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
