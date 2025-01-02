// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lottie/lottie.dart';
// import 'package:project_emergio/Widgets/custom_funtions.dart';
// import 'package:project_emergio/generated/constants.dart';
// import 'package:project_emergio/models/all%20profile%20model.dart';
// import 'package:project_emergio/services/recommended%20ads.dart';
// import 'package:shimmer/shimmer.dart';
//
// class SearchRecommendedWidget extends StatefulWidget {
//   const SearchRecommendedWidget({Key? key}) : super(key: key);
//
//   @override
//   State<SearchRecommendedWidget> createState() => _SearchRecommendedWidgetState();
// }
//
// class _SearchRecommendedWidgetState extends State<SearchRecommendedWidget> {
//   List<ProductDetails>? _recommendedads;
//   List<BusinessInvestorExplr> _wishlistAllItems = [];
//   List<FranchiseExplr> _wishlistFranchiseItems = [];
//   List<AdvisorExplr> _advisorItems = [];
//
//   bool _isLoading = true;
//   bool _hasError = false;
//   bool _noData = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadRecommendedAds();
//   }
//
//   Future<void> _loadRecommendedAds() async {
//     try {
//       var data = await RecommendedAds.fetchRecommended();
//
//       if (data != null && data["error"] == "Preference doesnot exist") {
//         setState(() {
//           _isLoading = false;
//           _noData = true;
//         });
//       } else if (data != null) {
//         setState(() {
//           fetchRecommendedData(data);
//           _isLoading = false;
//           _hasError = false;
//           _noData = _recommendedads?.isEmpty ?? true;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _hasError = true;
//         _noData = false;
//       });
//     }
//   }
//
//   Future<void> fetchRecommendedData(Map<String, dynamic> data) async {
//     setState(() {
//       _recommendedads = data["recommended"];
//       _wishlistAllItems = data["recommendedAll"];
//       _wishlistFranchiseItems = data["recommendedFranchiseItems"] ?? [];
//       _advisorItems = data["advisor_data"];
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double h = MediaQuery.of(context).size.height;
//     final double w = MediaQuery.of(context).size.width;
//
//     return Container(
//       height: 300,
//       width: double.infinity,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Recommended",
//             style: AppTheme.mediumTitleText(lightTextColor).copyWith(fontWeight: FontWeight.bold),
//           ),
//           SizedBox(
//             height: 16,
//           ),
//           Expanded(
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(0.0),
//                     child: SizedBox(
//                       child: _isLoading
//                           ? _buildShimmer(w, h)
//                           : _hasError
//                           ? _buildErrorMessage(h)
//                           : _noData
//                           ? _buildNoDataMessage(h)
//                           : ListView.separated(
//                           scrollDirection: Axis.horizontal,
//                           itemBuilder: (context, index) {
//                             final item = _recommendedads![index];
//                             return Container(
//                               height: double.infinity,
//                               width: 168.w,
//                               padding: EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     begin: Alignment.bottomCenter,
//                                     end: Alignment.topCenter,
//                                     colors: [
//                                       Colors.black.withOpacity(0.8),
//                                       Colors.transparent
//                                     ],
//                                   ),
//                                   borderRadius:
//                                   BorderRadius.circular(10),
//                                   image: DecorationImage(
//                                       image: NetworkImage(
//                                           item.imageUrl),
//                                       fit: BoxFit.cover)),
//                               child: Column(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.end,
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     width: 150.w,
//                                     decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius:
//                                         BorderRadius.circular(
//                                             50)),
//                                     child: Padding(
//                                       padding:
//                                       const EdgeInsets.all(6.0),
//                                       child: Text(
//                                         item.name,
//                                         style: TextStyle(
//                                             color: Colors.black,
//                                             fontWeight:
//                                             FontWeight.bold,
//                                             fontSize: 14),
//                                         maxLines: 1,
//                                         overflow:
//                                         TextOverflow.ellipsis,
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 4),
//                                   Container(
//                                     width: 100.w,
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius:
//                                       BorderRadius.circular(50),
//                                     ),
//                                     child: Padding(
//                                       padding:
//                                       const EdgeInsets.all(6.0),
//                                       child: Row(
//                                         children: [
//                                           Icon(Icons.location_on,
//                                               color: Colors.amber,
//                                               size: 18.h),
//                                           const SizedBox(width: 5),
//                                           Flexible(
//                                             child: Text(
//                                               CustomFunctions.toSentenceCase(item.city),
//                                               style: AppTheme.smallText(lightTextColor),
//                                               maxLines: 1,
//                                               overflow: TextOverflow
//                                                   .ellipsis,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                 ],
//                               ),
//                             );
//                           },
//                           separatorBuilder: (context, index) {
//                             return SizedBox(
//                               width: 10,
//                             );
//                           },
//                           itemCount: _recommendedads!.length),
//                     ),
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
//   Widget _buildErrorMessage(double h) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.error_outline, size: 40, color: Colors.red),
//           const SizedBox(height: 12),
//           Text(
//               "Oops! Something went wrong.",
//               style:   AppTheme.titleText(lightTextColor)
//           ),
//           SizedBox(height: 6),
//           Text(
//               "Please try again later.",
//               style:  AppTheme.smallText(lightTextColor)
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNoDataMessage(double h) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Lottie.asset(
//             'assets/nodata.json',
//             height: 80.h,
//             width: 90.w,
//             fit: BoxFit.cover,
//           ),
//           const  SizedBox(height: 12),
//           Text(
//               "No recommended ads available",
//               style: AppTheme.titleText(lightTextColor)
//           ),
//           const SizedBox(height: 6),
//           Text(
//               "Check back soon for exciting offers!",
//               style: AppTheme.smallText(lightTextColor)
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildShimmer(double w, double h) {
//     return ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (context, index) {
//           return Shimmer.fromColors(
//             baseColor: shimmerBaseColor!,
//             highlightColor: shimmerHighlightColor!,
//             child: Container(
//               height: double.infinity,
//               width: 210,
//               decoration: BoxDecoration(
//                   color: containerColor,
//                   borderRadius: BorderRadius.circular(borderRadius)),
//             ),
//           );
//         },
//         separatorBuilder: (context, index) {
//           return const SizedBox(
//             width: 10,
//           );
//         },
//         itemCount: 6);
//     }
// }
