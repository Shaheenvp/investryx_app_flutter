import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_emergio/Widgets/custom_profile_appbar_widget.dart';
import 'package:project_emergio/generated/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/suggestion service.dart';

class SuggestionScreen extends StatefulWidget {
  @override
  _SuggestionScreenState createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _suggestionController = TextEditingController();

  @override
  void dispose() {
    _suggestionController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: const CustomAppBarWidget(title: "Submit Your Suggestion",
          isBackIcon: true,),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10.h),
                Text(
                  'We value your feedback and suggestions to make our app better. Please enter your suggestion below:',
                  style: AppTheme.bodyMediumTitleText(lightTextColor),
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _suggestionController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your suggestion here...',
                      hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your suggestion';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 15.h),
                ElevatedButton(
                  onPressed: () async {
                    final success = await Suggestion.suggestion(
                      message: _suggestionController.text,
                    );

                    if (success == true) {
                      Get.snackbar(
                        'Success',
                        'Thank you for your suggestion!',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.black54,
                        colorText: Colors.white,
                      );
                      _suggestionController.clear();
                    } else {
                      print('Failed to send suggestion');
                      Get.snackbar(
                        'Error',
                        'Failed to send your suggestion.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.black54,
                        colorText: Colors.white,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: AppTheme.titleText(Colors.white),
                  ),
                ),
              ],
            ),
            ),
        );
    }
}
