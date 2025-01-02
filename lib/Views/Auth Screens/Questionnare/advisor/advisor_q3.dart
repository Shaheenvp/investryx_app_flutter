import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/generated/constants.dart';

import 'advisor_q4.dart';

class AdvisorQuestionnareScreen3 extends StatefulWidget {
  final String city;
  final String state;
  final String type;
  final String expertise;
  final String clientType;

  const AdvisorQuestionnareScreen3({
    super.key,
    required this.city,
    required this.state,
    required this.type,
    required this.expertise,
    required this.clientType,
  });

  @override
  State<AdvisorQuestionnareScreen3> createState() =>
      _AdvisorQuestionnareScreen3State();
}

class _AdvisorQuestionnareScreen3State
    extends State<AdvisorQuestionnareScreen3> {
  final TextEditingController _experienceController = TextEditingController();
  final Color customYellow = buttonColor;
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    _experienceController.addListener(_validateInput);
  }

  void _validateInput() {
    final value = _experienceController.text;
    if (value.isNotEmpty) {
      final number = int.tryParse(value);
      setState(() {
        isValid = number != null && number > 0 && number < 100;
      });
    } else {
      setState(() {
        isValid = false;
      });
    }
  }

  @override
  void dispose() {
    _experienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: Size(375, 812),
      minTextAdapt: true,
    );

    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          return false;
        },
        child: Scaffold(
            backgroundColor: backgroundColor,
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
                    child: Text('Back',
                        style: AppTheme.mediumTitleText(greyTextColor!)
                            .copyWith(fontWeight: FontWeight.w400)),
                  ),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                    child: Row(
                      children: [
                        Text(
                          '04/',
                          style: AppTheme.titleText(lightTextColor!)
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '08',
                          style: AppTheme.titleText(greyTextColor!).copyWith(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                // Progress bar
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: LinearProgressIndicator(
                      value: 0.5,
                      minHeight: 8.h,
                      backgroundColor: shimmerBaseColor,
                      valueColor: AlwaysStoppedAnimation<Color>(customYellow),
                    ),
                  ),
                ),

                // Question Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How many years of experience do you have in your field?',
                        style: AppTheme.headingText(lightTextColor!).copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Enter the number of years of professional experience',
                        style: AppTheme.bodyMediumTitleText(greyTextColor!).copyWith(
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                // Experience Input Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isValid ? customYellow : shimmerBaseColor!,
                            width: isValid ? 1.5 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                  controller: _experienceController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(2),
                                  ],
                                  decoration: InputDecoration(
                                    hintText: 'Enter years',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 12.h,
                                    ),
                                  ),
                                  style: AppTheme.mediumTitleText(lightTextColor!)
                                      .copyWith(fontWeight: FontWeight.w600)),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text('Years',
                                  style: AppTheme.mediumTitleText(greyTextColor!)
                                      .copyWith(fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                      ),
                      if (_experienceController.text.isNotEmpty && !isValid)
                        Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            'Please enter a valid number of years (1-99)',
                            style: AppTheme.smallText(errorIconColor),
                          ),
                        ),
                    ],
                  ),
                ),

                Spacer(),

                // Continue Button
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    border: Border(
                      top: BorderSide(
                        color: shimmerBaseColor!,
                        width: 1,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: isValid
                            ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AdvisorQuestionnareScreen4(
                                    city: widget.city,
                                    state: widget.state,
                                    type: widget.type,
                                    expertise: widget.expertise,
                                    clientType: widget.clientType,
                                    experience: _experienceController.text,
                                  ),
                            ),
                          );
                        }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: customYellow,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          disabledBackgroundColor: shimmerBaseColor,
                        ),
                        child: Text(
                          'Continue',
                          style: AppTheme.mediumTitleText(lightTextColor).copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ),
        );
    }
}
