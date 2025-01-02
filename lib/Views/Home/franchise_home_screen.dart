// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:project_emergio/Views/Profiles/franchise/Franchise%20Form.dart';
// import 'package:project_emergio/Views/dashboard/dashboard_screen.dart';
// import 'package:project_emergio/Views/featured%20experts%20screen.dart';
// import 'package:project_emergio/Views/franchise%20explore%20page.dart';
// import 'package:project_emergio/Widgets/custom_profile_appbar_widget.dart';
// import 'package:project_emergio/Widgets/recent_posts_widget.dart';
// import 'package:project_emergio/Widgets/recommended%20widget.dart';
// import 'package:get/get.dart';
// import 'package:project_emergio/services/profile%20forms/franchise/franchise%20get.dart';
// import '../../Widgets/banner slider widget.dart';
// import '../../Widgets/featured_business_and_investor.dart';
//
//
// class FranchiseHomeScreen extends StatelessWidget {
//   const FranchiseHomeScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//     void handleProfileTap() async {
//       try {
//         final franchises = await FranchiseFetchPage.fetchFranchiseData();
//
//         if (franchises != null && franchises.isNotEmpty) {
//           // Pass the franchise ID to dashboard
//           Get.to(() => DashboardScreen(
//             type: "franchise",
//             id: franchises[0].id, // Add the ID here
//           ));
//         } else {
//           Get.to(() => FranchiseFormScreen(isEdit: false));
//         }
//       } catch (e) {
//         print('Error handling profile tap: $e');
//         Get.to(() => FranchiseFormScreen(isEdit: false));
//       }
//     }
//
//     return Scaffold(
//         backgroundColor: Colors.white,
//         appBar: CustomProfileHomeAppBar(
//           title: "Franchise",
//           type: "franchise",
//           onProfileTap: handleProfileTap
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               const   BannerSlider(
//                 type: "franchise",
//               ),
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Franchise Opportunities',
//                           style: TextStyle(
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.bold,
//                             color: const Color(0xFF333333),
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () => Get.to(() => FranchiseExplorePage()),
//                           child: Text(
//                             'View All',
//                             style: TextStyle(
//                               color: const Color(0xFFFFCC00),
//                               fontSize: 14.sp,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Text(
//                       'Explore profitable franchise opportunities for investment',
//                       style: TextStyle(
//                         fontSize: 12.sp,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Quick Actions Section
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 16.w),
//                 padding: EdgeInsets.all(16.w),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.grey[200]!),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Quick Actions',
//                       style: TextStyle(
//                         fontSize: 15.sp,
//                         fontWeight: FontWeight.w600,
//                         color: const Color(0xFF333333),
//                       ),
//                     ),
//                     SizedBox(height: 16.h),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: _buildQuickAction(
//                             icon: Icons.store,
//                             title: 'Franchise Profile',
//                             description: 'Create your profile',
//                             onTap: () {
//                               Get.to(() => FranchiseFormScreen(isEdit: false));
//                             },
//                           ),
//                         ),
//                         SizedBox(width: 12.w),
//                         Expanded(
//                           child: _buildQuickAction(
//                             icon: Icons.storefront,
//                             title: 'Browse Franchise',
//                             description: 'Explore deals',
//                             onTap: () {
//                               Get.to(() => FranchiseExplorePage());
//                             },
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const  LatestActivitiesList(profile: "franchise"),
//               const RecommendedAdsPage(
//                 profile: "franchise",
//               ),
//               const  FeaturedBusinessInvestorAndFranchise(
//                 profile: "franchise",
//               ),
//               const  FeatureExpertList(isType: true,),
//               SizedBox(height: 20.h),
//             ],
//           ),
//         ),
//         // bottomNavigationBar: BottomNavBar(),
//         );
//     }
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
import 'package:project_emergio/Views/Profiles/franchise/Franchise%20Form.dart';
import 'package:project_emergio/Views/dashboard/dashboard_screen.dart';
import 'package:project_emergio/Views/featured%20experts%20screen.dart';
import 'package:project_emergio/Views/franchise%20explore%20page.dart';
import 'package:project_emergio/Widgets/custom_profile_appbar_widget.dart';
import 'package:project_emergio/Widgets/recent_posts_widget.dart';
import 'package:project_emergio/Widgets/recommended%20widget.dart';
import 'package:get/get.dart';
import 'package:project_emergio/services/profile%20forms/franchise/franchise%20get.dart';
import '../../Widgets/banner slider widget.dart';
import '../../Widgets/featured_business_and_investor.dart';


class FranchiseHomeScreen extends StatelessWidget {
  const FranchiseHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    void handleProfileTap() async {
      try {
        final franchises = await FranchiseFetchPage.fetchFranchiseData();

        if (franchises != null && franchises.isNotEmpty) {
          // Pass the franchise ID to dashboard
          Get.to(() => DashboardScreen(
            type: "franchise",
            id: franchises[0].id, // Add the ID here
          ));
        } else {
          Get.to(() => FranchiseFormScreen(isEdit: false, type: 'franchise',));
        }
      } catch (e) {
        print('Error handling profile tap: $e');
        Get.to(() => FranchiseFormScreen(isEdit: false, type: 'franchise',));
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomProfileHomeAppBar(
          title: "Franchise",
          type: "franchise",
          onProfileTap: handleProfileTap
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const   BannerSlider(
              type: "franchise",
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
                        'Franchise Opportunities',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.to(() => FranchiseExplorePage()),
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
                    'Explore profitable franchise opportunities for investment',
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
                          icon: Icons.store,
                          title: 'Franchise Profile',
                          description: 'Create your profile',
                          onTap: () {
                            Get.to(() => FranchiseFormScreen(isEdit: false, type: 'franchise',));
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildQuickAction(
                          icon: Icons.storefront,
                          title: 'Browse Franchise',
                          description: 'Explore deals',
                          onTap: () {
                            Get.to(() => FranchiseExplorePage());
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const  LatestActivitiesList(profile: "franchise"),
            const RecommendedAdsPage(
              profile: "franchise",
            ),
            const  FeaturedBusinessInvestorAndFranchise(
              profile: "franchise",
            ),
            const  FeatureExpertList(isType: true,),
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
