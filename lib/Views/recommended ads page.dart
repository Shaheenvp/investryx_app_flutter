import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/services/recent%20activities.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/all profile model.dart';
import '../services/recommended ads.dart';
import 'detail page/business deatil page.dart';
import 'detail page/franchise detail page.dart';
import 'detail page/invester detail page.dart';

class RecommendedAdsScreen extends StatefulWidget {
  const RecommendedAdsScreen({super.key});

  @override
  State<RecommendedAdsScreen> createState() => _RecommendedAdsScreenState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _RecommendedAdsScreenState extends State<RecommendedAdsScreen> {
  List<ProductDetails>? _recommendedAds;
  List<BusinessInvestorExplr>? _rmdAllItems; // Updated to List<ProductDetails>
  List<FranchiseExplr>? _rmdFranchiseItems;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecommendedAds();
  }

  Future<void> _loadRecommendedAds() async {
    final data = await RecommendedAds.fetchRecommended();
    setState(() {
      _recommendedAds = data!['recommended'];
      _rmdAllItems = data!['recommendedAll'];
      _rmdFranchiseItems = data!['recommendedFranchiseItems'];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Recommended For You',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: h * 0.025),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _isLoading
                ? GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 6,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.black12),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                  ),
                );
              },
            )
                : GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _recommendedAds?.length ?? 0,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemBuilder: (context, index) {
                var item = _recommendedAds![index];
                return GestureDetector(
                  onTap: () async {
                    await RecentActivities.recentActivities(
                        productId: item.id
                    );
                    if(item.type == 'business'){

                      Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) => BusinessDetailPage(
                            imageUrl: _rmdAllItems![index].imageUrl,
                            image2: _rmdAllItems![index].image2,
                            image3: _rmdAllItems![index].image3,
                            image4: _rmdAllItems![index].image4,
                            name: _rmdAllItems![index].name,
                            industry: _rmdAllItems![index].industry,
                            establish_yr: _rmdAllItems![index].establish_yr,
                            description: _rmdAllItems![index].description,
                            address_1: _rmdAllItems![index].address_1,
                            address_2: _rmdAllItems![index].address_2,
                            pin: _rmdAllItems![index].pin,
                            city: _rmdAllItems![index].city,
                            state: _rmdAllItems![index].state,
                            employees: _rmdAllItems![index].employees,
                            entity: _rmdAllItems![index].entity,
                            avg_monthly: _rmdAllItems![index].avg_monthly,
                            latest_yearly: _rmdAllItems![index].latest_yearly,
                            ebitda: _rmdAllItems![index].ebitda,
                            rate: _rmdAllItems![index].rate,
                            type_sale: _rmdAllItems![index].type_sale,
                            url: _rmdAllItems![index].url,
                            features: _rmdAllItems![index].features,
                            facility: _rmdAllItems![index].facility,
                            income_source: _rmdAllItems![index].income_source,
                            reason: _rmdAllItems![index].reason,
                            postedTime: _rmdAllItems![index].postedTime,
                            topSelling: _rmdAllItems![index].topSelling,
                            id: _rmdAllItems![index].id,
                            showEditOption: false,
                          ),
                        ),
                      );
                    }
                    else if(item.type == 'investor') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InvestorDetailPage(
                            imageUrl: _rmdAllItems![index].imageUrl,
                            name: _rmdAllItems![index].name,
                            city: _rmdAllItems![index].city,
                            postedTime: _rmdAllItems![index].postedTime,
                            state: _rmdAllItems![index].state,
                            industry: _rmdAllItems![index].industry,
                            description: _rmdAllItems![index].description,
                            url: _rmdAllItems![index].url,
                            rangeStarting: _rmdAllItems![index].rangeStarting,
                            rangeEnding: _rmdAllItems![index].rangeEnding,
                            evaluatingAspects: _rmdAllItems![index].evaluatingAspects,
                            CompanyName: _rmdAllItems![index].companyName,
                            locationInterested: _rmdAllItems![index].locationIntrested,
                            id: _rmdAllItems![index].id,
                            showEditOption: false,
                            image2: _rmdAllItems![index].image2,
                            image3: _rmdAllItems![index].image3,
                            image4: _rmdAllItems![index].image4,
                          ),
                        ),
                      );
                    }
                    else if(item.type == 'franchise') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FranchiseDetailPage(
                            id: _rmdFranchiseItems![index].id,
                            imageUrl: _rmdFranchiseItems![index].imageUrl,
                            image2: _rmdFranchiseItems![index].image2,
                            image3: _rmdFranchiseItems![index].image3,
                            image4: _rmdFranchiseItems![index].image4,
                            brandName: _rmdFranchiseItems![index].brandName,
                            city: _rmdFranchiseItems![index].city,
                            postedTime: _rmdFranchiseItems![index].postedTime,
                            state: _rmdFranchiseItems![index].state,
                            industry: _rmdFranchiseItems![index].industry,
                            description: _rmdFranchiseItems![index].description,
                            url: _rmdFranchiseItems![index].url,
                            initialInvestment:
                            _rmdFranchiseItems![index].initialInvestment,
                            projectedRoi: _rmdFranchiseItems![index].projectedRoi,
                            iamOffering: _rmdFranchiseItems![index].iamOffering,
                            currentNumberOfOutlets:
                            _rmdFranchiseItems![index].currentNumberOfOutlets,
                            franchiseTerms: _rmdFranchiseItems![index].franchiseTerms,
                            locationsAvailable:
                            _rmdFranchiseItems![index].locationsAvailable,
                            kindOfSupport: _rmdFranchiseItems![index].kindOfSupport,
                            allProducts: _rmdFranchiseItems![index].allProducts,
                            brandStartOperation:
                            _rmdFranchiseItems![index].brandStartOperation,
                            spaceRequiredMin:
                            _rmdFranchiseItems![index].spaceRequiredMin,
                            spaceRequiredMax:
                            _rmdFranchiseItems![index].spaceRequiredMax,
                            totalInvestmentFrom:
                            _rmdFranchiseItems![index].totalInvestmentFrom,
                            totalInvestmentTo:
                            _rmdFranchiseItems![index].totalInvestmentTo,
                            brandFee: _rmdFranchiseItems![index].brandFee,
                            avgNoOfStaff: _rmdFranchiseItems![index].avgNoOfStaff,
                            avgMonthlySales:
                            _rmdFranchiseItems![index].avgMonthlySales,
                            avgEBITDA: _rmdFranchiseItems![index].avgEBITDA,
                            showEditOption: false,
                          ),
                        ),
                      );

                    }
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    child: Container(
                      width: w * .5, // Set the width for each item
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 140.h,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                image: DecorationImage(
                                  image: NetworkImage(item.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ),
                          Text(
                            item.title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: h * .017),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 10),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/loc.png',
                                  height: h * 0.018,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  item.singleLineDescription,
                                  style: TextStyle(fontSize: h * .015),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.time,
                                  color: Colors.green,
                                  size: h * 0.018,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  formatDateTime(item.postedTime),
                                  style: TextStyle(fontSize: h * .015),
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
            ),
          ),
        ],
      ),
    );
  }

  String formatDateTime(String dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr);
    return timeago.format(dateTime, allowFromNow: true);
  }
}
