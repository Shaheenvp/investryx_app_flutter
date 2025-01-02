import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_emergio/Views/Profiles/advisor/Advisor%20form.dart';
import 'package:project_emergio/Views/advisor%20explore%20page.dart';
import 'package:project_emergio/Views/featured%20experts%20screen.dart';
import 'package:project_emergio/Widgets/custom_profile_appbar_widget.dart';
import 'package:project_emergio/Widgets/recommended%20widget.dart';
import 'package:project_emergio/generated/constants.dart';
import 'package:project_emergio/services/profile%20forms/advisor/advisor%20get.dart';
import '../../Widgets/banner slider widget.dart';
import '../../Widgets/bottom navbar_widget.dart';
import '../../Widgets/custom_funtions.dart';
import '../../Widgets/home businessforsale_widget.dart';
import '../Profiles/advisor/advisor_profile_add_screen.dart';
import '../dashboard/dashboard_screen.dart';


class AdvisorHomeScreen extends StatelessWidget {
  const AdvisorHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    void handleProfileTap() async {
      try {
        final advisors = await AdvisorFetchPage.fetchAdvisorData();

        if (advisors != null && advisors.length > 0) {
          Get.to(() => DashboardScreen(
            type: "advisor",
            id: advisors[0].id, // Pass the ID of the first advisor
          ));
        } else {
          // If no advisors found, navigate to advisor form page
          Get.to(() => AddAdvisorProfileScreen());
        }
      } catch (e) {
        print('Error handling profile tap: $e');
        // In case of any error, navigate to advisor form page
        Get.to(() => AddAdvisorProfileScreen());
      }
    }


    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomProfileHomeAppBar(
          type: "advisor",
          title: 'Advisor',
          onProfileTap: handleProfileTap
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const BannerSlider(
                type: "advisor",
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Advisors & Business Brokers',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF333333),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Get.to(() => AdvisorExploreScreen()),
                          child: Text(
                            'View All',
                            style: TextStyle(
                              color: const Color(0xFFFFCC00),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Explore advisory and brokerage services for your business',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    // SizedBox(height: 12.h),
                    // Container(
                    //   padding: EdgeInsets.all(16.w),
                    //   decoration: BoxDecoration(
                    //     color: businessContainerColor,
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                    //   child: CustomBusiness(
                    //     // title: "Featured Businesses",
                    //     // backgroundColor: Colors.transparent,
                    //     // mainNavigation: () {  },
                    //     onSellBusiness: () {  }, onFindInvestors: () {  },
                    //     // navigation: null,
                    //   ),
                    // ),
                  ],
                ),
              ),
              // Quick Actions Section
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickAction(
                            icon: Icons.badge,
                            title: 'Advisor Profile',
                            description: 'Create your profile',
                            onTap: () {
                              Get.to(() => AddAdvisorProfileScreen());
                            },
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildQuickAction(
                            icon: Icons.groups,
                            title: 'Find Advisors',
                            description: 'Browse experts',
                            onTap: () {
                              Get.to(() => AdvisorExploreScreen());
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const FeatureExpertList(
                isType: true,
              ),
              const RecommendedAdsPage(
                profile: "advisor",
              ),
              const FeatureExpertList(
                isAdvisor: true,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
        // bottomNavigationBar: BottomNavBar(),
        );
    }
  Widget _buildQuickAction({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFFCC00).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFCC00),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              description,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
