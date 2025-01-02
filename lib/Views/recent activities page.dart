// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:project_emergio/Widgets/shimmer%20explore%20widget.dart';
// import 'package:shimmer/shimmer.dart';
// import '../services/recent activities.dart';
// import 'package:timeago/timeago.dart' as timeago;
//
//
// class RecentActivitiesScreen extends StatefulWidget {
//   const RecentActivitiesScreen({super.key});
//
//   @override
//   State<RecentActivitiesScreen> createState() => _RecentActivitiesScreenState();
// }
//
// final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
// class _RecentActivitiesScreenState extends State<RecentActivitiesScreen> {
//   late Future<List<Recent>?> _recentActivitiesFuture;
//
//   String formatDateTime(String dateTimeStr) {
//     DateTime dateTime = DateTime.parse(dateTimeStr);
//     return timeago.format(dateTime, allowFromNow: true);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _recentActivitiesFuture = RecentActivities.fetchRecentActivities();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final h = MediaQuery
//         .of(context)
//         .size
//         .height;
//     final w = MediaQuery
//         .of(context)
//         .size
//         .width;
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: FutureBuilder<List<Recent>?>(
//         future: _recentActivitiesFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return ExploreShimmerWidget(width: 150, height: 150);
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No recent activities found.'));
//           }
//
//           final recentActivities = snapshot.data!;
//           return ListView(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   'Recent Activities',
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold, fontSize: h * 0.025),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: GridView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: recentActivities.length,
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     childAspectRatio: 2 / 3,
//                     mainAxisSpacing: 8.0,
//                     crossAxisSpacing: 8.0,
//                   ),
//                   itemBuilder: (context, index) {
//                     final recent = recentActivities[index];
//                     return Card(
//                       color: Colors.white,
//                       elevation: 2,
//                       child: Container(
//                         width: w * .5,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.all(Radius.circular(10)),
//                           border: Border.all(color: Colors.black12),
//                         ),
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Container(
//                                 height: 140.h,
//                                 decoration: BoxDecoration(
//                                   color: Colors.black12,
//                                   image: DecorationImage(
//                                     image: NetworkImage(recent.imageUrl),
//                                     fit: BoxFit.cover,
//                                   ),
//                                   borderRadius: BorderRadius.all(
//                                       Radius.circular(10)),
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               recent.name,
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: h * .017),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(
//                                   left: 8.0, top: 10),
//                               child: Row(
//                                 children: [
//                                   Image.asset(
//                                     'assets/loc.png',
//                                     height: h * 0.018,
//                                   ),
//                                   SizedBox(width: 5),
//                                   Text(
//                                     recent.city,
//                                     style: TextStyle(fontSize: h * .015),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     CupertinoIcons.time,
//                                     color: Colors.green,
//                                     size: h * 0.018,
//                                   ),
//                                   SizedBox(width: 5),
//                                   Text(
//                                     formatDateTime(recent.postedTime),
//                                     style: TextStyle(fontSize: h * .015),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
//
//
//
//   class ShimmerLoading extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//   final height = MediaQuery.of(context).size.height;
//   final width = MediaQuery.of(context).size.width;
//
//   return Shimmer.fromColors(
//   baseColor: Colors.grey[300]!,
//   highlightColor: Colors.grey[100]!,
//   child: GridView.builder(
//   shrinkWrap: true,
//   physics: NeverScrollableScrollPhysics(),
//   itemCount: 6, // Number of shimmer placeholders
//   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//   crossAxisCount: 2,
//   childAspectRatio: 2 / 3,
//   mainAxisSpacing: 8.0,
//   crossAxisSpacing: 8.0,
//   ),
//   itemBuilder: (context, index) {
//   return Card(
//   color: Colors.white,
//   elevation: 2,
//   child: Container(
//   width: width * .5,
//   decoration: BoxDecoration(
//   borderRadius: BorderRadius.all(Radius.circular(10)),
//   border: Border.all(color: Colors.black12),
//   ),
//   child: Column(
//   children: [
//   Container(
//   height: 140.h,
//   color: Colors.grey,
//   ),
//   SizedBox(height: 8),
//   Container(
//   height: 20,
//   color: Colors.grey,
//   margin: EdgeInsets.symmetric(horizontal: 8),
//   ),
//   SizedBox(height: 8),
//   Container(
//   height: 15,
//   color: Colors.grey,
//   margin: EdgeInsets.symmetric(horizontal: 8),
//   ),
//   SizedBox(height: 8),
//   Container(
//   height: 15,
//   color: Colors.grey,
//   margin: EdgeInsets.symmetric(horizontal: 8),
//   ),
//   ],
//   ),
//   ),
//   );
//   },
//   ),
//   );
//   }
//   }
//

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_emergio/Views/detail%20page/advisor%20detail%20page.dart';
import 'package:project_emergio/Widgets/custom_profile_appbar_widget.dart';
import 'package:project_emergio/Widgets/wishlist%20shimmer.dart';
import 'package:project_emergio/generated/constants.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/all profile model.dart';
import '../services/recent activities.dart';
import 'detail page/business deatil page.dart';
import 'detail page/franchise detail page.dart';
import 'detail page/invester detail page.dart';

class RecentActivitiesScreen extends StatefulWidget {
  const RecentActivitiesScreen({super.key});

  @override
  State<RecentActivitiesScreen> createState() => _RecentActivitiesScreenState();
}

class _RecentActivitiesScreenState extends State<RecentActivitiesScreen> {
  late Future<List<Recent>?> _recentActivitiesFuture;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Lists to store different types of activities
  List<Recent> businessItems = [];
  List<Recent> franchiseItems = [];
  List<Recent> investorItems = [];

  var recentBusinessInvestorItems = <BusinessInvestorExplr>[];
  var recentFranchiseItems = <FranchiseExplr>[];

  String formatDateTime(String dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr);
    return timeago.format(dateTime, allowFromNow: true);
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      _recentActivitiesFuture = RecentActivities.fetchRecentActivities();
      final activities = await _recentActivitiesFuture;
      if (activities != null) {
        _categorizeActivities(activities);
      }
    } catch (e) {
      print('Error loading data: $e');
      _showErrorSnackBar('Error loading recent activities');
    }
  }

  void _categorizeActivities(List<Recent> activities) {
    setState(() {
      // Clear existing items
      businessItems.clear();
      franchiseItems.clear();
      investorItems.clear();

      // Categorize activities
      for (final activity in activities) {
        final type = activity.entityType != null
            ? activity.entityType!.toLowerCase()
            : "";
        print(activity.entityType); // Print original type for logging

        if (type == 'business') {
          businessItems.add(activity);
        } else if (type == 'franchise' || type.contains('franchise')) {
          franchiseItems.add(activity);
        } else if (type == 'investor' || type.contains('investor')) {
          investorItems.add(activity);
        } else {
          businessItems.add(activity); // Default case adds to business items
        }
      }
    });
  }

  Future<void> _navigateToDetailPage(Recent item) async {
    if (item.entityType == "investor") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InvestorDetailPage(
            investor: BusinessInvestorExplr(
              id: item.id,
              imageUrl: item.imageUrl,
              image2: item.image2,
              image3: item.image3,
              name: item.name,
              city: item.city,
              postedTime: item.postedTime,
              topSelling: item.topSelling,
              address_1: item.address_1,
              address_2: item.address_2,
              avg_monthly: item.avgMonthlySales,
              brandName: item.brandName,
              companyName: item.companyName,
              description: item.description,
              ebitda: item.ebitda,
              employees: item.employees,
              entity: item.entity,
              entityType: item.entityType,
              establish_yr: item.establish_yr,
              evaluatingAspects: item.evaluatingAspects,
              facility: item.facility,
              features: item.features,
              image4: item.image4,
              income_source: item.income_source,
              industry: item.industry,
              latest_yearly: item.latest_yearly,
              locationIntrested: item.locationIntrested,
              locationsAvailable: item.locationsAvailable,
              pin: item.pin,
              rangeEnding: item.rangeEnding,
              rangeStarting: item.rangeStarting,
              rate: item.rate,
              reason: item.reason,
              state: item.state,
              type_sale: item.type_sale,
              url: item.url,
              singleLineDescription: '',
              title: '',
            ),
            showEditOption: false,
          ),
        ),
      );
    } else if (item.entityType == "business") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BusinessDetailPage(
            buisines: BusinessInvestorExplr(
              id: item.id,
              imageUrl: item.imageUrl,
              image2: item.image2,
              image3: item.image3,
              name: item.name,
              city: item.city,
              postedTime: item.postedTime,
              topSelling: item.topSelling,
              address_1: item.address_1,
              address_2: item.address_2,
              avg_monthly: item.avg_monthly,
              brandName: item.brandName,
              companyName: item.companyName,
              description: item.description,
              ebitda: item.ebitda,
              employees: item.employees,
              entity: item.entity,
              entityType: item.entityType,
              establish_yr: item.establish_yr,
              evaluatingAspects: item.evaluatingAspects,
              facility: item.facility,
              features: item.features,
              image4: item.image4,
              income_source: item.income_source,
              industry: item.industry,
              latest_yearly: item.latest_yearly,
              locationIntrested: item.locationIntrested,
              locationsAvailable: item.locationsAvailable,
              pin: item.pin,
              rangeEnding: item.rangeEnding,
              rangeStarting: item.rangeStarting,
              rate: item.rate,
              reason: item.reason,
              state: item.state,
              type_sale: item.type_sale,
              url: item.url,
              singleLineDescription: '',
              title: '',
            ),
            showEditOption: false,
          ),
        ),
      );
    } else if (item.entityType == "franchise") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FranchiseDetailPage(
            franchise: FranchiseExplr(
                title: '',
                singleLineDescription: 'N/A',
                imageUrl: item.imageUrl,
                image2: item.image2,
                image3: item.image3,
                image4: item.image4 ?? "",
                brandName: item.brandName ?? "",
                city: item.city,
                postedTime: item.postedTime,
                id: item.id,
                allProducts: item.allProducts,
                avgEBITDA: item.ebitda,
                avgMonthlySales: item.avgMonthlySales,
                avgNoOfStaff: item.avgNoOfStaff,
                brandFee: item.brandName,
                brandStartOperation: item.brandStartOperation,
                companyName: item.companyName,
                currentNumberOfOutlets: item.currentNumberOfOutlets,
                description: item.description,
                entityType: item.entityType,
                established_year: item.establish_yr,
                franchiseTerms: item.franchiseTerms,
                iamOffering: item.iamOffering,
                industry: item.industry,
                initialInvestment: item.initialInvestment,
                kindOfSupport: item.kindOfSupport,
                locationsAvailable: item.locationsAvailable,
                projectedRoi: item.projectedRoi,
                spaceRequiredMax: item.spaceRequiredMax,
                spaceRequiredMin: item.spaceRequiredMin,
                state: item.state,
                totalInvestmentFrom: item.totalInvestmentFrom,
                totalInvestmentTo: item.totalInvestmentTo),
            showEditOption: false,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdvisorDetailPage(
              advisor: AdvisorExplr(
                  title: '',
                  singleLineDescription: 'N/A',
                  imageUrl: item.imageUrl,
                  id: item.id,
                  user: item.user ?? "",
                  name: item.name,
                  location: item.location ?? "",
                  postedTime: item.postedTime,
                  brandLogo: item.brandLogo,
                  businessDocuments: item.businessDocuments,
                  businessPhotos: item.businessPhotos,
                  businessProof: item.businessProof,
                  contactNumber: item.contactNumber,
                  description: item.description,
                  designation: item.designation,
                  expertise: item.expertise,
                  interest: item.interest,
                  state: item.state,
                  url: item.url)),
        ),
      );
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted && context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: CustomAppBarWidget(
        title: "Recent Activities",
        isBackIcon: true,
      ),
      body: FutureBuilder<List<Recent>?>(
        future: _recentActivitiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return WishlistShimmer.buildShimmerLoading();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recent activities found.'));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCollectionTitle(),
                  const SizedBox(height: 20),
                  if (businessItems.isNotEmpty) ...[
                    _buildBusinessSection(),
                    const SizedBox(height: 20),
                  ],
                  if (franchiseItems.isNotEmpty) ...[
                    _buildFranchiseSection(),
                    const SizedBox(height: 20),
                  ],
                  if (investorItems.isNotEmpty) _buildInvestorSection(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCollectionTitle() {
    final totalItems =
        businessItems.length + franchiseItems.length + investorItems.length;
    return Row(
      children: [
        const Text(
          'Recent Activities',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '( $totalItems )',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xff6B89B7),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.business, color: Color(0xff6B89B7)),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Business',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '( ${businessItems.length} )',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildItemGrid(businessItems),
      ],
    );
  }

  Widget _buildFranchiseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xffF3D55E),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.store, color: Color(0xffF3D55E)),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Franchise',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '( ${franchiseItems.length} )',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildItemGrid(franchiseItems),
      ],
    );
  }

  Widget _buildInvestorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xffBDD0E7),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.store, color: Color(0xffBDD0E7)),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Investor',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '( ${investorItems.length} )',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildItemGrid(investorItems),
      ],
    );
  }

  Widget _buildItemGrid(List<Recent> items) {
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () => _navigateToDetailPage(item),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(item.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    item.city,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
          },
        );
    }
}
