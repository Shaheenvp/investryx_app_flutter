import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Add this import
import 'api_list.dart';

class UserProfile {
  static var client = http.Client();
  static final storage = FlutterSecureStorage(); // Initialize secure storage

// Fetch User Profile Data
  static Future<UserProfileAndImage?> fetchUserProfileData() async {
    try {
      final token = await storage.read(key: 'token'); // Retrieve token from secure storage
      if (token == null) {
        log('Error: token not found in secure storage');
        return null;
      }

      var response = await client.get(
        Uri.parse('${ApiList.userProfile!}'),
        headers: {
          'token': token, // Add token to request headers
        },
      );

      print('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          var data = jsonDecode(response.body); // Parse the response body

          // No need to check for 'user' key, directly map the response to UserProfileData
          UserProfileData profile = UserProfileData.fromJson(data);

          // Check if 'image' field exists and is valid
          if (data['image'] != null && data['image'] is String) {
            GetImage image = GetImage.fromJson(data);
            return UserProfileAndImage(profile: profile, image: image);
          } else {
            return UserProfileAndImage(profile: profile, image: null);
          }
        } else {
          log('Error: Response body is empty');
          return null;
        }
      } else {
        log('Failed to fetch user profile data: ${response.statusCode}');
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

  // Delete User Profile
  static Future<void> deleteUserProfile() async {
    try {
      final token = await storage.read(key: 'token'); // Retrieve token from secure storage
      if (token == null) {
        log('Error: token not found in secure storage');
        throw Exception('No token found');
      }

      var response = await client.delete(
        Uri.parse(ApiList.userProfile!),
        headers: {
          'token': token, // Add token to request headers
        },
      );

      if (response.statusCode == 200) {
        log('User profile deleted successfully');
      } else {
        log('Failed to delete user profile: ${response.statusCode}');
        throw Exception('Failed to delete user profile');
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

  // Update User Profile Data
  static Future<(bool, String)> updateUserProfileData(String token, String name,
      String email, String phone, File? imageFile) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: token not found in secure storage');
        return (false, 'Token not found');
      }

      var uri = Uri.parse('${ApiList.userProfile!}');
      var request = http.MultipartRequest('PATCH', uri)
        ..headers['token'] = token
        ..fields['first_name'] = name
        ..fields['email'] = email
        ..fields['username'] = phone;

      if (imageFile != null) {
        request.files.add(
          http.MultipartFile(
            'image',
            imageFile.readAsBytes().asStream(),
            imageFile.lengthSync(),
            filename: imageFile.path.split('/').last,
          ),
        );
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        print('Response: ${response.statusCode} - $responseBody');
        log('User profile updated successfully');
        return (true, 'Profile updated successfully');
      } else if (response.statusCode == 422) {
        log('Name mismatch error: ${response.statusCode} - $responseBody');
        return (false, 'Name does not match Aadhaar card details. Please enter the exact name as shown on your Aadhaar card.');
      } else {
        log('Failed to update user profile: ${response.statusCode} - $responseBody');
        return (false, 'Failed to update profile');
      }
    } on SocketException catch (e) {
      log('SocketException: ${e.message}');
      return (false, 'No internet connection');
    } on http.ClientException catch (e) {
      log('ClientException: ${e.message}');
      return (false, 'Client error occurred');
    } catch (e) {
      log('Unexpected error: $e');
      return (false, 'An unexpected error occurred');
    }
  }
}

class UserProfileData {
  final int id;
  final String username;
  final String firstName;
  final String email;
  final bool verified;

  UserProfileData({
    required this.id,
    required this.username,
    required this.firstName,
    required this.email,
    required this.verified,
  });

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    return UserProfileData(
      id: json['id'],
      username: json['username'],
      firstName: json['first_name'],
      email: json['email'],
      verified: json['verified'] ?? false,
    );
  }
}

class GetImage {
  final String image;

  GetImage({
    required this.image,
  });

  factory GetImage.fromJson(Map<String, dynamic> json) {
    return GetImage(
        image: json['image'] != null
            ? validateUrl(json['image'])
            : 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=');
  }

  static String validateUrl(String? url) {
    const String baseUrl = ApiList.imageBaseUrl;

    if (url == null || url.isEmpty) {
      return '';
    }

    try {
      // Handle relative URLs
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = url.startsWith('/') ? url.substring(1) : url;
        url = baseUrl + url;
      }

      final uri = Uri.parse(url);

      // Validate URL structure
      if (!uri.hasScheme || (!uri.hasAuthority && uri.host.isEmpty)) {
        return '';
      }

      return url;
    } catch (e) {
      print('URL validation error: $e');
      return '';
    }
  }

// static String validateUrl(String? url) {
//   const String baseUrl = 'https://investryx.com/';
//
//   if (url == null || url.isEmpty) {
//     return '';
//   }
//
//   Uri uri;
//   try {
//     uri = Uri.parse(url);
//     if (!uri.hasScheme) {
//       url = url.startsWith('/') ? url.substring(1) : url;
//       url = baseUrl + url;
//       uri = Uri.parse(url);
//     }
//     if (uri.hasScheme && (uri.hasAuthority || uri.host.isNotEmpty)) {
//       return url;
//     }
//   } catch (e) {
//     return '';
//   }
//   return '';
// }
}

class UserProfileAndImage {
  final UserProfileData profile;
  final GetImage? image;

  UserProfileAndImage({
  required this.profile,
  this.image,
  });
}
