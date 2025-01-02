import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/Views/Investment%20explore%20page.dart';
import 'package:project_emergio/Views/business%20explore%20page.dart';
import 'package:project_emergio/Views/detail%20page/business%20deatil%20page.dart';
import 'package:project_emergio/Views/detail%20page/franchise%20detail%20page.dart';
import 'package:project_emergio/Views/detail%20page/invester%20detail%20page.dart';
import 'package:project_emergio/Views/franchise%20explore%20page.dart';
import 'package:project_emergio/Widgets/custom_funtions.dart';
import 'package:project_emergio/generated/constants.dart';
import 'package:project_emergio/models/all%20profile%20model.dart';
import 'package:project_emergio/services/featured.dart';
import 'package:project_emergio/services/recent%20activities.dart';
import 'package:shimmer/shimmer.dart';
import '../services/latest transactions and activites.dart';

class FeaturedBusinessInvestorAndFranchise extends StatefulWidget {
  final String profile;
  const FeaturedBusinessInvestorAndFranchise({Key? key, required this.profile}) : super(key: key);
  @override
  _FeaturedBusinessInvestorAndFranchiseState createState() => _FeaturedBusinessInvestorAndFranchiseState();
}

class _FeaturedBusinessInvestorAndFranchiseState extends State<FeaturedBusinessInvestorAndFranchise> {
  List<LatestActivites>? _activities;
  List<BusinessInvestorExplr> _featured = [];
  List<FranchiseExplr> _franchiseFeatured = [];
  List<AdvisorExplr> _advisorFeatured = [];

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchActivities();
  }

  Future<void> _fetchActivities() async {
    String item = widget.profile == "business"
        ? "investor"
        : widget.profile == "investor"
        ? "business"
        : widget.profile == "franchise"
        ? "franchise"
        : "";
    try {
      final activities = await Featured.fetchFeaturedLists(profile: item);

      if (activities != null) {
        fetchFeatured(activities);
        setState(() {
          _isLoading = false;
        });
      } else {
        print("Result is empty lists");
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load activities';
        _isLoading = false;
      });
    }
  }

  Future<void> fetchFeatured(Map<String, dynamic> data) async {
    switch (widget.profile) {
      case "business":
        setState(() {
          _featured = data["investor_data"];
        });
        break;
      case "investor":
        setState(() {
          _featured = data["business_data"];
        });
        break;
      case "franchise":
        setState(() {
          _franchiseFeatured = data["franchise_data"];
        });
        break;

      default:
        setState(() {
          _franchiseFeatured = data["franchise_data"];
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
          const EdgeInsets.only(left: 16.0, right: 16, top: 16, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  widget.profile == "business"
                      ? "Featured investors"
                      : widget.profile == "investor"
                      ? 'Featured Business'
                      : "Featured franchises",
                  style: AppTheme.titleText(lightTextColor)),
              InkWell(
                onTap: () {
                  switch (widget.profile) {
                    case "business":
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const InvestorExplorePage(
                                currentIndex: 1,
                              )));
                      break;
                    case "investor":
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BusinessExplorePage(
                                currentIndex: 1,
                              )));
                      break;
                    case "franchise":
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FranchiseExplorePage(
                                currentIndex: 1,
                              )));
                      break;
                  }
                },
                child: SizedBox(
                  child: Text('See all',
                      style: AppTheme.bodyMediumTitleText(buttonColor)
                          .copyWith(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
        if (_isLoading)
          Center(child: recentPostShimmer())
        else if (_error != null)
          Center(child: Text(_error!))
        else if (widget.profile == "business" && _featured.isEmpty)
            _noPostAvailable()
          else if (widget.profile == "investor" && _featured.isEmpty)
              _noPostAvailable()
            else if (widget.profile == "franchise" && _franchiseFeatured.isEmpty)
                _noPostAvailable()
              else if (widget.profile == "" && _activities!.isEmpty)
                  _noPostAvailable()
                else if (widget.profile == "business" || widget.profile == "investor")
                    CarouselSlider.builder(
                      itemCount: _featured.length,
                      itemBuilder: (context, index, realIndex) {
                        return ActivityCard(
                          business: _featured[index],
                          profile: widget.profile,
                          index: index,
                          id: _featured[index].id,
                        );
                      },
                      options: CarouselOptions(
                        height: 225.h,
                        viewportFraction: 0.52,
                        disableCenter: true,
                        enlargeCenterPage: true,
                        autoPlay: false,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                      ),
                    )
                  else if (widget.profile == "franchise")
                      CarouselSlider.builder(
                        itemCount: _franchiseFeatured.length,
                        itemBuilder: (context, index, realIndex) {
                          return ActivityCard(
                            franchise: _franchiseFeatured[index],
                            profile: "franchise",
                            index: index,
                            id: _franchiseFeatured[index].id,
                          );
                        },
                        options: CarouselOptions(
                          height: 245.h,
                          viewportFraction: 0.57,
                          enlargeCenterPage: true,
                          autoPlay: false,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                        ),
                      )
      ],
    );
  }

  Widget recentPostShimmer() {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        height: 230,
        viewportFraction: 0.78,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
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
                  borderRadius: BorderRadius.circular(borderRadius)),
            ),
          )),
    );
  }

  Widget _noPostAvailable() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
          child: Text(
            'No posts available',
            style: AppTheme.smallText(lightTextColor),
          )),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final BusinessInvestorExplr? business;
  final FranchiseExplr? franchise;
  final String profile;
  final LatestActivites? allProfile;
  final int index;
  final String id;

  const ActivityCard(
      {Key? key,
        required this.index,
        required this.profile,
        this.business,
        this.allProfile,
        required this.id,
        this.franchise})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _navigateToDetailPage(index, id, context, profile);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: business != null && business!.imageUrl != null
                ? NetworkImage(business!.imageUrl)
                : franchise != null && franchise!.imageUrl != null
                ? NetworkImage(franchise!.imageUrl)
                : AssetImage('assets/businessimg.png') as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 150.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6.0),
                        child: Text(
                          business != null
                              ? CustomFunctions.toSentenceCase(business!.title ?? "N/A")
                              : franchise != null
                              ? CustomFunctions.toSentenceCase(
                              franchise!.title ?? "N/A")
                              : CustomFunctions.toSentenceCase(
                              allProfile!.title ?? "N/A"),
                          style: AppTheme.mediumTitleText(Colors.black87).copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.black87,
                              size: 16,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                business != null
                                    ? CustomFunctions.toSentenceCase(
                                    business!.city ?? "N/A")
                                    : franchise != null
                                    ? CustomFunctions.toSentenceCase(
                                    franchise!.city ?? "N/A")
                                    : CustomFunctions.toSentenceCase(
                                    allProfile!.singleLineDescription ?? "N/A"),
                                style: AppTheme.smallText(Colors.black87),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }

  Future<void> _navigateToDetailPage(
      int index, String id, BuildContext context, String profile) async {
    await RecentActivities.recentActivities(productId: id);

    if (profile == 'investor') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BusinessDetailPage(
            buisines: business,
            imageUrl: business!.imageUrl,
            image2: business!.image2,
            image3: business!.image3,
            image4: business!.image4,
            name: business!.name,
            industry: business!.industry,
            establish_yr: business!.establish_yr,
            description: business!.description,
            address_1: business!.address_1,
            address_2: business!.address_2,
            pin: business!.pin,
            city: business!.city,
            state: business!.state,
            employees: business!.employees,
            entity: business!.entity,
            avg_monthly: business!.avg_monthly,
            latest_yearly: business!.latest_yearly,
            ebitda: business!.ebitda,
            rate: business!.rate,
            type_sale: business!.type_sale,
            url: business!.url,
            features: business!.features,
            facility: business!.facility,
            income_source: business!.income_source,
            reason: business!.reason,
            postedTime: business!.postedTime,
            topSelling: business!.topSelling,
            id: business!.id,
            showEditOption: false,
          ),
        ),
      );
    } else if (profile == 'business') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InvestorDetailPage(
            investor: business,
            imageUrl: business!.imageUrl,
            name: business!.name,
            city: business!.city,
            postedTime: business!.postedTime,
            state: business!.state,
            industry: business!.industry,
            description: business!.description,
            url: business!.url,
            rangeStarting: business!.rangeStarting,
            rangeEnding: business!.rangeEnding,
            evaluatingAspects: business!.evaluatingAspects,
            CompanyName: business!.companyName,
            locationInterested: business!.locationIntrested,
            id: business!.id,
            showEditOption: false,
            image2: business!.image2 ?? '',
            image3: business!.image3 ?? '',
            image4: business!.image4,
          ),
        ),
      );
    } else {
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
    }
    }
}
