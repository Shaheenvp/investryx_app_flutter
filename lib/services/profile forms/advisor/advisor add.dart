import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart';
import '../../api_list.dart';

class AdvisorProfileService {
  static final _client = http.Client();
  static final _storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>> createAdvisorProfile({
    required String name,
    required String designation,
    required String email,
    required String number,
    required String industry,
    required String experience,
    required String areaOfInterest,
    required String state,
    required String city,
    required String about,
    required File profileImage,
  }) async {
    try {
      final token = await _storage.read(key: 'token');

      if (token == null) {
        log('Error: token not found in Flutter Secure Storage');
        return {"status": "loggedout"};
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiList.advisorAddPage ?? ''),
      );

      // Add headers
      request.headers['token'] = token;

      // Add fields
      request.fields.addAll({
        'name': name,
        'designation': designation,
        'email': email,
        'number': number,
        'industry': industry,
        'experiance': experience, // Note the spelling in API
        'interest': areaOfInterest,
        'state': state,
        'city': city,
        'description': about,
      });

      // Add profile image
      request.files.add(await http.MultipartFile.fromPath(
        'logo',
        profileImage.path,
        filename: basename(profileImage.path),
      ));

      // Send request and handle response
      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      log('Response: $responseString');

      var decodedResponse = json.decode(responseString);

      // Check for 201 status code
      if (response.statusCode == 201) {
        return {
          "status": true,
          "message": "Advisor profile created successfully"
        };
      } else if (decodedResponse is Map<String, dynamic>) {
        if (decodedResponse['message'] == "User does not exist") {
          return {"status": "loggedout"};
        }
        return {
          "status": false,
          "error": decodedResponse['message'] ?? "Failed to create advisor profile"
        };
      }

      log('Failed to add advisor: ${response.statusCode}');
      return {
        "status": false,
        "error": "Failed to create advisor profile. Status code: ${response.statusCode}"
      };

    } catch (e) {
      log('Unexpected error: $e');
      return {
        "status": false,
        "error": e.toString()
      };
    }
  }
}