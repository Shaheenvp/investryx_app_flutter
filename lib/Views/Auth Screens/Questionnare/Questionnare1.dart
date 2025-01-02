import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/generated/constants.dart';
import 'advisor/advisor_q1.dart';
import 'business/business_q1.dart';
import 'franchise/franchise_q1.dart';
import 'investor/investor_q1.dart';


class QuestionnareScreen1 extends StatefulWidget {
  final String city;
  final String state;

  const QuestionnareScreen1({
    super.key,
    required this.city,
    required this.state
  });

  @override
  State<QuestionnareScreen1> createState() => _QuestionnareScreen1State();
}

class _QuestionnareScreen1State extends State<QuestionnareScreen1>
    with SingleTickerProviderStateMixin {
  String? selectedOption;
  final Color customYellow = const Color(0xffFFCC00);


  final List<Map<String, dynamic>> options = [
    {
      'title': 'Business',
      'icon': Icons.store_outlined,
      'description': 'Business for Sale? Find the Right Investors',
    },
    {
      'title': 'Investment',
      'icon': Icons.trending_up_outlined,
      'description': 'Buy into a Business, Invest Today',
    },
    {
      'title': 'Franchises',
      'icon': Icons.business_outlined,
      'description': 'Expand Your Brand, Find Distributors',
    },
    {
      'title': 'Advisor',
      'icon': Icons.support_agent_outlined,
      'description': 'Act as an Advisor, Find Trusted Advisors',
    },
  ];


  void _handleOptionSelect(String option) {
    HapticFeedback.selectionClick();
    setState(() {
      selectedOption = option;
    });
  }

  void _navigateToNextScreen() {
    if (selectedOption == null) return;

    Widget nextScreen;
    switch (selectedOption) {
      case 'Business':
        nextScreen = BusinessQuestionnareScreen1(
          city: widget.city,
          state: widget.state,
          type: selectedOption!,

        );
        break;
      case 'Investment':
        nextScreen = InvestorQuestionnareScreen1(
          city: widget.city,
          state: widget.state,
          type: selectedOption!,
        );
        break;
      case 'Franchises':
        nextScreen = FranchiseQuestionnareScreen1(
          city: widget.city,
          state: widget.state,
          type: selectedOption!,

        );
        break;
      case 'Advisor':
        nextScreen = AdvisorQuestionnareScreen1(
          city: widget.city,
          state: widget.state,
          type: selectedOption!,

        );
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil with context
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
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(56.h),
              child: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                automaticallyImplyLeading: false,
                leadingWidth: 80.w,
                actions: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                    child: Row(
                      children: [
                        Text(
                          '01/',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
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
                // Progress bar
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: LinearProgressIndicator(
                      value: 0.125,
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
                          'What is your primary objective for using our platform?',
                          style: AppTheme.headingText(lightTextColor)

                      ),
                      SizedBox(height: 8.h),
                      Text(
                          'Choose the main reason for using our platform',
                          style: AppTheme.bodyMediumTitleText(greyTextColor!, )
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
                                color: isSelected ? customYellow : Colors.grey[300]!,
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
                                          style: AppTheme.bodyMediumTitleText(isSelected ? customYellow : Colors.black87).copyWith(
                                            fontWeight: FontWeight.w500,
                                            height: 1.3,
                                          )
                                        // TextStyle(
                                        //   fontSize: 15.sp,
                                        //   fontWeight: FontWeight.w500,
                                        //   color: isSelected ? customYellow : Colors.black87,
                                        //   height: 1.3,
                                        // ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                          option['description'],
                                          style: AppTheme.mediumSmallText(greyTextColor!, )
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
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey[200]!,
                        width: 1,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: selectedOption != null ? _navigateToNextScreen : null,
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
                ),
              ],
            ),
            ),
        );
    }
}
