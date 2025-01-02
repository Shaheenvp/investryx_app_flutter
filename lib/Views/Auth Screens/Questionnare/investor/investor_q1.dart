import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/generated/constants.dart';


import '../Questionnare1.dart';
import 'investor_q2.dart';

class InvestorQuestionnareScreen1 extends StatefulWidget {
  final String city;
  final String state;
  final String type;

  const InvestorQuestionnareScreen1(
      {super.key, required this.city, required this.state, required this.type});

  @override
  State<InvestorQuestionnareScreen1> createState() =>
      _InvestorQuestionnareScreen1State();
}

class _InvestorQuestionnareScreen1State
    extends State<InvestorQuestionnareScreen1>
    with SingleTickerProviderStateMixin {
  String? selectedOption;
  final Color customYellow = buttonColor;

  final List<Map<String, dynamic>> options = [
    {
      'title': 'Equity',
      'icon': Icons.pie_chart_outline,
      'description': 'Invest in company shares and ownership stakes',
    },
    {
      'title': 'Debt',
      'icon': Icons.account_balance_outlined,
      'description': 'Provide loans and debt financing solutions',
    },
    {
      'title': 'Real Estate',
      'icon': Icons.home_work_outlined,
      'description': 'Invest in commercial and residential properties',
    },
    {
      'title': 'Franchises',
      'icon': Icons.store_mall_directory_outlined,
      'description': 'Invest in established franchise opportunities',
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
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuestionnareScreen1(
                            city: widget.city,
                            state: widget.state,
                          ))),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
                    child: Text(
                      'Back',
                      style: AppTheme.mediumTitleText(greyTextColor!).copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                    child: Row(
                      children: [
                        Text('02/',
                            style: AppTheme.titleText(lightTextColor).copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                        Text('08',
                            style: AppTheme.titleText(greyTextColor!).copyWith(
                              fontWeight: FontWeight.bold,
                            )),
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
                      value: 0.25,
                      minHeight: 8.h,
                      backgroundColor: Colors.grey[200],
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
                        'What type of investments are you interested in?',
                        style: AppTheme.headingText(lightTextColor!)
                            .copyWith(fontWeight: FontWeight.w600, height: 1.2),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Select your preferred investment category',
                        style: AppTheme.mediumTitleText(greyTextColor!).copyWith(
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Options Section
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
                                isSelected ? customYellow : shimmerBaseColor!,
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
                                        style: AppTheme.mediumTitleText(isSelected
                                            ? customYellow
                                            : lightTextColor!)
                                            .copyWith(
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
                        onPressed: selectedOption != null
                            ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  InvestorQuestionnareScreen2(
                                    city: widget.city,
                                    state: widget.state,
                                    type: widget.type,
                                    investmentInterest: selectedOption!,
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
                          style: AppTheme.mediumTitleText(lightTextColor!).copyWith(
                            fontWeight: FontWeight.w500,
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
