// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:project_emergio/Views/Profiles/investor/Investor%20form.dart';
// import 'package:project_emergio/Views/business%20explore%20page.dart';
// import 'package:project_emergio/Views/dashboard/dashboard_screen.dart';
// import 'package:project_emergio/Widgets/custom_profile_appbar_widget.dart';
// import 'package:project_emergio/services/profile%20forms/investor/investor%20get.dart';
//
// import '../../Widgets/banner slider widget.dart';
// import '../../Widgets/featured_business_and_investor.dart';
// import '../../Widgets/recent_posts_widget.dart';
// import '../../Widgets/recommended widget.dart';
// import '../featured experts screen.dart';
//
// class InvestorHomeScreen extends StatelessWidget {
//   const InvestorHomeScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     void handleProfileTap() async {
//       try {
//         final investors = await InvestorFetchPage.fetchInvestorData();
//
//         if (investors != null && investors.isNotEmpty) {
//           // Navigate to dashboard with the first investor's ID
//           Get.to(() => DashboardScreen(
//             type: "investor",
//             id: investors[0].id, // Pass the ID here
//           ));
//         } else {
//           // If no investors found, navigate to investor form
//           Get.to(() => InvestorFormScreen(isEdit: false));
//         }
//       } catch (e) {
//         print('Error handling profile tap: $e');
//         Get.to(() => InvestorFormScreen(isEdit: false));
//       }
//     }
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CustomProfileHomeAppBar(
//           type: "investor",
//           title: 'Investment',
//           onProfileTap: handleProfileTap
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             BannerSlider(type: "investor"),
//             // Featured Business Section
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Business for Sale',
//                         style: TextStyle(
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.bold,
//                           color: const Color(0xFF333333),
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: () => Get.to(() => BusinessExplorePage()),
//                         child: Text(
//                           'View All',
//                           style: TextStyle(
//                             color: const Color(0xFFFFCC00),
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Text(
//                     'Explore businesses, investments, and stakes for acquisition',
//                     style: TextStyle(
//                       fontSize: 12.sp,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Quick Actions Section
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 16.w),
//               padding: EdgeInsets.all(16.w),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.grey[200]!),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Quick Actions',
//                     style: TextStyle(
//                       fontSize: 15.sp,
//                       fontWeight: FontWeight.w600,
//                       color: const Color(0xFF333333),
//                     ),
//                   ),
//                   SizedBox(height: 16.h),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildQuickAction(
//                           icon: Icons.person_add,
//                           title: 'Investor Profile',
//                           description: 'Create your profile',
//                           onTap: () async {
//                               Get.to(() => InvestorFormScreen(isEdit: false));
//                           },
//                         ),
//                       ),
//                       SizedBox(width: 12.w),
//                       Expanded(
//                         child: _buildQuickAction(
//                           icon: Icons.business_center,
//                           title: 'Browse Business',
//                           description: 'Explore businesses',
//                           onTap: () {
//                             Get.to(() => BusinessExplorePage());
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const LatestActivitiesList(profile: "investor"),
//             const RecommendedAdsPage(profile: "investor"),
//             const FeaturedBusinessInvestorAndFranchise(profile: "investor"),
//             const FeatureExpertList(isType: true),
//             SizedBox(height: 20.h),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildQuickAction({
//     required IconData icon,
//     required String title,
//     required String description,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         padding: EdgeInsets.all(16.w),
//         decoration: BoxDecoration(
//           color: const Color(0xFFFFCC00).withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFFFCC00),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(
//                 icon,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             ),
//             SizedBox(height: 12.h),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xFF333333),
//               ),
//             ),
//             SizedBox(height: 4.h),
//             Text(
//               description,
//               style: TextStyle(
//                 fontSize: 12.sp,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }







import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_emergio/Views/Profiles/investor/Investor%20form.dart';
import 'package:project_emergio/Views/business%20explore%20page.dart';
import 'package:project_emergio/Views/dashboard/dashboard_screen.dart';
import 'package:project_emergio/Widgets/custom_profile_appbar_widget.dart';
import 'package:project_emergio/services/profile%20forms/investor/investor%20get.dart';

import '../../Widgets/banner slider widget.dart';
import '../../Widgets/featured_business_and_investor.dart';
import '../../Widgets/recent_posts_widget.dart';
import '../../Widgets/recommended widget.dart';
import '../featured experts screen.dart';

class InvestorHomeScreen extends StatelessWidget {
  const InvestorHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void handleProfileTap() async {
      try {
        final investors = await InvestorFetchPage.fetchInvestorData();

        if (investors != null && investors.isNotEmpty) {
          // Navigate to dashboard with the first investor's ID
          Get.to(() => DashboardScreen(
            type: "investor",
            id: investors[0].id, // Pass the ID here
          ));
        } else {
          // If no investors found, navigate to investor form
          Get.to(() => InvestorFormScreen(isEdit: false, type: 'investor',));
        }
      } catch (e) {
        print('Error handling profile tap: $e');
        Get.to(() => InvestorFormScreen(isEdit: false, type: 'investor',));
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomProfileHomeAppBar(
          type: "investor",
          title: 'Investment',
          onProfileTap: handleProfileTap
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BannerSlider(type: "investor"),
            // Featured Business Section
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Business for Sale',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.to(() => BusinessExplorePage()),
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
                    'Explore businesses, investments, and stakes for acquisition',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
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
                          icon: Icons.person_add,
                          title: 'Investor Profile',
                          description: 'Create your profile',
                          onTap: () async {
                            Get.to(() => InvestorFormScreen(isEdit: false, type: 'investor',));
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildQuickAction(
                          icon: Icons.business_center,
                          title: 'Browse Business',
                          description: 'Explore businesses',
                          onTap: () {
                            Get.to(() => BusinessExplorePage());
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const LatestActivitiesList(profile: "investor"),
            const RecommendedAdsPage(profile: "investor"),
            const FeaturedBusinessInvestorAndFranchise(profile: "investor"),
            const FeatureExpertList(isType: true),
            SizedBox(height: 20.h),
          ],
        ),
      ),
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
              mainAxisAlignment: MainAxisAlignment.center,
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
