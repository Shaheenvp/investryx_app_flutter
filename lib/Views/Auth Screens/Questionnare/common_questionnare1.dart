import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/Views/Auth%20Screens/Questionnare/common_questionnare2.dart';
import 'package:project_emergio/generated/constants.dart';

class CommonQuestionnareScreen1 extends StatefulWidget {
  final String? city;
  final String? state;
  final String? businessStage;
  final String? businessGoal;
  final String? operationDuration;
  final String? budget;

  /// new optional parameters for investor questionnaire
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

  const CommonQuestionnareScreen1({
    super.key,
    this.city,
    this.state,
    this.businessStage,
    this.businessGoal,
    this.operationDuration,
    this.budget,
    // Initialize new parameters
    this.type,
    this.investmentInterest,
    this.investmentHorizon,
    this.riskTolerance,
    this.priorExperience,
    this.buyOrStart,
    this.franchiseTypes,
    this.brands,
    this.expertise,
    this.clientType,
    this.experience,
    this.advisoryDuration,
  });

  @override
  State<CommonQuestionnareScreen1> createState() =>
      _CommonQuestionnareScreen1State();
}

class _CommonQuestionnareScreen1State extends State<CommonQuestionnareScreen1> {
  final Set<String> selectedOptions = {};
  final Color customYellow = buttonColor;
  String searchQuery = '';

  final List<Map<String, dynamic>> industries = [
    {'title': 'Technology & Software', 'icon': Icons.computer_outlined},
    {
      'title': 'Healthcare & Pharmaceuticals',
      'icon': Icons.local_hospital_outlined
    },
    {'title': 'Finance & Banking', 'icon': Icons.account_balance_outlined},
    {'title': 'Retail & E-commerce', 'icon': Icons.shopping_cart_outlined},
    {'title': 'Manufacturing & Industrial', 'icon': Icons.factory_outlined},
    {'title': 'Real Estate & Construction', 'icon': Icons.home_work_outlined},
    {'title': 'Food & Beverage', 'icon': Icons.restaurant_outlined},
    {'title': 'Education & Training', 'icon': Icons.school_outlined},
    {
      'title': 'Automotive & Transportation',
      'icon': Icons.directions_car_outlined
    },
    {'title': 'Hospitality & Tourism', 'icon': Icons.hotel_outlined},
    {'title': 'Energy & Utilities', 'icon': Icons.power_outlined},
    {'title': 'Media & Entertainment', 'icon': Icons.movie_outlined},
    {'title': 'Telecommunications', 'icon': Icons.phone_android_outlined},
    {'title': 'Agriculture & Farming', 'icon': Icons.agriculture_outlined},
    {
      'title': 'Logistics & Supply Chain',
      'icon': Icons.local_shipping_outlined
    },
    {'title': 'Consumer Goods', 'icon': Icons.shopping_bag_outlined},
    {'title': 'Non-Profit & Social Services', 'icon': Icons.favorite_outline},
    {'title': 'Legal Services', 'icon': Icons.gavel_outlined},
    {'title': 'Sports & Recreation', 'icon': Icons.sports_baseball_outlined},
    {'title': 'Marketing & Advertising', 'icon': Icons.campaign_outlined},
    {'title': 'Others', 'icon': Icons.more_horiz_outlined},
  ];

  List<Map<String, dynamic>> get filteredIndustries => searchQuery.isEmpty
      ? industries
      : industries
      .where((industry) => industry['title']
      .toString()
      .toLowerCase()
      .contains(searchQuery.toLowerCase()))
      .toList();

  void _toggleOption(String option) {
    HapticFeedback.selectionClick();
    setState(() {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
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
                            '06/',
                            style: AppTheme.titleText(lightTextColor)
                        ),
                        Text(
                            '08',
                            style: AppTheme.titleText(greyTextColor!).copyWith(
                                fontWeight: FontWeight.w500
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
                      value: 0.75,
                      minHeight: 8.h,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(customYellow),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'What industries are you most interested in or associated with?',
                          style: AppTheme.headingText(lightTextColor)
                      ),
                      SizedBox(height: 8.h),
                      Text(
                          'Select all industries that apply',
                          style: AppTheme.bodyMediumTitleText(greyTextColor!)
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  child: TextField(
                    onChanged: (value) => setState(() => searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search industries...',
                      prefixIcon:
                      Icon(Icons.search, color: Colors.grey[600], size: 20.sp),
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
                  ),
                ),
                if (selectedOptions.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    child: Row(
                      children: [
                        Text(
                          '${selectedOptions.length} industry${selectedOptions.length > 1 ? 'ies' : ''} selected',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () => setState(() => selectedOptions.clear()),
                          child: Text(
                            'Clear all',
                            style: TextStyle(
                              color: customYellow,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                    ),
                    itemCount: filteredIndustries.length,
                    itemBuilder: (context, index) {
                      final industry = filteredIndustries[index];
                      final isSelected =
                      selectedOptions.contains(industry['title']);

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _toggleOption(industry['title']),
                          borderRadius: BorderRadius.circular(8.r),
                          child: Ink(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? customYellow.withOpacity(0.1)
                                  : Colors.white,
                              border: Border.all(
                                color:
                                isSelected ? customYellow : Colors.grey[300]!,
                                width: isSelected ? 1.5 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.w),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6.w),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? customYellow
                                          : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Icon(
                                      industry['icon'],
                                      size: 18.sp,
                                      color: isSelected
                                          ? Colors.black87
                                          : Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      industry['title'],
                                      style: AppTheme.mediumSmallText(lightTextColor).copyWith(
                                        fontWeight: isSelected
                                            ? FontWeight.w500
                                            : FontWeight.normal,
                                        color: isSelected
                                            ? Colors.black87
                                            : Colors.grey[800],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
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
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: selectedOptions.isNotEmpty
                            ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommonQuestionnareScreen2(
                                city: widget.city ?? '',
                                state: widget.state ?? '',
                                businessStage: widget.businessStage ?? '',
                                businessGoal: widget.businessGoal ?? '',
                                operationDuration:
                                widget.operationDuration ?? '',
                                budget: widget.budget ?? '',
                                industry: selectedOptions.join(", "),
                                type: widget.type,
                                investmentInterest: widget.investmentInterest,
                                investmentHorizon: widget.investmentHorizon,
                                riskTolerance: widget.riskTolerance,
                                priorExperience: widget.priorExperience,
                                brands: widget.brands,
                                buyOrStart: widget.buyOrStart,
                                franchiseTypes: widget.franchiseTypes,
                                advisoryDuration: widget.advisoryDuration,
                                clientType: widget.clientType,
                                experience: widget.experience,
                                expertise: widget.expertise,

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
