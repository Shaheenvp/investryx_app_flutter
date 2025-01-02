import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/generated/constants.dart';

import 'franchise_q4.dart';

class FranchiseQuestionnareScreen3 extends StatefulWidget {
  final String city;
  final String state;
  final String type;
  final String buyOrStart;
  final String franchiseTypes;

  const FranchiseQuestionnareScreen3({
    super.key,
    required this.city,
    required this.state,
    required this.type,
    required this.buyOrStart,
    required this.franchiseTypes,
  });

  @override
  State<FranchiseQuestionnareScreen3> createState() =>
      _FranchiseQuestionnareScreen3State();
}

class _FranchiseQuestionnareScreen3State
    extends State<FranchiseQuestionnareScreen3> {
  String? selectedOption;
  final Color customYellow = buttonColor;

  final List<Map<String, dynamic>> options = [
    {
      'title': 'Under \₹50,000',
      'icon': Icons.attach_money_outlined,
      'description': 'Low-cost franchise opportunities',
    },
    {
      'title': '\₹50,000 - \₹100,000',
      'icon': Icons.attach_money_outlined,
      'description': 'Entry-level franchise investments',
    },
    {
      'title': '\₹100,000 - \₹250,000',
      'icon': Icons.attach_money_outlined,
      'description': 'Mid-range franchise opportunities',
    },
    {
      'title': '\₹250,000 - \₹500,000',
      'icon': Icons.attach_money_outlined,
      'description': 'Established franchise concepts',
    },
    {
      'title': '\₹500,000 - \₹1 Million',
      'icon': Icons.attach_money_outlined,
      'description': 'Premium franchise opportunities',
    },
    {
      'title': 'Over \₹1 Million',
      'icon': Icons.attach_money_outlined,
      'description': 'Large-scale franchise investments',
    },
    {
      'title': 'Flexible Budget',
      'icon': Icons.all_inclusive_outlined,
      'description': 'Open to various investment levels',
    },
  ];

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
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: LinearProgressIndicator(
                      value: 0.5,
                      minHeight: 8.h,
                      backgroundColor: textLightGreyColor,
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
                        'What is your ideal investment budget for a franchise?',
                        style: AppTheme.headingText(lightTextColor!).copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Select your preferred investment range',
                        style: AppTheme.mediumTitleText(greyTextColor!).copyWith(
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
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
                                color:
                                isSelected ? customYellow : textLightGreyColor!,
                                width: isSelected ? 1.5 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  option['icon'],
                                  color: isSelected ? customYellow : greyTextColor,
                                  size: 22.sp,
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        option['title'],
                                        style: AppTheme.mediumTitleText(
                                          isSelected
                                              ? customYellow
                                              : lightTextColor,
                                        ).copyWith(
                                          fontWeight: FontWeight.w400,
                                          height: 1.3,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        option['description'],
                                        style: AppTheme.bodyMediumTitleText(
                                            greyTextColor!)
                                            .copyWith(
                                          height: 1.3,
                                        ),
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
                    color: backgroundColor,
                    border: Border(
                      top: BorderSide(
                        color: textLightGreyColor!,
                        width: 1,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: selectedOption != null
                            ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FranchiseQuestionnareScreen4(
                                    city: widget.city,
                                    state: widget.state,
                                    type: widget.type,
                                    buyOrStart: widget.buyOrStart,
                                    franchiseTypes: widget.franchiseTypes,
                                    budget: selectedOption!,
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
                          style: AppTheme.bodyMediumTitleText(lightTextColor!)
                              .copyWith(
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.2,
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
