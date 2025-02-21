import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:project_emergio/Views/detail%20page/advisor%20detail%20page.dart';
import 'package:project_emergio/Views/detail%20page/business%20deatil%20page.dart';
import 'package:project_emergio/Views/detail%20page/franchise%20detail%20page.dart';
import 'package:project_emergio/Views/detail%20page/invester%20detail%20page.dart';
import 'package:project_emergio/Widgets/custom_funtions.dart';
import 'package:project_emergio/generated/constants.dart';
import 'package:project_emergio/models/all%20profile%20model.dart';
import 'package:project_emergio/services/recent%20activities.dart';
import 'package:project_emergio/services/search.dart';
import 'package:shimmer/shimmer.dart';

class PopularSearchWidget extends StatefulWidget {
  const PopularSearchWidget({Key? key}) : super(key: key);

  @override
  State<PopularSearchWidget> createState() => _PopularSearchWidgetState();
}

class _PopularSearchWidgetState extends State<PopularSearchWidget> {
  List<dynamic> popularSearches = [];
  bool _mounted = true;

  List<Recent> _recents = [];
  bool _hasError = false;
  bool _noData = false;

  @override
  void initState() {
    super.initState();
    fetchSearch();
  }

  @override
  void dispose() {
    _mounted = false; // Set mounted flag to false when disposing
    super.dispose();
  }

  Future<void> fetchSearch() async {
    try {
      final _data = await SearchServices().fetchPopularSearches();
      // Check if widget is still mounted before calling setState
      if (_mounted && _data != null) {
        setState(() {
          popularSearches = _data;
          isLoading = false;
          _recents = _data;
        });
      }
    } catch (e) {
      if (_mounted) {
        setState(() {
          isLoading = false;
          _hasError = true;
          _noData = false;
        });
      }
      print("Error fetching popular searches: $e");
    }
  }

  bool isLoading = true;

  void _navigation(String type, Recent item) {
    if (type == "business") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BusinessDetailPage(
                  buisines: BusinessInvestorExplr(
                      id: item.id,
                      singleLineDescription: '',
                      title: item.title!,
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
                      url: item.url),
                  showEditOption: false)));
    } else if (type == "investor") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => InvestorDetailPage(
                  investor: BusinessInvestorExplr(
                      id: item.id,
                      singleLineDescription: '',
                      title: item.title!,
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
                      url: item.url),
                  showEditOption: false)));
    } else if (type == "franchise") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FranchiseDetailPage(
                  franchise: FranchiseExplr(
                      title: item.title!,
                      singleLineDescription: 'N/A',
                      id: item.id,
                      imageUrl: item.imageUrl,
                      image2: item.image2,
                      image3: item.image3,
                      image4: item.image4.toString(),
                      city: item.city,
                      postedTime: item.postedTime,
                      allProducts: item.allProducts,
                      brandName: item.name,
                      companyName: item.companyName,
                      description: item.description,
                      avgEBITDA: item.ebitda,
                      avgMonthlySales: item.avgMonthlySales,
                      entityType: item.entityType,
                      iamOffering: item.iamOffering,
                      avgNoOfStaff: item.avgNoOfStaff,
                      brandFee: item.brandFee,
                      brandStartOperation: item.brandStartOperation,
                      currentNumberOfOutlets: item.currentNumberOfOutlets,
                      established_year: item.establish_yr,
                      franchiseTerms: item.franchiseTerms,
                      industry: item.industry,
                      initialInvestment: item.initialInvestment,
                      locationsAvailable: item.locationsAvailable,
                      kindOfSupport: item.kindOfSupport,
                      state: item.state,
                      projectedRoi: item.projectedRoi,
                      spaceRequiredMax: item.spaceRequiredMax,
                      spaceRequiredMin: item.spaceRequiredMin,
                      totalInvestmentFrom: item.totalInvestmentFrom,
                      totalInvestmentTo: item.totalInvestmentTo,
                      url: item.url),
                  showEditOption: false)));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AdvisorDetailPage(
                  advisor: AdvisorExplr(
                      title: item.title!,
                      singleLineDescription: 'N/A',
                      imageUrl: item.imageUrl,
                      id: item.id,
                      user: item.user.toString(),
                      name: item.name,
                      location: item.location.toString(),
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
                      type: item.type_sale,
                      url: item.url))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    return Container(
      // height: 320,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Popular search",
            style: AppTheme.titleText(lightTextColor),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            child: isLoading
                ? _buildShimmer(w, h)
                : _hasError
                ? _buildErrorMessage(h)
                : _noData
                ? _buildNoDataMessage(h)
                : _recents.isEmpty
                ? _buildNoDataMessage(h)
                : CarouselSlider.builder(
              itemCount: _recents.length,
              itemBuilder: (context, index, realIndex) {
                final item = _recents[index];


                return InkWell(
                  onTap: () {
                    _navigation(
                        item.entityType.toString(), item);
                  },
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(15),
                        image: DecorationImage(
                            image:
                            NetworkImage(item.imageUrl),
                            fit: BoxFit.cover)),
                    child: Container(
                      // padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.transparent
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, bottom: 10),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          mainAxisAlignment:
                          MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 150.w,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(
                                      50)),
                              child: Padding(
                                padding:
                                const EdgeInsets.all(6.0),
                                child: Text(
                                  CustomFunctions.toSentenceCase(item.title!),
                                  style: AppTheme.mediumTitleText(lightTextColor).copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow:
                                  TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            SizedBox(height: 4),
                            Container(
                              width: 100.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(50),
                              ),
                              child: Padding(
                                padding:
                                const EdgeInsets.all(6.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on,
                                        color: buttonColor,
                                        size: 18.h),
                                    SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        CustomFunctions.toSentenceCase(item.city),
                                        style: AppTheme.smallText(lightTextColor),
                                        maxLines: 1,
                                        overflow: TextOverflow
                                            .ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: 245.h,
                viewportFraction: 0.57,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration:
                Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataMessage(double h) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/nodata.json',
            height: 80.h,
            width: 90.w,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 12),
          Text(
            "No data available",
            style: AppTheme.smallText(lightTextColor, ),
          ),
          SizedBox(height: 6),
          Text(
            "Check back soon for exciting offers!",
            style: AppTheme.smallText(lightTextColor),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(double h) {
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 40, color: errorIconColor),
          const  SizedBox(height: 12),
          Text(
            "Oops! Something went wrong.",
            style: AppTheme.bodyMediumTitleText(lightTextColor),
          ),
          SizedBox(height: 6),
          Text(
            "Please try again later.",
            style: AppTheme.smallText(lightTextColor),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer(double w, double h) {
    return CarouselSlider.builder(
        itemCount: 5,
        itemBuilder: (context, index, realIndex) {
          return Shimmer.fromColors(
            baseColor: shimmerBaseColor!,
            highlightColor: shimmerHighlightColor!,
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      height: 150,
                      width: 120,
                      color: containerColor,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 20,
                            width: 100,
                            color: containerColor,
                          ),
                          SizedBox(height: 8),
                          Container(
                            height: 16,
                            width: 150,
                            color: containerColor,
                          ),
                          SizedBox(height: 8),
                          Container(
                            height: 14,
                            width: 80,
                            color: containerColor,
                          ),
                          SizedBox(height: 16),
                          Container(
                            height: 36,
                            width: 100,
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
            height: 250,
            viewportFraction: 0.8,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            ),
        );
    }
}
