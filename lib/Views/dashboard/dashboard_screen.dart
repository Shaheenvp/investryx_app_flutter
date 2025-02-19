// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../models/all profile model.dart';
// import '../../generated/constants.dart';
// import '../../services/recent_enquries.dart';
// import '../../controller/dashboard_controller.dart';
// import '../chat_screens/chat screen.dart';
// import 'dashboard_components.dart';
//
// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key, required this.type, this.id});
//   final String type;
//   final String? id;
//
//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }
//
// class _DashboardScreenState extends State<DashboardScreen>
//     with SingleTickerProviderStateMixin {
//   late Future<List<enquiry>?> _recentEnquiryFuture;
//   late Future<EnquiryCounts?> _enquiryCounts;
//   late final AnimationController _animationController;
//   late final Animation<double> _animation;
//
//   final DashboardController _controller = Get.put(DashboardController());
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//     _setupAnimation();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _controller.initializeWithProfile(widget.type, widget.id);
//     });
//   }
//
//   void _initializeData() {
//     _recentEnquiryFuture = RecentEnquiries.fetchEnquiries(id: widget.id);
//     _enquiryCounts = RecentEnquiries.fetchEnquiriesCounts(id: widget.id);
//   }
//
//   void _setupAnimation() {
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );
//
//     _animation = Tween<double>(begin: 0.0, end: 0.5)
//         .animate(_animationController)
//       ..addListener(() => setState(() {}));
//
//     _animationController.forward();
//   }
//
//   Future<void> _refreshAllData() async {
//     setState(() {
//       _recentEnquiryFuture = RecentEnquiries.fetchEnquiries(id: widget.id);
//       _enquiryCounts = RecentEnquiries.fetchEnquiriesCounts(id: widget.id);
//     });
//     await _controller.fetchListings(widget.type, profileId: widget.id, forceRefresh: true);
//   }
//
//   Future<void> _handleProfileChange(dynamic newProfile) async {
//     setState(() {
//       _recentEnquiryFuture = RecentEnquiries.fetchEnquiries(id: newProfile.id);
//       _enquiryCounts = RecentEnquiries.fetchEnquiriesCounts(id: newProfile.id);
//     });
//
//     switch (widget.type.toLowerCase()) {
//       case "advisor":
//         await _controller.updateCurrentAdvisorProfile(newProfile as AdvisorExplr);
//         break;
//       case "franchise":
//         await _controller.updateCurrentFranchiseProfile(newProfile as FranchiseExplr);
//         break;
//       default:
//         await _controller.updateCurrentProfile(newProfile as BusinessInvestorExplr);
//     }
//   }
//
//   @override
//   void didUpdateWidget(DashboardScreen oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.id != widget.id) {
//       _refreshAllData();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Obx(() {
//           if (_controller.isLoading.value && _controller.businessInvestorList.isEmpty) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           if (_controller.errorMessage.value.isNotEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     _controller.errorMessage.value,
//                     style: AppTheme.mediumTitleText(greyTextColor!),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 16.h),
//                   ElevatedButton(
//                     onPressed: _refreshAllData,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: businessContainerColor,
//                     ),
//                     child: Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           return SingleChildScrollView(
//             controller: _scrollController,
//             physics: AlwaysScrollableScrollPhysics(),
//             child: Column(
//               children: [
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.43.h,
//                   child: Column(
//                     children: [
//                       _buildProfileSection(),
//                     ],
//                   ),
//                 ),
//
//                 _buildStatsSection(),
//
//                 // Profile Progress and Enquiries sections
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 16.h),
//                   child: Column(
//                     children: [
//                       _buildProfileProgress(),
//                       SizedBox(height: 24.h),
//                       _buildEnquiriesHeader(),
//                       SizedBox(height: 12.h),
//                       _buildEnquiriesSection(),
//                       SizedBox(height: 20.h),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }
//
//   Widget _buildProfileSection() {
//     return Obx(() {
//       if (_controller.isLoading.value) {
//         return _profileShimmer();
//       }
//
//       switch (widget.type.toLowerCase()) {
//         case "advisor":
//           if (_controller.advisorList.isEmpty) {
//             return _profileShimmer();
//           }
//           return ProfileHeaderWithSlider(
//             profile: _controller.advisorList[0],
//             allProfiles: _controller.advisorList,
//             onProfileChanged: _handleProfileChange,
//             type: widget.type,
//           );
//         case "franchise":
//           if (_controller.franchiseLists.isEmpty) {
//             return _profileShimmer();
//           }
//           return ProfileHeaderWithSlider(
//             profile: _controller.franchiseLists[0],
//             allProfiles: _controller.franchiseLists,
//             onProfileChanged: _handleProfileChange,
//             type: widget.type,
//           );
//         default:
//           if (_controller.businessInvestorList.isEmpty) {
//             return _profileShimmer();
//           }
//           return ProfileHeaderWithSlider(
//             profile: _controller.businessInvestorList[0],
//             allProfiles: _controller.businessInvestorList,
//             onProfileChanged: _handleProfileChange,
//             type: widget.type,
//           );
//       }
//     });
//   }
//
//   // Future<void> _handleProfileChange(dynamic newProfile) async {
//   //   setState(() {
//   //     _recentEnquiryFuture = RecentEnquiries.fetchEnquiries(id: newProfile.id);
//   //     _enquiryCounts = RecentEnquiries.fetchEnquiriesCounts(id: newProfile.id);
//   //   });
//   //
//   //   await _controller.updateCurrentProfile(newProfile);
//   // }
//
//
//   Widget _buildStatsSection() {
//     return FutureBuilder<EnquiryCounts?>(
//       future: _enquiryCounts,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return _buildStatsShimmer();
//         }
//
//         return Container(
//           margin: EdgeInsets.symmetric(horizontal: 8.w),
//           child: StatsCard(data: snapshot.data),
//         );
//       },
//     );
//   }
//
//
//   Widget _buildProfileProgress() {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.r),
//         boxShadow: [
//           BoxShadow(
//             color: boxShadowColor.withOpacity(0.1),
//             spreadRadius: 0,
//             blurRadius: 10,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           CircularPercentIndicator(
//             radius: 45.0,
//             lineWidth: 8.0,
//             percent: 0.75,
//             startAngle: 180,
//             arcType: ArcType.FULL,
//             center: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "75%",
//                   style: AppTheme.titleText(lightTextColor).copyWith(
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 Text(
//                   "Complete",
//                   style: AppTheme.smallText(greyTextColor!).copyWith(
//                     fontSize: 10.sp,
//                   ),
//                 ),
//               ],
//             ),
//             progressColor: _getProgressColor(),
//             backgroundColor: Colors.grey[200]!,
//             arcBackgroundColor: Colors.grey[200]!,
//             circularStrokeCap: CircularStrokeCap.round,
//             animation: true,
//             animationDuration: 1500,
//           ),
//           SizedBox(width: 16.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Profile Completion',
//                   style: AppTheme.titleText(lightTextColor).copyWith(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(height: 6.h),
//                 Text(
//                   'Complete your profile to increase visibility and engagement.',
//                   style: AppTheme.smallText(greyTextColor!),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 SizedBox(height: 8.h),
//                 TextButton(
//                   onPressed: () {
//                     // Handle complete profile action
//                   },
//                   style: TextButton.styleFrom(
//                     padding: EdgeInsets.zero,
//                     minimumSize: Size(0, 0),
//                     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         'Complete Profile',
//                         style: AppTheme.smallText(_getProgressColor()).copyWith(
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       SizedBox(width: 4.w),
//                       Icon(
//                         Icons.arrow_forward,
//                         size: 14.sp,
//                         color: _getProgressColor(),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEnquiriesHeader() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           'Recent Enquiries',
//           style: AppTheme.titleText(lightTextColor).copyWith(
//             fontSize: 18.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         TextButton(
//           onPressed: () {
//             // Handle view all action
//           },
//           style: TextButton.styleFrom(
//             padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//             minimumSize: Size(0, 0),
//             tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'View All',
//                 style: AppTheme.smallText(businessContainerColor),
//               ),
//               SizedBox(width: 4.w),
//               Icon(
//                 Icons.arrow_forward_ios,
//                 size: 12.sp,
//                 color: businessContainerColor,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildEnquiriesSection() {
//     return FutureBuilder<List<enquiry>?>(
//       future: _recentEnquiryFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return _buildEnquiriesShimmer();
//         }
//
//         if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
//           return Container(
//             height: 100.h,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Colors.grey.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: Center(
//               child: Text(
//                 "No recent enquiries",
//                 style: AppTheme.smallText(lightTextColor),
//               ),
//             ),
//           );
//         }
//
//         return ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: snapshot.data!.length,
//           itemBuilder: (_, index) => _EnquiryCard(
//             enquiryData: snapshot.data![index],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildErrorStats() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.r),
//         boxShadow: [
//           BoxShadow(
//             color: boxShadowColor.withOpacity(0.1),
//             spreadRadius: 0,
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: _buildErrorStatItem(
//                   "Today's Enquiry",
//                   Icons.today,
//                   businessContainerColor,
//                 ),
//               ),
//               SizedBox(width: 12.w),
//               Expanded(
//                 child: _buildErrorStatItem(
//                   "Total Impressions",
//                   Icons.bar_chart,
//                   investorContainerColor,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 12.h),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildErrorStatItem(
//                   "Yesterday's Enquiry",
//                   Icons.history,
//                   franchiseContainerColor,
//                 ),
//               ),
//               SizedBox(width: 12.w),
//               Expanded(
//                 child: _buildErrorStatItem(
//                   "Total Enquiry",
//                   Icons.people,
//                   advisorContainerColor,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _profileShimmer() {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.4,
//       child: Shimmer.fromColors(
//         baseColor: shimmerBaseColor!,
//         highlightColor: shimmerHighlightColor!,
//         child: Container(
//           color: Colors.grey[300],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatsShimmer() {
//     return Shimmer.fromColors(
//       baseColor: shimmerBaseColor!,
//       highlightColor: shimmerHighlightColor!,
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.95,
//         height: MediaQuery.of(context).size.height * 0.25,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//           color: Colors.grey[300],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEnquiriesShimmer() {
//     return Shimmer.fromColors(
//       baseColor: shimmerBaseColor!,
//       highlightColor: shimmerHighlightColor!,
//       child: Column(
//         children: List.generate(
//           4,
//               (index) => Container(
//             height: 100,
//             width: double.infinity,
//             margin: const EdgeInsets.symmetric(vertical: 3),
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: BorderRadius.circular(15),
//             ),
//           ),
//         ),
//       ),);
//   }
//
//   Widget _buildErrorStatItem(String label, IconData icon, Color color) {
//     return Container(
//       padding: EdgeInsets.all(12.w),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(
//           color: color.withOpacity(0.1),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(6.r),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   icon,
//                   color: color,
//                   size: 16.sp,
//                 ),
//               ),
//               SizedBox(width: 8.w),
//               Text(
//                 '--',
//                 style: AppTheme.titleText(lightTextColor).copyWith(
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 8.h),
//           Text(
//             label,
//             style: AppTheme.smallText(greyTextColor!),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Color _getProgressColor() {
//     switch (widget.type) {
//       case "business":
//         return businessContainerColor;
//       case "investor":
//         return investorContainerColor;
//       case "franchise":
//         return franchiseContainerColor;
//       case "advisor":
//         return advisorContainerColor;
//       default:
//         return businessContainerColor;
//     }
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
// }
//
// class _EnquiryCard extends StatelessWidget {
//   final enquiry enquiryData;
//
//   const _EnquiryCard({required this.enquiryData});
//
//   // Function to launch phone dialer
//   void _launchPhoneDialer(BuildContext context) async {
//     final phoneNumber = enquiryData.user.username;
//     final uri = Uri.parse('tel:+91$phoneNumber');
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Could not launch phone dialer')),
//         );
//       }
//     }
//   }
//
//   // Function to navigate to chat screen
//   void _navigateToChat(BuildContext context) {
//     Get.to(() => ChatScreen(
//       chatUserId: enquiryData.user.id,
//       name: enquiryData.user.firstName.isNotEmpty
//           ? enquiryData.user.firstName
//           : enquiryData.user.username,
//       imageUrl: enquiryData.user.image,
//       roomId: enquiryData.roomId.toString(),
//       number: enquiryData.user.username,
//       lastActive: '',
//       isActive: false,
//     ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Parse the original datetime and convert to IST
//     final utcDateTime = DateTime.parse(enquiryData.created);
//     final istDateTime = utcDateTime.add(const Duration(hours: 5, minutes: 30)); // Convert to IST
//
//     // Format date and time in IST
//     final formatDate = DateFormat("dd MMM yyyy", 'en_US').format(istDateTime);
//     final formatTime = DateFormat("hh:mm a", 'en_US').format(istDateTime);
//
//     return Container(
//       margin: EdgeInsets.only(bottom: 12.h),
//       padding: EdgeInsets.all(12.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.r),
//         boxShadow: [
//           BoxShadow(
//             color: boxShadowColor.withOpacity(0.1),
//             spreadRadius: 0,
//             blurRadius: 10,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12.r),
//             child: enquiryData.user.image != null
//                 ? Image.network(
//               enquiryData.user.image!,
//               width: 60.w,
//               height: 60.w,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) {
//                 return _buildDefaultImage();
//               },
//             )
//                 : _buildDefaultImage(),
//           ),
//           SizedBox(width: 12.w),
//
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   enquiryData.user.firstName.isNotEmpty
//                       ? enquiryData.user.firstName
//                       : "+91 ${enquiryData.user.username}",
//                   style: AppTheme.titleText(lightTextColor).copyWith(
//                     fontSize: 15.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(height: 4.h),
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.calendar_today,
//                       color: businessContainerColor,
//                       size: 14.sp,
//                     ),
//                     SizedBox(width: 4.w),
//                     Text(
//                       formatDate,
//                       style: AppTheme.smallText(greyTextColor!),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 4.h),
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.access_time,
//                       color: greyTextColor,
//                       size: 14.sp,
//                     ),
//                     SizedBox(width: 4.w),
//                     Text(
//                       formatTime,
//                       style: AppTheme.smallText(greyTextColor!),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _ActionButton(
//                 icon: Icons.phone,
//                 onPressed: () => _launchPhoneDialer(context),
//                 color: businessContainerColor,
//               ),
//               SizedBox(width: 8.w),
//               _ActionButton(
//                 icon: Icons.message,
//                 onPressed: () => _navigateToChat(context),
//                 color: businessContainerColor,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDefaultImage() {
//     return Container(
//       width: 60.w,
//       height: 60.w,
//       color: Colors.grey[200],
//       child: Icon(Icons.person, color: Colors.grey[400], size: 30.w),
//     );
//   }
// }
//
// class _ActionButton extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onPressed;
//   final Color color;
//
//   const _ActionButton({
//     required this.icon,
//     required this.onPressed,
//     required this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: color,
//       borderRadius: BorderRadius.circular(30.r),
//       child: InkWell(
//         onTap: onPressed,
//         borderRadius: BorderRadius.circular(30.r),
//         child: Container(
//           width: 36.w,
//           height: 36.w,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(30.r),
//           ),
//           child: Icon(
//             icon,
//             color: Colors.white,
//             size: 18.sp,
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:project_emergio/Views/Profiles/Business/Business%20addPage.dart';
import 'package:project_emergio/Views/Profiles/advisor/advisor_profile_add_screen.dart';
import 'package:project_emergio/Views/Profiles/franchise/Franchise%20Form.dart';
import 'package:project_emergio/Views/Profiles/investor/Investor%20form.dart';
import 'package:project_emergio/Views/edit%20profile/edit_profile_screen.dart';
import 'package:project_emergio/services/profile%20forms/advisor/advisor%20get.dart';
import 'package:project_emergio/services/profile%20forms/business/business%20get.dart';
import 'package:project_emergio/services/profile%20forms/franchise/franchise%20get.dart';
import 'package:project_emergio/services/profile%20forms/investor/investor%20get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/all profile model.dart';
import '../../generated/constants.dart';
import '../../services/recent_enquries.dart';
import '../../controller/dashboard_controller.dart';
import '../chat_screens/chat screen.dart';
import 'dashboard_components.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.type, this.id});
  final String type;
  final String? id;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<enquiry>?> _recentEnquiryFuture;
  late Future<EnquiryCounts?> _enquiryCounts;
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  final DashboardController _controller = Get.put(DashboardController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupAnimation();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.initializeWithProfile(widget.type, widget.id);
    });
  }

  void _initializeData() {
    _recentEnquiryFuture = RecentEnquiries.fetchEnquiries(id: widget.id);
    _enquiryCounts = RecentEnquiries.fetchEnquiriesCounts(id: widget.id);
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _animation = Tween<double>(begin: 0.0, end: 0.5)
        .animate(_animationController)
      ..addListener(() => setState(() {}));

    _animationController.forward();
  }

  Future<void> _refreshAllData() async {
    setState(() {
      _recentEnquiryFuture = RecentEnquiries.fetchEnquiries(id: widget.id);
      _enquiryCounts = RecentEnquiries.fetchEnquiriesCounts(id: widget.id);
    });
    await _controller.fetchListings(widget.type,
        profileId: widget.id, forceRefresh: true);
  }

  Future<void> _handleProfileChange(dynamic newProfile) async {
    setState(() {
      _recentEnquiryFuture = RecentEnquiries.fetchEnquiries(id: newProfile.id);
      _enquiryCounts = RecentEnquiries.fetchEnquiriesCounts(id: newProfile.id);
    });

    switch (widget.type.toLowerCase()) {
      case "advisor":
        await _controller
            .updateCurrentAdvisorProfile(newProfile as AdvisorExplr);
        break;
      case "franchise":
        await _controller
            .updateCurrentFranchiseProfile(newProfile as FranchiseExplr);
        break;
      default:
        await _controller
            .updateCurrentProfile(newProfile as BusinessInvestorExplr);
    }
  }

  @override
  void didUpdateWidget(DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.id != widget.id) {
      _refreshAllData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 2,
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                // Back Button
                IconButton(
                  icon: Icon(Icons.arrow_back, color: lightTextColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                // Spacer to push action buttons to the right
                const Spacer(),
                // Edit Profile Button
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    color: _getProgressColor(),
                    size: 24,
                  ),
                  onPressed: _handleEdit,
                ),
                // Delete Profile Button
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 24,
                  ),
                  onPressed: () => _showDeleteDialog(
                    context,
                        () {
                      if (widget.type == 'business') {
                        BusinessGet.deleteBusiness(widget.id.toString());
                      } else if (widget.type == 'investor') {
                        InvestorFetchPage.deleteInvestor(widget.id.toString());
                      } else if (widget.type == 'franchise') {
                        FranchiseFetchPage.deleteFranchise(widget.id.toString());
                      } else if (widget.type == 'advisor') {
                        AdvisorFetchPage.deleteAdvisorProfile(widget.id.toString());
                      }
                    },
                  ),
                ),
                SizedBox(width: 8.w),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (_controller.isLoading.value &&
              _controller.businessInvestorList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_controller.errorMessage.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _controller.errorMessage.value,
                    style: AppTheme.mediumTitleText(greyTextColor!),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: _refreshAllData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: businessContainerColor,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildModernProfileSection(),
                _buildStatsSection(),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 16.h),
                  child: Column(
                    children: [
                      _buildProfileProgress(),
                      SizedBox(height: 24.h),
                      _buildEnquiriesHeader(),
                      SizedBox(height: 12.h),
                      _buildEnquiriesSection(),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildModernProfileSection() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.39.h,
      child: Stack(
        children: [
          // Background gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    _getProgressColor().withOpacity(0.05),
                  ],
                ),
              ),
            ),
          ),

          Column(
            children: [
              Expanded(
                child: _buildProfileSection(),
              ),
            ],
          ),
        ],
      ),
    );
  }



  // Widget _buildModernProfileSection() {
  //   return Container(
  //     height: MediaQuery.of(context).size.height * 0.43.h,
  //     child: Stack(
  //       children: [
  //         // Background gradient overlay
  //         Positioned.fill(
  //           child: Container(
  //             decoration: BoxDecoration(
  //               gradient: LinearGradient(
  //                 begin: Alignment.topCenter,
  //                 end: Alignment.bottomCenter,
  //                 colors: [
  //                   Colors.transparent,
  //                   _getProgressColor().withOpacity(0.05),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //
  //         // Main profile content
  //         Column(
  //           children: [
  //             Expanded(
  //               child: _buildProfileSection(),
  //             ),
  //
  //             // Control strip at the bottom of profile section
  //             Container(
  //               padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.black.withOpacity(0.05),
  //                     blurRadius: 10,
  //                     offset: Offset(0, -2),
  //                   ),
  //                 ],
  //               ),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 children: [
  //                   _buildActionButton(
  //                     icon: Icons.edit_outlined,
  //                     label: 'Edit Profile',
  //                     onTap: _handleEdit,
  //                     isPrimary: true,
  //                   ),
  //                   SizedBox(width: 12.w),
  //                   _buildActionButton(
  //                     icon: Icons.delete_outline,
  //                     label: 'Delete',
  //                     onTap: () => _showDeleteDialog(
  //                       context,
  //                           () {
  //                         if (widget.type == 'business') {
  //                           BusinessGet.deleteBusiness(widget.id.toString());
  //                         } else if (widget.type == 'investor') {
  //                           InvestorFetchPage.deleteInvestor(widget.id.toString());
  //                         } else if (widget.type == 'franchise') {
  //                           FranchiseFetchPage.deleteFranchise(widget.id.toString());
  //                         } else if (widget.type == 'advisor') {
  //                           AdvisorFetchPage.deleteAdvisorProfile(widget.id.toString());
  //                         }
  //                       },
  //                     ),
  //                     isDestructive: true,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildActionButton({
  //   required IconData icon,
  //   required String label,
  //   required VoidCallback onTap,
  //   bool isPrimary = false,
  //   bool isDestructive = false,
  // }) {
  //   Color baseColor = isPrimary
  //       ? _getProgressColor()
  //       : isDestructive
  //       ? Colors.red
  //       : greyTextColor!;
  //
  //   return Material(
  //     color: Colors.transparent,
  //     child: InkWell(
  //       onTap: onTap,
  //       borderRadius: BorderRadius.circular(8.r),
  //       child: Container(
  //         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
  //         decoration: BoxDecoration(
  //           border: Border.all(
  //             color: baseColor.withOpacity(0.2),
  //           ),
  //           borderRadius: BorderRadius.circular(8.r),
  //           color: isPrimary
  //               ? baseColor.withOpacity(0.1)
  //               : Colors.transparent,
  //         ),
  //         child: Row(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Icon(
  //               icon,
  //               size: 18.sp,
  //               color: baseColor,
  //             ),
  //             SizedBox(width: 8.w),
  //             Text(
  //               label,
  //               style: AppTheme.smallText(baseColor).copyWith(
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void _showDeleteDialog(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
              SizedBox(width: 8),
              Text("Delete Profile"),
            ],
          ),
          content: Text(
            "Are you sure you want to delete this profile? This action cannot be undone.",
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: TextStyle(color: greyTextColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
                Navigator.of(context).pop();
              },
              child: Text(
                "Delete",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleEdit() {
    String type = widget.type;

    if (type == "business") {
      Get.to(() => BusinessInfoPage(
        isEdit: true,
        busines: _controller.businessInvestorList[0],
        type: type,
      ));
    } else if (type == "investor") {
      Get.to(() => InvestorFormScreen(
        isEdit: true,
        investor: _controller.businessInvestorList[0],
        type: type,
      ));
    } else if (type == "advisor") {
      Get.to(() => EditProfileScreen(
        isEdit: true,
        advisor: _controller.advisorList[0],
        type: type,
        action: () {},
      ));
    } else if (type == "franchise") {
      Get.to(() => FranchiseFormScreen(
        isEdit: true,
        franchise: _controller.franchiseLists[0],
        type: type,
      ));
    }
  }

  // void _showDeleteDialog(BuildContext context, VoidCallback onConfirm) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Confirm Delete"),
  //         content: const Text("Are you sure you want to delete this item?"),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: const Text("Cancel"),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //               onConfirm();
  //               // Perform the delete action
  //               Navigator.of(context).pop(); // Close the dialog
  //
  //             },
  //             child: const Text(
  //               "Delete",
  //               style: TextStyle(color: Colors.red),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget _buildProfileSection() {
    return Obx(() {
      if (_controller.isLoading.value) {
        return _profileShimmer();
      }

      switch (widget.type.toLowerCase()) {
        case "advisor":
          if (_controller.advisorList.isEmpty) {
            return _profileShimmer();
          }
          return ProfileHeaderWithSlider(
            profile: _controller.advisorList[0],
            allProfiles: _controller.advisorList,
            onProfileChanged: _handleProfileChange,
            type: widget.type,
          );
        case "franchise":
          if (_controller.franchiseLists.isEmpty) {
            return _profileShimmer();
          }
          return ProfileHeaderWithSlider(
            profile: _controller.franchiseLists[0],
            allProfiles: _controller.franchiseLists,
            onProfileChanged: _handleProfileChange,
            type: widget.type,
          );
        default:
          if (_controller.businessInvestorList.isEmpty) {
            return _profileShimmer();
          }
          return ProfileHeaderWithSlider(
            profile: _controller.businessInvestorList[0],
            allProfiles: _controller.businessInvestorList,
            onProfileChanged: _handleProfileChange,
            type: widget.type,
          );
      }
    });
  }

  // Future<void> _handleProfileChange(dynamic newProfile) async {
  //   setState(() {
  //     _recentEnquiryFuture = RecentEnquiries.fetchEnquiries(id: newProfile.id);
  //     _enquiryCounts = RecentEnquiries.fetchEnquiriesCounts(id: newProfile.id);
  //   });
  //
  //   await _controller.updateCurrentProfile(newProfile);
  // }

  Widget _buildStatsSection() {
    return FutureBuilder<EnquiryCounts?>(
      future: _enquiryCounts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildStatsShimmer();
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          child: StatsCard(data: snapshot.data),
        );
      },
    );
  }

  Widget _buildProfileProgress() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: boxShadowColor.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 45.0,
            lineWidth: 8.0,
            percent: 0.75,
            startAngle: 180,
            arcType: ArcType.FULL,
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "75%",
                  style: AppTheme.titleText(lightTextColor).copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Complete",
                  style: AppTheme.smallText(greyTextColor!).copyWith(
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
            progressColor: _getProgressColor(),
            backgroundColor: Colors.grey[200]!,
            arcBackgroundColor: Colors.grey[200]!,
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
            animationDuration: 1500,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile Completion',
                  style: AppTheme.titleText(lightTextColor).copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Complete your profile to increase visibility and engagement.',
                  style: AppTheme.smallText(greyTextColor!),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                TextButton(
                  onPressed: () {
                    String type = widget.type;

                    if (type == "business") {
                      Get.to(BusinessInfoPage(
                        isEdit: true,
                        busines: _controller.businessInvestorList[0],
                        type: type,
                      ));
                    } else if (type == "investor") {
                      Get.to(InvestorFormScreen(
                        isEdit: true,
                        investor: _controller.businessInvestorList[0],
                        type: type,
                      ));
                    } else if (type == "advisor") {
                      Get.to(EditProfileScreen(
                        isEdit: true,
                        advisor: _controller.advisorList[0],
                        type: type,
                        action: () {},
                      ));
                    } else if (type == "franchise") {
                      Get.to(FranchiseFormScreen(
                        isEdit: true,
                        franchise: _controller.franchiseLists[0],
                        type: type,
                      ));
                    } else {
                      // Handle unknown type if necessary.
                      print("Unknown type: $type");
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Complete Profile',
                        style: AppTheme.smallText(_getProgressColor()).copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.arrow_forward,
                        size: 14.sp,
                        color: _getProgressColor(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnquiriesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Recent Enquiries',
          style: AppTheme.titleText(lightTextColor).copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
          onPressed: () {
            // Handle view all action
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'View All',
                style: AppTheme.smallText(businessContainerColor),
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.arrow_forward_ios,
                size: 12.sp,
                color: businessContainerColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnquiriesSection() {
    return FutureBuilder<List<enquiry>?>(
      future: _recentEnquiryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildEnquiriesShimmer();
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            height: 100.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                "No recent enquiries",
                style: AppTheme.smallText(lightTextColor),
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.length,
          itemBuilder: (_, index) => _EnquiryCard(
            enquiryData: snapshot.data![index],
          ),
        );
      },
    );
  }

  Widget _buildErrorStats() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: boxShadowColor.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildErrorStatItem(
                  "Today's Enquiry",
                  Icons.today,
                  businessContainerColor,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildErrorStatItem(
                  "Total Impressions",
                  Icons.bar_chart,
                  investorContainerColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildErrorStatItem(
                  "Yesterday's Enquiry",
                  Icons.history,
                  franchiseContainerColor,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildErrorStatItem(
                  "Total Enquiry",
                  Icons.people,
                  advisorContainerColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _profileShimmer() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Shimmer.fromColors(
        baseColor: shimmerBaseColor!,
        highlightColor: shimmerHighlightColor!,
        child: Container(
          color: Colors.grey[300],
        ),
      ),
    );
  }

  Widget _buildStatsShimmer() {
    return Shimmer.fromColors(
      baseColor: shimmerBaseColor!,
      highlightColor: shimmerHighlightColor!,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey[300],
        ),
      ),
    );
  }

  Widget _buildEnquiriesShimmer() {
    return Shimmer.fromColors(
      baseColor: shimmerBaseColor!,
      highlightColor: shimmerHighlightColor!,
      child: Column(
        children: List.generate(
          4,
              (index) => Container(
            height: 100,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorStatItem(String label, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 16.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '--',
                style: AppTheme.titleText(lightTextColor).copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: AppTheme.smallText(greyTextColor!),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Color _getProgressColor() {
    switch (widget.type) {
      case "business":
        return businessContainerColor;
      case "investor":
        return investorContainerColor;
      case "franchise":
        return franchiseContainerColor;
      case "advisor":
        return advisorContainerColor;
      default:
        return businessContainerColor;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class _EnquiryCard extends StatelessWidget {
  final enquiry enquiryData;

  const _EnquiryCard({required this.enquiryData});

  // Function to launch phone dialer
  void _launchPhoneDialer(BuildContext context) async {
    final phoneNumber = enquiryData.user.username;
    final uri = Uri.parse('tel:+91$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch phone dialer')),
        );
      }
    }
  }

  /// Function to navigate to chat screen
  void _navigateToChat(BuildContext context) {
    Get.to(() => ChatScreen(
      chatUserId: enquiryData.user.id,
      name: enquiryData.user.firstName.isNotEmpty
          ? enquiryData.user.firstName
          : enquiryData.user.username,
      imageUrl: enquiryData.user.image,
      roomId: enquiryData.roomId.toString(),
      number: enquiryData.user.username,
      lastActive: '',
      isActive: false,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.parse(enquiryData.created);
    final formatDate = DateFormat("dd MMM yyyy", 'en_US').format(dateTime.toLocal());
    final formatTime = DateFormat("hh:mm a", 'en_US').format(dateTime.toLocal());

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: boxShadowColor.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: enquiryData.user.image != null
                ? Image.network(
              enquiryData.user.image!,
              width: 60.w,
              height: 60.w,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildDefaultImage();
              },
            )
                : _buildDefaultImage(),
          ),
          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  enquiryData.user.firstName.isNotEmpty
                      ? enquiryData.user.firstName
                      : "+91 ${enquiryData.user.username}",
                  style: AppTheme.titleText(lightTextColor).copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: businessContainerColor,
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      formatDate,
                      style: AppTheme.smallText(greyTextColor!),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: greyTextColor,
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      formatTime,
                      style: AppTheme.smallText(greyTextColor!),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Updated Action Buttons with functionality
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ActionButton(
                icon: Icons.phone,
                onPressed: () => _launchPhoneDialer(context),
                color: businessContainerColor,
              ),
              SizedBox(width: 8.w),
              _ActionButton(
                icon: Icons.message,
                onPressed: () => _navigateToChat(context),
                color: businessContainerColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultImage() {
    return Container(
      width: 60.w,
      height: 60.w,
      color: Colors.grey[200],
      child: Icon(Icons.person, color: Colors.grey[400], size: 30.w),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
        color: color,
        borderRadius: BorderRadius.circular(30.r),
        child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(30.r),
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
            ),
        );
    }
}
