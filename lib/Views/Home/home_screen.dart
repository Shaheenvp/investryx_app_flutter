import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/Views/Home/business_home.dart';
import 'package:project_emergio/Views/Home/franchise_home_screen.dart';
import 'package:project_emergio/Views/Home/investor_home_screen.dart';
import 'package:project_emergio/Views/notification%20page.dart';
import 'package:project_emergio/Views/pricing%20screen.dart';
import 'package:project_emergio/Views/search%20page.dart';
import 'package:project_emergio/Widgets/banner%20slider%20widget.dart';
import 'package:project_emergio/Widgets/graph%20widget.dart';
import 'package:project_emergio/Widgets/recommended%20widget.dart';
import 'package:project_emergio/generated/constants.dart';
import 'package:project_emergio/models/all%20profile%20model.dart';
import 'package:project_emergio/services/latest%20transactions%20and%20activites.dart';
import 'package:shimmer/shimmer.dart';
import '../../Widgets/animated_navigation.dart';
import '../../Widgets/businessvaluecalculator_widget.dart';
import '../../Widgets/chat_button_widget.dart';
import '../../Widgets/recent activities_widget.dart';
import '../../Widgets/recent_posts_widget.dart';
import '../chat_screens/inbox_list page.dart';
import 'advisor_home_screen.dart';
import '../featured experts screen.dart';

class InveStryxHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 70.h),
        child: ChatFloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => InboxListScreen()));
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: isTablet ? 10.h : 2.h),
              _buildSearchBar(context),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLeftColumn(context),
                  _buildRightColumn(context),
                ],
              ),
              const BannerSlider(
                type: "all",
              ),
              SizedBox(
                height: 15.h,
              ),
              const AllRecentPosts(profile: ""),
              SizedBox(
                height: 14.h,
              ),
              const RecommendedAdsPage(
                profile: "home",
              ),
              const FeatureExpertList(
                isType: true,
                profile: "home",
              ),
              SizedBox(
                height: 20.h,
              ),
              const BusinessValuationPromoCard(),
              SizedBox(
                height: 16.h,
              ),
              SizedBox(height: 400.h, child: InvestmentChart()),
              SizedBox(height: 370.h, child: RecentActivitiesWidget()),
              buildFooter(),
              SizedBox(
                height: 50.h,
              ), // Increased bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFooter() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.grey[50]!,
          ],
        ),
      ),
      child: Column(
        children: [
          // Decorative element
          Container(
            margin: EdgeInsets.only(bottom: 24.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40.w,
                  height: 1.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, buttonColor.withOpacity(0.5)],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Icon(
                    Icons.diamond_outlined,
                    color: buttonColor,
                    size: 24.sp,
                  ),
                ),
                Container(
                  width: 40.w,
                  height: 1.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [buttonColor.withOpacity(0.5), Colors.transparent],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main App Name with modern styling
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Inve',
                    style: TextStyle(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                      letterSpacing: 0.5,
                    ),
                  ),
                  TextSpan(
                    text: 'Stry',
                    style: TextStyle(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.w600,
                      color: buttonColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  TextSpan(
                    text: 'x',
                    style: TextStyle(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 8.h),

          // Tagline
          Text(
            'Transforming Investment Journeys',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
              letterSpacing: 0.5,
              fontWeight: FontWeight.w400,
            ),
          ),

          SizedBox(height: 24.h),

          // Crafted message in elegant container
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Emergio ',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: buttonColor,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                  TextSpan(
                    text: '❤️',
                    style: TextStyle(
                      fontSize: 15.sp,
                    ),
                  ),
                  TextSpan(
                    text: ' Crafted in Kochi',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.grey[600],
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // Copyright and version
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.copyright_rounded,
                size: 14.sp,
                color: Colors.grey[400],
              ),
              SizedBox(width: 4.w),
              Text(
                '2024 InveStryx',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[400],
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                'v1.0.0',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[400],
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Inve',
                style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              TextSpan(
                text: 'Stry',
                style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: buttonColor),
              ),
              TextSpan(
                text: 'x',
                style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
        actions: [
          InkWell(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => PricingScreenNew()));
              },
              child: const Icon(Icons.workspace_premium, color: buttonColor)),
          SizedBox(width: 16.w),
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationScreen()));
              },
              child: const Icon(Icons.notifications, color: Colors.black)),
          SizedBox(width: 16.w),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0.w),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            AnimatedNavigation().navigateToScreen(SearchScreen()),
          );
        },
        child: AbsorbPointer(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: 6.0.w, top: 3.h, bottom: 3.h),
                child: Container(
                  decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.all(Radius.circular(15.r))
                      // shape: BoxShape.circle,
                      ),
                  child: Icon(Icons.search, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required double height,
    required double width,
    required Color color,
    required String text,
    required String imagePath,
    required VoidCallback onTap,
    String? highlightedText,
    String? secondaryText,
    List<String>? highlightedWords,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2),
              BlendMode.darken,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextContent(text, highlightedText, secondaryText, highlightedWords),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent(String text, String? highlightedText, String? secondaryText, List<String>? highlightedWords) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                // height: 1.2,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              highlightedText!,
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                // height: 1.2,
              ),
            ),
          ],
        ),
        if (secondaryText != null)
          RichText(
            text: TextSpan(
              children: _buildHighlightedText(secondaryText, highlightedWords ?? []),
            ),
          ),
      ],
    );
  }

  List<TextSpan> _buildHighlightedText(String text, List<String> highlightedWords) {
    List<TextSpan> spans = [];
    String remainingText = text;

    while (remainingText.isNotEmpty) {
      bool foundHighlight = false;
      for (String word in highlightedWords) {
        if (remainingText.toLowerCase().contains(word.toLowerCase())) {
          int index = remainingText.toLowerCase().indexOf(word.toLowerCase());
          // Add text before highlight
          if (index > 0) {
            spans.add(TextSpan(
              text: remainingText.substring(0, index),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                // height: 1.2,
              ),
            ));
          }
          // Add highlighted text
          spans.add(TextSpan(
            text: remainingText.substring(index, index + word.length),
            style: TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              // height: 1.2,
            ),
          ));
          remainingText = remainingText.substring(index + word.length);
          foundHighlight = true;
          break;
        }
      }
      if (!foundHighlight) {
        spans.add(TextSpan(
          text: remainingText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            // height: 1.2,
          ),
        ));
        break;
      }
    }
    return spans;
  }

  Widget _buildLeftColumn(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 768;
    return Column(
      children: [
        SizedBox(height: 15.h),
        Padding(
          padding: EdgeInsets.only(left: 10.0.w, bottom: 10.h),
          child: _buildCard(
            height: isTablet ? 200.h : 190.h,
            width: 173.w,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BusinessHomeScreen(),
                ),
              );
            },
            color: businessContainerColor,
            text: 'Sell your',
            highlightedText: 'Business',
            secondaryText: 'Find Investors',
            highlightedWords: ['Investors'],
            imagePath: 'assets/lefttop.png',
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0.w, bottom: 10.h),
          child: _buildCard(
            height: isTablet ? 225.h : 215.h,
            width: 173.w,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FranchiseHomeScreen(),
                ),
              );
            },
            color: franchiseContainerColor,
            text: 'Franchise your',
            highlightedText: 'Brand',
            secondaryText: 'Get Distributors',
            highlightedWords: ['Distributors'],
            imagePath: 'assets/bottomleft.png',
          ),
        ),
      ],
    );
  }

  Widget _buildRightColumn(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 768;
    return Column(
      children: [
        SizedBox(height: 15.h),
        Padding(
          padding: EdgeInsets.only(left: 10.0.w, bottom: 10.h),
          child: _buildCard(
            height: isTablet ? 225.h : 215.h,
            width: 173.w,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InvestorHomeScreen(),
                ),
              );
            },
            color: investorContainerColor,
            text: 'Buy into a',
            highlightedText: 'Business',
            secondaryText: 'Invest in a Business',
            highlightedWords: ['Invest'],
            imagePath: 'assets/righttop.png',
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0.w, bottom: 10.w),
          child: _buildCard(
            height: isTablet ? 200.h : 190.h,
            width: 173.w,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdvisorHomeScreen(),
                ),
              );
            },
            color: advisorContainerColor,
            text: 'Register as',
            highlightedText: 'Advisor',
            secondaryText: 'or Business Broker',
            highlightedWords: ['Business Broker'],
            imagePath: 'assets/bottomright.png',
          ),
        ),
      ],
    );
  }


}


class AllRecentPosts extends StatefulWidget {
  final String profile;

  const AllRecentPosts({Key? key, required this.profile}) : super(key: key);

  @override
  State<AllRecentPosts> createState() => _AllRecentPostsState();
}

class _AllRecentPostsState extends State<AllRecentPosts> {
  bool _isLoading = true;
  List<dynamic> _combinedData = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  double _getViewportFraction(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 768) {
      return 0.35; // Match LatestActivitiesList tablet viewport
    }
    return 0.52; // Original mobile fraction
  }

  double _getCarouselHeight(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 768) {
      return 250.h; // Match LatestActivitiesList tablet height
    }
    return 225.h; // Original mobile height
  }

  Future<void> fetchPosts() async {
    try {
      final response = await LatestTransactions.fetchRecentPosts(widget.profile);

      if (response != null) {
        List<BusinessInvestorExplr> businesses = response['business'] ?? [];
        List<BusinessInvestorExplr> investors = response['investors'] ?? [];
        List<FranchiseExplr> franchises = response['franchises'] ?? [];

        List<Map<String, dynamic>> combinedList = [];

        for (var business in businesses) {
          combinedList.add({
            'entity_type': 'business',
            'data': business,
          });
        }

        for (var investor in investors) {
          combinedList.add({
            'entity_type': 'investor',
            'data': investor,
          });
        }

        for (var franchise in franchises) {
          combinedList.add({
            'entity_type': 'franchise',
            'data': franchise,
          });
        }

        setState(() {
          _combinedData = combinedList;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 768;
    final viewportFraction = _getViewportFraction(context);
    final carouselHeight = _getCarouselHeight(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 24.0 : 16.0.w,
            vertical: isTablet ? 16.0 : 8.0.h,
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
            ],
          ),
        ),
        if (_isLoading)
          Center(child: _buildResponsiveShimmer(context))
        else if (_combinedData.isEmpty)
          SizedBox(
            height: isTablet ? 180.h : 200.h,
            child: Center(
              child: Text(
                'No recent posts available',
                style: AppTheme.smallText(lightTextColor).copyWith(
                  fontSize: isTablet ? 14.sp : null,
                ),
              ),
            ),
          )
        else
          CarouselSlider.builder(
            itemCount: _combinedData.length,
            itemBuilder: (context, index, realIndex) {
              final item = _combinedData[index];
              final String entityType = item['entity_type'];
              final dynamic data = item['data'];

              return ActivityCard(
                index: index,
                business: entityType == 'business'
                    ? data as BusinessInvestorExplr
                    : null,
                investor: entityType == 'investor'
                    ? data as BusinessInvestorExplr
                    : null,
                franchise:
                entityType == 'franchise' ? data as FranchiseExplr : null,
                profile: entityType,
                isHome: true,
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
    final isTablet = MediaQuery.of(context).size.width >= 768;
    final viewportFraction = _getViewportFraction(context);
    final carouselHeight = _getCarouselHeight(context);

    return CarouselSlider(
      options: CarouselOptions(
        height: carouselHeight,
        viewportFraction: viewportFraction,
        disableCenter: true,
        enlargeCenterPage: true,
        autoPlay: true,
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
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
      ),
    );
  }
}
