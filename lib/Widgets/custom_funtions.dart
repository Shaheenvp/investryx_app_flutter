import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_emergio/Views/Auth%20Screens/reg_otp%20verification.dart';
import 'package:project_emergio/Views/Profiles/Business/Business_profile_add_screen.dart';
import 'package:project_emergio/Views/Profiles/advisor/advisor_profile_add_screen.dart';
import 'package:project_emergio/Views/Profiles/franchise/franchise_profile_add_screen.dart';
import 'package:project_emergio/Views/Profiles/investor/investor_profile_add_screen.dart';
import 'package:project_emergio/Views/dashboard/dashboard_screen.dart';
import 'package:project_emergio/Views/detail%20page/advisor%20detail%20page.dart';
import 'package:project_emergio/Views/detail%20page/business%20deatil%20page.dart';
import 'package:project_emergio/Views/detail%20page/franchise%20detail%20page.dart';
import 'package:project_emergio/Views/detail%20page/invester%20detail%20page.dart';
import 'package:project_emergio/Views/pricing%20screen.dart';
import 'package:project_emergio/generated/constants.dart';
import 'package:project_emergio/models/all%20profile%20model.dart';
import 'package:project_emergio/services/check%20subscribe.dart';
import 'package:project_emergio/services/profile%20forms/business/BusinessAddPage.dart';
import 'package:project_emergio/services/sales_profile.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../services/search.dart';

class CustomFunctions {
  static String toStringValue(dynamic value) {
    if (value == null) return '';
    if (value is int || value is double) return value.toString();
    if (value is List) return value.join(', ');
    return value.toString();
  }

  static String formatDateTime(String dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr);
    return timeago.format(dateTime, allowFromNow: true);
  }

  static void navigateToDetail(
      SearchResult result, String id, BuildContext context) async {
    await SearchServices.postToPopularSearch(id);
    // await SearchServices.postToRecentSearch(id);

    switch (result.type.toLowerCase()) {
      case 'business':
        final businessData = {
          ...result.rawData,
          'employees': toStringValue(result.rawData['employees']),
          'avg_monthly': toStringValue(result.rawData['avg_monthly']),
          'latest_yearly': toStringValue(result.rawData['latest_yearly']),
          'ebitda': toStringValue(result.rawData['ebitda']),
          'rate': toStringValue(result.rawData['rate']),
          'postedTime': result.rawData['listed_on'],
          'establish_yr': toStringValue(result.rawData['establish_yr']),
        };

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BusinessDetailPage(
              buisines: BusinessInvestorExplr(
                id: result.id,
                imageUrl: result.imageUrl,
                image2: toStringValue(businessData['image2']),
                image3: toStringValue(businessData['image3']),
                name: result.name,
                city: result.location,
                postedTime: businessData['postedTime'],
                topSelling: toStringValue(businessData['topSelling']),
                address_1: toStringValue(businessData['address_1']),
                address_2: toStringValue(businessData['address_2']),
                industry: toStringValue(businessData['industry']),
                establish_yr: businessData['establish_yr'],
                description: result.singleLineDescription,
                pin: toStringValue(businessData['pin']),
                state: toStringValue(businessData['state']),
                employees: businessData['employees'],
                entity: toStringValue(businessData['entity']),
                avg_monthly: businessData['avg_monthly'],
                latest_yearly: businessData['latest_yearly'],
                ebitda: businessData['ebitda'],
                rate: businessData['rate'],
                type_sale: toStringValue(businessData['type_sale']),
                url: toStringValue(businessData['url']),
                features: toStringValue(businessData['features']),
                facility: toStringValue(businessData['facility']),
                income_source: toStringValue(businessData['income_source']),
                reason: toStringValue(businessData['reason']),
                singleLineDescription: toStringValue(result.rawData['single_desc']),
                title: toStringValue(result.rawData['title']),
              ),
              showEditOption: false,
            ),
          ),
        );
        break;

      case 'investor':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InvestorDetailPage(
              investor: BusinessInvestorExplr(
                topSelling: toStringValue(result.rawData['top_selling']),
                singleLineDescription: toStringValue(result.rawData['single_desc']),
                title: toStringValue(result.rawData['title']),
                imageUrl: result.imageUrl,
                image2: toStringValue(result.rawData['image2']),
                image3: toStringValue(result.rawData['image3']),
                image4: toStringValue(result.rawData['image4']),
                name: result.name,
                city: result.location,
                postedTime: result.rawData['listed_on'],
                state: toStringValue(result.rawData['state']),
                industry: toStringValue(result.rawData['industry']),
                description: result.description,
                url: toStringValue(result.rawData['url']),
                rangeStarting: toStringValue(result.rawData['range_starting']),
                rangeEnding: toStringValue(result.rawData['range_ending']),
                evaluatingAspects:
                toStringValue(result.rawData['evaluating_aspects']),
                companyName:
                toStringValue(result.rawData['company'] ?? result.name),
                locationIntrested:
                toStringValue(result.rawData['location_interested']),
                id: result.id,
                preference: result.rawData["preference"] is String
                    ? jsonDecode(result.rawData["preference"]) as List<dynamic>?
                    : result.rawData["preference"] as List<dynamic>?,
              ),
              showEditOption: false,
            ),
          ),
        );
        break;

      case 'franchise':
        final franchiseData = {
          ...result.rawData,
          'postedTime': formatDateTime(result.rawData['listed_on']),
          'currentNumberOfOutlets':
          toStringValue(result.rawData['currentNumberOfOutlets']),
          'spaceRequiredMin': toStringValue(result.rawData['min_space']),
          'spaceRequiredMax': toStringValue(result.rawData['max_space']),
          'totalInvestmentFrom':
          toStringValue(result.rawData['range_starting']),
          'totalInvestmentTo': toStringValue(result.rawData['range_ending']),
          'brandFee': toStringValue(result.rawData['brand_fee']),
          'avgNoOfStaff': toStringValue(result.rawData['staff']),
          'avgMonthlySales': toStringValue(result.rawData['avg_monthly_sales']),
          'avgEBITDA': toStringValue(result.rawData['ebitda']),
          'brandStartOperation': toStringValue(result.rawData['establish_yr']),
        };

        final parsedDate = DateTime.parse(result.rawData['listed_on']);
        print("parsed date is $parsedDate");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FranchiseDetailPage(
              franchise: FranchiseExplr(
                  title: '',
                  singleLineDescription: 'N/A',
                  imageUrl: result.imageUrl,
                  image2:
                  CustomFunctions.toStringValue(franchiseData['image2']),
                  image3:
                  CustomFunctions.toStringValue(franchiseData['image3']),
                  image4:
                  CustomFunctions.toStringValue(franchiseData["image4"]),
                  brandName: franchiseData["name"],
                  city: franchiseData["city"].toString(),
                  postedTime: franchiseData["postedTime"].toString(),
                  id: id.toString(),
                  allProducts: franchiseData["services"].toString(),
                  avgEBITDA: franchiseData["avgEBITDA"].toString(),
                  avgMonthlySales:
                  franchiseData["avg_monthly_sales"].toString(),
                  avgNoOfStaff: franchiseData["staff"].toString(),
                  brandFee: franchiseData["brandFee"].toString(),
                  brandStartOperation: franchiseData["establish_yr"],
                  companyName: franchiseData["company"].toString(),
                  currentNumberOfOutlets:
                  franchiseData["total_outlets"].toString(),
                  description: franchiseData["description"].toString(),
                  established_year: franchiseData["establish_yr"].toString(),
                  franchiseTerms: franchiseData["yr_period"].toString(),
                  iamOffering: franchiseData["offering"].toString(),
                  industry: franchiseData["industry"].toString(),
                  initialInvestment: franchiseData["initial"].toString(),
                  kindOfSupport: franchiseData["supports"],
                  locationsAvailable:
                  franchiseData["locations_available"].toString(),
                  projectedRoi: franchiseData["proj_ROI"].toString(),
                  logo: result.logo.toString(),
                  spaceRequiredMax: franchiseData["max_space"].toString(),
                  spaceRequiredMin: franchiseData["min_space"].toString(),
                  state: franchiseData["state"].toString(),
                  totalInvestmentFrom:
                  franchiseData["range_starting"].toString(),
                  totalInvestmentTo: franchiseData["range_ending"].toString(),
                  url: franchiseData["url"]),
              showEditOption: false,
            ),
          ),
        );
        break;

      case 'advisor':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdvisorDetailPage(),
          ),
        );
        break;
    }
  }

  static String toSentenceCase(String input) {
    if (input.isEmpty) return input;

    // Convert first letter to uppercase and the rest to lowercase
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  // Future<void> navigationToDashboard(String profile) async {
  //   try {
  //     print(profile);
  //     final profileResult =
  //     await SalesProfile.fetchSalesProfileData(type: profile);
  //
  //     if (profileResult != null) {
  //       Get.to(DashboardScreen(type: profile));
  //     } else if (profileResult == null) {
  //       if (profile == "business") {
  //         Get.to(AddBusinessProfileScreen());
  //       } else if (profile == "investor") {
  //         Get.to(AddInvestorProfileScreen());
  //       } else if (profile == "franchise") {
  //         Get.to(AddFranchiseProfileScreen());
  //       } else {
  //         Get.to(AddAdvisorProfileScreen());
  //       }
  //     } else if (profileResult != null) {
  //       AlertDialogueWidget.showAlertDialog("Alert !",
  //           "Your subscription has expired. Please select a plan to continue.",
  //               () {
  //             // Get.off(PricingScreenNew());
  //           }, () {
  //             Get.back();
  //           });
  //     } else {
  //       AlertDialogueWidget.showAlertDialog("Alert !",
  //           "You don't have an active subscription. Please subscribe to a plan to continue.",
  //               () {
  //             // Get.off(PricingScreenNew());
  //           }, () {
  //             Get.back();
  //           });
  //     }
  //   } catch (e) {}
  // }
}

class AlertDialogueWidget {
  // Function to show the alert dialog
  static void showAlertDialog(String title, String description,
      VoidCallback confirmAction, VoidCallback cancelAction) {
    Get.defaultDialog(
        titleStyle: AppTheme.mediumTitleText(errorIconColor),
        barrierDismissible: false,
        title: title,
        middleText: description,
        confirmTextColor: Colors.white,
        cancel: InkWell(
          onTap: cancelAction,
          child: Container(
            height: 35,
            width: 100,
            decoration: BoxDecoration(
                border: Border.all(color: buttonColor),
                borderRadius: BorderRadius.circular(borderRadius)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Cancel",
                  style: AppTheme.bodyMediumTitleText(buttonColor),
                )
              ],
            ),
          ),
        ),
        confirm: InkWell(
          onTap: confirmAction,
          child: Container(
            height: 35,
            width: 100,
            decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(borderRadius)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Confirm",
                  style: AppTheme.bodyMediumTitleText(Colors.white),
                )
              ],
            ),
          ),
        ),
        onCancel: () {
          // Get.back();
          },
        );
    }
}
