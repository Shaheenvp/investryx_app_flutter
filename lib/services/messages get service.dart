// // import 'dart:convert';
// // import 'dart:developer';
// // import 'dart:io';
// // import 'package:http/http.dart' as http;
// // import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// // import 'api_list.dart';
// //
// //
// // class MessageService {
// //   static final client = http.Client();
// //   static final storage = FlutterSecureStorage();
// //
// //   static Future<List<MessageData>?> fetchMessageData(String id) async {
// //     try {
// //       final token = await storage.read(key: 'token');
// //       if (token == null) {
// //         log('Error: token not found in Flutter Secure Storage');
// //         return null;
// //       }
// //
// //       final response = await client.get(
// //         Uri.parse('${ApiList.message}?roomId=$id'),
// //         headers: {
// //           'token': token,
// //         },
// //       );
// //
// //       log('Response body: ${response.body}');
// //
// //       if (response.statusCode == 200) {
// //         var data = jsonDecode(response.body);
// //
// //         if (data is Map<String, dynamic> && data.containsKey('messages')) {
// //           final messages = data['messages'] as List;
// //           final defaultNumber = data['number'] as String?;
// //           return messages.map((json) => MessageData.fromJson(json, defaultNumber)).toList();
// //         } else {
// //           log('Unexpected response format: ${data.runtimeType}');
// //           return null;
// //         }
// //       } else {
// //         log('Failed to fetch message data: ${response.statusCode}');
// //         return null;
// //       }
// //     } on SocketException catch (e) {
// //       log('SocketException: ${e.message}');
// //       return null;
// //     } on http.ClientException catch (e) {
// //       log('ClientException: ${e.message}');
// //       return null;
// //     } catch (e) {
// //       log('Unexpected error: $e');
// //       return null;
// //     }
// //   }
// // }
// //
// // class MessageData {
// //   final String? message;
// //   final String sendedBy;
// //   final String sendedTo;
// //   final String? time;
// //   final String? phoneNumber;
// //
// //   MessageData({
// //     this.message,
// //     required this.sendedBy,
// //     required this.sendedTo,
// //     this.time,
// //     this.phoneNumber,
// //   });
// //
// //   factory MessageData.fromJson(Map<String, dynamic> json, String? defaultNumber) {
// //     final senderObj = json['sended_by'];
// //     final receiverObj = json['sended_to'];
// //
// //     final senderPhone = senderObj?['username'] as String?;
// //     final receiverPhone = receiverObj?['username'] as String?;
// //
// //     return MessageData(
// //       message: json['message'],
// //       sendedBy: senderObj?['id']?.toString() ?? '',
// //       sendedTo: receiverObj?['id']?.toString() ?? '',
// //       time: json['timestamp'],
// //       phoneNumber: defaultNumber ?? '', // Using the number from root JSON
// //     );
// //   }
// // }
//
//
//
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'api_list.dart';
//
// class MessageService {
//   static final _client = http.Client();
//   static final _storage = FlutterSecureStorage();
//
//   static Future<MessageDataResponse?> fetchMessageData(String id) async {
//     try {
//       final token = await _storage.read(key: 'token');
//       if (token == null) {
//         log('Error: token not found in Flutter Secure Storage');
//         return null;
//       }
//
//       final response = await _client.get(
//         Uri.parse('${ApiList.message}?roomId=$id'),
//         headers: {
//           'token': token,
//         },
//       );
//
//       log('Response body: ${response.body}');
//
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         if (data is Map<String, dynamic> && data.containsKey('messages')) {
//           final messages = data['messages'] as List;
//           final number = data['number'] as String?;
//
//           return MessageDataResponse(
//             messages: messages.map((json) => MessageData.fromJson(json)).toList(),
//             phoneNumber: number ?? '',
//           );
//         } else {
//           log('Unexpected response format: ${data.runtimeType}');
//           return null;
//         }
//       } else {
//         log('Failed to fetch message data: ${response.statusCode}');
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
//
// class MessageDataResponse {
//   final List<MessageData> messages;
//   final String phoneNumber;
//
//   MessageDataResponse({
//     required this.messages,
//     required this.phoneNumber,
//   });
// }
//
// class MessageData {
//   final String? message;
//   final String sendedBy;
//   final String sendedTo;
//   final String? time;
//   final String? audioData;
//   final String? duration;
//
//   MessageData({
//     this.message,
//     required this.sendedBy,
//     required this.sendedTo,
//     this.time,
//     this.audioData,
//     this.duration,
//   });
//
//   factory MessageData.fromJson(Map<String, dynamic> json) {
//     final senderObj = json['sended_by'];
//     final receiverObj = json['sended_to'];
//
//     return MessageData(
//       message: json['message'],
//       audioData: json['audio'],
//       duration: json['duration']?.toString(),
//       sendedBy: senderObj?['id']?.toString() ?? '',
//       sendedTo: receiverObj?['id']?.toString() ?? '',
//       time: json['timestamp'],
//     );
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_list.dart';

class MessageService {
  static final _client = http.Client();
  static final _storage = FlutterSecureStorage();

  static Future<MessageDataResponse?> fetchMessageData(String id) async {

    try {
      final token = await _storage.read(key: 'token');
      if (token == null) {
        log('Error: token not found in Flutter Secure Storage');
        return null;
      }

      final response = await _client.get(
        Uri.parse('${ApiList.message}?roomId=$id'),
        headers: {
          'token': token,
        },
      );

      log('Response body: ${response.body}');


      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('messages')) {
          final messages = data['messages'] as List;
          final number = data['number'] as String?;

          return MessageDataResponse(
            messages: messages.map((json) => MessageData.fromJson(json)).toList(),
            phoneNumber: number ?? '',
          );
        } else {
          log('Unexpected response format: ${data.runtimeType}');
          return null;
        }
      } else {
        log('Failed to fetch message data: ${response.statusCode}');
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

class MessageDataResponse {
  final List<MessageData> messages;
  final String phoneNumber;

  MessageDataResponse({
    required this.messages,
    required this.phoneNumber,
  });
}

class MessageData {
  final String? message;
  final String sendedBy;
  final String sendedTo;
  final String? time;
  final String? audioData;
  final String? duration;
  final Map<String, dynamic>? attachment;

  MessageData({
    this.message,
    required this.sendedBy,
    required this.sendedTo,
    this.time,
    this.audioData,
    this.duration,
    this.attachment,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) {
    final senderObj = json['sended_by'];
    final receiverObj = json['sended_to'];

    // Handle attachment data
    Map<String, dynamic>? attachmentData;
    if (json['attachment'] != null) {
      try {
        if (json['attachment'] is String) {
          // If attachment is a string (likely URL or base64), parse it
          attachmentData = {
            'url': json['attachment'],
            'type': _determineAttachmentType(json['attachment']),
            'fileName': _extractFileName(json['attachment']),
          };
        } else if (json['attachment'] is Map) {
          // If attachment is already a map, use it directly
          attachmentData = Map<String, dynamic>.from(json['attachment']);
        }
      } catch (e) {
        log('Error parsing attachment data: $e');
        attachmentData = null;
      }
    }

    return MessageData(
      message: json['message'],
      audioData: json['audio'],
      duration: json['duration']?.toString(),
      sendedBy: senderObj?['id']?.toString() ?? '',
      sendedTo: receiverObj?['id']?.toString() ?? '',
      time: json['timestamp'],
      attachment: attachmentData,
    );
  }

  // Helper method to determine attachment type from URL or data
  static String _determineAttachmentType(String data) {
    final lowerData = data.toLowerCase();
    if (lowerData.endsWith('.jpg') ||
        lowerData.endsWith('.jpeg') ||
        lowerData.endsWith('.png') ||
        lowerData.endsWith('.gif')) {
      return 'image';
    } else if (lowerData.endsWith('.pdf')) {
      return 'pdf';
    } else if (lowerData.endsWith('.doc') || lowerData.endsWith('.docx')) {
      return 'document';
    } else if (lowerData.startsWith('data:image')) {
      return 'image';
    }
    return 'file';
  }

  // Helper method to extract filename from URL or path
  static String _extractFileName(String path) {
    try {
      final uri = Uri.parse(path);
      final pathSegments = uri.pathSegments;
      if (pathSegments.isNotEmpty) {
        return pathSegments.last;
      }
    } catch (e) {
      log('Error extracting filename: $e');
    }
    return 'attachment';
  }
}