// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:http/http.dart' as http;
//
// import 'api_list.dart';
//
// class WishList {
//   static var client = http.Client();
//   static Future<bool?> wishList({
//     required String userId,
//     required String productId,
//   }) async {
//     var body = jsonEncode({
//       "userId": userId,
//       "productId": productId,
//     });
//
//     try {
//       var response = await client.post(
//         Uri.parse(ApiList.wishList!),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: body,
//       );
//       print('Response: ${response.statusCode} - ${response.body}');
//       Map<String, dynamic> responseBody = json.decode(response.body);
//       bool status = responseBody['status'];
//       if (status) {
//         return status;
//       } else {
//         log('Failed to add item to wishlist: ${response.statusCode}');
//         return false;
//       }
//     } on SocketException catch (e) {
//       log('SocketException: ${e.message}');
//       return null;
//     } on http.ClientException catch (e) {
//       log('ClientException: ${e.message}');
//       return null;
//     } catch (e) {
//       log('Unexpected error: $e');
//       return null;
//     }
//   }
// }

//
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'api_list.dart';
//
// class WishList {
//   static var client = http.Client();
//
//   // Method to add item to wishlist
//   static Future<bool?> wishList({
//     required String userId,
//     required String productId,
//   }) async {
//     var body = jsonEncode({
//       "userId": userId,
//       "productId": productId,
//     });
//
//     try {
//       var response = await client.post(
//         Uri.parse(ApiList.wishList!),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: body,
//       );
//       print('Response: ${response.statusCode} - ${response.body}');
//       Map<String, dynamic> responseBody = json.decode(response.body);
//       bool status = responseBody['status'];
//       if (status) {
//         return status;
//       } else {
//         log('Failed to add item to wishlist: ${response.statusCode}');
//         return false;
//       }
//     } on SocketException catch (e) {
//       log('SocketException: ${e.message}');
//       return null;
//     } on http.ClientException catch (e) {
//       log('ClientException: ${e.message}');
//       return null;
//     } catch (e) {
//       log('Unexpected error: $e');
//       return null;
//     }
//   }
//
//   // Method to remove item from wishlist
//   static Future<bool?> removeFromWishlist({
//     required String userId,
//     required String productId,
//   }) async {
//     try {
//       var response = await client.delete(
//         Uri.parse('${ApiList.wishList!}$userId?productId=$productId'),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       );
//       print('Response: ${response.statusCode} - ${response.body}');
//       Map<String, dynamic> responseBody = json.decode(response.body);
//       bool status = responseBody['status'];
//       if (status) {
//         return status;
//       } else {
//         log('Failed to remove item from wishlist: ${response.statusCode}');
//         return false;
//       }
//     } on SocketException catch (e) {
//       log('SocketException: ${e.message}');
//       return null;
//     } on http.ClientException catch (e) {
//       log('ClientException: ${e.message}');
//       return null;
//     } catch (e) {
//       log('Unexpected error: $e');
//       return null;
//     }
//   }
//
//   // Method for fetching wishlist items
//   static Future<List<Wishlist>?> fetchWishlistData() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final userId = prefs.getInt('userId');
//       if (userId == null) {
//         log('Error: userId not found in SharedPreferences');
//         return null;
//       }
//
//       var response =
//       await client.get(Uri.parse('${ApiList.wishList!}$userId'));
//       print('Response: ${response.statusCode} - ${response.body}');
//
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body) as List;
//         List<Wishlist> wishlistItems =
//         data.map((json) => Wishlist.fromJson(json)).toList();
//         return wishlistItems;
//       } else {
//         log('Failed to fetch wishlist data: ${response.statusCode}');
//         return null;
//       }
//     } on SocketException catch (e) {
//       log('SocketException: ${e.message}');
//       return null;
//     } on http.ClientException catch (e) {
//       log('ClientException: ${e.message}');
//       return null;
//     } catch (e) {
//       log('Unexpected error: $e');
//       return null;
//     }
//   }
// }
//
// class Wishlist {
//   final String id;
//   final String imageUrl;
//   final String name;
//   final String city;
//   final String postedTime;
//
//   Wishlist({
//     required this.id,
//     required this.imageUrl,
//     required this.name,
//     required this.city,
//     required this.postedTime,
//   });
//
//   factory Wishlist.fromJson(Map<String, dynamic> json) {
//     return Wishlist(
//       id: json['id'].toString(),
//       imageUrl: validateUrl(json['image1']) ?? 'https://via.placeholder.com/400x200',
//       name: json['name'] ?? 'N/A',
//       city: json['city'] ?? 'N/A',
//       postedTime: json['listed_on'] ?? 'N/A',
//     );
//   }
//
//   static String? validateUrl(String? url) {
//     const String baseUrl = 'https://suhail101.pythonanywhere.com/';
//
//     if (url == null || url.isEmpty) {
//       return null;
//     }
//
//     Uri? uri;
//     try {
//       uri = Uri.parse(url);
//       if (!uri.hasScheme) {
//         url = url.startsWith('/') ? url.substring(1) : url;
//         url = baseUrl + url;
//         uri = Uri.parse(url);
//       }
//       if (uri.hasScheme && (uri.hasAuthority || uri.host.isNotEmpty)) {
//         return url;
//       }
//     } catch (e) {
//       return null;
//     }
//     return null;
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/all profile model.dart';
import 'api_list.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



class WishList {
  static var client = http.Client();
  static final storage = FlutterSecureStorage(); // Initialize secure storage

  // Method to add item to wishlist
  static Future<bool?> wishList({
    required String productId,
  }) async {
    final token = await storage.read(key: 'token'); // Retrieve token from secure storage

    if (token == null) {
      log('Error: token not found in secure storage');
      return null;
    }

    var body = jsonEncode({
      "productId": productId,
    });

    try {
      var response = await client.post(
        Uri.parse(ApiList.wishList!),
        headers: {
          'Content-Type': 'application/json',
          'token': token, // Add token to request headers
        },
        body: body,
      );
      print('Response: ${response.statusCode} - ${response.body}');
      Map<String, dynamic> responseBody = json.decode(response.body);
      bool status = responseBody['status'];
      if (status) {
        return status;
      } else {
        log('Failed to add item to wishlist: ${response.statusCode}');
        return false;
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

  // Method to remove item from wishlist
  static Future<bool?> removeFromWishlist({
    required String productId,
  }) async {
    final token = await storage.read(key: 'token'); // Retrieve token from secure storage

    if (token == null) {
      log('Error: token not found in secure storage');
      return null;
    }

    try {
      var response = await client.delete(
        Uri.parse('${ApiList.wishList!}?productId=$productId'),
        headers: {
          'Content-Type': 'application/json',
          'token': token, // Add token to request headers
        },
      );
      print('Response: ${response.statusCode} - ${response.body}');
      Map<String, dynamic> responseBody = json.decode(response.body);
      bool status = responseBody['status'];
      if (status) {
        return status;
      } else {
        log('Failed to remove item from wishlist: ${response.statusCode}');
        return false;
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

  // Method for fetching wishlist items
  static Future<Map<String, dynamic>?> fetchWishlistData() async {
    final token = await storage.read(key: 'token'); // Retrieve token from secure storage

    if (token == null) {
      log('Error: token not found in secure storage');
      return null;
    }

    try {
      var response = await client.get(
        Uri.parse(ApiList.wishList!),
        headers: {
          'token': token, // Add token to request headers
        },
      );
      print('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;
        List<ProductDetails> wishlistItems =
        data.map((json) => ProductDetails.fromJson(json)).toList();
        List<BusinessInvestorExplr> wishlistAllItems =
        data.map((json) => BusinessInvestorExplr.fromJson(json)).toList();
        List<FranchiseExplr> wishlistFranchiseItems =
        data.map((json) => FranchiseExplr.fromJson(json)).toList();

        return {
          "wishlist": wishlistItems,
          "wishlistAll": wishlistAllItems,
          "wishlistFranchiseItems": wishlistFranchiseItems
        };
      } else {
        log('Failed to fetch wishlist data: ${response.statusCode}');
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
  final String type;
  final String imageUrl;
  final String name;
  final String city;
  final String postedTime;

  ProductDetails({
    required this.id,
    required this.type,
    required this.imageUrl,
    required this.name,
    required this.city,
    required this.postedTime,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      id: json['id'].toString(),
      type: json['entity_type'].toString(),
      imageUrl: validateUrl(json['image1']) ?? 'https://via.placeholder.com/400x200',
      name: json['name'] ?? 'N/A',
      city: json['city'] ?? "json['locations_available'],",
      postedTime: json['listed_on'] ?? 'N/A',
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
