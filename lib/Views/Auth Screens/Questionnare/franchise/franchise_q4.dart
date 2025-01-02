import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/Views/Auth%20Screens/Questionnare/common_questionnare1.dart';
import 'package:project_emergio/generated/constants.dart';


class FranchiseQuestionnareScreen4 extends StatefulWidget {
  final String city;
  final String state;
  final String type;
  final String buyOrStart;
  final String franchiseTypes;
  final String budget;

  const FranchiseQuestionnareScreen4({
    super.key,
    required this.city,
    required this.state,
    required this.type,
    required this.buyOrStart,
    required this.franchiseTypes,
    required this.budget,
  });

  @override
  State<FranchiseQuestionnareScreen4> createState() =>
      _FranchiseQuestionnareScreen4State();
}

class _FranchiseQuestionnareScreen4State
    extends State<FranchiseQuestionnareScreen4> {
  final Set<String> selectedBrands = {};
  final Color customYellow = buttonColor;
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = false;

  // Sample list of major franchise brands
  final List<Map<String, dynamic>> majorBrands = [
    {
      'name': 'McDonald\'s',
      'category': 'Food & Beverage',
      'logo': Icons.restaurant,
    },
    {
      'name': 'Subway',
      'category': 'Food & Beverage',
      'logo': Icons.restaurant,
    },
    {
      'name': '7-Eleven',
      'category': 'Retail',
      'logo': Icons.store,
    },
    {
      'name': 'KFC',
      'category': 'Food & Beverage',
      'logo': Icons.restaurant,
    },
    {
      'name': 'Pizza Hut',
      'category': 'Food & Beverage',
      'logo': Icons.local_pizza,
    },
    {
      'name': 'Dunkin\'',
      'category': 'Food & Beverage',
      'logo': Icons.coffee,
    },
    {
      'name': 'Ace Hardware',
      'category': 'Retail',
      'logo': Icons.handyman,
    },
    {
      'name': 'Planet Fitness',
      'category': 'Fitness',
      'logo': Icons.fitness_center,
    },
    {
      'name': 'RE/MAX',
      'category': 'Real Estate',
      'logo': Icons.home,
    },
    {
      'name': 'UPS Store',
      'category': 'Business Services',
      'logo': Icons.local_shipping,
    },
  ];

  List<Map<String, dynamic>> get filteredBrands => searchQuery.isEmpty
      ? majorBrands
      : majorBrands
      .where((brand) =>
  brand['name']
      .toString()
      .toLowerCase()
      .contains(searchQuery.toLowerCase()) ||
      brand['category']
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase()))
      .toList();

// Replace the _showAddCustomBrandDialog method with this enhanced version:

  void _showAddCustomBrandDialog() {
    final TextEditingController brandNameController = TextEditingController();
    String? selectedCategory;
    final formKey = GlobalKey<FormState>();

    final List<String> categories = [
      'Food & Beverage',
      'Retail',
      'Health & Wellness',
      'Education & Training',
      'Automotive',
      'Home Services',
      'Pet Care',
      'Childcare & Early Education',
      'Real Estate',
      'Logistics & Delivery',
      'Hospitality & Travel',
      'Business Services',
      'Fitness & Sports',
      'Beauty & Personal Care',
      'Entertainment & Recreation',
      'Other',
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Container(
            width: 0.9.sw,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
                color: backgroundColor, borderRadius: BorderRadius.circular(5)),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add Custom Brand',
                        style: AppTheme.mediumHeadingText(lightTextColor!)
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          size: 24.sp,
                          color: greyTextColor,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Brand Name',
                    style: AppTheme.titleText(greyTextColor!)
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: brandNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter brand name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter brand name',
                      hintStyle:
                      AppTheme.bodyMediumTitleText(greyTextColor!.withOpacity(0.3))
                          .copyWith(),
                      filled: true,
                      fillColor: shimmerHighlightColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                          color: shimmerBaseColor!,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                          color: customYellow,
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                          color: errorIconColor,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                          color: errorIconColor,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Category',
                    style: AppTheme.titleText(greyTextColor!.withOpacity(0.3))
                        .copyWith(
                      fontWeight: FontWeight.w500,
                    )
                        .copyWith(),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    decoration: BoxDecoration(
                      color: shimmerHighlightColor,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: selectedCategory != null
                            ? customYellow
                            : shimmerBaseColor!,
                        width: selectedCategory != null ? 1.5 : 1,
                      ),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedCategory,
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          hintText: 'Select category',
                          hintStyle: AppTheme.bodyMediumTitleText(greyTextColor!)
                      ),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: greyTextColor,
                      ),
                      isExpanded: true,
                      dropdownColor: backgroundColor,
                      items: categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Row(
                            children: [
                              Icon(
                                _getCategoryIcon(category),
                                size: 18.sp,
                                color: greyTextColor,
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                category,
                                style:
                                AppTheme.bodyMediumTitleText(greyTextColor!)
                                    .copyWith(),

                                // TextStyle(
                                //   fontSize: 14.sp,
                                //   color: Colors.grey[800],
                                // ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              side: BorderSide(
                                color: shimmerBaseColor!,
                              ),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: AppTheme.bodyMediumTitleText(greyTextColor!)
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                majorBrands.add({
                                  'name': brandNameController.text,
                                  'category': selectedCategory!,
                                  'logo': _getCategoryIcon(selectedCategory!),
                                });
                                selectedBrands.add(brandNameController.text);
                              });
                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                        size: 20.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                          '${brandNameController.text} added successfully'),
                                    ],
                                  ),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.all(20.w),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: customYellow,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Add Brand',
                            style: AppTheme.bodyMediumTitleText(lightTextColor!)
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food & Beverage':
        return Icons.restaurant;
      case 'Retail':
        return Icons.store;
      case 'Health & Wellness':
        return Icons.healing;
      case 'Education & Training':
        return Icons.school;
      case 'Automotive':
        return Icons.directions_car;
      case 'Home Services':
        return Icons.home_repair_service;
      case 'Pet Care':
        return Icons.pets;
      case 'Childcare & Early Education':
        return Icons.child_care;
      case 'Real Estate':
        return Icons.apartment;
      case 'Logistics & Delivery':
        return Icons.local_shipping;
      case 'Hospitality & Travel':
        return Icons.hotel;
      case 'Business Services':
        return Icons.business_center;
      case 'Fitness & Sports':
        return Icons.fitness_center;
      case 'Beauty & Personal Care':
        return Icons.spa;
      case 'Entertainment & Recreation':
        return Icons.sports_esports;
      default:
        return Icons.store;
    }
  }

  void _toggleBrand(String brandName) {
    HapticFeedback.selectionClick();
    setState(() {
      if (selectedBrands.contains(brandName)) {
        selectedBrands.remove(brandName);
      } else {
        selectedBrands.add(brandName);
      }
    });
  }

  void _searchOnline() async {
    if (searchQuery.isEmpty) {
      _showAddCustomBrandDialog();
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
      _searchController.clear();
      searchQuery = '';
    });

    _showAddCustomBrandDialog();
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
                        Text(
                          '05/',
                          style: AppTheme.titleText(lightTextColor!).copyWith(
                            fontWeight: FontWeight.bold,
                          ),
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
                      value: 0.625,
                      minHeight: 8.h,
                      backgroundColor: textLightGreyColor,
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
                        'Are there specific franchise brands you are interested in?',
                        style: AppTheme.headingText(lightTextColor!)
                            .copyWith(fontWeight: FontWeight.w600, height: 1.2),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Search and select franchise brands or add your own',
                        style: AppTheme.mediumTitleText(greyTextColor!)
                            .copyWith(fontWeight: FontWeight.w400, height: 1.4),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) => setState(() => searchQuery = value),
                          decoration: InputDecoration(
                            hintText: 'Search or add custom brand...',
                            hintStyle: AppTheme.mediumTitleText(greyTextColor!)
                                .copyWith(fontWeight: FontWeight.w500),
                            prefixIcon: Icon(Icons.search,
                                color: greyTextColor, size: 15.sp),
                            filled: true,
                            fillColor: shimmerHighlightColor,
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
                      SizedBox(width: 8.w),
                      SizedBox(
                        height: 48.h,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _searchOnline,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: customYellow,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: isLoading
                              ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  lightTextColor),
                            ),
                          )
                              : Icon(
                            Icons.add,
                            color: lightTextColor,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (selectedBrands.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Selected Brands',
                              style: AppTheme.bodyMediumTitleText(greyTextColor!)
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () =>
                                  setState(() => selectedBrands.clear()),
                              child: Text(
                                'Clear all',
                                style: AppTheme.bodyMediumTitleText(customYellow)
                                    .copyWith(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: selectedBrands
                              .map(
                                (brand) => Chip(
                              label: Text(
                                brand,
                                style: AppTheme.smallText(lightTextColor!)
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                              deleteIcon: Icon(Icons.close, size: 16.sp),
                              onDeleted: () => _toggleBrand(brand),
                              backgroundColor: customYellow.withOpacity(0.1),
                              side: BorderSide(color: customYellow),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                          )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    itemCount: filteredBrands.length,
                    separatorBuilder: (context, index) => SizedBox(height: 8.h),
                    itemBuilder: (context, index) {
                      final brand = filteredBrands[index];
                      final isSelected = selectedBrands.contains(brand['name']);

                      return Material(
                        color: transparentColor,
                        child: InkWell(
                          onTap: () => _toggleBrand(brand['name']),
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
                              padding: EdgeInsets.all(12.w),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? customYellow
                                          : shimmerHighlightColor,
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Icon(
                                      brand['logo'],
                                      size: 20.sp,
                                      color: isSelected
                                          ? lightTextColor
                                          : greyTextColor,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          brand['name'],
                                          style: AppTheme.bodyMediumTitleText(
                                              isSelected
                                                  ? customYellow
                                                  : lightTextColor!)
                                              .copyWith(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          brand['category'],
                                          style: AppTheme.smallText(greyTextColor!)
                                              .copyWith(),
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
                        onPressed: selectedBrands.isNotEmpty
                            ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommonQuestionnareScreen1(
                                city: widget.city,
                                state: widget.state,
                                type: widget.type,
                                buyOrStart: widget.buyOrStart,
                                franchiseTypes: widget.franchiseTypes,
                                budget: widget.budget,
                                brands: selectedBrands.join(", "),
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
                              letterSpacing: 0.2, fontWeight: FontWeight.w500),
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
