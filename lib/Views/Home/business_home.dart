// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:project_emergio/Views/Investment%20explore%20page.dart';
// import 'package:project_emergio/Views/featured%20experts%20screen.dart';
// import 'package:project_emergio/Widgets/custom_profile_appbar_widget.dart';
// import 'package:project_emergio/Widgets/recent_posts_widget.dart';
// import 'package:project_emergio/Widgets/recommended%20widget.dart';
// import 'package:project_emergio/services/profile%20forms/business/business%20get.dart';
// import '../../Widgets/banner slider widget.dart';
// import '../../Widgets/custom_funtions.dart';
// import '../../Widgets/featured_business_and_investor.dart';
// import '../../controller/business_controller.dart';
// import '../Profiles/Business/Business addPage.dart';
// import '../Profiles/Business/Business_profile_add_screen.dart';
// import '../dashboard/dashboard_screen.dart';
//
//
// class BusinessHomeScreen extends StatelessWidget {
//   const BusinessHomeScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final BusinessProfileController businessController = Get.put(BusinessProfileController());
//
//     void handleProfileTap() async {
//       try {
//         final businesses = await BusinessGet.fetchBusinessListings();
//
//         if (businesses != null && businesses.length > 0) {
//           Get.to(() => DashboardScreen(type: "business", id: businesses[0].id));
//         } else {
//           // If no businesses found or error occurred, navigate to business info page
//           Get.to(() => const BusinessInfoPage(isEdit: false));
//         }
//       } catch (e) {
//         print('Error handling profile tap: $e');
//         // In case of any error, navigate to business info page
//         Get.to(() => BusinessInfoPage(isEdit: false));
//       }
//     }
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CustomProfileHomeAppBar(
//         type: "business",
//         title: "Business",
//         onProfileTap: handleProfileTap,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             BannerSlider(type: "business"),
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
//                         'Investors and Buyers',
//                         style: TextStyle(
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.bold,
//                           color: const Color(0xFF333333),
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: () => Get.to(() => InvestorExplorePage()),
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
//                     'Connect with investors ready to back your business or idea',
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
//
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
//
//                         child: _buildQuickAction(
//                           icon: Icons.add_business,
//                           title: 'Sell Business',
//                           description: 'List your business',
//                           onTap: () {
//                             Get.to(() => BusinessInfoPage(isEdit: false,));
//                           },
//                         ),
//                       ),
//                       SizedBox(width: 12.w),
//                       Expanded(
//                         child: _buildQuickAction(
//                           icon: Icons.handshake_outlined,
//                           title: 'Find Investors',
//                           description: 'Connect investors',
//                           onTap: () {
//                             Get.to(() => InvestorExplorePage());
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const LatestActivitiesList(profile: "business"),
//             const RecommendedAdsPage(profile: "business"),
//             const FeaturedBusinessInvestorAndFranchise(profile: "business"),
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
import 'package:project_emergio/Views/Investment%20explore%20page.dart';
import 'package:project_emergio/Views/featured%20experts%20screen.dart';
import 'package:project_emergio/Widgets/custom_profile_appbar_widget.dart';
import 'package:project_emergio/Widgets/recent_posts_widget.dart';
import 'package:project_emergio/Widgets/recommended%20widget.dart';
import 'package:project_emergio/services/profile%20forms/business/business%20get.dart';
import '../../Widgets/banner slider widget.dart';
import '../../Widgets/custom_funtions.dart';
import '../../Widgets/featured_business_and_investor.dart';
import '../../controller/business_controller.dart';
import '../Profiles/Business/Business addPage.dart';
import '../Profiles/Business/Business_profile_add_screen.dart';
import '../dashboard/dashboard_screen.dart';


class BusinessHomeScreen extends StatelessWidget {
  const BusinessHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BusinessProfileController businessController = Get.put(BusinessProfileController());

    void handleProfileTap() async {
      try {
        final businesses = await BusinessGet.fetchBusinessListings();

        if (businesses != null && businesses.length > 0) {
          Get.to(() => DashboardScreen(type: "business", id: businesses[0].id));
        } else {
          // If no businesses found or error occurred, navigate to business info page
          Get.to(() => const BusinessInfoPage(isEdit: false, type: 'business',));
        }
      } catch (e) {
        print('Error handling profile tap: $e');
        // In case of any error, navigate to business info page
        Get.to(() => BusinessInfoPage(isEdit: false, type: 'business',));
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomProfileHomeAppBar(
        type: "business",
        title: "Business",
        onProfileTap: handleProfileTap,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BannerSlider(type: "business"),
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
                        'Investors and Buyers',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.to(() => InvestorExplorePage()),
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
                    'Connect with investors ready to back your business or idea',
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
                          icon: Icons.add_business,
                          title: 'Sell Business',
                          description: 'List your business',
                          onTap: () {
                            Get.to(() => BusinessInfoPage(isEdit: false, type: 'business',));
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildQuickAction(
                          icon: Icons.handshake_outlined,
                          title: 'Find Investors',
                          description: 'Connect investors',
                          onTap: () {
                            Get.to(() => InvestorExplorePage());
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const LatestActivitiesList(profile: "business"),
            const RecommendedAdsPage(profile: "business"),
            const FeaturedBusinessInvestorAndFranchise(profile: "business"),
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
