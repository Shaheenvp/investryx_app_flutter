// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//
// import 'api_list.dart';
//
// class QuestionnairePost {
//   static var client = http.Client();
//   static final storage = FlutterSecureStorage();
//
//   static Future<bool?> questionnairePost({
//     String? userId,
//     String? city,
//     String? state,
//     String? businessStage,
//     String? businessGoal,
//     String? operationDuration,
//     String? budget,
//     String? industry,
//     List<String>? selectedStates,
//     Map<String, List<String>>? selectedCities,
//     String? frequency,
//     // Optional parameters for investor
//     String? type,
//     String? investmentInterest,
//     String? investmentHorizon,
//     String? riskTolerance,
//     String? priorExperience,
//     // Optional parameters for franchise
//     String? buyOrStart,
//     String? franchiseTypes,
//     String? brands,
//     // Optional parameters for advisor
//     String? expertise,
//     String? clientType,
//     String? experience,
//     String? advisoryDuration,
//   }) async {
//     // Retrieve the token from Flutter secure storage
//     String? token = await storage.read(key: 'token');
//     if (token == null) {
//       log('Token is missing');
//       return null;
//     }
//
//     // Create base request body with non-null values only
//     Map<String, dynamic> requestBody = {};
//
//     // Helper function to add non-null values to request body
//     void addIfNotNull(String key, dynamic value) {
//       if (value != null) {
//         requestBody[key] = value;
//       }
//     }
//
//     // Add all parameters if they are not null
//     addIfNotNull("city", city);
//     addIfNotNull("state", state);
//     addIfNotNull("business_stage", businessStage);
//     addIfNotNull("business_goal", businessGoal);
//     addIfNotNull("business_duration", operationDuration);
//     addIfNotNull("budget", budget);
//     addIfNotNull("industry", industry);
//     addIfNotNull("interested_state", selectedStates);
//     addIfNotNull("interested_city", selectedCities);
//     addIfNotNull("frequency", frequency);
//
//     // Investor parameters
//     addIfNotNull("profile", type);
//     addIfNotNull("investment_interest", investmentInterest);
//     addIfNotNull("investment_horizon", investmentHorizon);
//     addIfNotNull("risk_tolerance", riskTolerance);
//     addIfNotNull("investment_experience", priorExperience);
//
//     // Franchise parameters
//     addIfNotNull("buy_start", buyOrStart);
//     addIfNotNull("franchise_type", franchiseTypes);
//     addIfNotNull("franchise_brands", brands);
//
//     // Advisor parameters
//     addIfNotNull("expertise", expertise);
//     addIfNotNull("client_type", clientType);
//     addIfNotNull("advisor_experience", experience);
//     addIfNotNull("advisory_duration", advisoryDuration);
//
//     try {
//       var response = await client.post(
//         Uri.parse(ApiList.questionnaire!),
//         headers: {
//           'Content-Type': 'application/json',
//           'token': token,
//         },
//         body: jsonEncode(requestBody),
//       );
//
//       log('Response: ${response.statusCode} - ${response.body}');
//
//       if (response.statusCode == 200) {
//         Map<String, dynamic> responseBody = json.decode(response.body);
//         return responseBody['status'] ?? false;
//       } else {
//         log('Failed to submit questionnaire: ${response.statusCode}');
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



import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_list.dart';

// Custom exception for questionnaire-related errors
class QuestionnaireException implements Exception {
  final String message;
  final int? statusCode;

  QuestionnaireException(this.message, {this.statusCode});

  @override
  String toString() => 'QuestionnaireException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class QuestionnairePost {
  static final client = http.Client();
  static final storage = FlutterSecureStorage();

  static Future<bool> questionnairePost({
    String? userId,
    String? city,
    String? state,
    String? businessStage,
    String? businessGoal,
    String? operationDuration,
    String? budget,
    String? industry,
    List<String>? selectedStates,
  List<String>? selectedCities,
    String? frequency,
    // Optional parameters for investor
    String? type,
    String? investmentInterest,
    String? investmentHorizon,
    String? riskTolerance,
    String? priorExperience,
    // Optional parameters for franchise
    String? buyOrStart,
    String? franchiseTypes,
    String? brands,
    // Optional parameters for advisor
    String? expertise,
    String? clientType,
    String? experience,
    String? advisoryDuration,
  }) async {
    // Retrieve and validate token
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw QuestionnaireException('Authentication token is missing');
    }

    // Create request body with non-null values
    Map<String, dynamic> requestBody = {
      if (city != null) "city": city,
      if (state != null) "state": state,
      if (businessStage != null) "business_stage": businessStage,
      if (businessGoal != null) "business_goal": businessGoal,
      if (operationDuration != null) "business_duration": operationDuration,
      if (budget != null) "budget": budget,
      if (industry != null) "industry": industry,
      if (selectedStates != null) "interested_state": selectedStates,
      if (selectedCities != null) "interested_city": selectedCities,
      if (frequency != null) "frequency": frequency,
      // Investor parameters
      if (type != null) "profile": type,
      if (investmentInterest != null) "investment_interest": investmentInterest,
      if (investmentHorizon != null) "investment_horizon": investmentHorizon,
      if (riskTolerance != null) "risk_tolerance": riskTolerance,
      if (priorExperience != null) "investment_experience": priorExperience,
      // Franchise parameters
      if (buyOrStart != null) "buy_start": buyOrStart,
      if (franchiseTypes != null) "franchise_type": franchiseTypes,
      if (brands != null) "franchise_brands": brands,
      // Advisor parameters
      if (expertise != null) "expertise": expertise,
      if (clientType != null) "client_type": clientType,
      if (experience != null) "advisor_experience": experience,
      if (advisoryDuration != null) "advisory_duration": advisoryDuration,
    };

    try {
      final response = await client.post(
        Uri.parse(ApiList.questionnaire!),
        headers: {
          'Content-Type': 'application/json',
          'token': token,
        },
        body: jsonEncode(requestBody),
      );

      log('Questionnaire Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['status'] == true) {
          return true;
        }
        throw QuestionnaireException(
          responseBody['message'] ?? 'Submission failed',
          statusCode: response.statusCode,
        );
      }

      throw QuestionnaireException(
        'Server error occurred',
        statusCode: response.statusCode,
      );
    } on SocketException {
      throw QuestionnaireException('Network connection error');
    } on FormatException {
      throw QuestionnaireException('Invalid response format');
    } on http.ClientException catch (e) {
      throw QuestionnaireException('Request failed: ${e.message}');
    } catch (e) {
      if (e is QuestionnaireException) rethrow;
      throw QuestionnaireException('Unexpected error: $e');
    }
  }
}