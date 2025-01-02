// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:intl/intl.dart';
// import 'package:lottie/lottie.dart';
// import 'package:project_emergio/Views/Investment%20explore%20page.dart';
// import 'package:project_emergio/Views/advisor%20explore%20page.dart';
// import 'package:project_emergio/Views/business%20explore%20page.dart';
// import 'package:project_emergio/Views/detail%20page/advisor%20detail%20page.dart';
// import 'package:project_emergio/Views/franchise%20explore%20page.dart';
// import 'package:project_emergio/Widgets/custom_funtions.dart';
// import 'package:project_emergio/generated/constants.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import '../Views/detail page/business deatil page.dart';
// import '../Views/detail page/franchise detail page.dart';
// import '../Views/detail page/invester detail page.dart';
// import '../models/all profile model.dart';
// import '../services/recommended ads.dart';
// import '../services/recent activities.dart';
// import 'package:timeago/timeago.dart' as timeago;
//
// class RecommendedAdsPage extends StatefulWidget {
//   final String profile;
//   const RecommendedAdsPage({Key? key, required this.profile}) : super(key: key);
//   @override
//   _RecommendedAdsPageState createState() => _RecommendedAdsPageState();
// }
//
// class _RecommendedAdsPageState extends State<RecommendedAdsPage> {
//   List<ProductDetails>? _recommendedads;
//   List<BusinessInvestorExplr> _wishlistAllItems = [];
//   List<FranchiseExplr> _wishlistFranchiseItems = [];
//   List<AdvisorExplr> _advisorItems = [];
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
//       } else if (data != null &&
//           data.containsKey("status") &&
//           data["status"] == "loggedout") {
//       } else if (data != null) {
//         setState(() {
//           fetchRecommendedData(data);
//           _isLoading = false;
//           _hasError = false;
//           _noData = _recommendedads?.isEmpty ?? true;
//         });
//       } else {
//         _isLoading = false;
//         _hasError = true;
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
//     switch (widget.profile) {
//       case "investor":
//         setState(() {
//           _recommendedads = data['business_recommended'] ?? [];
//           _wishlistAllItems = data["business_data"] ?? [];
//         });
//         break;
//       case "business":
//         setState(() {
//           _recommendedads = data['investor_recommended'] ?? [];
//           _wishlistAllItems = data["investor_data"] ?? [];
//         });
//         break;
//       case "franchise":
//         setState(() {
//           _recommendedads = data['franchise_recommended'] ?? [];
//           _wishlistFranchiseItems = data["franchise_data"] ?? [];
//         });
//         break;
//       case "advisor":
//         _recommendedads = data["advisor_recommended"] ?? [];
//         _advisorItems = data["advisor_data"] ?? [];
//       default:
//         setState(() {
//           _recommendedads = data["recommended"] ?? [];
//           _wishlistAllItems = data["recommendedAll"] ?? [];
//           _wishlistFranchiseItems = data["recommendedFranchiseItems"] ?? [];
//           _advisorItems = data["advisor_data"] ?? [];
//         });
//         break;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Recommended list',
//                 style: AppTheme.titleText(lightTextColor),
//               ),
//               InkWell(
//                 onTap: () {
//                   switch (widget.profile) {
//                     case "business":
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const InvestorExplorePage(
//                                 currentIndex: 2,
//                               )));
//                       break;
//                     case "investor":
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const BusinessExplorePage(
//                                 currentIndex: 2,
//                               )));
//                       break;
//                     case "franchise":
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const FranchiseExplorePage(
//                                 currentIndex: 2,
//                               )));
//                       break;
//                     case "advisor":
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const AdvisorExploreScreen(
//                                 currentIndex: 2,
//                               )));
//                       break;
//                   }
//                 },
//                 child: Text(
//                   widget.profile == "home" ? "" : 'See all',
//                   style: AppTheme.bodyMediumTitleText(buttonColor)
//                       .copyWith(fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(
//           child: _isLoading
//               ? _buildShimmer()
//               : _hasError
//               ? _buildErrorMessage()
//               : _noData == true || _recommendedads == null
//               ? _buildNoDataMessage()
//               : _buildRecommendedAdsList(),
//         ),
//         SizedBox(height: 10.h),
//       ],
//     );
//   }
//
//   Widget _buildShimmer() {
//     return CarouselSlider.builder(
//       itemCount: 5,
//       itemBuilder: (context, index, realIndex) {
//         return Shimmer.fromColors(
//           baseColor: shimmerBaseColor!,
//           highlightColor: shimmerHighlightColor!,
//           child: Card(
//             margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
//             child: Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(16.w),
//               child: Row(
//                 children: [
//                   Container(
//                     height: 150.h,
//                     width: 120.w,
//                     color: containerColor,
//                   ),
//                   SizedBox(width: 16.w),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           height: 20.h,
//                           width: 100.w,
//                           color: containerColor,
//                         ),
//                         SizedBox(height: 8.h),
//                         Container(
//                           height: 16.h,
//                           width: 150.w,
//                           color: containerColor,
//                         ),
//                         SizedBox(height: 8.h),
//                         Container(
//                           height: 14.h,
//                           width: 80.w,
//                           color: containerColor,
//                         ),
//                         SizedBox(height: 16.h),
//                         Container(
//                           height: 36.h,
//                           width: 100.w,
//                           color: containerColor,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//       options: CarouselOptions(
//         height: 229.h,
//         viewportFraction: 0.8,
//         enlargeCenterPage: true,
//         autoPlay: true,
//         autoPlayInterval: const Duration(seconds: 3),
//         autoPlayAnimationDuration: const Duration(milliseconds: 800),
//         autoPlayCurve: Curves.fastOutSlowIn,
//       ),
//     );
//   }
//
//   Widget _buildErrorMessage() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.error_outline, size: 40.sp, color: errorIconColor),
//           SizedBox(height: 12.h),
//           Text(
//             "Oops! Something went wrong.",
//             style: AppTheme.titleText(lightTextColor),
//           ),
//           SizedBox(height: 6.h),
//           Text(
//             "Please try again later.",
//             style: AppTheme.smallText(lightTextColor),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNoDataMessage() {
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
//           SizedBox(height: 12.h),
//           Text(
//             "No recommended ads available",
//             style: AppTheme.titleText(lightTextColor),
//           ),
//           SizedBox(height: 6.h),
//           Text(
//             "Check back soon for exciting offers!",
//             style: AppTheme.smallText(lightTextColor),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRecommendedAdsList() {
//     return CarouselSlider.builder(
//       itemCount: _recommendedads?.length ?? 0,
//       itemBuilder: (context, index, realIndex) {
//         var item = _recommendedads![index];
//         final parsedDate = DateTime.parse(item.postedTime);
//         final formattedDate = DateFormat("dd-MM-yyyy").format(parsedDate);
//
//         return GestureDetector(
//           onTap: () {
//             _navigateToDetailPage(item, index);
//           },
//           child: Container(
//             margin: EdgeInsets.only( top: 2.h),
//             decoration: BoxDecoration(
//               color: containerColor,
//               borderRadius: BorderRadius.circular(borderRadius),
//               boxShadow: [
//                 BoxShadow(
//                   color: boxShadowColor,
//                   blurRadius: 3,
//                   offset: const Offset(1, 1),
//                 )
//               ],
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   height: double.infinity,
//                   width: 150.w,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     color: Colors.grey[300],
//                     image: DecorationImage(
//                       image: NetworkImage(item.imageUrl),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 26.w),
//                 Expanded(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 5.h),
//                       Text(
//                         CustomFunctions.toSentenceCase(item.title),
//                         style: AppTheme.mediumTitleText(lightTextColor),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       SizedBox(height: 2.h),
//                       Text(
//                         CustomFunctions.toSentenceCase(item.singleLineDescription),
//                         style: AppTheme.mediumSmallText(greyTextColor!)
//                             .copyWith(fontWeight: FontWeight.w500),
//                         maxLines: 1,
//                       ),
//                       Text(
//                         CustomFunctions.toSentenceCase(item.type),
//                         style: AppTheme.mediumSmallText(greyTextColor!)
//                             .copyWith(fontWeight: FontWeight.w800),
//                       ),
//                       SizedBox(height: 2.h),
//                       TextButton(
//                         onPressed: () {
//                           _navigateToDetailPage(item, index);
//                         },
//                         child: Row(
//                           children: [
//                             Text(
//                               'View Post ',
//                               style: AppTheme.mediumTitleText(Color(0xff0D0B56)),
//                             ),
//                             Icon(
//                               CupertinoIcons.arrow_right_circle_fill,
//                               color: Color(0xff0D0B56),
//                               size: 16.sp,
//                             )
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//       options: CarouselOptions(
//         height: 158.h,
//         viewportFraction: 0.95,
//         enlargeCenterPage: true,
//         autoPlay: true,
//         autoPlayInterval: const Duration(seconds: 6),
//         autoPlayAnimationDuration: const Duration(milliseconds: 800),
//         autoPlayCurve: Curves.fastOutSlowIn,
//       ),
//     );
//   }
//
//   Future<void> _navigateToDetailPage(ProductDetails item, int index) async {
//     await RecentActivities.recentActivities(productId: item.id);
//     if (item.type == 'business') {
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//           builder: (context) => BusinessDetailPage(
//           buisines: _wishlistAllItems[index],
//           imageUrl: _wishlistAllItems[index].imageUrl,
//           image2: _wishlistAllItems[index].image2,
//           image3: _wishlistAllItems[index].image3,
//           image4: _wishlistAllItems[index].image4,
//           name: _wishlistAllItems[index].name,
//           industry: _wishlistAllItems[index].industry,
//           establish_yr: _wishlistAllItems[index].establish_yr,
//           description: _wishlistAllItems[index].description,
//           address_1: _wishlistAllItems[index].address_1,
//           address_2: _wishlistAllItems[index].address_2,
//           pin: _wishlistAllItems[index].pin,
//           city: _wishlistAllItems[index].city,
//           state: _wishlistAllItems[index].state,
//           employees: _wishlistAllItems[index].employees,
//           entity: _wishlistAllItems[index].entity,
//           avg_monthly: _wishlistAllItems[index].avg_monthly,
//           latest_yearly: _wishlistAllItems[index].latest_yearly,
//             ebitda: _wishlistAllItems[index].ebitda,
//             rate: _wishlistAllItems[index].rate,
//             type_sale: _wishlistAllItems[index].type_sale,
//             url: _wishlistAllItems[index].url,
//             features: _wishlistAllItems[index].features,
//             facility: _wishlistAllItems[index].facility,
//             income_source: _wishlistAllItems[index].income_source,
//             reason: _wishlistAllItems[index].reason,
//             postedTime: _wishlistAllItems[index].postedTime,
//             topSelling: _wishlistAllItems[index].topSelling,
//             id: _wishlistAllItems[index].id,
//             showEditOption: false,
//           ),
//           ),
//       );
//     } else if (item.type == 'investor') {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => InvestorDetailPage(
//             investor: _wishlistAllItems[index],
//             imageUrl: _wishlistAllItems[index].imageUrl,
//             name: _wishlistAllItems[index].name,
//             city: _wishlistAllItems[index].city,
//             postedTime: _wishlistAllItems[index].postedTime,
//             state: _wishlistAllItems[index].state,
//             industry: _wishlistAllItems[index].industry,
//             description: _wishlistAllItems[index].description,
//             url: _wishlistAllItems[index].url,
//             rangeStarting: _wishlistAllItems[index].rangeStarting,
//             rangeEnding: _wishlistAllItems[index].rangeEnding,
//             evaluatingAspects: _wishlistAllItems[index].evaluatingAspects,
//             CompanyName: _wishlistAllItems[index].companyName,
//             locationInterested: _wishlistAllItems[index].locationIntrested,
//             id: _wishlistAllItems[index].id,
//             showEditOption: false,
//             image2: _wishlistAllItems[index].image2 ?? '',
//             image3: _wishlistAllItems[index].image3 ?? '',
//             image4: _wishlistAllItems[index].image4,
//           ),
//         ),
//       );
//     } else if (item.type == 'franchise') {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => FranchiseDetailPage(
//             franchise: _wishlistFranchiseItems[index],
//             id: _wishlistFranchiseItems[index].id,
//             imageUrl: _wishlistFranchiseItems[index].imageUrl,
//             image2: _wishlistFranchiseItems[index].image2,
//             image3: _wishlistFranchiseItems[index].image3,
//             image4: _wishlistFranchiseItems[index].image4,
//             brandName: _wishlistFranchiseItems[index].brandName,
//             city: _wishlistFranchiseItems[index].city,
//             postedTime: _wishlistFranchiseItems[index].postedTime,
//             state: _wishlistFranchiseItems[index].state,
//             industry: _wishlistFranchiseItems[index].industry,
//             description: _wishlistFranchiseItems![index].description,
//             url: _wishlistFranchiseItems[index].url,
//             initialInvestment: _wishlistFranchiseItems[index].initialInvestment,
//             projectedRoi: _wishlistFranchiseItems[index].projectedRoi,
//             iamOffering: _wishlistFranchiseItems[index].iamOffering,
//             currentNumberOfOutlets: _wishlistFranchiseItems[index].currentNumberOfOutlets,
//             franchiseTerms: _wishlistFranchiseItems[index].franchiseTerms,
//             locationsAvailable: _wishlistFranchiseItems[index].locationsAvailable,
//             kindOfSupport: _wishlistFranchiseItems[index].kindOfSupport,
//             allProducts: _wishlistFranchiseItems[index].allProducts,
//             brandStartOperation: _wishlistFranchiseItems[index].brandStartOperation,
//             spaceRequiredMin: _wishlistFranchiseItems[index].spaceRequiredMin,
//             spaceRequiredMax: _wishlistFranchiseItems[index].spaceRequiredMax,
//             totalInvestmentFrom: _wishlistFranchiseItems[index].totalInvestmentFrom,
//             totalInvestmentTo: _wishlistFranchiseItems[index].totalInvestmentTo,
//             brandFee: _wishlistFranchiseItems[index].brandFee,
//             avgNoOfStaff: _wishlistFranchiseItems[index].avgNoOfStaff,
//             avgMonthlySales: _wishlistFranchiseItems[index].avgMonthlySales,
//             avgEBITDA: _wishlistFranchiseItems[index].avgEBITDA,
//             showEditOption: false,
//           ),
//         ),
//       );
//     } else {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => AdvisorDetailPage(
//             advisor: _advisorItems[index],
//           ),
//         ),
//       );
//     }
//   }
//
//   String formatDateTime(String dateTimeStr) {
//     DateTime dateTime = DateTime.parse(dateTimeStr);
//     return timeago.format(dateTime, allowFromNow: true);
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:project_emergio/Views/Investment%20explore%20page.dart';
import 'package:project_emergio/Views/advisor%20explore%20page.dart';
import 'package:project_emergio/Views/business%20explore%20page.dart';
import 'package:project_emergio/Views/detail%20page/advisor%20detail%20page.dart';
import 'package:project_emergio/Views/franchise%20explore%20page.dart';
import 'package:project_emergio/Widgets/custom_funtions.dart';
import 'package:project_emergio/generated/constants.dart';
import 'package:shimmer/shimmer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../Views/detail page/business deatil page.dart';
import '../Views/detail page/franchise detail page.dart';
import '../Views/detail page/invester detail page.dart';
import '../models/all profile model.dart';
import '../services/recommended ads.dart';
import '../services/recent activities.dart';
import 'package:timeago/timeago.dart' as timeago;

class RecommendedAdsPage extends StatefulWidget {
  final String profile;
  const RecommendedAdsPage({Key? key, required this.profile}) : super(key: key);
  @override
  _RecommendedAdsPageState createState() => _RecommendedAdsPageState();
}

class _RecommendedAdsPageState extends State<RecommendedAdsPage> {
  List<ProductDetails>? _recommendedads;
  List<BusinessInvestorExplr> _wishlistAllItems = [];
  List<FranchiseExplr> _wishlistFranchiseItems = [];
  List<AdvisorExplr> _advisorItems = [];
  bool _isLoading = true;
  bool _hasError = false;
  bool _noData = false;

  @override
  void initState() {
    super.initState();
    _loadRecommendedAds();
  }

  double _getViewportFraction(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 768) {
      return 0.90; // Reduced from 0.85 for better tablet fit
    }
    return 0.95; // Original mobile
  }

  double _getCarouselHeight(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 768) {
      return 165.h; // Reduced from 180.h for tablets
    }
    return 158.h; // Original mobile
  }


  Future<void> _loadRecommendedAds() async {
    try {
      var data = await RecommendedAds.fetchRecommended();

      if (data != null && data["error"] == "Preference doesnot exist") {
        setState(() {
          _isLoading = false;
          _noData = true;
        });
      } else if (data != null &&
          data.containsKey("status") &&
          data["status"] == "loggedout") {
        // Handle logged out state if needed
      } else if (data != null) {
        setState(() {
          fetchRecommendedData(data);
          _isLoading = false;
          _hasError = false;
          _noData = _recommendedads?.isEmpty ?? true;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _noData = false;
      });
    }
  }

  Future<void> fetchRecommendedData(Map<String, dynamic> data) async {
    switch (widget.profile) {
      case "investor":
        setState(() {
          _recommendedads = data['business_recommended'] ?? [];
          _wishlistAllItems = data["business_data"] ?? [];
        });
        break;
      case "business":
        setState(() {
          _recommendedads = data['investor_recommended'] ?? [];
          _wishlistAllItems = data["investor_data"] ?? [];
        });
        break;
      case "franchise":
        setState(() {
          _recommendedads = data['franchise_recommended'] ?? [];
          _wishlistFranchiseItems = data["franchise_data"] ?? [];
        });
        break;
      case "advisor":
        setState(() {
          _recommendedads = data["advisor_recommended"] ?? [];
          _advisorItems = data["advisor_data"] ?? [];
        });
        break;
      default:
        setState(() {
          _recommendedads = data["recommended"] ?? [];
          _wishlistAllItems = data["recommendedAll"] ?? [];
          _wishlistFranchiseItems = data["recommendedFranchiseItems"] ?? [];
          _advisorItems = data["advisor_data"] ?? [];
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 768;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: isTablet ? 24.0 : 16.0,
            right: isTablet ? 24.0 : 16.0,
            top: 8,
            bottom: isTablet ? 20 : 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recommended list',
                style: AppTheme.titleText(lightTextColor).copyWith(
                  fontSize: isTablet ? 18.sp : null, // Reduced from 22.sp
                ),
              ),
              InkWell(
                onTap: () {
                  switch (widget.profile) {
                    case "business":
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InvestorExplorePage(
                            currentIndex: 2,
                          ),
                        ),
                      );
                      break;
                    case "investor":
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BusinessExplorePage(
                            currentIndex: 2,
                          ),
                        ),
                      );
                      break;
                    case "franchise":
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FranchiseExplorePage(
                            currentIndex: 2,
                          ),
                        ),
                      );
                      break;
                    case "advisor":
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdvisorExploreScreen(
                            currentIndex: 2,
                          ),
                        ),
                      );
                      break;
                  }
                },
                child: Text(
                  widget.profile == "home" ? "" : 'See all',
                  style: AppTheme.bodyMediumTitleText(buttonColor).copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 12.sp : null, // Reduced from 16.sp
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          child: _isLoading
              ? _buildShimmer()
              : _hasError
              ? _buildErrorMessage()
              : _noData == true || _recommendedads == null
              ? _buildNoDataMessage()
              : _buildRecommendedAdsList(),
        ),
        SizedBox(height: isTablet ? 12.h : 10.h), // Reduced tablet spacing
      ],
    );
  }

  Widget _buildShimmer() {
    final isTablet = MediaQuery.of(context).size.width >= 768;
    final viewportFraction = _getViewportFraction(context);
    final carouselHeight = _getCarouselHeight(context);

    return CarouselSlider.builder(
      itemCount: 5,
      itemBuilder: (context, index, realIndex) {
        return Shimmer.fromColors(
          baseColor: shimmerBaseColor!,
          highlightColor: shimmerHighlightColor!,
          child: Card(
            margin: EdgeInsets.symmetric(
              horizontal: isTablet ? 12.w : 8.w,
              vertical: isTablet ? 12.h : 8.h,
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(isTablet ? 20.w : 16.w),
              child: Row(
                children: [
                  Container(
                    height: isTablet ? 180.h : 150.h,
                    width: isTablet ? 140.w : 120.w,
                    color: containerColor,
                  ),
                  SizedBox(width: isTablet ? 24.w : 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: isTablet ? 24.h : 20.h,
                          width: isTablet ? 120.w : 100.w,
                          color: containerColor,
                        ),
                        SizedBox(height: isTablet ? 12.h : 8.h),
                        Container(
                          height: isTablet ? 20.h : 16.h,
                          width: isTablet ? 180.w : 150.w,
                          color: containerColor,
                        ),
                        SizedBox(height: isTablet ? 12.h : 8.h),
                        Container(
                          height: isTablet ? 18.h : 14.h,
                          width: isTablet ? 100.w : 80.w,
                          color: containerColor,
                        ),
                        SizedBox(height: isTablet ? 20.h : 16.h),
                        Container(
                          height: isTablet ? 40.h : 36.h,
                          width: isTablet ? 120.w : 100.w,
                          color: containerColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: carouselHeight,
        viewportFraction: viewportFraction,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
      ),
    );
  }

  Widget _buildErrorMessage() {
    final isTablet = MediaQuery.of(context).size.width >= 768;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: isTablet ? 48.sp : 40.sp,
            color: errorIconColor,
          ),
          SizedBox(height: isTablet ? 16.h : 12.h),
          Text(
            "Oops! Something went wrong.",
            style: AppTheme.titleText(lightTextColor).copyWith(
              fontSize: isTablet ? 20.sp : null,
            ),
          ),
          SizedBox(height: isTablet ? 8.h : 6.h),
          Text(
            "Please try again later.",
            style: AppTheme.smallText(lightTextColor).copyWith(
              fontSize: isTablet ? 16.sp : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataMessage() {
    final isTablet = MediaQuery.of(context).size.width >= 768;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/nodata.json',
            height: isTablet ? 100.h : 80.h,
            width: isTablet ? 110.w : 90.w,
            fit: BoxFit.cover,
          ),
          SizedBox(height: isTablet ? 16.h : 12.h),
          Text(
            "No recommended ads available",
            style: AppTheme.titleText(lightTextColor).copyWith(
              fontSize: isTablet ? 20.sp : null,
            ),
          ),
          SizedBox(height: isTablet ? 8.h : 6.h),
          Text(
            "Check back soon for exciting offers!",
            style: AppTheme.smallText(lightTextColor).copyWith(
              fontSize: isTablet ? 16.sp : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedAdsList() {
    final isTablet = MediaQuery.of(context).size.width >= 768;
    final viewportFraction = _getViewportFraction(context);
    final carouselHeight = _getCarouselHeight(context);

    return CarouselSlider.builder(
      itemCount: _recommendedads?.length ?? 0,
      itemBuilder: (context, index, realIndex) {
        var item = _recommendedads![index];
        final parsedDate = DateTime.parse(item.postedTime);
        final formattedDate = DateFormat("dd-MM-yyyy").format(parsedDate);

        return GestureDetector(
          onTap: () {
            _navigateToDetailPage(item, index);
          },
          child: Container(
            margin: EdgeInsets.only(top: isTablet ? 3.h : 2.h),
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: boxShadowColor,
                  blurRadius: 3,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: double.infinity,
                  width: isTablet ? 140.w : 150.w, // Reduced from 180.w
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[300],
                    image: DecorationImage(
                      image: NetworkImage(item.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: isTablet ? 20.w : 26.w), // Reduced from 32.w
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: isTablet ? 6.h : 5.h), // Reduced from 8.h
                      Text(
                        CustomFunctions.toSentenceCase(item.title),
                        style: AppTheme.mediumTitleText(lightTextColor).copyWith(
                          fontSize: isTablet ? 12.sp : null, // Reduced from 18.sp
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isTablet ? 3.h : 2.h), // Reduced from 4.h
                      Text(
                        CustomFunctions.toSentenceCase(item.singleLineDescription),
                        style: AppTheme.mediumSmallText(greyTextColor!).copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: isTablet ? 10.sp : null, // Reduced from 15.sp
                        ),
                        maxLines: 1,
                      ),
                      Text(
                        CustomFunctions.toSentenceCase(item.type),
                        style: AppTheme.mediumSmallText(greyTextColor!).copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: isTablet ? 10.sp : null, // Reduced from 15.sp
                        ),
                      ),
                      SizedBox(height: isTablet ? 3.h : 2.h), // Reduced from 4.h
                      TextButton(
                        onPressed: () {
                          _navigateToDetailPage(item, index);
                        },
                        child: Row(
                          children: [
                            Text(
                              'View Post ',
                              style: AppTheme.mediumTitleText(Color(0xff0D0B56)).copyWith(
                                fontSize: isTablet ? 10.sp : null, // Reduced from 16.sp
                              ),
                            ),
                            Icon(
                              CupertinoIcons.arrow_right_circle_fill,
                              color: Color(0xff0D0B56),
                              size: isTablet ? 18.sp : 16.sp, // Reduced from 20.sp
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(width: isTablet ? 12.w : 12.w), // Reduced from 16.w
              ],
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: carouselHeight,
        viewportFraction: viewportFraction,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 6),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
      ),
    );
  }

  Future<void> _navigateToDetailPage(ProductDetails item, int index) async {
    await RecentActivities.recentActivities(productId: item.id);

    if (item.type == 'business') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BusinessDetailPage(
            buisines: _wishlistAllItems[index],
            imageUrl: _wishlistAllItems[index].imageUrl,
            image2: _wishlistAllItems[index].image2,
            image3: _wishlistAllItems[index].image3,
            image4: _wishlistAllItems[index].image4,
            name: _wishlistAllItems[index].name,
            industry: _wishlistAllItems[index].industry,
            establish_yr: _wishlistAllItems[index].establish_yr,
            description: _wishlistAllItems[index].description,
            address_1: _wishlistAllItems[index].address_1,
            address_2: _wishlistAllItems[index].address_2,
            pin: _wishlistAllItems[index].pin,
            city: _wishlistAllItems[index].city,
            state: _wishlistAllItems[index].state,
            employees: _wishlistAllItems[index].employees,
            entity: _wishlistAllItems[index].entity,
            avg_monthly: _wishlistAllItems[index].avg_monthly,
            latest_yearly: _wishlistAllItems[index].latest_yearly,
            ebitda: _wishlistAllItems[index].ebitda,
            rate: _wishlistAllItems[index].rate,
            type_sale: _wishlistAllItems[index].type_sale,
            url: _wishlistAllItems[index].url,
            features: _wishlistAllItems[index].features,
            facility: _wishlistAllItems[index].facility,
            income_source: _wishlistAllItems[index].income_source,
            reason: _wishlistAllItems[index].reason,
            postedTime: _wishlistAllItems[index].postedTime,
            topSelling: _wishlistAllItems[index].topSelling,
            id: _wishlistAllItems[index].id,
            showEditOption: false,
          ),
        ),
      );
    } else if (item.type == 'investor') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InvestorDetailPage(
            investor: _wishlistAllItems[index],
            imageUrl: _wishlistAllItems[index].imageUrl,
            name: _wishlistAllItems[index].name,
            city: _wishlistAllItems[index].city,
            postedTime: _wishlistAllItems[index].postedTime,
            state: _wishlistAllItems[index].state,
            industry: _wishlistAllItems[index].industry,
            description: _wishlistAllItems[index].description,
            url: _wishlistAllItems[index].url,
            rangeStarting: _wishlistAllItems[index].rangeStarting,
            rangeEnding: _wishlistAllItems[index].rangeEnding,
            evaluatingAspects: _wishlistAllItems[index].evaluatingAspects,
            CompanyName: _wishlistAllItems[index].companyName,
            locationInterested: _wishlistAllItems[index].locationIntrested,
            id: _wishlistAllItems[index].id,
            showEditOption: false,
            image2: _wishlistAllItems[index].image2 ?? '',
            image3: _wishlistAllItems[index].image3 ?? '',
            image4: _wishlistAllItems[index].image4,
          ),
        ),
      );
    } else if (item.type == 'franchise') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FranchiseDetailPage(
            franchise: _wishlistFranchiseItems[index],
            id: _wishlistFranchiseItems[index].id,
            imageUrl: _wishlistFranchiseItems[index].imageUrl,
            image2: _wishlistFranchiseItems[index].image2,
            image3: _wishlistFranchiseItems[index].image3,
            image4: _wishlistFranchiseItems[index].image4,
            brandName: _wishlistFranchiseItems[index].brandName,
            city: _wishlistFranchiseItems[index].city,
            postedTime: _wishlistFranchiseItems[index].postedTime,
            state: _wishlistFranchiseItems[index].state,
            industry: _wishlistFranchiseItems[index].industry,
            description: _wishlistFranchiseItems[index].description,
            url: _wishlistFranchiseItems[index].url,
            initialInvestment: _wishlistFranchiseItems[index].initialInvestment,
            projectedRoi: _wishlistFranchiseItems[index].projectedRoi,
            iamOffering: _wishlistFranchiseItems[index].iamOffering,
            currentNumberOfOutlets: _wishlistFranchiseItems[index].currentNumberOfOutlets,
            franchiseTerms: _wishlistFranchiseItems[index].franchiseTerms,
            locationsAvailable: _wishlistFranchiseItems[index].locationsAvailable,
            kindOfSupport: _wishlistFranchiseItems[index].kindOfSupport,
            allProducts: _wishlistFranchiseItems[index].allProducts,
            brandStartOperation: _wishlistFranchiseItems[index].brandStartOperation,
            spaceRequiredMin: _wishlistFranchiseItems[index].spaceRequiredMin,
            spaceRequiredMax: _wishlistFranchiseItems[index].spaceRequiredMax,
            totalInvestmentFrom: _wishlistFranchiseItems[index].totalInvestmentFrom,
            totalInvestmentTo: _wishlistFranchiseItems[index].totalInvestmentTo,
            brandFee: _wishlistFranchiseItems[index].brandFee,
            avgNoOfStaff: _wishlistFranchiseItems[index].avgNoOfStaff,
            avgMonthlySales: _wishlistFranchiseItems[index].avgMonthlySales,
            avgEBITDA: _wishlistFranchiseItems[index].avgEBITDA,
            showEditOption: false,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>AdvisorDetailPage(
            recommendedAdvisor: item,
            isFromRecommended: true,
          ),
        ),
      );
    }
  }

  String formatDateTime(String dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr);
    return timeago.format(dateTime, allowFromNow: true);
  }
}