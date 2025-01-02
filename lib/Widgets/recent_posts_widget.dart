// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:project_emergio/Views/Investment%20explore%20page.dart';
// import 'package:project_emergio/Views/business%20explore%20page.dart';
// import 'package:project_emergio/Views/detail%20page/business%20deatil%20page.dart';
// import 'package:project_emergio/Views/detail%20page/franchise%20detail%20page.dart';
// import 'package:project_emergio/Views/detail%20page/invester%20detail%20page.dart';
// import 'package:project_emergio/Views/franchise%20explore%20page.dart';
// import 'package:project_emergio/Widgets/custom_funtions.dart';
// import 'package:project_emergio/Widgets/plan%20shimmer%20widget.dart';
// import 'package:project_emergio/generated/constants.dart';
// import 'package:project_emergio/models/all%20profile%20model.dart';
// import 'package:project_emergio/services/recent%20activities.dart';
// import 'package:shimmer/shimmer.dart';
// import '../services/latest transactions and activites.dart';
//
// List<BusinessInvestorExplr> _recentBusiness = [];
// List<FranchiseExplr> _recentFranchise = [];
// List<BusinessInvestorExplr> _recentInvestors = [];
//
// class LatestActivitiesList extends StatefulWidget {
//   final String profile;
//   const LatestActivitiesList({Key? key, required this.profile})
//       : super(key: key);
//   @override
//   _LatestActivitiesListState createState() => _LatestActivitiesListState();
// }
//
// class _LatestActivitiesListState extends State<LatestActivitiesList> {
//   List<LatestActivites>? _activities;
//   bool _isLoading = true;
//   String? _error;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchActivities();
//   }
//
//   Future<void> _fetchActivities() async {
//     try {
//       String item = widget.profile == "business"
//           ? "investor"
//           : widget.profile == "investor"
//           ? "business"
//           : widget.profile == "franchise"
//           ? "franchise"
//           : widget.profile == "advisor"
//           ? "advisor"
//           : "";
//
//       final data = await LatestTransactions.fetchRecentPosts(item);
//       if (data != null) {
//         fetchRecent(data);
//       } else {
//         print("Rceents lists is empty");
//       }
//
//       _isLoading = false;
//     } catch (e) {
//       setState(() {
//         _error = 'Failed to load activities';
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future<void> fetchRecent(Map<String, dynamic> data) async {
//     switch (widget.profile) {
//       case "business":
//         setState(() {
//           _recentBusiness = data["investor_data"];
//         });
//
//         break;
//
//       case "investor":
//         setState(() {
//           _recentBusiness = data["business_data"];
//         });
//         break;
//       case "franchise":
//         setState(() {
//           _recentFranchise = data["franchise_data"];
//         });
//         break;
//
//       default:
//         setState(() {
//           _activities = data["home_data"];
//           _recentBusiness = data["business"];
//           _recentFranchise = data["franchises"];
//           _recentInvestors = data["investors"];
//         });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding:
//           const EdgeInsets.only(left: 16.0, right: 16, top: 8, bottom: 20),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Recent Posts', style: AppTheme.titleText(lightTextColor)),
//               InkWell(
//                 onTap: () {
//                   switch (widget.profile) {
//                     case "business":
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const InvestorExplorePage(
//                                 currentIndex: 0,
//                               )));
//                       break;
//                     case "investor":
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const BusinessExplorePage(
//                                 currentIndex: 0,
//                               )));
//                       break;
//
//                     case "franchise":
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const FranchiseExplorePage(
//                                 currentIndex: 0,
//                               )));
//                       break;
//                   }
//                 },
//                 child: SizedBox(
//                   child: Text('See all',
//                       style: AppTheme.bodyMediumTitleText(buttonColor)
//                           .copyWith(fontWeight: FontWeight.bold)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         if (_isLoading)
//           Center(child: recentPostShimmer())
//         else if (_error != null)
//           Center(child: Text(_error!))
//         else if (widget.profile == "business" &&
//               _recentBusiness != null &&
//               _recentBusiness.isEmpty)
//             _noPostAvailable()
//           else if (widget.profile == "investor" &&
//                 _recentBusiness != null &&
//                 _recentBusiness.isEmpty)
//               _noPostAvailable()
//             else if (widget.profile == "franchise" &&
//                   _recentFranchise != null &&
//                   _recentFranchise.isEmpty)
//                 _noPostAvailable()
//               else if (widget.profile == "" &&
//                     (_activities != null && _activities!.isEmpty))
//                   _noPostAvailable()
//                 else if (widget.profile == "business" || widget.profile == "investor")
//                     CarouselSlider.builder(
//                       itemCount: _recentBusiness.length,
//                       itemBuilder: (context, index, realIndex) {
//                         return ActivityCard(
//                           index: index,
//                           business: _recentBusiness[index],
//                           profile: widget.profile,
//                         );
//                       },
//                       options: CarouselOptions(
//                         height: 225.h,
//                         viewportFraction: 0.52,
//                         disableCenter: true,
//                         enlargeCenterPage: true,
//                         autoPlay: false,
//                         autoPlayInterval: Duration(seconds: 3),
//                         autoPlayAnimationDuration: Duration(milliseconds: 800),
//                         autoPlayCurve: Curves.fastOutSlowIn,
//                       ),
//                     )
//                   else if (widget.profile == "franchise")
//                       CarouselSlider.builder(
//                         itemCount: _recentFranchise.length,
//                         itemBuilder: (context, index, realIndex) {
//                           return ActivityCard(
//                             index: index,
//                             franchise: _recentFranchise[index],
//                             profile: "franchise",
//                           );
//                         },
//                         options: CarouselOptions(
//                           height: 225.h,
//                           viewportFraction: 0.52,
//                           disableCenter: true,
//                           enlargeCenterPage: true,
//                           autoPlay: false,
//                           autoPlayInterval: Duration(seconds: 3),
//                           autoPlayAnimationDuration: Duration(milliseconds: 800),
//                           autoPlayCurve: Curves.fastOutSlowIn,
//                         ),
//                       )
//                     else
//                       CarouselSlider.builder(
//                         itemCount: _activities != null ? _activities!.length : 0,
//                         itemBuilder: (context, index, realIndex) {
//                           return ActivityCard(
//                             index: index,
//                             activity: _activities![index],
//                             profile: "",
//                             // business: _recentBusiness[index],
//                             // franchise: _recentFranchise[index],
//                             // investor: _recentInvestors[index],
//                           );
//                         },
//                         options: CarouselOptions(
//                           height: 225.h,
//                           viewportFraction: 0.52,
//                           disableCenter: true,
//                           enlargeCenterPage: true,
//                           autoPlay: false,
//                           autoPlayInterval: Duration(seconds: 3),
//                           autoPlayAnimationDuration: Duration(milliseconds: 800),
//                           autoPlayCurve: Curves.fastOutSlowIn,
//                         ),
//                       )
//       ],
//     );
//   }
//
//   Widget recentPostShimmer(){
//     return CarouselSlider(
//       options: CarouselOptions(
//         height: 225.h,
//         viewportFraction: 0.52,
//         disableCenter: true,
//         enlargeCenterPage: true,
//         autoPlay: false,
//         autoPlayInterval: Duration(seconds: 3),
//         autoPlayAnimationDuration: Duration(milliseconds: 800),
//         autoPlayCurve: Curves.fastOutSlowIn,
//       ),
//       items: List.generate(3, (index) => Shimmer.fromColors(
//         baseColor: shimmerBaseColor!,
//         highlightColor: shimmerHighlightColor!,
//         child: Container(
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(borderRadius)
//           ),
//         ),
//
//       )),
//     );
//   }
//
//   Widget _noPostAvailable() {
//     return Padding(
//       padding: const EdgeInsets.all(10),
//       child: Center(
//           child: Text(
//             'No posts available',
//             style: AppTheme.smallText(lightTextColor),
//           )),
//     );
//   }
// }
//
// class ActivityCard extends StatelessWidget {
//   final LatestActivites? activity;
//   final BusinessInvestorExplr? business;
//   final FranchiseExplr? franchise;
//   final BusinessInvestorExplr? investor;
//   final String profile;
//   final int index;
//   final bool? isHome;
//
//   const ActivityCard(
//       {Key? key,
//         required this.index,
//         this.activity,
//         this.business,
//         this.franchise,
//         this.investor,
//         required this.profile,
//         this.isHome})
//       : super(key: key);
//
//   String _formatDateTime(String postedTime) {
//     try {
//       final dateTime = DateTime.parse(postedTime);
//       return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
//     } catch (e) {
//       return "Invalid date";
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final item = profile == "franchise" ? franchise : business;
//
//     return InkWell(
//         onTap: () async {
//           if ((profile == "business" && business != null && isHome == true)) {
//             await RecentActivities.recentActivities(productId: business!.id);
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => BusinessDetailPage(
//                   buisines: business,
//                   showEditOption: false,
//                 ),
//               ),
//             );
//           } else if (profile == "investor" && business != null && isHome ==true) {
//             await RecentActivities.recentActivities(productId: business!.id);
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => InvestorDetailPage(
//                   investor: business ?? _recentBusiness[index],
//                   showEditOption: false,
//                 ),
//               ),
//             );
//           } else if (profile == "business" &&
//               business != null
//           ) {
//             await RecentActivities.recentActivities(productId: business!.id);
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => InvestorDetailPage(
//                   investor: business,
//                 ),
//               ),
//             );
//           } else if (profile == "investor" && business != null) {
//             await RecentActivities.recentActivities(productId: business!.id);
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => BusinessDetailPage(
//                   buisines: business ?? _recentBusiness[index],
//                   showEditOption: false,
//                 ),
//               ),
//             );
//           } else if (profile == "franchise" && franchise != null) {
//             await RecentActivities.recentActivities(productId: franchise!.id);
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => FranchiseDetailPage(
//                   franchise: franchise,
//                   id: franchise!.id,
//                   imageUrl: franchise!.imageUrl,
//                   image2: franchise!.image2,
//                   image3: franchise!.image3,
//                   image4: franchise!.image4,
//                   brandName: franchise!.brandName,
//                   city: franchise!.city,
//                   postedTime: franchise!.postedTime,
//                   state: franchise!.state,
//                   industry: franchise!.industry,
//                   description: franchise!.description,
//                   url: franchise!.url,
//                   initialInvestment: franchise!.initialInvestment,
//                   projectedRoi: franchise!.projectedRoi,
//                   iamOffering: franchise!.iamOffering,
//                   currentNumberOfOutlets: franchise!.currentNumberOfOutlets,
//                   franchiseTerms: franchise!.franchiseTerms,
//                   locationsAvailable: franchise!.locationsAvailable,
//                   kindOfSupport: franchise!.kindOfSupport,
//                   allProducts: franchise!.allProducts,
//                   brandStartOperation: franchise!.brandStartOperation,
//                   spaceRequiredMin: franchise!.spaceRequiredMin,
//                   spaceRequiredMax: franchise!.spaceRequiredMax,
//                   totalInvestmentFrom: franchise!.totalInvestmentFrom,
//                   totalInvestmentTo: franchise!.totalInvestmentTo,
//                   brandFee: franchise!.brandFee,
//                   avgNoOfStaff: franchise!.avgNoOfStaff,
//                   avgMonthlySales: franchise!.avgMonthlySales,
//                   avgEBITDA: franchise!.avgEBITDA,
//                   showEditOption: false,
//                 ),
//               ),
//             );
//           } else if (investor != null) {
//             await RecentActivities.recentActivities(productId: investor!.id);
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => InvestorDetailPage(
//                   investor: investor,
//                 ),
//               ),
//             );
//           }
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: Colors.black12)
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 6.0,top: 6,right: 6),
//                 child: Container(
//                   height: 125.h,
//                     margin: const EdgeInsets.symmetric(horizontal: 0.0),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       image: DecorationImage(
//                         image: business != null && business!.imageUrl != null
//                             ? NetworkImage(business!.imageUrl)
//                             : franchise != null
//                             ? NetworkImage(franchise!.imageUrl)
//                             : activity != null && activity!.imageUrl != null
//                             ? NetworkImage(activity!.imageUrl)
//                             : investor != null
//                             ? NetworkImage(investor!.imageUrl)
//                             : const AssetImage('assets/businessimg.png'),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     // child:
//                     // Stack(
//                     //   children: [
//                     //     Positioned(
//                     //       bottom: 0,
//                     //       left: 0,
//                     //       right: 0,
//                     //       child:
//                     //       Container(
//                     //         padding: const EdgeInsets.all(10),
//                     //         decoration: BoxDecoration(
//                     //           gradient: gradient,
//                     //           borderRadius: BorderRadius.only(
//                     //             bottomLeft: Radius.circular(borderRadius),
//                     //             bottomRight: Radius.circular(borderRadius),
//                     //           ),
//                     //         ),
//                     //         child: Padding(
//                     //           padding: const EdgeInsets.only(left: 10.0),
//                     //           child:
//                     //           Column(
//                     //             crossAxisAlignment: CrossAxisAlignment.start,
//                     //             mainAxisSize: MainAxisSize.min,
//                     //             children: [
//                     //               Container(
//                     //                 width: 150.w,
//                     //                 decoration: BoxDecoration(
//                     //                     color: Colors.white,
//                     //                     borderRadius: BorderRadius.circular(50)),
//                     //                 child: Padding(
//                     //                   padding: const EdgeInsets.all(6.0),
//                     //                   child: Text(
//                     //                     investor != null
//                     //                         ? CustomFunctions.toSentenceCase(investor!.name)
//                     //                         : business != null
//                     //                         ? CustomFunctions.toSentenceCase(
//                     //                         business!.name)
//                     //                         : franchise != null
//                     //                         ? CustomFunctions.toSentenceCase(
//                     //                         franchise!.brandName)
//                     //                         : activity != null
//                     //                         ? CustomFunctions.toSentenceCase(
//                     //                         activity!.name)
//                     //                         : "N/A",
//                     //                     style: AppTheme.mediumTitleText(lightTextColor)
//                     //                         .copyWith(fontWeight: FontWeight.bold),
//                     //                     maxLines: 1,
//                     //                     overflow: TextOverflow.ellipsis,
//                     //                   ),
//                     //                 ),
//                     //               ),
//                     //               const SizedBox(height: 4),
//                     //               Container(
//                     //                 width: 100.w,
//                     //                 decoration: BoxDecoration(
//                     //                   color: containerColor,
//                     //                   borderRadius: BorderRadius.circular(50),
//                     //                 ),
//                     //                 child: Padding(
//                     //                   padding: const EdgeInsets.all(6.0),
//                     //                   child: Row(
//                     //                     children: [
//                     //                       Icon(Icons.location_on,
//                     //                           color: buttonColor, size: 18.h),
//                     //                       const SizedBox(width: 5),
//                     //                       Flexible(
//                     //                           child: Text(
//                     //                             investor != null
//                     //                                 ? CustomFunctions.toSentenceCase(
//                     //                                 investor!.city ?? "N/A")
//                     //                                 : business != null
//                     //                                 ? CustomFunctions.toSentenceCase(
//                     //                                 business!.city ?? "N/A")
//                     //                                 : franchise != null
//                     //                                 ? CustomFunctions.toSentenceCase(
//                     //                                 franchise!.city ?? "N/A")
//                     //                                 : "N/A",
//                     //                             style: AppTheme.smallText(lightTextColor),
//                     //                             maxLines: 1,
//                     //                             overflow: TextOverflow.ellipsis,
//                     //                           )),
//                     //                     ],
//                     //                   ),
//                     //                 ),
//                     //               ),
//                     //               const SizedBox(height: 4),
//                     //             ],
//                     //           ),
//                     //         ),
//                     //       ),
//                     //     ),
//                     //   ],
//                     // ),
//                     ),
//               ),
//                SizedBox(height: 3.h),
//               Container(
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(50)),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 6,right: 6),
//                   child: Text(
//                     investor != null
//                         ? CustomFunctions.toSentenceCase(investor!.title)
//                         : business != null
//                         ? CustomFunctions.toSentenceCase(
//                         business!.title)
//                         : franchise != null
//                         ? CustomFunctions.toSentenceCase(
//                         franchise!.title)
//                         : activity != null
//                         ? CustomFunctions.toSentenceCase(
//                         activity!.title)
//                         : "N/A",
//                     style: AppTheme.mediumTitleText(lightTextColor)
//                         .copyWith(fontWeight: FontWeight.w600,fontSize: bodyMediumTitleFont),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   color: containerColor,
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 6,right: 6,top: 2),
//                   child: Text(
//                     investor != null
//                         ? CustomFunctions.toSentenceCase(investor!.singleLineDescription)
//                         : business != null
//                         ? CustomFunctions.toSentenceCase(business!.singleLineDescription)
//                             : franchise != null
//                         ? CustomFunctions.toSentenceCase(franchise!.singleLineDescription)
//                         : "N/A",
//                     style: AppTheme.smallText(lightTextColor),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 6,right: 6,top: 2),
//                 child: Text(
//                   investor != null
//                       ? _formatDateTime(investor!.postedTime)
//                       : business != null
//                       ? _formatDateTime(business!.postedTime)
//                       : franchise != null
//                       ? _formatDateTime(franchise!.postedTime)
//                       : activity != null
//                       ? _formatDateTime(activity!.postedTime)
//                       : "N/A",
//                   style: AppTheme.smallText(lightTextColor).copyWith(fontSize: 11.sp),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         );
//     }
// }




import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:project_emergio/Views/Investment%20explore%20page.dart';
import 'package:project_emergio/Views/business%20explore%20page.dart';
import 'package:project_emergio/Views/detail%20page/business%20deatil%20page.dart';
import 'package:project_emergio/Views/detail%20page/franchise%20detail%20page.dart';
import 'package:project_emergio/Views/detail%20page/invester%20detail%20page.dart';
import 'package:project_emergio/Views/franchise%20explore%20page.dart';
import 'package:project_emergio/Widgets/custom_funtions.dart';
import 'package:project_emergio/Widgets/plan%20shimmer%20widget.dart';
import 'package:project_emergio/generated/constants.dart';
import 'package:project_emergio/models/all%20profile%20model.dart';
import 'package:project_emergio/services/recent%20activities.dart';
import 'package:shimmer/shimmer.dart';
import '../services/latest transactions and activites.dart';

List<BusinessInvestorExplr> _recentBusiness = [];
List<FranchiseExplr> _recentFranchise = [];
List<BusinessInvestorExplr> _recentInvestors = [];

class LatestActivitiesList extends StatefulWidget {
  final String profile;
  const LatestActivitiesList({Key? key, required this.profile}) : super(key: key);
  @override
  _LatestActivitiesListState createState() => _LatestActivitiesListState();
}

class _LatestActivitiesListState extends State<LatestActivitiesList> {
  List<LatestActivites>? _activities;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchActivities();
  }

  Future<void> _fetchActivities() async {
    try {
      String item = widget.profile == "business"
          ? "investor"
          : widget.profile == "investor"
          ? "business"
          : widget.profile == "franchise"
          ? "franchise"
          : widget.profile == "advisor"
          ? "advisor"
          : "";

      final data = await LatestTransactions.fetchRecentPosts(item);
      if (data != null) {
        fetchRecent(data);
      } else {
        print("Recent lists is empty");
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load activities';
        _isLoading = false;
      });
    }
  }

  Future<void> fetchRecent(Map<String, dynamic> data) async {
    switch (widget.profile) {
      case "business":
        setState(() {
          _recentBusiness = data["investor_data"];
        });
        break;

      case "investor":
        setState(() {
          _recentBusiness = data["business_data"];
        });
        break;
      case "franchise":
        setState(() {
          _recentFranchise = data["franchise_data"];
        });
        break;

      default:
        setState(() {
          _activities = data["home_data"];
          _recentBusiness = data["business"];
          _recentFranchise = data["franchises"];
          _recentInvestors = data["investors"];
        });
    }
  }

  double _getViewportFraction(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 768) {
      return 0.35;
    }
    return 0.52;
  }

  double _getCarouselHeight(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 768) {
      return 250.h; // Reduced from 275.h for tablets
    }
    return 225.h; // Original mobile height
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width >= 768;
    final viewportFraction = _getViewportFraction(context);
    final carouselHeight = _getCarouselHeight(context);

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
                'Recent Posts',
                style: AppTheme.titleText(lightTextColor).copyWith(
                  fontSize: isTablet ? 18.sp : null,
                ),
              ),
              InkWell(
                onTap: () {
                  switch (widget.profile) {
                    case "business":
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const InvestorExplorePage(currentIndex: 0),
                        ),
                      );
                      break;
                    case "investor":
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const BusinessExplorePage(currentIndex: 0),
                        ),
                      );
                      break;
                    case "franchise":
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const FranchiseExplorePage(currentIndex: 0),
                        ),
                      );
                      break;
                  }
                },
                child: Text(
                  'See all',
                  style: AppTheme.bodyMediumTitleText(buttonColor).copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 12.sp : null,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_isLoading)
          Center(child: _buildResponsiveShimmer(context))
        else if (_error != null)
          Center(
            child: Text(
              _error!,
              style: TextStyle(fontSize: isTablet ? 16.sp : 14.sp),
            ),
          )
        else if ((widget.profile == "business" ||
              widget.profile == "investor") &&
              _recentBusiness.isEmpty)
            _noPostAvailable(isTablet)
          else if (widget.profile == "franchise" && _recentFranchise.isEmpty)
              _noPostAvailable(isTablet)
            else if (widget.profile == "" && (_activities?.isEmpty ?? true))
                _noPostAvailable(isTablet)
              else if (widget.profile == "business" || widget.profile == "investor")
                  CarouselSlider.builder(
                    itemCount: _recentBusiness.length,
                    itemBuilder: (context, index, realIndex) {
                      return ActivityCard(
                        index: index,
                        business: _recentBusiness[index],
                        profile: widget.profile,
                        isTablet: isTablet,
                      );
                    },
                    options: CarouselOptions(
                      height: carouselHeight,
                      viewportFraction: viewportFraction,
                      disableCenter: true,
                      enlargeCenterPage: true,
                      autoPlay: false,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                    ),
                  )
                else if (widget.profile == "franchise")
                    CarouselSlider.builder(
                      itemCount: _recentFranchise.length,
                      itemBuilder: (context, index, realIndex) {
                        return ActivityCard(
                          index: index,
                          franchise: _recentFranchise[index],
                          profile: "franchise",
                          isTablet: isTablet,
                        );
                      },
                      options: CarouselOptions(
                        height: carouselHeight,
                        viewportFraction: viewportFraction,
                        disableCenter: true,
                        enlargeCenterPage: true,
                        autoPlay: false,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                      ),
                    )
                  else
                    CarouselSlider.builder(
                      itemCount: _activities?.length ?? 0,
                      itemBuilder: (context, index, realIndex) {
                        return ActivityCard(
                          index: index,
                          activity: _activities![index],
                          profile: "",
                          isTablet: isTablet,
                        );
                      },
                      options: CarouselOptions(
                        height: carouselHeight,
                        viewportFraction: viewportFraction,
                        disableCenter: true,
                        enlargeCenterPage: true,
                        autoPlay: false,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                      ),
                    ),
      ],
    );
  }

  Widget _buildResponsiveShimmer(BuildContext context) {
    final viewportFraction = _getViewportFraction(context);
    final carouselHeight = _getCarouselHeight(context);

    return CarouselSlider(
      options: CarouselOptions(
        height: carouselHeight,
        viewportFraction: viewportFraction,
        disableCenter: true,
        enlargeCenterPage: true,
        autoPlay: false,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
      ),
      items: List.generate(
        3,
            (index) => Shimmer.fromColors(
          baseColor: shimmerBaseColor!,
          highlightColor: shimmerHighlightColor!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
      ),
    );
  }

  Widget _noPostAvailable(bool isTablet) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Text(
          'No posts available',
          style: AppTheme.smallText(lightTextColor).copyWith(
            fontSize: isTablet ? 16.sp : null,
          ),
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final LatestActivites? activity;
  final BusinessInvestorExplr? business;
  final FranchiseExplr? franchise;
  final BusinessInvestorExplr? investor;
  final String profile;
  final int index;
  final bool? isHome;
  final bool isTablet;

  const ActivityCard({
    Key? key,
    required this.index,
    this.activity,
    this.business,
    this.franchise,
    this.investor,
    required this.profile,
    this.isHome,
    this.isTablet = false,
  }) : super(key: key);

  String _formatDateTime(String postedTime) {
    try {
      final dateTime = DateTime.parse(postedTime);
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      return "Invalid date";
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = profile == "franchise" ? franchise : business;

    return InkWell(
        onTap: () async {
      if ((profile == "business" && business != null && isHome == true)) {
        await RecentActivities.recentActivities(productId: business!.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BusinessDetailPage(
              buisines: business,
              showEditOption: false,
            ),
          ),
        );
      } else if (profile == "investor" && business != null && isHome == true) {
        await RecentActivities.recentActivities(productId: business!.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InvestorDetailPage(
              investor: business ?? _recentBusiness[index],
              showEditOption: false,
            ),
          ),
        );
      } else if (profile == "business" && business != null) {
        await RecentActivities.recentActivities(productId: business!.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InvestorDetailPage(
              investor: business,
            ),
          ),
        );
      } else if (profile == "investor" && business != null) {
        await RecentActivities.recentActivities(productId: business!.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BusinessDetailPage(
              buisines: business ?? _recentBusiness[index],
              showEditOption: false,
            ),
          ),
        );
      } else if (profile == "franchise" && franchise != null) {
        await RecentActivities.recentActivities(productId: franchise!.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FranchiseDetailPage(
              franchise: franchise,
              id: franchise!.id,
              imageUrl: franchise!.imageUrl,
              image2: franchise!.image2,
              image3: franchise!.image3,
              image4: franchise!.image4,
              brandName: franchise!.brandName,
              city: franchise!.city,
              postedTime: franchise!.postedTime,
              state: franchise!.state,
              industry: franchise!.industry,
              description: franchise!.description,
              url: franchise!.url,
              initialInvestment: franchise!.initialInvestment,
              projectedRoi: franchise!.projectedRoi,
              iamOffering: franchise!.iamOffering,
              currentNumberOfOutlets: franchise!.currentNumberOfOutlets,
              franchiseTerms: franchise!.franchiseTerms,
              locationsAvailable: franchise!.locationsAvailable,
              kindOfSupport: franchise!.kindOfSupport,
              allProducts: franchise!.allProducts,
              brandStartOperation: franchise!.brandStartOperation,
              spaceRequiredMin: franchise!.spaceRequiredMin,
              spaceRequiredMax: franchise!.spaceRequiredMax,
              totalInvestmentFrom: franchise!.totalInvestmentFrom,
              totalInvestmentTo: franchise!.totalInvestmentTo,
              brandFee: franchise!.brandFee,
              avgNoOfStaff: franchise!.avgNoOfStaff,
              avgMonthlySales: franchise!.avgMonthlySales,
              avgEBITDA: franchise!.avgEBITDA,
              showEditOption: false,
            ),
          ),
        );
      } else if (investor != null) {
        await RecentActivities.recentActivities(productId: investor!.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InvestorDetailPage(
              investor: investor,
            ),
          ),
        );
      }
        },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: isTablet ? 6.0 : 6.0, 
                top: isTablet ? 6.0 : 6.0,  
                right: isTablet ? 6.0 : 6.0, 
              ),
              child: Container(
                height: isTablet ? 130.h : 125.h, // Reduced from 160.h for tablet
                margin: const EdgeInsets.symmetric(horizontal: 0.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: business != null && business!.imageUrl != null
                        ? NetworkImage(business!.imageUrl)
                        : franchise != null
                        ? NetworkImage(franchise!.imageUrl)
                        : activity != null && activity!.imageUrl != null
                        ? NetworkImage(activity!.imageUrl)
                        : investor != null
                        ? NetworkImage(investor!.imageUrl)
                        : const AssetImage('assets/businessimg.png')
                    as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: isTablet ? 3.h : 3.h), // Reduced from 5.h for tablet
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 6.0 : 6.0, 
                  vertical: isTablet ? 2.0 : 2.0,  
                ),
                child: Text(
                  investor != null
                      ? CustomFunctions.toSentenceCase(investor!.title)
                      : business != null
                      ? CustomFunctions.toSentenceCase(business!.title)
                      : franchise != null
                      ? CustomFunctions.toSentenceCase(franchise!.title)
                      : activity != null
                      ? CustomFunctions.toSentenceCase(activity!.title)
                      : "N/A",
                  style: AppTheme.mediumTitleText(lightTextColor).copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: isTablet
                        ? smallTextFont
                        : bodyMediumTitleFont,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: isTablet ? 6.0 : 6.0,  
                  right: isTablet ? 6.0 : 6.0, 
                  top: isTablet ? 2.0 : 2.0,   
                ),
                child: Text(
                  investor != null
                      ? CustomFunctions.toSentenceCase(
                      investor!.singleLineDescription)
                      : business != null
                      ? CustomFunctions.toSentenceCase(
                      business!.singleLineDescription)
                      : franchise != null
                      ? CustomFunctions.toSentenceCase(
                      franchise!.singleLineDescription)
                      : "N/A",
                  style: AppTheme.smallText(lightTextColor).copyWith(
                    fontSize: isTablet ? 10.sp : null, 
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: isTablet ? 6.0 : 6.0,   
                right: isTablet ? 6.0 : 6.0,  
                top: isTablet ? 2.0 : 2.0,    
              ),
              child: Text(
                investor != null
                    ? _formatDateTime(investor!.postedTime)
                    : business != null
                    ? _formatDateTime(business!.postedTime)
                    : franchise != null
                    ? _formatDateTime(franchise!.postedTime)
                    : activity != null
                    ? _formatDateTime(activity!.postedTime)
                    : "N/A",
                style: AppTheme.smallText(lightTextColor).copyWith(
                  fontSize: isTablet ? 8.sp : 11.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}