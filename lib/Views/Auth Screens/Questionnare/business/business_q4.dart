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
  String? _turnoverError;

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

    // Extract only digit characters, ignoring currency symbols and formatting
    final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanValue.isEmpty) {
      return 'Please enter a valid amount';
    }

    final turnover = BigInt.tryParse(cleanValue);
    if (turnover == null) {
      return 'Please enter a valid amount';
    }
    if (turnover <= BigInt.zero) {
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
        _turnoverError = null;
      }
    });
  }

  String _formatCurrency(String value) {
    if (value.isEmpty) return '';

    final onlyNumbers = value.replaceAll(RegExp(r'[^\d]'), '');
    if (onlyNumbers.isEmpty) return '';

    return '₹${_formatWithCommas(onlyNumbers)}';
  }

  String _formatWithCommas(String numStr) {
    String result = '';
    int len = numStr.length;

    for (int i = 0; i < len; i++) {
      if (i > 0 && (len - i) % 2 == 0 && (len - i) > 2) {
        result += ',';
      }
      result += numStr[i];
    }

    return result;
  }

  // Get min value (for string substring operations)
  int min(int a, int b) {
    return a < b ? a : b;
  }

  // This function validates input without changing state
  bool _isFormValid() {
    if (selectedRange == null) return false;

    if (isCustomTurnover) {
      final validationResult = _validateTurnover(_turnoverController.text);
      return validationResult == null && _turnoverController.text.isNotEmpty;
    }

    return true;
  }

  // Get clean turnover value for passing to next screen
  String _getCleanTurnoverValue() {
    if (!isCustomTurnover) return selectedRange!;
    return _turnoverController.text.isEmpty ? 'Custom' : _turnoverController.text;
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
                              errorText: _turnoverError,
                              errorStyle: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.red[700],
                              ),
                              helperText: 'Enter any amount without limit',
                              helperStyle: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly, // Allow only numbers
                            ],
                            onChanged: (value) {
                              setState(() {
                                // Validate the input
                                _turnoverError = _validateTurnover(value);

                                // Only format if valid
                                if (_turnoverError == null && value.isNotEmpty) {
                                  // Remove all non-digit characters
                                  final rawDigits = value.replaceAll(RegExp(r'[^\d]'), '');

                                  if (rawDigits.isNotEmpty) {
                                    // Format the raw digits with commas
                                    String formattedValue = _formatCurrency(rawDigits);

                                    // Update the controller only if the formatted value is different
                                    if (_turnoverController.text != formattedValue) {
                                      _turnoverController.value = TextEditingValue(
                                        text: formattedValue,
                                        selection: TextSelection.collapsed(offset: formattedValue.length),
                                      );
                                    }
                                  }
                                }
                              });
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
                    onPressed: _isFormValid()
                        ? () {
                      final turnover = _getCleanTurnoverValue();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommonQuestionnareScreen1(
                            city: widget.city,
                            state: widget.state,
                            businessStage: widget.businessStage,
                            businessGoal: widget.businessGoal,
                            operationDuration: widget.operationDuration,
                            budget: turnover,
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