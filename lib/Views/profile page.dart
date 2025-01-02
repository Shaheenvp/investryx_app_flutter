//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:project_emergio/Views/Investment%20explore%20page.dart';
// import 'package:project_emergio/Views/advisor%20explore%20page.dart';
// import 'package:project_emergio/Views/business%20explore%20page.dart';
// import 'package:project_emergio/Views/franchise%20explore%20page.dart';
// import 'package:project_emergio/Views/settings_screen.dart';
// import '../controller/Profile controller.dart';
// import '../Views/personal information screen.dart';
// import '../Views/recent activities page.dart';
// import '../Views/manage profile screen.dart';
//
//
//
// class ProfileScreen extends StatelessWidget {
//   final ProfileController controller = Get.put(ProfileController());
//
//   ProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: Colors.white,
//       body: Obx(() {
//         return SizedBox(
//           height: double.infinity,
//           width: double.infinity,
//           child: Stack(
//             children: [
//               // Background image container (unchanged)
//               Obx(() => Stack(
//                   children: [
//                     Container(
//                       height: 310.h,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                           image: controller.profileImageUrl.value != null
//                               ? NetworkImage(controller.profileImageUrl.value!)
//                               : const AssetImage('assets/profile_picture.jpg') as ImageProvider,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       color: Colors.black45,
//                     )
//                   ])),
//
//               // White container with rounded corners
//               Padding(
//                 padding: EdgeInsets.only(top: 190.h),
//                 child: Container(
//                   height: 632.h,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(38.r),
//                       topRight: Radius.circular(38.r),
//                     ),
//                   ),
//                   child: SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     child: Padding(
//                       padding: EdgeInsets.only(top: 45.h),
//                       child: Column(
//                         children: [
//                           // Name and verification status
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 controller.firstName.value.isEmpty
//                                     ? 'Loading...'
//                                     : controller.firstName.value,
//                                 style: TextStyle(
//                                   fontSize: 22.sp,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               SizedBox(width: 8.w),
//                               Obx(() => controller.isVerified.value
//                                   ? Icon(
//                                 Icons.verified,
//                                 color: const Color(0xff6B89B7),
//                                 size: 24.sp,
//                               )
//                                   : SizedBox.shrink(),
//                               ),
//                             ],
//                           ),
//                           // Verification button or status
//                           Obx(() => !controller.isVerified.value
//                               ? Padding(
//                             padding: EdgeInsets.symmetric(vertical: 6.h),
//                             child: TextButton.icon(
//                               onPressed: () => controller.showVerificationBenefits(context), // Changed this line
//                               icon: Icon(
//                                 Icons.verified_outlined,
//                                 size: 20.sp,
//                                 color: const Color(0xff6B89B7),
//                               ),
//                               label: Text(
//                                 'Verify Now',
//                                 style: TextStyle(
//                                   fontSize: 14.sp,
//                                   color: const Color(0xff6B89B7),
//                                 ),
//                               ),
//                             ),
//                           )
//                               : Padding(
//                             padding: EdgeInsets.symmetric(vertical: 8.h),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.check_circle,
//                                   color: Colors.green,
//                                   size: 16.sp,
//                                 ),
//                                 SizedBox(width: 4.w),
//                                 Text(
//                                   'Verified Profile',
//                                   style: TextStyle(
//                                     fontSize: 14.sp,
//                                     color: Colors.green,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           ),
//
//                           SizedBox(height: 10.h),
//
//                           // Role Containers (unchanged)
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 11.w),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 InkWell(
//                                   onTap: (){
//                                     Navigator.push(context, MaterialPageRoute(builder: (context)=>BusinessExplorePage()));
//                                   },
//                                   child: _buildRoleContainer('Business',
//                                       const Color(0xff6B89B7), Icons.business),
//                                 ),
//                                 InkWell(
//                                   onTap: (){
//                                     Navigator.push(context, MaterialPageRoute(builder: (context)=>FranchiseExplorePage()));
//                                   },
//                                   child: _buildRoleContainer('Franchise',
//                                       const Color(0xffF3D55E), Icons.store),
//                                 ),
//                                 InkWell(
//                                   onTap: (){
//                                     Navigator.push(context, MaterialPageRoute(builder: (context)=>InvestorExplorePage()));
//                                   },
//                                   child: _buildRoleContainer('Investor',
//                                       const Color(0xffBDD0E7), Icons.monetization_on),
//                                 ),
//                                 InkWell(
//                                   onTap: (){
//                                     Navigator.push(context, MaterialPageRoute(builder: (context)=>AdvisorExploreScreen()));
//                                   },
//                                   child: _buildRoleContainer('Advisor',
//                                       const Color(0xffD9D9D9), Icons.person),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           SizedBox(height: 12.h),
//
//                           // List Tiles (unchanged)
//                           _buildListTile(
//                             'Personal Information',
//                             Icons.person,
//                             onTap: () {
//                               Get.to(
//                                     () => PersonalInformationScreen(
//                                   onUpdate: (newImage) {
//                                     if (newImage != null) {
//                                       String newImageUrl =
//                                       controller.profileImageUrl.value!;
//                                       controller.updateProfileImage(newImageUrl);
//                                     }
//                                   },
//                                 ),
//                               )?.then((_) => controller.fetchUserProfile());
//                             },
//                           ),
//                           _buildListTile(
//                             'Recent Activities',
//                             Icons.history,
//                             onTap: () => Get.to(() => RecentActivitiesScreen()),
//                           ),
//                           _buildListTile(
//                             'Manage Profiles',
//                             Icons.edit,
//                             onTap: () => Get.to(() => ManageProfileScreen()),
//                           ),
//                           _buildListTile(
//                             'Settings',
//                             Icons.settings,
//                             onTap: () => Get.to(() => SettingsScreen()),
//                           ),
//                           _buildListTile(
//                             'Log Out',
//                             Icons.exit_to_app,
//                             isLogout: true,
//                             onTap: () => controller.showLogoutDialog(context),
//                           ),
//                           SizedBox(height: 15.h),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               // Profile Image (unchanged)
//               Positioned(
//                 top: 115.h,
//                 left: 0,
//                 right: 0,
//                 child: Column(
//                   children: [
//                     CircleAvatar(
//                       radius: 58.r,
//                       backgroundImage: controller.profileImageUrl.value == null
//                           ? const AssetImage('assets/profile_picture.jpg') as ImageProvider
//                           : NetworkImage(controller.profileImageUrl.value!),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _buildRoleContainer(String title, Color color, IconData icon) {
//     return Container(
//       height: 80.h,
//       width: 80.w,
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(16.r),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             size: 26.sp,
//             color: Colors.white,
//           ),
//           SizedBox(height: 7.h),
//           Text(
//             title,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 13.5.sp,
//               fontWeight: FontWeight.bold,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildListTile(String title, IconData icon,
//       {bool isLogout = false, VoidCallback? onTap}) {
//     return ListTile(
//       contentPadding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 3.h),
//       leading: Icon(
//         icon,
//         color: isLogout ? Colors.red : Colors.black,
//         size: 23.sp,
//       ),
//       title: Text(
//         title,
//         style: TextStyle(
//           color: isLogout ? Colors.red : Colors.black,
//           fontSize: 15.sp,
//         ),
//       ),
//       trailing: Icon(Icons.arrow_forward_ios, size: 15.sp),
//       onTap: onTap,
//     );
//   }
// }
//
//
//

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_emergio/Views/Investment%20explore%20page.dart';
import 'package:project_emergio/Views/advisor%20explore%20page.dart';
import 'package:project_emergio/Views/business%20explore%20page.dart';
import 'package:project_emergio/Views/franchise%20explore%20page.dart';
import 'package:project_emergio/Views/settings_screen.dart';
import '../controller/Profile controller.dart';
import '../Views/personal information screen.dart';
import '../Views/recent activities page.dart';
import '../Views/manage profile screen.dart';
import '../generated/constants.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Obx(
          () => SingleChildScrollView(
            child: Padding(
              // Reduced horizontal padding for tablet
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 24.w : 16.w),
              child: Column(
                children: [
                  // Reduced top spacing for tablet
                  SizedBox(height: isTablet ? 40.h : 50.h),
                  _buildProfileHeader(isTablet),
                  SizedBox(height: isTablet ? 32.h : 15.h),
                  _buildRoleSection(isTablet),
                  SizedBox(height: isTablet ? 32.h : 15.h),
                  _buildMenuSection(isTablet),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(bool isTablet) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: buttonColor,
              // Reduced border width for tablet
              width: isTablet ? 2 : 2,
            ),
          ),
          child: CircleAvatar(
            // Adjusted avatar size for tablet
            radius: isTablet ? 60.r : 50.r,
            backgroundColor: borderColor,
            backgroundImage: controller.profileImageUrl.value != null
                ? NetworkImage(controller.profileImageUrl.value!)
                : const AssetImage('assets/profile_picture.jpg')
                    as ImageProvider,
          ),
        ),
        SizedBox(height: isTablet ? 20.h : 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              controller.firstName.value.isEmpty
                  ? 'Loading...'
                  : controller.firstName.value,
              // Adjusted text size for tablet
              style: isTablet
                  ? AppTheme.headingText(lightTextColor)
                      .copyWith(fontSize: 24.sp)
                  : AppTheme.headingText(lightTextColor),
            ),
            if (controller.isVerified.value) ...[
              SizedBox(width: isTablet ? 10.w : 8.w),
              Icon(
                Icons.verified,
                color: businessContainerColor,
                // Adjusted icon size for tablet
                size: isTablet ? 28.sp : 24.sp,
              ),
            ],
          ],
        ),
        SizedBox(height: 8.h),
        Obx(() {
          print(
              'Debug: Current verification status in UI: ${controller.isVerified.value}');
          return !controller.isVerified.value
              ? TextButton.icon(
                  onPressed: () =>
                      controller.showVerificationBenefits(Get.context!),
                  icon: Icon(
                    Icons.verified_outlined,
                    size: isTablet ? 22.sp : 20.sp,
                    color: businessContainerColor,
                  ),
                  label: Text(
                    'Verify Now',
                    style: AppTheme.mediumTitleText(businessContainerColor),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 20.w : 16.w,
                      vertical: isTablet ? 10.h : 8.h,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: isTablet ? 18.sp : 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Verified Profile',
                      style: AppTheme.mediumSmallText(Colors.green),
                    ),
                  ],
                );
        })
      ],
    );
  }

  Widget _buildRoleSection(bool isTablet) {
    final double containerSize = isTablet ? 70.w : 80.w;
    final spacing = isTablet ? 5.w : 10.w;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final totalWidth = (containerSize * 4) + (spacing * 2);

        if (availableWidth >= totalWidth) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRoleContainer(
                'Business',
                Icons.business,
                businessContainerColor,
                () => Get.to(() => BusinessExplorePage()),
                isTablet,
                containerSize,
              ),
              _buildRoleContainer(
                'Franchise',
                Icons.store,
                franchiseContainerColor,
                () => Get.to(() => FranchiseExplorePage()),
                isTablet,
                containerSize,
              ),
              _buildRoleContainer(
                'Investor',
                Icons.monetization_on,
                investorContainerColor,
                () => Get.to(() => InvestorExplorePage()),
                isTablet,
                containerSize,
              ),
              _buildRoleContainer(
                'Advisor',
                Icons.person,
                advisorContainerColor,
                () => Get.to(() => AdvisorExploreScreen()),
                isTablet,
                containerSize,
              ),
            ],
          );
        } else {
          return Wrap(
            alignment: WrapAlignment.spaceEvenly,
            spacing: spacing,
            runSpacing: spacing,
            children: [
              _buildRoleContainer(
                'Business',
                Icons.business,
                businessContainerColor,
                () => Get.to(() => BusinessExplorePage()),
                isTablet,
                containerSize,
              ),
              _buildRoleContainer(
                'Franchise',
                Icons.store,
                franchiseContainerColor,
                () => Get.to(() => FranchiseExplorePage()),
                isTablet,
                containerSize,
              ),
              _buildRoleContainer(
                'Investor',
                Icons.monetization_on,
                investorContainerColor,
                () => Get.to(() => InvestorExplorePage()),
                isTablet,
                containerSize,
              ),
              _buildRoleContainer(
                'Advisor',
                Icons.person,
                advisorContainerColor,
                () => Get.to(() => AdvisorExploreScreen()),
                isTablet,
                containerSize,
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildRoleContainer(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
    bool isTablet,
    double size,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: whiteTextColor,
              // Adjusted icon size for tablet
              size: isTablet ? 25.sp : 24.sp,
            ),
            SizedBox(height: isTablet ? 10.h : 8.h),
            Text(
              title,
              style: isTablet
                  ? AppTheme.smallText(whiteTextColor)
                  : AppTheme.mediumSmallText(whiteTextColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(bool isTablet) {
    return Container(
      constraints: BoxConstraints(
        // Adjusted max width for tablet
        maxWidth: isTablet ? 500.w : double.infinity,
      ),
      child: Column(
        children: [
          _buildMenuItem(
            'Personal Information',
            Icons.person_outline,
            onTap: () => Get.to(() => PersonalInformationScreen(
                  onUpdate: (newImage) {
                    if (newImage != null) {
                      controller.updateProfileImage(
                          controller.profileImageUrl.value!);
                    }
                  },
                ))?.then((_) => controller.fetchUserProfile()),
            isTablet: isTablet,
          ),
          _buildDivider(),
          _buildMenuItem(
            'Recent Activities',
            Icons.history,
            onTap: () => Get.to(() => RecentActivitiesScreen()),
            isTablet: isTablet,
          ),
          _buildDivider(),
          _buildMenuItem(
            'Manage Profiles',
            Icons.edit_outlined,
            onTap: () => Get.to(() => ManageProfileScreen()),
            isTablet: isTablet,
          ),
          _buildDivider(),
          _buildMenuItem(
            'Settings',
            Icons.settings_outlined,
            onTap: () => Get.to(() => SettingsScreen()),
            isTablet: isTablet,
          ),
          _buildDivider(),
          _buildMenuItem(
            'Log Out',
            Icons.logout,
            onTap: () => controller.showLogoutDialog(Get.context!),
            isLogout: true,
            isTablet: isTablet,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    String title,
    IconData icon, {
    required VoidCallback onTap,
    bool isLogout = false,
    required bool isTablet,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        // Adjusted padding for tablet
        vertical: isTablet ? 6.h : 4.h,
        horizontal: isTablet ? 12.w : 0,
      ),
      leading: Icon(
        icon,
        color: isLogout ? errorIconColor : iconColor,
        // Adjusted icon size for tablet
        size: isTablet ? 28.sp : 24.sp,
      ),
      title: Text(
        title,
        style: isTablet
            ? AppTheme.mediumTitleText(
                isLogout ? errorIconColor : lightTextColor,
              ).copyWith(fontSize: 16.sp)
            : AppTheme.mediumTitleText(
                isLogout ? errorIconColor : lightTextColor,
              ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        // Adjusted icon size for tablet
        size: isTablet ? 18.sp : 16.sp,
        color: isLogout ? errorIconColor.withOpacity(0.7) : iconColor,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1.h,
      thickness: 1,
      color: borderColor,
    );
  }
}
