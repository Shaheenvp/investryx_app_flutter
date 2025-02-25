import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project_emergio/models/all%20profile%20model.dart';
import 'package:project_emergio/services/api_list.dart';
import 'package:project_emergio/services/recent%20activities.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SearchResult {
  final String name;
  final String description;
  final String imageUrl;
  final String location;
  final String type;
  final String id;
  final String title;
  final String singleLineDescription;
  final Map<String, dynamic> rawData;
  final bool isLiked;
  final String? entityType;
  final String? logo;

  SearchResult(
      {required this.name,
        required this.description,
        required this.imageUrl,
        required this.title,
        required this.singleLineDescription,
        required this.location,
        required this.type,
        required this.id,
        required this.rawData,
        this.isLiked = false,
        this.entityType,
        this.logo});

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    final entityType = json['entity_type'] ?? 'Unknown';
    final name = entityType.toLowerCase() == 'investor'
        ? json['company'] ?? json['name'] ?? 'Unknown'
        : json['name'] ?? json['company'] ?? 'Unknown';

    return SearchResult(
        name: name,
        description: json['description'] ?? 'No description provided',
        title: json['title'] ?? "N/A",
        singleLineDescription: json['single_desc'] ?? 'No description provided',
        imageUrl: validateUrl(json['image1']) ??
            'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
        location: json['city'] ?? 'No location provided',
        type: json["type"] ?? entityType,
        id: json['id']?.toString() ?? '',
        rawData: json,
        isLiked: json['is_liked'] ?? false,
        entityType: json["entity_type"] ?? "N/A",
        logo:
        validateUrl(json["logo"] ?? "https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM="));
  }

  static String? validateUrl(String? url) {
    const String baseUrl = ApiList.imageBaseUrl;
    if (url == null || url.isEmpty) return null;
    try {
      Uri uri = Uri.parse(url);
      if (!uri.hasScheme) {
        url = url.startsWith('/') ? url.substring(1) : url;
        url = baseUrl + url;
      }
      return url;
    } catch (e) {
      return null;
    }
  }
}

class SearchServices {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<List<String>> loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList('recent_searches') ?? [];
  }

  Future<void> saveRecentSearch(
      String query, List<String> currentSearches) async {
    if (query.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    currentSearches.remove(query);
    currentSearches.insert(0, query);
    if (currentSearches.length > 6) {
      currentSearches.removeLast();
    }
    await prefs.setStringList('recent_searches', currentSearches);
  }

  Future<void> clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recent_searches');
  }

  Future<List<SearchResult>> getRecentResults() async {
    try {
      final token = await _storage.read(key: 'token');
      print(token);

      if (token == null) {
        return [];
      }

      final url = '${ApiList.baseUrl}/recent-results';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'token': token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['data'] as List;
        return results.map((item) => SearchResult.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Error loading recent results: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> performSearch(
      {required String query,
        String city = '',
        String state = '',
        String industry = '',
        String entityType = '',
        String establishFrom = '',
        String establishTo = '',
        String rangeStarting = '',
        String rangeEnding = '',
        bool filter = false,
        String preference = '',
        String entity = '',
        String transaction = ''}) async {
    try {
      final queryParams = Uri(
        queryParameters: {
          'query': query,
          'city': city,
          'state': state,
          'industry': industry,
          'entity_type': entityType,
          'establish_from': establishFrom,
          'establish_to': establishTo,
          'range_starting': rangeStarting,
          'range_ending': rangeEnding,
          'filter': filter.toString(),
        },
      ).query;

      final token = await _storage.read(key: 'token');

      if (token == null) {
        return {
          'success': false,
          'error': 'Authentication error. Please login again.',
          'results': <SearchResult>[],
        };
      }

      final url = '${ApiList.baseUrl}/search?$queryParams';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'token': token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['data'];

        if (results.isEmpty) {
          return {
            'success': false,
            'error': 'No results found for "$query"',
            'results': <SearchResult>[],
          };
        }

        final searchResults = List<SearchResult>.from(
          results.map((item) => SearchResult.fromJson(item)),
        );

        return {
          'success': true,
          'results': searchResults,
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to fetch results. Please try again.',
          'results': <SearchResult>[],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error':
        'An error occurred. Please check your connection and try again.',
        'results': <SearchResult>[],
      };
    }
  }




  Future<Map<String, dynamic>> searchFilter(
      {
        String city = '',
        String state = '',
        String industry = '',
        String entityType = '',
        String establishFrom = '',
        String establishTo = '',
        String rangeStarting = '',
        String rangeEnding = '',
        String preference = '',
        String entity = '',

        String ebitda = ''}) async {
    try {
      final queryParams = Uri(
        queryParameters: {

          'city': city,
          'state': state,
          'industry': industry,
          'entity_type': entityType,
          'establish_from': establishFrom,
          'establish_to': establishTo,
          'range_starting': rangeStarting,
          'range_ending': rangeEnding,
          "ebitda": ebitda,
          "entity": entity

        },
      ).query;

      final token = await _storage.read(key: 'token');

      if (token == null) {
        return {
          'success': false,
          'error': 'Authentication error. Please login again.',
          'results': <SearchResult>[],
        };
      }

      final url = '${ApiList.filterSearch}?$queryParams';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'token': token,
          'Content-Type': 'application/json',
        },
      );

      print("response of serach filteres  ${response.statusCode},  ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['data'];

        if (results.isEmpty) {
          return {
            'success': false,
            'error': 'No results found',
            'results': <SearchResult>[],
          };
        }

        final searchResults = List<SearchResult>.from(
          results.map((item) => SearchResult.fromJson(item)),
        );

        print("search result   ${searchResults.length}");

        return {
          'success': true,
          'results': searchResults,
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to fetch results. Please try again.',
          'results': <SearchResult>[],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error':
        'An error occurred. Please check your connection and try again.',
        'results': <SearchResult>[],
      };
    }
  }

  // Future<List<Recent>?> fetchPopularSearches() async {
  //   final token = await _storage.read(key: 'token');
  //   try {
  //     final url = Uri.parse(ApiList.popularSearch.toString());

  //     final response = await http.get(url, headers: {
  //       "token": token.toString(),
  //       'Content-Type': 'application/json',
  //     });

  //     print(
  //         "Response fetching popular search ${response.statusCode},  ${response.body}");

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> responseData = jsonDecode(response.body);
  //       List<dynamic> data = responseData["data"]; // Changed to List<dynamic>
  //       List<dynamic> sendLists = [];
  //       List<Map<String, dynamic>> Data = (responseData["data"] as List)
  //           .whereType<Map<String, dynamic>>()
  //           .toList();
  //       List<Recent> recents = [];

  //       print("Post data: ${Data}");
  //       for (var item in Data) {
  //         if (item != null) {
  //           recents.add(Recent.fromJson(item["post"]));
  //           sendLists.add(item["post"]);
  //         }
  //       }

  //       print("Total items:${sendLists.length},  ${recents.length}");
  //       return recents;
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //     return null;
  //   }
  // }

  Future<List<Recent>?> fetchPopularSearches() async {
    final token = await _storage.read(key: 'token');
    try {
      final url = Uri.parse(ApiList.popularSearch.toString());

      final response = await http.get(url, headers: {
        "token": token.toString(),
        'Content-Type': 'application/json',
      });

      print(
          "Response fetching popular search: ${response.statusCode}, ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);

        List<Recent> _recents = [];
        // Ensure data is a list before proceeding
        for (var item in responseData) {
          _recents.add(Recent.fromJson(item["post"]));
        }

        return _recents;
      } else {
        print(
            "Error: Failed to fetch popular searches, status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching popular searches: $e");
      return null;
    }
  }

  static Future<void> postToPopularSearch(String id) async {
    try {
      final prefs = await FlutterSecureStorage();
      final token = await prefs.read(key: 'token');

      final url = Uri.parse(ApiList.popularSearch.toString());

      final response = await http.post(url, body: {
        "post_id": id
      }, headers: {
        "token": token.toString(),
      });

      print(
          "response of posting popular search ${response.statusCode},   ${response.body}");
      if (response.statusCode == 201) {
        print("Added to popular search successfully");
      } else {
        print("error adding to popular search");
      }
    } catch (e) {
      print(e);
    }
  }

  // static Future<void> postToRecentSearch(String id) async {
  //   try {
  //     final prefs = await FlutterSecureStorage();
  //     final token = await prefs.read(key: 'token');
  //
  //     final url = Uri.parse(ApiList.recentSearch.toString());
  //
  //     final response = await http.post(url, body: {
  //       "post_id": id
  //     }, headers: {
  //       "token": token.toString(),
  //     });
  //
  //     print(
  //         "response of posting recent search ${response.statusCode},   ${response.body}");
  //     if (response.statusCode == 201) {
  //       print("Added to recent search successfully");
  //     } else {
  //       print("error adding to recent search");
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // static Future<List<Recent>?> fetchRecentSearches() async {
  //   try {
  //     final prefs = await FlutterSecureStorage();
  //     final token = await prefs.read(key: 'token');
  //
  //     final url = Uri.parse(ApiList.recentSearch.toString());
  //
  //     final response =
  //     await http.get(url, headers: {"token": token.toString()});
  //
  //     print("fetch recent ${response.statusCode},   ${response.body}");
  //
  //     if (response.statusCode == 200) {
  //       List<dynamic> responseData = await jsonDecode(response.body);
  //
  //       List<Recent> recents = [];
  //
  //       for (var item in responseData) {
  //         if (item != null) {
  //           recents.add(Recent.fromJson(item["post"]));
  //         }
  //       }
  //
  //       print("Total recent searched items:${recents.length}");
  //       return recents;
  //     }
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  //   }
}
