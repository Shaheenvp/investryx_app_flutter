import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Add this import
import 'api_list.dart';

class SalesProfile {
  static var client = http.Client();
  static final storage = FlutterSecureStorage(); // Initialize secure storage

// // Fetch User Profile Data
//   static Future<salesProfileandImage?> fetchSalesProfileData(
//       {required String type}) async {
//     try {
//       // Check token
//       final token = await storage.read(key: 'token');
//       if (token == null) {
//         log('Error: token not found in secure storage');
//         return null;
//       }
//       log('Token found: ${token.substring(0, 10)}...'); // Show first 10 chars for security

//       // Make API call
//       final url = '${ApiList.saleProfile}?type=$type';
//       log('Requesting URL: $url');

//       var response = await client.get(
//         Uri.parse(url),
//         headers: {
//           'token': token,
//         },
//       );

//       print('Response fetch profile:  ${response.statusCode} ${response.body}');

//       if (response.statusCode == 200) {
//         if (response.body.isNotEmpty) {
//           print('Response body received, attempting to parse JSON');
//           Map<String, dynamic> data = jsonDecode(response.body);
//           print('Parsed JSON data: $data');

//           if (data.containsKey("status") &&
//               data["message"] == "No profiles found") {
//             return null;
//           } else {
//             try {
//               saleProfile profile = saleProfile.fromJson(data);
//               print('Successfully created profile object  ');

//               if (data['image'] != null && data['image'] is String) {
//                 print('Image data found, creating GetImage object');
//                 GetImage image = GetImage.fromJson(data);
//                 print('Successfully created image object  ${profile.name}');
//                 return salesProfileandImage(profile: profile, image: image);
//               } else {
//                 print('No image data found or invalid image data');
//                 return salesProfileandImage(profile: profile, image: null);
//               }
//             } catch (e) {
//               print('Error creating profile/image objects: $e');
//               return null;
//             }
//           }
//         } else {
//           print('Error: Response body is empty');
//           return null;
//         }
//       } else {
//         log('Failed to fetch sales profile data: ${response.statusCode}');
//         log('Error response body: ${response.body}');
//         return null;
//       }
//     } on SocketException catch (e) {
//       log('SocketException: ${e.message}');
//       return null;
//     } on http.ClientException catch (e) {
//       log('ClientException: ${e.message}');
//       return null;
//     } catch (e, stackTrace) {
//       print('Unexpected error: $e');
//       print('Stack trace: $stackTrace');
//       return null;
//     }
//   }



// Fetch User Profile Data
  static Future<salesProfileandImage?> fetchSalesProfileData(
      {required String type}) async {
    try {
      // Check token
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: token not found in secure storage');
        return null;
      }
      log('Token found: ${token.substring(0, 10)}...'); // Show first 10 chars for security

      // Make API call
      final url = '${ApiList.saleProfile}?type=$type';
      log('Requesting URL: $url');

      var response = await client.get(
        Uri.parse(url),
        headers: {
          'token': token,
        },
      );

      print('Response fetch profile:  ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          print('Response body received, attempting to parse JSON');
          List<dynamic> data = jsonDecode(response.body);
          print('Parsed JSON data: $data');

          if (data.isEmpty) {
            return null;
          } else {
            try {
              saleProfile profile = saleProfile.fromJson(data.first);
              print('Successfully created profile object  ');

              if (data.first['image'] != null && data.first['image'] is String) {
                print('Image data found, creating GetImage object');
                GetImage image = GetImage.fromJson(data.first);
                print('Successfully created image object  ${profile.name}');
                return salesProfileandImage(profile: profile, image: image);
              } else {
                print('No image data found or invalid image data');
                return salesProfileandImage(profile: profile, image: null);
              }
            } catch (e) {
              print('Error creating profile/image objects: $e');
              return null;
            }
          }
        } else {
          print('Error: Response body is empty');
          return null;
        }
      } else {
        log('Failed to fetch sales profile data: ${response.statusCode}');
        log('Error response body: ${response.body}');
        return null;
      }
    } on SocketException catch (e) {
      log('SocketException: ${e.message}');
      return null;
    } on http.ClientException catch (e) {
      log('ClientException: ${e.message}');
      return null;
    } catch (e, stackTrace) {
      print('Unexpected error: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }






// update profile
  static Future<bool> patchSalesProfileData({
    required String id,
    required String type,
    required Map<String, dynamic> updateData,
  }) async {
    try {
      // Check token
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: token not found in secure storage');
        return false;
      }
      log('Token found: ${token.substring(0, 10)}...'); // Show first 10 chars for security

      // Make API call
      final url = '${ApiList.saleProfile}$id';


      var response = await client.patch(
        Uri.parse(url),
        headers: {
          'token': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updateData),
      );

      print('Response Status Code: ${response.statusCode}');
      log('Response Headers: ${response.headers}');
      print('Response Body of update profile: ${response.body}');

      if (response.statusCode == 201) {
        // if (response.body.isNotEmpty) {
        //   log('Response body received, verifying update success');
        //   var data = jsonDecode(response.body);
        //   log('Parsed response data: $data');

        //   // Check if update was successful based on response
        //   if ( data['status'] == true) {
        //     log('Profile update successful');
        //     return true;
        //   } else {
        //     log('Update failed: Response indicates failure');
        //     return false;
        //   }
        // } else {
        //   log('Error: Response body is empty');
        //   return false;
        // }
        Map<String, dynamic> responseData = jsonDecode(response.body);
        if(responseData.containsKey("status") && responseData["status"] == true){
          return true;
        }else{
          return false;
        }
      } else {
        print('Failed to update sales profile: ${response.statusCode}');
        print('Error response body: ${response.body}');
        return false;
      }
    } on SocketException catch (e) {
      print('SocketException: ${e.message}');
      return false;
    } on http.ClientException catch (e) {
      log('ClientException: ${e.message}');
      return false;
    } catch (e, stackTrace) {
      print('Unexpected error: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }




// Update profile
  static Future<bool?> updateSalesProfileData({
    required String id,
    required String type,
    required Map<String, dynamic> updateData,
  }) async {
    try {
      // Fetch the token from Flutter Secure Storage
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: Token not found in Flutter Secure Storage');
        return null;
      }

      // Create multipart request
      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse("${ApiList.saleProfile!}$id"),
      );

      // Add headers
      request.headers.addAll({
        'token': token,
      });

      // Add image if it exists and is a base64 string
      if (updateData["image"] != null) {
        // Decode base64 string to bytes
        var imageStream = http.ByteStream(updateData["image"].openRead());
        var length = await updateData["image"].length();
        var multipartFile = http.MultipartFile(
            'image', // This should match your API's expected field name
            imageStream,
            length,
            filename: updateData["image"].path.split('/').last
        );
        request.files.add(multipartFile);
      }

      // Convert fields to Map<String, String>
      var fields = <String, String>{};
      fields['name'] = updateData["name"].toString();
      fields['type'] = type;
      fields['email'] = updateData["email"].toString();
      fields['number'] = updateData["number"].toString();
      fields['industry'] = updateData["industry"].toString();
      fields['about'] = updateData["about"].toString();
      fields['state'] = updateData["state"].toString();
      fields['city'] = updateData["city"].toString();
      fields["interest"] = updateData["interest"].toString();

      // Add optional fields if they are provided
      if (updateData["webUrl"] != null) {
        fields['web_url'] = updateData["webUrl"].toString();
      }
      if (updateData["occupation"] != null) {
        fields['experiance'] = updateData["occupation"].toString();
      }

      request.fields.addAll(fields);

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print(
          'Response of profile update: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        bool status = responseBody['status'];
        return status;
      } else {
        print('Failed to update profile: ${response.statusCode}');
        return false;
      }
    } on SocketException catch (e) {
      log('SocketException: ${e.message}');
      return null;
    } on http.ClientException catch (e) {
      log('ClientException: ${e.message}');
      return null;
    } catch (e) {
      print('Unexpected error: $e');
      return null;
    }
  }



  // Delete User Profile
  static Future<void> deleteUserProfile() async {
    try {
      final token = await storage.read(
          key: 'token'); // Retrieve token from secure storage
      if (token == null) {
        log('Error: token not found in secure storage');
        throw Exception('No token found');
      }

      var response = await client.delete(
        Uri.parse(ApiList.saleProfile!),
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
}

class saleProfile {
  final String? id;
  final String? name;
  final String? number;
  final String? email;
  final String? industry;
  final String? webUrl;
  final String? state;
  final String? city;
  final String? experience;
  final String? interest;
  final String? about;
  final String? createdAt;
  final String? updatedAt;
  final String? type;
  final int? user;

  saleProfile({
    this.id,
    this.name = '',
    this.number = '',
    this.email = '',
    this.industry = '',
    this.webUrl = '',
    this.state = '',
    this.city = '',
    this.experience = '',
    this.interest = '',
    this.about = '',
    this.createdAt = '',
    this.updatedAt = '',
    this.type = '',
    this.user = 0,
  });

  factory saleProfile.fromJson(Map<String, dynamic> json) {
    return saleProfile(
      id: json['id'].toString(),
      name: json['name'] ?? "",
      number: json['number'] ?? "",
      email: json['email'] ?? "",
      industry: json['industry'] ?? "",
      webUrl: json['web_url'] ?? "",
      state: json['state'] ?? "",
      city: json['city'] ?? "",
      experience:
      json['experiance'] ?? "",
      interest: json['interest'] ?? "",
      about: json['about'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      type: json['type'] ?? "",
      user: json['user'] ?? 0,
    );
  }
}

class GetImage {
  final String? image;

  GetImage({
    this.image,
  });
  factory GetImage.fromJson(Map<String, dynamic> json) {
    String? imageUrl = validateUrl(json['image']) ??
        'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=600';

    return GetImage(
      image: imageUrl,
    );
  }

  // Helper method to validate URL format
  static String? validateUrl(String? url) {
    const String baseUrl = ApiList.imageBaseUrl;

    if (url == null || url.isEmpty) {
      return null; // null
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

class salesProfileandImage {
  final saleProfile profile;
  final GetImage? image;

  salesProfileandImage({
  required this.profile,
  this.image,
  });
}
