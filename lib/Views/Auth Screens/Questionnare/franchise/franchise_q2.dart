import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/generated/constants.dart';

import 'franchise_q3.dart';

class FranchiseQuestionnareScreen2 extends StatefulWidget {
  final String city;
  final String state;
  final String type;
  final String buyOrStart;

  const FranchiseQuestionnareScreen2({
    super.key,
    required this.city,
    required this.state,
    required this.type,
    required this.buyOrStart,
  });

  @override
  State<FranchiseQuestionnareScreen2> createState() =>
      _FranchiseQuestionnareScreen2State();
}

class _FranchiseQuestionnareScreen2State
    extends State<FranchiseQuestionnareScreen2> {
  final Set<String> selectedOptions = {};
  final Color customYellow = buttonColor;
  String searchQuery = '';

  final List<Map<String, dynamic>> franchiseTypes = [
    {'title': 'Food & Beverage', 'icon': Icons.restaurant_outlined},
    {'title': 'Retail', 'icon': Icons.shopping_bag_outlined},
    {'title': 'Health & Wellness', 'icon': Icons.healing_outlined},
    {'title': 'Education & Training', 'icon': Icons.school_outlined},
    {'title': 'Automotive', 'icon': Icons.directions_car_outlined},
    {'title': 'Home Services', 'icon': Icons.home_repair_service_outlined},
    {'title': 'Pet Care', 'icon': Icons.pets_outlined},
    {'title': 'Childcare & Early Education', 'icon': Icons.child_care_outlined},
    {'title': 'Real Estate', 'icon': Icons.apartment_outlined},
    {'title': 'Logistics & Delivery', 'icon': Icons.local_shipping_outlined},
    {'title': 'Hospitality & Travel', 'icon': Icons.hotel_outlined},
    {'title': 'Business Services', 'icon': Icons.business_center_outlined},
    {'title': 'Fitness & Sports', 'icon': Icons.fitness_center_outlined},
    {'title': 'Beauty & Personal Care', 'icon': Icons.spa_outlined},
    {
      'title': 'Entertainment & Recreation',
      'icon': Icons.sports_esports_outlined
    },
    {'title': 'Franchise Resales', 'icon': Icons.store_outlined},
    {'title': 'Others', 'icon': Icons.menu},
  ];

  List<Map<String, dynamic>> get filteredFranchiseTypes => searchQuery.isEmpty
      ? franchiseTypes
      : franchiseTypes
      .where((franchise) => franchise['title']
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
                          '03/',
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
                      value: 0.375,
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
                        'What type of franchise interests you?',
                        style: AppTheme.headingText(lightTextColor!).copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Select all industries that interest you',
                        style: AppTheme.mediumTitleText(greyTextColor!).copyWith(
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  child: TextField(
                    onChanged: (value) => setState(() => searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search franchise types...',
                      hintStyle: AppTheme.headingText(greyTextColor!)
                          .copyWith(fontSize: 15, fontWeight: FontWeight.w400),
                      prefixIcon:
                      Icon(Icons.search, color: greyTextColor, size: 15.sp),
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
                          '${selectedOptions.length} type${selectedOptions.length > 1 ? 's' : ''} selected',
                          style: AppTheme.mediumTitleText(greyTextColor!)
                              .copyWith(fontSize: 15),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () => setState(() => selectedOptions.clear()),
                          child: Text(
                            'Clear all',
                            style: AppTheme.mediumTitleText(customYellow!)
                                .copyWith(fontSize: 15),
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
                    itemCount: filteredFranchiseTypes.length,
                    itemBuilder: (context, index) {
                      final franchise = filteredFranchiseTypes[index];
                      final isSelected =
                      selectedOptions.contains(franchise['title']);

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _toggleOption(franchise['title']),
                          borderRadius: BorderRadius.circular(8.r),
                          child: Ink(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? customYellow.withOpacity(0.1)
                                  : backgroundColor,
                              border: Border.all(
                                color:
                                isSelected ? customYellow : shimmerBaseColor!,
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
                                          : shimmerHighlightColor,
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Icon(
                                      franchise['icon'],
                                      size: 18.sp,
                                      color: isSelected
                                          ? lightTextColor
                                          : greyTextColor,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      franchise['title'],
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: isSelected
                                            ? FontWeight.w500
                                            : FontWeight.normal,
                                        color: isSelected
                                            ? lightTextColor
                                            : greyTextColor,
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
                    color: backgroundColor,
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
                              builder: (context) =>
                                  FranchiseQuestionnareScreen3(
                                    city: widget.city,
                                    state: widget.state,
                                    type: widget.type,
                                    buyOrStart: widget.buyOrStart,
                                    franchiseTypes: selectedOptions.join(", "),
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
