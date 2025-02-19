import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/generated/constants.dart';

import '../common_questionnare1.dart';

class BusinessQuestionnareScreen4 extends StatefulWidget {
  final String city;
  final String state;
  final String type;
  final String businessStage;
  final String businessGoal;
  final String operationDuration;

  const BusinessQuestionnareScreen4({
    super.key,
    required this.city,
    required this.state,
    required this.businessStage,
    required this.businessGoal,
    required this.operationDuration,
    required this.type,
  });

  @override
  State<BusinessQuestionnareScreen4> createState() => _BusinessQuestionnareScreen4State();
}

class _BusinessQuestionnareScreen4State extends State<BusinessQuestionnareScreen4> {
  final Color customYellow = buttonColor;
  final TextEditingController _turnoverController = TextEditingController();
  String? selectedRange;
  bool isCustomTurnover = false;

  final List<Map<String, String>> turnoverRanges = [
    {
      'range': 'Less than 25 Lakhs',
      'subtitle': 'Small business or startup',
    },
    {
      'range': '25 Lakhs - 1 Crore',
      'subtitle': 'Growing small business',
    },
    {
      'range': '1 Crore - 5 Crores',
      'subtitle': 'Medium-sized business',
    },
    {
      'range': '5 Crores - 20 Crores',
      'subtitle': 'Large business operations',
    },
    {
      'range': 'More than 20 Crores',
      'subtitle': 'Enterprise-level business',
    },
    {
      'range': 'Custom Turnover',
      'subtitle': 'Specify your exact annual turnover',
    },
  ];

  @override
  void dispose() {
    _turnoverController.dispose();
    super.dispose();
  }

  String? _validateTurnover(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your turnover';
    }
    final turnover = int.tryParse(value.replaceAll(RegExp(r'[^\d]'), ''));
    if (turnover == null) {
      return 'Please enter a valid amount';
    }
    if (turnover <= 0) {
      return 'Turnover must be greater than 0';
    }
    return null;
  }

  void _handleOptionSelect(String range) {
    HapticFeedback.selectionClick();
    setState(() {
      selectedRange = range;
      isCustomTurnover = range == 'Custom Turnover';
      if (!isCustomTurnover) {
        _turnoverController.clear();
      }
    });
  }

  String _formatCurrency(String value) {
    if (value.isEmpty) return '';

    final onlyNumbers = value.replaceAll(RegExp(r'[^\d]'), '');
    if (onlyNumbers.isEmpty) return '';

    final number = int.tryParse(onlyNumbers) ?? 0;

    if (number >= 10000000) { // 1 Crore or more
      double crores = number / 10000000;
      return '₹${crores.toStringAsFixed(2)} Cr';
    } else if (number >= 100000) { // 1 Lakh or more
      double lakhs = number / 100000;
      return '₹${lakhs.toStringAsFixed(2)} L';
    } else {
      return '₹$number'; // Less than 1 Lakh, show raw number
    }
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
                        '05/',
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
                  value: 0.625,
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
                      'What is your annual turnover?',
                      style: AppTheme.headingText(lightTextColor)
                  ),
                  SizedBox(height: 8.h),
                  Text(
                      'Select a turnover range or specify your exact annual turnover',
                      style: AppTheme.bodyMediumTitleText(greyTextColor!)
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: turnoverRanges.length,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final range = turnoverRanges[index];
                  final isSelected = selectedRange == range['range'];

                  return Column(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _handleOptionSelect(range['range']!),
                          borderRadius: BorderRadius.circular(8.r),
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected ? customYellow : Colors.grey[300]!,
                                width: isSelected ? 1.5 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                              color: isSelected ? customYellow.withOpacity(0.1) : Colors.white,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          range['range']!,
                                          style: AppTheme.titleText(lightTextColor).copyWith(
                                            color: isSelected ? Colors.black87 : Colors.grey[800],
                                            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                                          )
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                          range['subtitle']!,
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
                      ),
                      if (isSelected && isCustomTurnover)
                        Padding(
                          padding: EdgeInsets.only(top: 12.h),
                          child: TextFormField(
                            controller: _turnoverController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 15.sp),
                            decoration: InputDecoration(
                              hintText: 'Enter your annual turnover',
                              prefixText: '₹ ',
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly, // Allow only numbers
                            ],
                            onChanged: (value) {
                              String formattedValue = _formatCurrency(value.replaceAll(RegExp(r'[^\d]'), ''));
                              _turnoverController.value = TextEditingValue(
                                text: formattedValue,
                                selection: TextSelection.collapsed(offset: formattedValue.length),
                              );
                            },
                          ),
                        ),
                    ],
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
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: (selectedRange != null &&
                        (!isCustomTurnover || (isCustomTurnover && _turnoverController.text.isNotEmpty)))
                        ? () {
                      final turnover = isCustomTurnover ? _turnoverController.text : selectedRange;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommonQuestionnareScreen1(
                            city: widget.city,
                            state: widget.state,
                            businessStage: widget.businessStage,
                            businessGoal: widget.businessGoal,
                            operationDuration: widget.operationDuration,
                            budget: selectedRange!, // Note: The parameter name remains 'budget' to maintain compatibility
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
                        style: AppTheme.titleText(lightTextColor).copyWith(
                            fontWeight: FontWeight.w500
                        )
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