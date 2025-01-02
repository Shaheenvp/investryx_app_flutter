import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/generated/constants.dart';

import 'advisor_q2.dart';

class AdvisorQuestionnareScreen1 extends StatefulWidget {
  final String city;
  final String state;
  final String type;

  const AdvisorQuestionnareScreen1(
      {super.key, required this.city, required this.state, required this.type});

  @override
  State<AdvisorQuestionnareScreen1> createState() =>
      _AdvisorQuestionnareScreen1State();
}

class _AdvisorQuestionnareScreen1State extends State<AdvisorQuestionnareScreen1>
    with SingleTickerProviderStateMixin {
  final Set<String> selectedOptions = {};
  final Color customYellow = const Color(0xffFFCC00);

  final ScrollController _scrollController = ScrollController();
  String searchQuery = '';

  final List<Map<String, dynamic>> expertiseAreas = [
    {'title': 'Business Strategy & Planning', 'icon': Icons.access_time},
    {'title': 'Financial Planning & Analysis', 'icon': Icons.attach_money},
    {'title': 'Marketing & Branding', 'icon': Icons.campaign},
    {'title': 'Sales & Business Development', 'icon': Icons.trending_up},
    {'title': 'Operations Management', 'icon': Icons.settings},
    {'title': 'Supply Chain & Logistics', 'icon': Icons.local_shipping},
    {'title': 'Human Resources & Talent', 'icon': Icons.people},
    {'title': 'Legal & Compliance', 'icon': Icons.gavel},
    {'title': 'Technology & IT Consulting', 'icon': Icons.computer},
    {'title': 'Data Analytics & BI', 'icon': Icons.analytics},
    {'title': 'Project Management', 'icon': Icons.assignment},
    {'title': 'Investment & Fundraising', 'icon': Icons.account_balance},
    {'title': 'Mergers & Acquisitions', 'icon': Icons.merge_type},
    {'title': 'Product Development', 'icon': Icons.developer_board},
    {'title': 'Customer Experience', 'icon': Icons.support_agent},
    {'title': 'Sustainability & CSR', 'icon': Icons.eco},
    {'title': 'Risk Management', 'icon': Icons.security},
    {'title': 'PR & Communication', 'icon': Icons.record_voice_over},
    {'title': 'Quality Assurance', 'icon': Icons.verified},
    {'title': 'Healthcare & Medical', 'icon': Icons.local_hospital},
    {'title': 'Real Estate Management', 'icon': Icons.apartment},
    {'title': 'Government Affairs', 'icon': Icons.policy},
    {'title': 'Franchise Consulting', 'icon': Icons.store},
    {'title': 'Education & Training', 'icon': Icons.school},
    {'title': 'Crisis Management', 'icon': Icons.warning},
  ];

  List<Map<String, dynamic>> get filteredExpertise => searchQuery.isEmpty
      ? expertiseAreas
      : expertiseAreas
      .where((area) => area['title']
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
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
                    child: Text(
                      'Back',
                      style: AppTheme.mediumTitleText(greyTextColor!)
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                    child: Row(
                      children: [
                        Text(
                          '02/',
                          style: AppTheme.titleText(lightTextColor!)
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '08',
                          style: AppTheme.titleText(greyTextColor!),
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
                      value: 0.25,
                      minHeight: 8.h,
                      backgroundColor: textLightGreyColor,
                      valueColor: AlwaysStoppedAnimation<Color>(customYellow),
                    ),
                  ),
                ),

                // Question Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What areas of expertise do you offer?',
                        style: AppTheme.headingText(lightTextColor!).copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Select all areas that apply to your expertise',
                        style: AppTheme.bodyMediumTitleText(greyTextColor!)
                            .copyWith(height: 1.4),
                      ),
                    ],
                  ),
                ),

                // Search Bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  child: TextField(
                    onChanged: (value) => setState(() => searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search expertise...',
                      hintStyle: AppTheme.mediumTitleText(greyTextColor!)
                          .copyWith(fontWeight: FontWeight.w500),
                      prefixIcon:
                      Icon(Icons.search, color: Colors.grey[600], size: 15.sp),
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

                // Selected Count
                if (selectedOptions.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    child: Row(
                      children: [
                        Text(
                          '${selectedOptions.length} area${selectedOptions.length > 1 ? 's' : ''} selected',
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

                // Expertise Grid
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                    ),
                    itemCount: filteredExpertise.length,
                    itemBuilder: (context, index) {
                      final expertise = filteredExpertise[index];
                      final isSelected =
                      selectedOptions.contains(expertise['title']);

                      return Material(
                        color: transparentColor,
                        child: InkWell(
                          onTap: () => _toggleOption(expertise['title']),
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
                                      expertise['icon'],
                                      size: 18.sp,
                                      color: isSelected
                                          ? Colors.black
                                          : Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      expertise['title'],
                                      style: AppTheme.smallText(
                                        isSelected
                                            ? Colors.black
                                            : Colors.grey[600]!,
                                      ).copyWith(
                                        fontWeight: isSelected
                                            ? FontWeight.w500
                                            : FontWeight.normal,
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

                // Continue Button
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: containerColor,
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
                                  AdvisorQuestionnareScreen2(
                                    city: widget.city,
                                    state: widget.state,
                                    type: widget.type,
                                    expertise: selectedOptions.join(", "),
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
