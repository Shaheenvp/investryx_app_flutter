// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:project_emergio/generated/constants.dart';
//
//
// class CustomBusiness extends StatelessWidget {
//   final String? title;
//   final String description;
//   final String mainImage;
//   final String topRightImage;
//   final String bottomRightImage;
//   final Color backgroundColor;
//   final double height;
//   final VoidCallback navigation;
//
//   const CustomBusiness({
//     super.key,
//     this.title,
//     this.description = 'Lorem Ipsum Dolor Sit Amet Consectetur, Tellus Iaculis Orcit.',
//     this.mainImage = 'assets/business_vector.png',
//     this.topRightImage = 'assets/investor_vector.png',
//     this.bottomRightImage = 'assets/img2.png',
//     this.backgroundColor = const Color(0xff6B89B7),
//     this.height = 218,
//     required this.navigation
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding:  EdgeInsets.all(10.0.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//              SizedBox(height: 8.h),
//             Row(
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: Container(
//                     height: height,
//                     decoration: BoxDecoration(
//                       color: backgroundColor,
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Stack(
//                       children: [
//                         Positioned(
//                           right: 8.w,
//                           bottom: 8.h,
//                           child: Opacity(
//                               opacity: 0.6,
//                               child: Image.asset(mainImage)),
//                         ),
//                         Padding(
//                           padding:  EdgeInsets.all(15.0.w),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 title ?? "",
//                                 style:  TextStyle(
//                                   fontSize: titleFont,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                                // SizedBox(height: 5.h),
//                               Text(
//                                 description,
//                                 style:  TextStyle(
//                                     fontSize: mediumSmallFont,
//                                     color: Colors.white70),
//                               ),
//                               SizedBox(height: 10.h),
//                               ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.white,
//                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r))),
//                                   onPressed: navigation,
//                                   child: Text('Explore >',style: TextStyle(color: Color(0xffFFCC00)),)),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                  SizedBox(width: 8.w),
//                 Expanded(
//                   child: Column(
//                     children: [
//                       Container(
//                         height: 95.h,
//                         decoration: BoxDecoration(
//                           color: backgroundColor,
//                           borderRadius: BorderRadius.circular(16.r),
//                           image: DecorationImage(
//                             opacity: 0.8,
//                             image: AssetImage(
//                               topRightImage,),
//                           ),
//                         ),
//                       ),
//                        SizedBox(height: 8.h),
//                       Container(
//                         height: 95.h,
//                         decoration: BoxDecoration(
//                           color: backgroundColor,
//                           borderRadius: BorderRadius.circular(16.r),
//                           image: DecorationImage(
//                             opacity: 0.8,
//                             image: AssetImage(bottomRightImage),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBusiness extends StatelessWidget {
  final VoidCallback onSellBusiness;
  final VoidCallback onFindInvestors;

  const CustomBusiness({
    super.key,
    required this.onSellBusiness,
    required this.onFindInvestors,
  });

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
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28.w,
              color: const Color(0xFF2196F3),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              description,
              textAlign: TextAlign.center,
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

  @override
  Widget build(BuildContext context) {
    return Container(
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
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
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
                  onTap: onSellBusiness,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildQuickAction(
                  icon: Icons.handshake_outlined,
                  title: 'Find Investors',
                  description: 'Connect with investors',
                  onTap: onFindInvestors,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}