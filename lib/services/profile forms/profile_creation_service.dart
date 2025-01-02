import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api_list.dart';

class ProfileCreationResponse {
  final bool success;
  final int statusCode;
  final String? message;

  ProfileCreationResponse({
    required this.success,
    required this.statusCode,
    this.message,
  });
}

class ProfileCreationService {
  static var _client = http.Client();
  static final _storage = FlutterSecureStorage();

  static Future<ProfileCreationResponse> profileCreation({
    required String name,
    required File image,
    required String type,
    required String number,
    required String email,
    required String industry,
    required String state,
    required String city,
    required String about,
    String? designation,  // Added designation parameter
    String? webUrl,
    String? experience,
    String? areaOfInterest,
  }) async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) {
        log('Error: Token not found in Flutter Secure Storage');
        return ProfileCreationResponse(
          success: false,
          statusCode: 401,
          message: 'Authentication token not found',
        );
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiList.saleProfile!),
      );

      // Add headers
      request.headers.addAll({
        'token': token,
      });

      // Add image file
      var imageStream = http.ByteStream(image.openRead());
      var length = await image.length();
      var multipartFile = http.MultipartFile(
          'image',
          imageStream,
          length,
          filename: image.path.split('/').last
      );
      request.files.add(multipartFile);

      // Add required fields
      var fields = {
        'name': name,
        'type': type,
        'email': email,
        'number': number,
        'industry': industry,
        'about': about,
        'state': state,
        'city': city,
      };

      // Add optional fields if they exist
      if (designation != null && designation.isNotEmpty) {
        fields['designation'] = designation;  // Added designation field
      }
      if (webUrl != null && webUrl.isNotEmpty) {
        fields['web_url'] = webUrl;
      }
      if (experience != null && experience.isNotEmpty) {
        fields['experiance'] = experience;  // Note: keeping original spelling 'experiance'
      }
      if (areaOfInterest != null && areaOfInterest.isNotEmpty) {
        fields['interest'] = areaOfInterest;
      }

      // Add all fields to request
      request.fields.addAll(fields);

      // Log request details for debugging
      log('Sending profile creation request with fields: $fields');

      // Send request and get response
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      log('Response of profile creation: ${response.statusCode} - ${response.body}');

      // Handle different status codes
      switch (response.statusCode) {
        case 201:
          return ProfileCreationResponse(
            success: true,
            statusCode: 201,
            message: 'Profile created successfully',
          );
        case 206:
          return ProfileCreationResponse(
            success: true,
            statusCode: 206,
            message: 'Profile created, verification required',
          );
        case 400:
          Map<String, dynamic> errorResponse = json.decode(response.body);
          return ProfileCreationResponse(
            success: false,
            statusCode: 400,
            message: errorResponse['message'] ?? 'Bad request',
          );
        case 401:
          return ProfileCreationResponse(
            success: false,
            statusCode: 401,
            message: 'Unauthorized access',
          );
        case 403:
          return ProfileCreationResponse(
            success: false,
            statusCode: 403,
            message: 'Access forbidden',
          );
        case 500:
          return ProfileCreationResponse(
            success: false,
            statusCode: 500,
            message: 'Server error occurred',
          );
        default:
          return ProfileCreationResponse(
            success: false,
            statusCode: response.statusCode,
            message: 'Failed to create profile',
          );
      }
    } on SocketException catch (e) {
      log('SocketException: ${e.message}');
      return ProfileCreationResponse(
        success: false,
        statusCode: 0,
        message: 'Network connection error',
      );
    } on http.ClientException catch (e) {
      log('ClientException: ${e.message}');
      return ProfileCreationResponse(
        success: false,
        statusCode: 0,
        message: 'Client error occurred',
      );
    } catch (e) {
      log('Unexpected error: $e');
      return ProfileCreationResponse(
        success: false,
        statusCode: 0,
        message: 'An unexpected error occurred',
      );
    }
  }

  // Helper method to clean up resources
  static void dispose() {
    _client.close();
  }
}