// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:intl/intl.dart';
// import 'package:project_emergio/Views/Profiles/Business/Business%20addPage.dart';
// import 'package:project_emergio/generated/constants.dart';
// import 'package:project_emergio/models/all profile model.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
//
// import '../../services/profile forms/advisor/advisor get.dart';
// import '../../services/profile forms/business/business get.dart';
// import '../../services/profile forms/franchise/franchise get.dart';
// import '../../services/profile forms/investor/investor get.dart';
// import '../../services/recent_enquries.dart';
// import '../Profiles/franchise/Franchise Form.dart';
// import '../Profiles/investor/Investor form.dart';
//
// class ProfileHeaderWithSlider extends StatefulWidget {
//   final dynamic profile;
//   final List<dynamic> allProfiles;
//   final Function(dynamic)? onProfileChanged;
//   final String type;
//
//   const ProfileHeaderWithSlider({
//     Key? key,
//     required this.profile,
//     required this.allProfiles,
//     this.onProfileChanged,
//     required this.type,
//   }) : super(key: key);
//
//   @override
//   State<ProfileHeaderWithSlider> createState() => _ProfileHeaderWithSliderState();
// }
//
// class _ProfileHeaderWithSliderState extends State<ProfileHeaderWithSlider> {
//   int activeIndex = 0;
//
//   void _handleProfileSwitch(dynamic newProfile) {
//     if (widget.onProfileChanged != null) {
//       widget.onProfileChanged!(newProfile);
//     }
//   }
//
//   Color get _themeColor {
//     switch (widget.type.toLowerCase()) {
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
//
//   String _getDisplayInfo() {
//     if (widget.type.toLowerCase() == "advisor") {
//       return (widget.profile as AdvisorExplr).expertise ?? 'Expertise not specified';
//     } else if (widget.type.toLowerCase() == "franchise") {
//       return (widget.profile as FranchiseExplr).initialInvestment ?? 'Investment not specified';
//     } else if (widget.type.toLowerCase() == "investor") {
//       return (widget.profile as BusinessInvestorExplr).totalInvestmentFrom ?? 'Investment size N/A';
//     } else {
//       return (widget.profile as BusinessInvestorExplr).askingPrice ?? 'Price not specified';
//     }
//   }
//
//   String _getDisplayPrice() {
//     if (widget.type.toLowerCase() == "advisor") {
//       // For advisor, show expertise or designation instead of price
//       final advisorProfile = widget.profile as AdvisorExplr;
//       return advisorProfile.expertise ?? advisorProfile.designation ?? 'Expertise not specified';
//     } else if (widget.type.toLowerCase() == "franchise") {
//       return (widget.profile as FranchiseExplr).initialInvestment ?? 'Investment not specified';
//     } else if (widget.type.toLowerCase() == "investor") {
//       return (widget.profile as BusinessInvestorExplr).totalInvestmentFrom ?? 'Investment size N/A';
//     } else {
//       return (widget.profile as BusinessInvestorExplr).askingPrice ?? 'Price not specified';
//     }
//   }
//
//   String _getDisplayType() {
//     if (widget.type.toLowerCase() == "advisor") {
//       return (widget.profile as AdvisorExplr).type ?? 'Advisor';
//     } else if (widget.type.toLowerCase() == "franchise") {
//       return (widget.profile as FranchiseExplr).entityType ?? 'Type not specified';
//     } else {
//       return (widget.profile as BusinessInvestorExplr).entityType ?? 'Type not specified';
//     }
//   }
//
//   List<String> _getImages() {
//     if (widget.type.toLowerCase() == "advisor") {
//       final advisorProfile = widget.profile as AdvisorExplr;
//       final List<String> images = [];
//
//       // Add main image
//       if (advisorProfile.imageUrl.isNotEmpty) {
//         images.add(advisorProfile.imageUrl);
//       }
//
//       // Add business photos if available
//       if (advisorProfile.businessPhotos != null) {
//         images.addAll(advisorProfile.businessPhotos!);
//       }
//
//       return images.isNotEmpty ? images : ['https://via.placeholder.com/400x200'];
//     } else if (widget.type.toLowerCase() == "franchise") {
//       final franchiseProfile = widget.profile as FranchiseExplr;
//       return [
//         franchiseProfile.imageUrl,
//         franchiseProfile.image2,
//         franchiseProfile.image3,
//         franchiseProfile.image4,
//       ].where((image) => image.isNotEmpty).toList();
//     } else {
//       final businessProfile = widget.profile as BusinessInvestorExplr;
//       return [
//         businessProfile.imageUrl,
//         businessProfile.image2,
//         businessProfile.image3,
//         if (businessProfile.image4 != null && businessProfile.image4!.isNotEmpty)
//           businessProfile.image4!,
//       ].where((image) => image.isNotEmpty).toList();
//     }
//   }
//
//   String _getDisplayName() {
//     if (widget.type.toLowerCase() == "advisor") {
//       return (widget.profile as AdvisorExplr).name;
//     } else if (widget.type.toLowerCase() == "franchise") {
//       return (widget.profile as FranchiseExplr).brandName;
//     } else {
//       return (widget.profile as BusinessInvestorExplr).title;
//     }
//   }
//
//   String _getDisplayLocation() {
//     if (widget.type.toLowerCase() == "advisor") {
//       return (widget.profile as AdvisorExplr).location;
//     } else if (widget.type.toLowerCase() == "franchise") {
//       return (widget.profile as FranchiseExplr).city;
//     } else {
//       return (widget.profile as BusinessInvestorExplr).city;
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final images = _getImages();
//
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.43.h,
//       child: Column(
//         children: [
//           // Image Slider Section
//           Container(
//             height: MediaQuery.of(context).size.height * 0.27,
//             child: Stack(
//               children: [
//                 CarouselSlider.builder(
//                   itemCount: images.length,
//                   options: CarouselOptions(
//                     height: MediaQuery.of(context).size.height * 0.28,
//                     viewportFraction: 1,
//                     autoPlay: true,
//                     autoPlayInterval: Duration(seconds: 5),
//                     onPageChanged: (index, reason) =>
//                         setState(() => activeIndex = index),
//                   ),
//                   itemBuilder: (context, index, realIndex) {
//                     return Container(
//                       width: double.infinity,
//                       child: Image.network(
//                         images[index],
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Container(
//                             color: Colors.grey[300],
//                             child: Icon(Icons.error_outline, color: Colors.grey[500]),
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 ),
//                 // Navigation and profile switcher
//                 Positioned(
//                   top: 0,
//                   left: 0,
//                   right: 0,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           Colors.black.withOpacity(0.4),
//                           Colors.transparent,
//                         ],
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.arrow_back, color: Colors.white),
//                           onPressed: () => Navigator.of(context).pop(),
//                         ),
//                         ProfileSwitcher(
//                           profiles: widget.allProfiles,
//                           onProfileSelected: _handleProfileSwitch,
//                           type: widget.type,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // Page Indicator
//                 Positioned(
//                   bottom: 8,
//                   left: 0,
//                   right: 0,
//                   child: Center(
//                     child: AnimatedSmoothIndicator(
//                       activeIndex: activeIndex,
//                       count: images.length,
//                       effect: ExpandingDotsEffect(
//                         dotHeight: 8,
//                         dotWidth: 8,
//                         spacing: 4,
//                         dotColor: Colors.white.withOpacity(0.5),
//                         activeDotColor: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Details Section
//           Container(
//             padding: EdgeInsets.all(12.w),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border(
//                 bottom: BorderSide(
//                   color: Colors.grey[200]!,
//                   width: 1,
//                 ),
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         _getDisplayName(),
//                         style: AppTheme.titleText(lightTextColor).copyWith(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 8.w,
//                         vertical: 2.h,
//                       ),
//                       decoration: BoxDecoration(
//                         color: _themeColor.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.verified,
//                             size: 12.sp,
//                             color: _themeColor,
//                           ),
//                           SizedBox(width: 4.w),
//                           Text(
//                             'Verified',
//                             style: AppTheme.smallText(_themeColor)
//                                 .copyWith(fontSize: 10.sp),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 8.h),
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.location_on,
//                       size: 14.sp,
//                       color: _themeColor,
//                     ),
//                     SizedBox(width: 4.w),
//                     Expanded(
//                       child: Text(
//                         _getDisplayLocation(),
//                         style: AppTheme.smallText(greyTextColor!),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 8.h),
//                 Row(
//                   children: [
//                     _buildInfoChip(
//                       widget.type.toLowerCase() == "franchise"
//                           ? Icons.store
//                           : widget.type.toLowerCase() == "investor"
//                           ? Icons.account_balance_wallet
//                           : Icons.business_center,
//                       _getDisplayType(),
//                     ),
//                     SizedBox(width: 12.w),
//                     _buildInfoChip(
//                       Icons.currency_rupee,
//                       _getDisplayPrice(),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoChip(IconData icon, String label) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(6.r),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon,
//             size: 12.sp,
//             color: greyTextColor,
//           ),
//           SizedBox(width: 4.w),
//           Text(
//             label,
//             style: AppTheme.smallText(greyTextColor!).copyWith(
//               fontSize: 10.sp,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class StatsCard extends StatelessWidget {
//   final EnquiryCounts? data;
//
//   const StatsCard({Key? key, required this.data}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.95,
//       margin: EdgeInsets.symmetric(horizontal: 8.w),
//       padding: EdgeInsets.all(16.w),
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
//         mainAxisSize: MainAxisSize.min, // Add this to prevent expansion
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: _buildStatItem(
//                   'Today Enquiry',
//                   data?.todayCount.toString() ?? '0',
//                   Icons.today,
//                   businessContainerColor,
//                 ),
//               ),
//               SizedBox(width: 16.w),
//               Expanded(
//                 child: _buildStatItem(
//                   'Total Impressions',
//                   data?.impressions.toString() ?? '0',
//                   Icons.bar_chart,
//                   investorContainerColor,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 16.h),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildStatItem(
//                   'Yesterday Enquiry',
//                   data?.yesterdayCount.toString() ?? '0',
//                   Icons.history,
//                   franchiseContainerColor,
//                 ),
//               ),
//               SizedBox(width: 16.w),
//               Expanded(
//                 child: _buildStatItem(
//                   'Total Enquiry',
//                   data?.totalCount.toString() ?? '0',
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
//   Widget _buildStatItem(String label, String value, IconData icon, Color color) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
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
//               Expanded(
//                 child: Text(
//                   value,
//                   style: AppTheme.titleText(lightTextColor).copyWith(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 8.h),
//           Text(
//             label,
//             style: AppTheme.smallText(greyTextColor!).copyWith(
//               fontSize: 12.sp,
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ProfileSwitcher extends StatefulWidget {
//   final List<dynamic> profiles;
//   final Function(dynamic) onProfileSelected;
//   final String type;
//
//   const ProfileSwitcher({
//     Key? key,
//     required this.profiles,
//     required this.onProfileSelected,
//     required this.type,
//   }) : super(key: key);
//
//   @override
//   State<ProfileSwitcher> createState() => _ProfileSwitcherState();
// }
//
// class _ProfileSwitcherState extends State<ProfileSwitcher> {
//   List<dynamic> _allProfiles = [];
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchProfiles();
//   }
//
//   Future<void> _fetchProfiles() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       final profiles = widget.type.toLowerCase() == "advisor"
//           ? await AdvisorFetchPage.fetchAdvisorData()
//           : widget.type.toLowerCase() == "franchise"
//           ? await FranchiseFetchPage.fetchFranchiseData()
//           : widget.type.toLowerCase() == "investor"
//           ? await InvestorFetchPage.fetchInvestorData()
//           : await BusinessGet.fetchBusinessListings();
//
//       if (profiles != null) {
//         setState(() {
//           _allProfiles = profiles;
//         });
//       }
//     } catch (e) {
//       print('Error fetching profiles: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to load profiles',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   String _getDisplayName(dynamic profile) {
//     if (widget.type.toLowerCase() == "advisor") {
//       return (profile as AdvisorExplr).name;
//     } else if (widget.type.toLowerCase() == "franchise") {
//       return (profile as FranchiseExplr).brandName;
//     } else {
//       return (profile as BusinessInvestorExplr).name;
//     }
//   }
//
//   String _getDisplayLocation(dynamic profile) {
//     if (widget.type.toLowerCase() == "advisor") {
//       return (profile as AdvisorExplr).location;
//     } else if (widget.type.toLowerCase() == "franchise") {
//       return (profile as FranchiseExplr).city;
//     } else {
//       return (profile as BusinessInvestorExplr).city;
//     }
//   }
//
//   String _getDisplayType(dynamic profile) {
//     if (widget.type.toLowerCase() == "advisor") {
//       return (profile as AdvisorExplr).designation ?? 'Expert';
//     } else if (widget.type.toLowerCase() == "franchise") {
//       return (profile as FranchiseExplr).entityType ?? 'Type not specified';
//     } else {
//       return (profile as BusinessInvestorExplr).entityType ?? 'Type not specified';
//     }
//   }
//
//   String _getImageUrl(dynamic profile) {
//     if (widget.type.toLowerCase() == "advisor") {
//       return (profile as AdvisorExplr).imageUrl;
//     } else if (widget.type.toLowerCase() == "franchise") {
//       return (profile as FranchiseExplr).imageUrl;
//     } else {
//       return (profile as BusinessInvestorExplr).imageUrl;
//     }
//   }
//
//   void show(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => DraggableScrollableSheet(
//         initialChildSize: 0.85,
//         minChildSize: 0.5,
//         maxChildSize: 0.95,
//         builder: (context, scrollController) => Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//           ),
//           child: Column(
//             children: [
//               // Draggable handle
//               Container(
//                 margin: EdgeInsets.symmetric(vertical: 10.h),
//                 width: 40.w,
//                 height: 4.h,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2.r),
//                 ),
//               ),
//
//               // Header
//               Padding(
//                 padding: EdgeInsets.all(16.w),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       widget.type.toLowerCase() == "franchise"
//                           ? 'Switch Franchise Profile'
//                           : widget.type == "investor"
//                           ? 'Switch Investor Profile'
//                           : 'Switch Business Profile',
//                       style: AppTheme.titleText(lightTextColor),
//                     ),
//                     Row(
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.refresh),
//                           onPressed: _fetchProfiles,
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.close),
//                           onPressed: () => Navigator.pop(context),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Add New Profile Button
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w),
//                 child: InkWell(
//                   onTap: () async {
//                     Navigator.pop(context);
//                     if (widget.type.toLowerCase() == "franchise") {
//                       await Get.to(() => FranchiseFormScreen(isEdit: false));
//                     } else if (widget.type.toLowerCase() == "investor") {
//                       await Get.to(() => InvestorFormScreen(isEdit: false));
//                     } else {
//                       await Get.to(() => BusinessInfoPage(isEdit: false));
//                     }
//                     _fetchProfiles();
//                   },
//                   child: Container(
//                     padding: EdgeInsets.all(16.w),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           widget.type.toLowerCase() == "franchise"
//                               ? franchiseContainerColor
//                               : widget.type.toLowerCase() == "investor"
//                               ? investorContainerColor
//                               : businessContainerColor,
//                           widget.type.toLowerCase() == "franchise"
//                               ? franchiseContainerColor.withOpacity(0.8)
//                               : widget.type.toLowerCase() == "investor"
//                               ? investorContainerColor.withOpacity(0.8)
//                               : businessContainerColor.withOpacity(0.8),
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.circular(12.r),
//                       boxShadow: [
//                         BoxShadow(
//                           color: widget.type.toLowerCase() == "franchise"
//                               ? franchiseContainerColor.withOpacity(0.3)
//                               : widget.type.toLowerCase() == "investor"
//                               ? investorContainerColor.withOpacity(0.3)
//                               : businessContainerColor.withOpacity(0.3),
//                           blurRadius: 8,
//                           offset: Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(10.r),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.2),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             widget.type.toLowerCase() == "franchise"
//                                 ? Icons.store
//                                 : widget.type.toLowerCase() == "investor"
//                                 ? Icons.person_add
//                                 : Icons.add_business,
//                             color: Colors.white,
//                             size: 24.sp,
//                           ),
//                         ),
//                         SizedBox(width: 16.w),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 widget.type.toLowerCase() == "franchise"
//                                     ? 'Add New Franchise'
//                                     : widget.type.toLowerCase() == "investor"
//                                     ? 'Add New Investor Profile'
//                                     : 'Add New Business',
//                                 style: AppTheme.titleText(Colors.white),
//                               ),
//                               SizedBox(height: 4.h),
//                               Text(
//                                 widget.type.toLowerCase() == "franchise"
//                                     ? 'Create a new franchise profile'
//                                     : widget.type.toLowerCase() == "investor"
//                                     ? 'Create a new investor profile'
//                                     : 'Create a new business profile',
//                                 style: AppTheme.smallText(Colors.white.withOpacity(0.8)),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Icon(
//                           Icons.arrow_forward_ios,
//                           color: Colors.white,
//                           size: 20.sp,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               // Section divider
//               Padding(
//                 padding: EdgeInsets.all(16.w),
//                 child: Row(
//                   children: [
//                     Expanded(child: Divider()),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 16.w),
//                       child: Text(
//                         widget.type.toLowerCase() == "franchise"
//                             ? 'Your Franchise Profiles'
//                             : widget.type.toLowerCase() == "investor"
//                             ? 'Your Investor Profiles'
//                             : 'Your Business Profiles',
//                         style: AppTheme.smallText(greyTextColor!),
//                       ),
//                     ),
//                     Expanded(child: Divider()),
//                   ],
//                 ),
//               ),
//
//               // Profiles List
//               Expanded(
//                 child: _isLoading
//                     ? Center(child: CircularProgressIndicator())
//                     : _allProfiles.isEmpty
//                     ? Center(
//                   child: Text(
//                     'No profiles found',
//                     style: AppTheme.mediumTitleText(greyTextColor!),
//                   ),
//                 )
//                     : ListView.builder(
//                   controller: scrollController,
//                   itemCount: _allProfiles.length,
//                   padding: EdgeInsets.symmetric(horizontal: 16.w),
//                   itemBuilder: (context, index) {
//                     final profile = _allProfiles[index];
//                     return EnhancedProfileCard(
//                       profile: profile,
//                       onTap: () {
//                         Navigator.pop(context);
//                         widget.onProfileSelected(profile);
//                       },
//                       type: widget.type,
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       onPressed: () => show(context),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20.r),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 4,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Switch profile',
//               style: AppTheme.smallText(Colors.black),
//             ),
//             SizedBox(width: 4.w),
//             Icon(Icons.swap_horiz, size: 16.sp),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class EnhancedProfileCard extends StatelessWidget {
//   final dynamic profile;
//   final VoidCallback onTap;
//   final String type;
//
//   const EnhancedProfileCard({
//     Key? key,
//     required this.profile,
//     required this.onTap,
//     required this.type,
//   }) : super(key: key);
//
//   Color get _themeColor {
//     switch (type.toLowerCase()) {
//       case "investor":
//         return investorContainerColor;
//       case "franchise":
//         return franchiseContainerColor;
//       default:
//         return businessContainerColor;
//     }
//   }
//
//   String _getDisplayName() {
//     if (type.toLowerCase() == "advisor") {
//       return (profile as AdvisorExplr).name;
//     } else if (type.toLowerCase() == "franchise") {
//       return (profile as FranchiseExplr).brandName;
//     } else {
//       return (profile as BusinessInvestorExplr).name;
//     }
//   }
//
//   String _getDisplayLocation() {
//     if (type.toLowerCase() == "advisor") {
//       return (profile as AdvisorExplr).location;
//     } else if (type.toLowerCase() == "franchise") {
//       return (profile as FranchiseExplr).city;
//     } else {
//       return (profile as BusinessInvestorExplr).city;
//     }
//   }
//
//   String _getDisplayType() {
//     if (type.toLowerCase() == "advisor") {
//       return (profile as AdvisorExplr).type ?? 'Advisor';
//     } else if (type.toLowerCase() == "franchise") {
//       return (profile as FranchiseExplr).entityType ?? 'Type not specified';
//     } else {
//       return (profile as BusinessInvestorExplr).entityType ?? 'Type not specified';
//     }
//   }
//
//   String _getImageUrl() {
//     if (type.toLowerCase() == "advisor") {
//       return (profile as AdvisorExplr).imageUrl;
//     } else if (type.toLowerCase() == "franchise") {
//       return (profile as FranchiseExplr).imageUrl;
//     } else {
//       return (profile as BusinessInvestorExplr).imageUrl;
//     }
//   }
//
//   String _getId() {
//     if (type.toLowerCase() == "advisor") {
//       return (profile as AdvisorExplr).id;
//     } else if (type.toLowerCase() == "franchise") {
//       return (profile as FranchiseExplr).id;
//     } else {
//       return (profile as BusinessInvestorExplr).id;
//     }
//   }
//
//   String? _getInvestmentInfo() {
//     if (type.toLowerCase() == "franchise") {
//       return (profile as FranchiseExplr).initialInvestment;
//     } else if (type.toLowerCase() == "investor") {
//       return (profile as BusinessInvestorExplr).totalInvestmentFrom;
//     }
//     return null;
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 12.h),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12.r),
//         child: Container(
//           padding: EdgeInsets.all(12.w),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12.r),
//             border: Border.all(color: Colors.grey[200]!),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 10,
//                 offset: Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               // Profile Image
//               Hero(
//                 tag: 'profile-${_getId()}',
//                 child: Container(
//                   width: 60.w,
//                   height: 60.w,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8.r),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 4,
//                         offset: Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(8.r),
//                     child: Image.network(
//                       _getImageUrl(),
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Container(
//                           color: Colors.grey[200],
//                           child: Icon(
//                             type.toLowerCase() == "franchise"
//                                 ? Icons.store
//                                 : type.toLowerCase() == "investor"
//                                 ? Icons.person
//                                 : Icons.business,
//                             color: Colors.grey[400],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 16.w),
//
//               // Profile Details
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       _getDisplayName(),
//                       style: AppTheme.titleText(lightTextColor),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: 4.h),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.location_on,
//                           size: 16.sp,
//                           color: greyTextColor,
//                         ),
//                         SizedBox(width: 4.w),
//                         Expanded(
//                           child: Text(
//                             _getDisplayLocation(),
//                             style: AppTheme.smallText(greyTextColor!),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 4.h),
//                     Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 8.w,
//                             vertical: 2.h,
//                           ),
//                           decoration: BoxDecoration(
//                             color: _themeColor.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(4.r),
//                           ),
//                           child: Text(
//                             'Active',
//                             style: AppTheme.smallText(_themeColor),
//                           ),
//                         ),
//                         SizedBox(width: 8.w),
//                         if (_getInvestmentInfo() != null)
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 8.w,
//                               vertical: 2.h,
//                             ),
//                             decoration: BoxDecoration(
//                               color: _themeColor.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(4.r),
//                             ),
//                             child: Text(
//                               _getInvestmentInfo()!,
//                               style: AppTheme.smallText(_themeColor),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Icon(
//                 Icons.arrow_forward_ios,
//                 size: 16.sp,
//                 color: greyTextColor,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:project_emergio/Views/Profiles/Business/Business%20addPage.dart';
import 'package:project_emergio/generated/constants.dart';
import 'package:project_emergio/models/all profile model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../services/profile forms/advisor/advisor get.dart';
import '../../services/profile forms/business/business get.dart';
import '../../services/profile forms/franchise/franchise get.dart';
import '../../services/profile forms/investor/investor get.dart';
import '../../services/recent_enquries.dart';
import '../Profiles/franchise/Franchise Form.dart';
import '../Profiles/investor/Investor form.dart';

class ProfileHeaderWithSlider extends StatefulWidget {
  final dynamic profile;
  final List<dynamic> allProfiles;
  final Function(dynamic)? onProfileChanged;
  final String type;

  const ProfileHeaderWithSlider({
    Key? key,
    required this.profile,
    required this.allProfiles,
    this.onProfileChanged,
    required this.type,
  }) : super(key: key);

  @override
  State<ProfileHeaderWithSlider> createState() => _ProfileHeaderWithSliderState();
}

class _ProfileHeaderWithSliderState extends State<ProfileHeaderWithSlider> {
  int activeIndex = 0;

  void _handleProfileSwitch(dynamic newProfile) {
    if (widget.onProfileChanged != null) {
      widget.onProfileChanged!(newProfile);
    }
  }

  Color get _themeColor {
    switch (widget.type.toLowerCase()) {
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


  String _getDisplayInfo() {
    if (widget.type.toLowerCase() == "advisor") {
      return (widget.profile as AdvisorExplr).expertise ?? 'Expertise not specified';
    } else if (widget.type.toLowerCase() == "franchise") {
      return (widget.profile as FranchiseExplr).initialInvestment ?? 'Investment not specified';
    } else if (widget.type.toLowerCase() == "investor") {
      return (widget.profile as BusinessInvestorExplr).totalInvestmentFrom ?? 'Investment size N/A';
    } else {
      return (widget.profile as BusinessInvestorExplr).askingPrice ?? 'Price not specified';
    }
  }

  String _getDisplayPrice() {
    if (widget.type.toLowerCase() == "advisor") {
      // For advisor, show expertise or designation instead of price
      final advisorProfile = widget.profile as AdvisorExplr;
      return advisorProfile.expertise ?? advisorProfile.designation ?? 'Expertise not specified';
    } else if (widget.type.toLowerCase() == "franchise") {
      return (widget.profile as FranchiseExplr).initialInvestment ?? 'Investment not specified';
    } else if (widget.type.toLowerCase() == "investor") {
      return (widget.profile as BusinessInvestorExplr).totalInvestmentFrom ?? 'Investment size N/A';
    } else {
      return (widget.profile as BusinessInvestorExplr).askingPrice ?? 'Price not specified';
    }
  }

  String _getDisplayType() {
    if (widget.type.toLowerCase() == "advisor") {
      return (widget.profile as AdvisorExplr).type ?? 'Advisor';
    } else if (widget.type.toLowerCase() == "franchise") {
      return (widget.profile as FranchiseExplr).entityType ?? 'Type not specified';
    } else {
      return (widget.profile as BusinessInvestorExplr).entityType ?? 'Type not specified';
    }
  }

  List<String> _getImages() {
    if (widget.type.toLowerCase() == "advisor") {
      final advisorProfile = widget.profile as AdvisorExplr;
      final List<String> images = [];

      // Add main image
      if (advisorProfile.imageUrl.isNotEmpty) {
        images.add(advisorProfile.imageUrl);
      }

      // Add business photos if available
      if (advisorProfile.businessPhotos != null) {
        images.addAll(advisorProfile.businessPhotos!);
      }

      return images.isNotEmpty ? images : ['https://via.placeholder.com/400x200'];
    } else if (widget.type.toLowerCase() == "franchise") {
      final franchiseProfile = widget.profile as FranchiseExplr;
      return [
        franchiseProfile.imageUrl,
        franchiseProfile.image2,
        franchiseProfile.image3,
        franchiseProfile.image4,
      ].where((image) => image.isNotEmpty).toList();
    } else {
      final businessProfile = widget.profile as BusinessInvestorExplr;
      return [
        businessProfile.imageUrl,
        businessProfile.image2,
        businessProfile.image3,
        if (businessProfile.image4 != null && businessProfile.image4!.isNotEmpty)
          businessProfile.image4!,
      ].where((image) => image.isNotEmpty).toList();
    }
  }

  String _getDisplayName() {
    if (widget.type.toLowerCase() == "advisor") {
      return (widget.profile as AdvisorExplr).name;
    } else if (widget.type.toLowerCase() == "franchise") {
      return (widget.profile as FranchiseExplr).brandName;
    } else {
      return (widget.profile as BusinessInvestorExplr).title;
    }
  }

  String _getDisplayLocation() {
    if (widget.type.toLowerCase() == "advisor") {
      return (widget.profile as AdvisorExplr).location;
    } else if (widget.type.toLowerCase() == "franchise") {
      return (widget.profile as FranchiseExplr).city;
    } else {
      return (widget.profile as BusinessInvestorExplr).city;
    }
  }



  @override
  Widget build(BuildContext context) {
    final images = _getImages();

    return Container(
      height: MediaQuery.of(context).size.height * 0.43.h,
      child: Column(
        children: [
          // Image Slider Section
          Container(
            height: MediaQuery.of(context).size.height * 0.27,
            child: Stack(
              children: [
                CarouselSlider.builder(
                  itemCount: images.length,
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.28,
                    viewportFraction: 1,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 5),
                    onPageChanged: (index, reason) =>
                        setState(() => activeIndex = index),
                  ),
                  itemBuilder: (context, index, realIndex) {
                    return Container(
                      width: double.infinity,
                      child: Image.network(
                        images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: Icon(Icons.error_outline, color: Colors.grey[500]),
                          );
                        },
                      ),
                    );
                  },
                ),
                // Navigation and profile switcher
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        ProfileSwitcher(
                          profiles: widget.allProfiles,
                          onProfileSelected: _handleProfileSwitch,
                          type: widget.type,
                        ),
                      ],
                    ),
                  ),
                ),
                // Page Indicator
                Positioned(
                  bottom: 8,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: AnimatedSmoothIndicator(
                      activeIndex: activeIndex,
                      count: images.length,
                      effect: ExpandingDotsEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 4,
                        dotColor: Colors.white.withOpacity(0.5),
                        activeDotColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Details Section
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _getDisplayName(),
                        style: AppTheme.titleText(lightTextColor).copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: _themeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified,
                            size: 12.sp,
                            color: _themeColor,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Verified',
                            style: AppTheme.smallText(_themeColor)
                                .copyWith(fontSize: 10.sp),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 14.sp,
                      color: _themeColor,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        _getDisplayLocation(),
                        style: AppTheme.smallText(greyTextColor!),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    _buildInfoChip(
                      widget.type.toLowerCase() == "franchise"
                          ? Icons.store
                          : widget.type.toLowerCase() == "investor"
                          ? Icons.account_balance_wallet
                          : Icons.business_center,
                      _getDisplayType(),
                    ),
                    SizedBox(width: 12.w),
                    _buildInfoChip(
                      Icons.currency_rupee,
                      _getDisplayPrice(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12.sp,
            color: greyTextColor,
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: AppTheme.smallText(greyTextColor!).copyWith(
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  final EnquiryCounts? data;

  const StatsCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
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
      child: Column(
        mainAxisSize: MainAxisSize.min, // Add this to prevent expansion
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Today Enquiry',
                  data?.todayCount.toString() ?? '0',
                  Icons.today,
                  businessContainerColor,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildStatItem(
                  'Total Impressions',
                  data?.impressions.toString() ?? '0',
                  Icons.bar_chart,
                  investorContainerColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Yesterday Enquiry',
                  data?.yesterdayCount.toString() ?? '0',
                  Icons.history,
                  franchiseContainerColor,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildStatItem(
                  'Total Enquiry',
                  data?.totalCount.toString() ?? '0',
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

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
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
              Expanded(
                child: Text(
                  value,
                  style: AppTheme.titleText(lightTextColor).copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: AppTheme.smallText(greyTextColor!).copyWith(
              fontSize: 12.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class ProfileSwitcher extends StatefulWidget {
  final List<dynamic> profiles;
  final Function(dynamic) onProfileSelected;
  final String type;

  const ProfileSwitcher({
    Key? key,
    required this.profiles,
    required this.onProfileSelected,
    required this.type,
  }) : super(key: key);

  @override
  State<ProfileSwitcher> createState() => _ProfileSwitcherState();
}

class _ProfileSwitcherState extends State<ProfileSwitcher> {
  List<dynamic> _allProfiles = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProfiles();
  }

  Future<void> _fetchProfiles() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final profiles = widget.type.toLowerCase() == "advisor"
          ? await AdvisorFetchPage.fetchAdvisorData()
          : widget.type.toLowerCase() == "franchise"
          ? await FranchiseFetchPage.fetchFranchiseData()
          : widget.type.toLowerCase() == "investor"
          ? await InvestorFetchPage.fetchInvestorData()
          : await BusinessGet.fetchBusinessListings();

      if (profiles != null) {
        setState(() {
          _allProfiles = profiles;
        });
      }
    } catch (e) {
      print('Error fetching profiles: $e');
      Get.snackbar(
        'Error',
        'Failed to load profiles',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getDisplayName(dynamic profile) {
    if (widget.type.toLowerCase() == "advisor") {
      return (profile as AdvisorExplr).name;
    } else if (widget.type.toLowerCase() == "franchise") {
      return (profile as FranchiseExplr).brandName;
    } else {
      return (profile as BusinessInvestorExplr).name;
    }
  }

  String _getDisplayLocation(dynamic profile) {
    if (widget.type.toLowerCase() == "advisor") {
      return (profile as AdvisorExplr).location;
    } else if (widget.type.toLowerCase() == "franchise") {
      return (profile as FranchiseExplr).city;
    } else {
      return (profile as BusinessInvestorExplr).city;
    }
  }

  String _getDisplayType(dynamic profile) {
    if (widget.type.toLowerCase() == "advisor") {
      return (profile as AdvisorExplr).designation ?? 'Expert';
    } else if (widget.type.toLowerCase() == "franchise") {
      return (profile as FranchiseExplr).entityType ?? 'Type not specified';
    } else {
      return (profile as BusinessInvestorExplr).entityType ?? 'Type not specified';
    }
  }

  String _getImageUrl(dynamic profile) {
    if (widget.type.toLowerCase() == "advisor") {
      return (profile as AdvisorExplr).imageUrl;
    } else if (widget.type.toLowerCase() == "franchise") {
      return (profile as FranchiseExplr).imageUrl;
    } else {
      return (profile as BusinessInvestorExplr).imageUrl;
    }
  }

  void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              // Draggable handle
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),

              // Header
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.type.toLowerCase() == "franchise"
                          ? 'Switch Franchise Profile'
                          : widget.type == "investor"
                          ? 'Switch Investor Profile'
                          : 'Switch Business Profile',
                      style: AppTheme.titleText(lightTextColor),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: _fetchProfiles,
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Add New Profile Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    if (widget.type.toLowerCase() == "franchise") {
                      await Get.to(() => FranchiseFormScreen(isEdit: false,type: 'franchise',));
                    } else if (widget.type.toLowerCase() == "investor") {
                      await Get.to(() => InvestorFormScreen(isEdit: false,type: 'investor'));
                    } else {
                      await Get.to(() => BusinessInfoPage(isEdit: false,type: 'business'));
                    }
                    _fetchProfiles();
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.type.toLowerCase() == "franchise"
                              ? franchiseContainerColor
                              : widget.type.toLowerCase() == "investor"
                              ? investorContainerColor
                              : businessContainerColor,
                          widget.type.toLowerCase() == "franchise"
                              ? franchiseContainerColor.withOpacity(0.8)
                              : widget.type.toLowerCase() == "investor"
                              ? investorContainerColor.withOpacity(0.8)
                              : businessContainerColor.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: widget.type.toLowerCase() == "franchise"
                              ? franchiseContainerColor.withOpacity(0.3)
                              : widget.type.toLowerCase() == "investor"
                              ? investorContainerColor.withOpacity(0.3)
                              : businessContainerColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.r),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.type.toLowerCase() == "franchise"
                                ? Icons.store
                                : widget.type.toLowerCase() == "investor"
                                ? Icons.person_add
                                : Icons.add_business,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.type.toLowerCase() == "franchise"
                                    ? 'Add New Franchise'
                                    : widget.type.toLowerCase() == "investor"
                                    ? 'Add New Investor Profile'
                                    : 'Add New Business',
                                style: AppTheme.titleText(Colors.white),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                widget.type.toLowerCase() == "franchise"
                                    ? 'Create a new franchise profile'
                                    : widget.type.toLowerCase() == "investor"
                                    ? 'Create a new investor profile'
                                    : 'Create a new business profile',
                                style: AppTheme.smallText(Colors.white.withOpacity(0.8)),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Section divider
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        widget.type.toLowerCase() == "franchise"
                            ? 'Your Franchise Profiles'
                            : widget.type.toLowerCase() == "investor"
                            ? 'Your Investor Profiles'
                            : 'Your Business Profiles',
                        style: AppTheme.smallText(greyTextColor!),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
              ),

              // Profiles List
              Expanded(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _allProfiles.isEmpty
                    ? Center(
                  child: Text(
                    'No profiles found',
                    style: AppTheme.mediumTitleText(greyTextColor!),
                  ),
                )
                    : ListView.builder(
                  controller: scrollController,
                  itemCount: _allProfiles.length,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemBuilder: (context, index) {
                    final profile = _allProfiles[index];
                    return EnhancedProfileCard(
                      profile: profile,
                      onTap: () {
                        Navigator.pop(context);
                        widget.onProfileSelected(profile);
                      },
                      type: widget.type,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => show(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Switch profile',
              style: AppTheme.smallText(Colors.black),
            ),
            SizedBox(width: 4.w),
            Icon(Icons.swap_horiz, size: 16.sp),
          ],
        ),
      ),
    );
  }
}

class EnhancedProfileCard extends StatelessWidget {
  final dynamic profile;
  final VoidCallback onTap;
  final String type;

  const EnhancedProfileCard({
    Key? key,
    required this.profile,
    required this.onTap,
    required this.type,
  }) : super(key: key);

  Color get _themeColor {
    switch (type.toLowerCase()) {
      case "investor":
        return investorContainerColor;
      case "franchise":
        return franchiseContainerColor;
      default:
        return businessContainerColor;
    }
  }

  String _getDisplayName() {
    if (type.toLowerCase() == "advisor") {
      return (profile as AdvisorExplr).name;
    } else if (type.toLowerCase() == "franchise") {
      return (profile as FranchiseExplr).brandName;
    } else {
      return (profile as BusinessInvestorExplr).name;
    }
  }

  String _getDisplayLocation() {
    if (type.toLowerCase() == "advisor") {
      return (profile as AdvisorExplr).location;
    } else if (type.toLowerCase() == "franchise") {
      return (profile as FranchiseExplr).city;
    } else {
      return (profile as BusinessInvestorExplr).city;
    }
  }

  String _getDisplayType() {
    if (type.toLowerCase() == "advisor") {
      return (profile as AdvisorExplr).type ?? 'Advisor';
    } else if (type.toLowerCase() == "franchise") {
      return (profile as FranchiseExplr).entityType ?? 'Type not specified';
    } else {
      return (profile as BusinessInvestorExplr).entityType ?? 'Type not specified';
    }
  }

  String _getImageUrl() {
    if (type.toLowerCase() == "advisor") {
      return (profile as AdvisorExplr).imageUrl;
    } else if (type.toLowerCase() == "franchise") {
      return (profile as FranchiseExplr).imageUrl;
    } else {
      return (profile as BusinessInvestorExplr).imageUrl;
    }
  }

  String _getId() {
    if (type.toLowerCase() == "advisor") {
      return (profile as AdvisorExplr).id;
    } else if (type.toLowerCase() == "franchise") {
      return (profile as FranchiseExplr).id;
    } else {
      return (profile as BusinessInvestorExplr).id;
    }
  }

  String? _getInvestmentInfo() {
    if (type.toLowerCase() == "franchise") {
      return (profile as FranchiseExplr).initialInvestment;
    } else if (type.toLowerCase() == "investor") {
      return (profile as BusinessInvestorExplr).totalInvestmentFrom;
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Profile Image
              Hero(
                tag: 'profile-${_getId()}',
                child: Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(
                      _getImageUrl(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Icon(
                            type.toLowerCase() == "franchise"
                                ? Icons.store
                                : type.toLowerCase() == "investor"
                                ? Icons.person
                                : Icons.business,
                            color: Colors.grey[400],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),

              // Profile Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getDisplayName(),
                      style: AppTheme.titleText(lightTextColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16.sp,
                          color: greyTextColor,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            _getDisplayLocation(),
                            style: AppTheme.smallText(greyTextColor!),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: _themeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'Active',
                            style: AppTheme.smallText(_themeColor),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        if (_getInvestmentInfo() != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: _themeColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              _getInvestmentInfo()!,
                              style: AppTheme.smallText(_themeColor),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
                color: greyTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}