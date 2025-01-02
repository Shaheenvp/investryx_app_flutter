import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/Views/Auth%20Screens/Questionnare/business/business_q4.dart';
import 'package:project_emergio/generated/constants.dart';


class BusinessQuestionnareScreen3 extends StatefulWidget {
  final String city;
  final String state;
  final String businessStage;
  final String businessGoal;
  final String type;


  const BusinessQuestionnareScreen3({
    super.key,
    required this.city,
    required this.state,
    required this.businessStage,
    required this.businessGoal, required this.type,
  });

  @override
  State<BusinessQuestionnareScreen3> createState() => _BusinessQuestionnareScreen3State();
}

class _BusinessQuestionnareScreen3State extends State<BusinessQuestionnareScreen3>
    with SingleTickerProviderStateMixin {
  String? selectedOption;
  final Color customYellow = buttonColor;

  final List<Map<String, dynamic>> options = [
    {
      'title': 'Less than 1 year',
      'icon': Icons.access_time,
      'description': 'New or recently started business',
    },
    {
      'title': '1-3 years',
      'icon': Icons.calendar_today_outlined,
      'description': 'Early stage business with some track record',
    },
    {
      'title': '3-5 years',
      'icon': Icons.event_outlined,
      'description': 'Established business with proven history',
    },
    {
      'title': '5-10 years',
      'icon': Icons.history_outlined,
      'description': 'Well-established business with solid track record',
    },
    {
      'title': 'More than 10 years',
      'icon': Icons.stars_outlined,
      'description': 'Long-standing business with extensive history',
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
                        style: AppTheme.bodyMediumTitleText(greyTextColor!)
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                    child: Row(
                      children: [
                        Text(
                            '04/',
                            style: AppTheme.titleText(lightTextColor)
                        ),
                        Text(
                            '08',
                            style: AppTheme.titleText(greyTextColor!).copyWith(
                                fontWeight: FontWeight.w400
                            )
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
                          'How long has your business been in operation?',
                          style: AppTheme.headingText(lightTextColor)
                      ),
                      SizedBox(height: 8.h),
                      Text(
                          'Select the duration of your business operations',
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
                                              color: isSelected ? customYellow : Colors.black87,
                                              fontWeight: FontWeight.w500
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
                            builder: (context) => BusinessQuestionnareScreen4(
                              city: widget.city,
                              state: widget.state,
                              businessStage: widget.businessStage,
                              businessGoal: widget.businessGoal,
                              operationDuration: selectedOption!,
                              type: widget.type,

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
