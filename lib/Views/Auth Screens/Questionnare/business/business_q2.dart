import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/Views/Auth%20Screens/Questionnare/common_questionnare1.dart';
import 'package:project_emergio/generated/constants.dart';

import 'business_q3.dart';


class BusinessQuestionnareScreen2 extends StatefulWidget {
  final String city;
  final String state;
  final String type;
  final String businessStage;

  const BusinessQuestionnareScreen2({
    super.key,
    required this.city,
    required this.state,
    required this.businessStage, required this.type,
  });

  @override
  State<BusinessQuestionnareScreen2> createState() => _BusinessQuestionnareScreen2State();
}

class _BusinessQuestionnareScreen2State extends State<BusinessQuestionnareScreen2>
    with SingleTickerProviderStateMixin {
  String? selectedOption;
  final Color customYellow = buttonColor;

  final List<Map<String, dynamic>> options = [
    {
      'title': 'Attracting investors',
      'icon': Icons.people_outline,
      'description': 'Looking for funding and strategic investment partners',
    },
    {
      'title': 'Selling the business',
      'icon': Icons.store_outlined,
      'description': 'Planning to exit and transfer ownership',
    },
    {
      'title': 'Finding partners',
      'icon': Icons.handshake_outlined,
      'description': 'Seeking strategic business partnerships or collaborations',
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  void _handleOptionSelect(String option) {
    HapticFeedback.selectionClick();
    setState(() {
      selectedOption = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(375, 812),
      minTextAdapt: true,
    );

    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          return false;
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(56.h),
              child: AppBar(
                backgroundColor: Colors.white,
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
                        style:AppTheme.mediumTitleText(greyTextColor!).copyWith(
                            fontWeight: FontWeight.w400,
                            height: 1.3
                        )
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                    child: Row(
                      children: [
                        Text(
                            '03/',
                            style: AppTheme.titleText(lightTextColor)
                        ),
                        Text(
                          '08',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: LinearProgressIndicator(
                      value: 0.375,
                      minHeight: 8.h,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(customYellow),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'What are your goals for listing your business?',
                          style: AppTheme.headingText(lightTextColor)

                      ),
                      SizedBox(height: 8.h),
                      Text(
                          'Select your primary objective for listing',
                          style: AppTheme.bodyMediumTitleText(greyTextColor!)

                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: options.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final option = options[index];
                      final isSelected = selectedOption == option['title'];

                      return Material(
                        color: backgroundColor,
                        child: InkWell(
                          onTap: () => _handleOptionSelect(option['title']),
                          borderRadius: BorderRadius.circular(8.r),
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected ? customYellow : Colors.grey[300]!,
                                width: isSelected ? 1.5 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  option['icon'],
                                  color: isSelected ? customYellow : Colors.grey[600],
                                  size: 22.sp,
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          option['title'],
                                          style: AppTheme.bodyMediumTitleText(lightTextColor).copyWith(
                                            fontWeight: FontWeight.w500,
                                          )
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                          option['description'],
                                          style: AppTheme.mediumSmallText(greyTextColor!)
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color: customYellow,
                                    size: 20.sp,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey[200]!,
                        width: 1,
                      ),
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: selectedOption != null
                          ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BusinessQuestionnareScreen3(
                              city: widget.city,
                              state: widget.state,
                              type: widget.type,
                              businessStage: widget.businessStage,
                              businessGoal: selectedOption!, // Pass the selected business goal
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
                        disabledBackgroundColor: Colors.grey[300],
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
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
