import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project_emergio/Views/Auth%20Screens/Questionnare/reg_successfull.dart';
import 'package:project_emergio/generated/constants.dart';

import '../../../services/Questionnaire.dart';

class CommonQuestionnaireScreen3 extends StatefulWidget {
  final String city;
  final String state;
  final String businessStage;
  final String businessGoal;
  final String operationDuration;
  final String budget;
  final String industry;
  final List<String> selectedStates;
  final List<String> selectedCities;
  /// Add new optional parameters for investor questionnaire
  final String? type;
  final String? investmentInterest;
  final String? investmentHorizon;
  final String? riskTolerance;
  final String? priorExperience;
  /// new optional parameters for franchise questionnaire
  final String? buyOrStart;
  final String? franchiseTypes;
  final String? brands;
  /// advisor
  final String? expertise;
  final String? clientType;
  final String? experience;
  final String? advisoryDuration;

  const CommonQuestionnaireScreen3({
    super.key,
    required this.city,
    required this.state,
    required this.businessStage,
    required this.businessGoal,
    required this.operationDuration,
    required this.budget,
    required this.industry,
    required this.selectedStates,
    required this.selectedCities,
    // Initialize new optional parameters
    this.type,
    this.investmentInterest,
    this.investmentHorizon,
    this.riskTolerance,
    this.priorExperience, this.buyOrStart, this.franchiseTypes, this.brands, this.expertise, this.clientType, this.experience, this.advisoryDuration,
  });

  @override
  State<CommonQuestionnaireScreen3> createState() => _CommonQuestionnaireScreen3State();
}

class _CommonQuestionnaireScreen3State extends State<CommonQuestionnaireScreen3> {
  final Color customYellow = buttonColor;
  String? selectedFrequency;
  final List<String> frequencies = ['Daily', 'Weekly', 'Monthly'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          automaticallyImplyLeading: false,
          leadingWidth: 80.w,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
              child: Text(
                'Back',
                style: AppTheme.bodyMediumTitleText(greyTextColor!),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
              child: Row(
                children: [
                  Text(
                    '08/',
                    style: AppTheme.mediumTitleText(lightTextColor),
                  ),
                  Text(
                    '08',
                    style: AppTheme.bodyMediumTitleText(greyTextColor!),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Progress Bar
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: LinearProgressIndicator(
                value: 1.0,
                minHeight: 8.h,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(customYellow),
              ),
            ),
          ),

          // Title Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How often would you like to receive updates?',
                  style: AppTheme.headingText(lightTextColor),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Select your preferred frequency for updates and recommendations',
                  style: AppTheme.bodyMediumTitleText(greyTextColor!),
                ),
              ],
            ),
          ),

          // Frequency Options
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: frequencies.map((frequency) {
                    final bool isSelected = selectedFrequency == frequency;
                    final bool isLast = frequency == frequencies.last;

                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              selectedFrequency = frequency;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                            child: Row(
                              children: [
                                Container(
                                  width: 24.w,
                                  height: 24.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? customYellow : borderColor!,
                                      width: 2.w,
                                    ),
                                  ),
                                  child: isSelected
                                      ? Center(
                                    child: Container(
                                      width: 12.w,
                                      height: 12.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: customYellow,
                                      ),
                                    ),
                                  )
                                      : null,
                                ),
                                SizedBox(width: 16.w),
                                Text(
                                  frequency,
                                  style: AppTheme.mediumTitleText(lightTextColor.withOpacity(0.7)).copyWith(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (!isLast)
                          Divider(
                            height: 1,
                            indent: 56.w,
                            color: borderColor,
                          ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Continue Button
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: containerColor,
              border: Border(
                top: BorderSide(
                  color: borderColor!,
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: selectedFrequency != null
                      ? () {
                    _handleQuestionnaireSubmission();
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customYellow,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: Text(
                    'Continue',
                    style: AppTheme.mediumTitleText(lightTextColor),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _handleQuestionnaireSubmission() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(customYellow),
          ),
        ),
      );

      final success = await QuestionnairePost.questionnairePost(
        city: widget.city,
        state: widget.state,
        businessStage: widget.businessStage,
        businessGoal: widget.businessGoal,
        operationDuration: widget.operationDuration,
        budget: widget.budget,
        industry: widget.industry,
        selectedStates: widget.selectedStates,
        selectedCities: widget.selectedCities.toList(),
        frequency: selectedFrequency,
        // Optional parameters
        type: widget.type,
        investmentInterest: widget.investmentInterest,
        investmentHorizon: widget.investmentHorizon,
        riskTolerance: widget.riskTolerance,
        priorExperience: widget.priorExperience,
        buyOrStart: widget.buyOrStart,
        franchiseTypes: widget.franchiseTypes,
        brands: widget.brands,
        expertise: widget.expertise,
        clientType: widget.clientType,
        experience: widget.experience,
        advisoryDuration: widget.advisoryDuration,
      );

      if (!context.mounted) return;
      Navigator.pop(context);

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CustomRegistrationSuccessScreen(),
          ),
        );
      }
    } on QuestionnaireException catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context); // Remove loading indicator

      // Show error message with specific error details
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: () {},
            textColor: Colors.white,
          ),
        ),
      );
    }
  }
}
