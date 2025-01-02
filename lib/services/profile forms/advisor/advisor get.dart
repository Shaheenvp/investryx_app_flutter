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
          headers: {
            'token': '$token',
          }
      );

      print('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;
        List<AdvisorExplr> advisors = data.map((json) => AdvisorExplr(
          title: json['title']?.toString() ?? 'N/A',
          singleLineDescription:  json['single_desc']?.toString() ?? 'N/A',
          imageUrl: validateUrl(json['logo']) ?? 'https://via.placeholder.com/400x200',
          id: json['id']?.toString() ?? '',
          user: json['user']?.toString() ?? '',
          name: json['name'] ?? 'N/A',
          designation: json['designation'] ?? 'Expert',
          location: json['city'] ?? 'N/A',
          postedTime: json['listed_on'] ?? 'N/A',
          state: json['state'],
          expertise: json['expertise'],
          url: json['url'],
          type: json['type']?.toString(),
          contactNumber: json['number'],
          interest: json['interest'],
          description: json['about'],
          businessPhotos: json['image1'] != null ? [validateUrl(json['image1']) ?? ''] : null,
          businessProof: validateUrl(json['proof1']),
          businessDocuments: json['doc1'] != null ? [validateUrl(json['doc1']) ?? ''] : null,
          brandLogo: json['logo'] != null ? [validateUrl(json['logo']) ?? ''] : null,
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

  static Future<void> deleteAdvisorProfile(String token) async {
    try {
      final token = await storage.read(key: 'token'); // Retrieve token from secure storage

      if (token == null) {
        log('Error: token not found in secure storage');
        return;
      }

      var response = await client.delete(
          Uri.parse('${ApiList.advisorAddPage!}${0}'),
          headers: {
            'token': token, // Add token to request headers
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
    required String businessWebsite,
    required String state,
    required String city,
    required String contactNumber,
    required String describeExpertise,
    required String areaOfInterest,
    List<File>? brandLogo,
    List<File>? businessPhotos,
    File? businessProof,
    List<File>? businessDocuments,
  }) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: token not found in secure storage');
        return false;
      }

      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse('${ApiList.advisorAddPage!}$advisorId'),
      );

      request.headers['token'] = token;
      request.fields['name'] = advisorName;
      request.fields['designation'] = designation;
      request.fields['url'] = businessWebsite;
      request.fields['state'] = state;
      request.fields['city'] = city;
      request.fields['number'] = contactNumber;
      request.fields['description'] = describeExpertise;
      request.fields['interest'] = areaOfInterest;

      // Helper function to add files to the request
      Future<void> addFiles(String field, List<File>? files) async {
        if (files != null && files.isNotEmpty) {
          for (var file in files) {
            request.files.add(await http.MultipartFile.fromPath(
              field,
              file.path,
              filename: basename(file.path),
            ));
          }
        }
      }

      // Add files only if they are provided
      await addFiles('logo', brandLogo);
      await addFiles('image1', businessPhotos);
      await addFiles('doc1', businessDocuments);

      if (businessProof != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'proof1',
          businessProof.path,
          filename: basename(businessProof.path),
        ));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        log('Advisor updated successfully!');
        var responseString = await response.stream.bytesToString();
        log('Response: $responseString');
        return true;
      } else {
        log('Failed to update advisor: ${response.statusCode}');
        var responseString = await response.stream.bytesToString();
        log('Error response: $responseString');
        return false;
      }
    } catch (e) {
      log('Unexpected error: $e');
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
      imageUrl: validateUrl(json['logo']) ?? 'https://via.placeholder.com/400x200',
      name: json['name'] ?? 'N/A',
      designation: json['designation'] ?? 'N/A',
      location: json['city'] ?? 'N/A',
      postedTime: json['listed_on'] ?? 'N/A',
      state: json['state'],
      url: json['url'],
      contactNumber: json['number'],
      interest: json['interest'],
      description: json['description'],
      id: json['id']?.toString() ?? '', // Ensure id is a String

      // Validating single URL for business photos
      businessPhotos: validateUrl(json['image1']) ?? 'https://via.placeholder.com/400x200',

      // Validating single URL for business proof
      businessProof: validateUrl(json['proof1']) ?? 'https://via.placeholder.com/400x200',

      // Validating single URL for business documents
      businessDocuments: validateUrl(json['doc1']) ?? 'https://via.placeholder.com/400x200',
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
