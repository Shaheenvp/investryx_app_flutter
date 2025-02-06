import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:project_emergio/Views/detail%20page/advisor%20detail%20page.dart';
import 'package:project_emergio/Views/detail%20page/franchise%20detail%20page.dart';
import 'package:project_emergio/Widgets/custom_profile_appbar_widget.dart';
import 'package:project_emergio/models/all%20profile%20model.dart';
import 'package:project_emergio/services/featured.dart';
import 'package:project_emergio/services/latest%20transactions%20and%20activites.dart';
import 'package:project_emergio/services/recent%20activities.dart';
import 'package:project_emergio/services/search.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:shimmer/shimmer.dart';

import '../Widgets/custom_funtions.dart';
import '../models/places.dart';
import '../services/recommended ads.dart';

class AdvisorExploreScreen extends StatefulWidget {
  final int? currentIndex;
  const AdvisorExploreScreen({Key? key, this.currentIndex}) : super(key: key);

  @override
  State<AdvisorExploreScreen> createState() => _AdvisorExploreScreenState();
}

class _AdvisorExploreScreenState extends State<AdvisorExploreScreen>
    with SingleTickerProviderStateMixin {
  List<SearchResult> searchResults = [];
  List<SearchResult> recentResults = [];
  List<String> recentSearches = [];
  Timer? _debounce;
  String? errorMessage;
  bool hasSearched = false;
  final SearchServices _searchServices = SearchServices();

// Filter variables
  String city = '';

  String state = '';

  String industry = '';

  String entityType = '';

  String establishFrom = '';

  String establishTo = '';

  String rangeStarting = '';

  String rangeEnding = '';

  bool filter = false;

  int ebitaRange = 10;

  String transaction_type = "All";

  String entity = "";

  String preference = '';
  bool isLoading = false;

  int _currentTab = 0;
  late TabController _tabController;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the tab controller with the passed index
    _currentTab = widget.currentIndex ?? 0;
    _tabController = TabController(
        length: 3, vsync: this, initialIndex: widget.currentIndex ?? 0);

    // Add listener for tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentTab = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        errorMessage = null;
        hasSearched = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    // Perform the search
    final result = await _searchServices.performSearch(
      query: query,
      city: city,
      state: state,
      industry: industry,
      entityType: entityType,
      establishFrom: establishFrom,
      establishTo: establishTo,
      rangeStarting: rangeStarting,
      rangeEnding: rangeEnding,
      filter: filter,
      entity: entity,
      preference: preference,
      transaction: transaction_type,
    );

    setState(() {
      isLoading = false;
      hasSearched = true;
      if (result['success']) {
        try {
          final List<SearchResult> rawResults =
          result['results'] as List<SearchResult>;

          searchResults =
              rawResults.where((item) => item.type == "advisor").toList();

          errorMessage = null;
        } catch (e) {
          searchResults = [];
          errorMessage = 'Error processing search results: ${e.toString()}';
        }
      } else {
        searchResults = [];
        errorMessage = result['error'];
      }
    });
  }

  void _onTextChanged(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        search(query);
      } else {
        setState(() {
          searchResults = [];
          errorMessage = null;
          hasSearched = false;
        });
      }
    });
  }

  void showCustomBottomSheet(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: SizedBox(
                  // height: h * 0.7,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Filters',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  city = '';
                                  state = '';
                                  industry = '';
                                  entityType = '';
                                  establishFrom = '';
                                  establishTo = '';
                                  rangeStarting = '';
                                  rangeEnding = '';
                                  entity = '';

                                  ebitaRange = 1;
                                  filter = false;
                                });
                                Navigator.pop(context);
                                search(_textController.text);
                              },
                              child: const Text(
                                'Remove',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        // Location Filter
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 3,
                                color: Color.fromARGB(255, 200, 199, 199),
                                offset: Offset(1, 1),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownSearch<String>(
                            decoratorProps: DropDownDecoratorProps(
                              decoration: InputDecoration(
                                labelText: 'Location',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                  BorderSide(color: Color(0xffFFCC00)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                  BorderSide(color: Color(0xffFFCC00)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                  BorderSide(color: Color(0xffFFCC00)),
                                ),
                              ),
                            ),
                            items: (filter, infiniteScrollProps) => AllPlaces()
                                .places, // Assuming AllPlaces().places is a list of strings
                            selectedItem: city.isEmpty ? null : city,

                            onChanged: (String? newValue) {
                              setState(() {
                                city = newValue ?? '';
                              });
                            },

                            popupProps: PopupProps.menu(
                              showSearchBox: true, // Enables the search box

                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                  hintText: 'Search locations...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                    BorderSide(color: Color(0xffFFCC00)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),


                        const SizedBox(height: 25),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              filter = true;
                              Navigator.pop(context);
                              search(_textController.text);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffFFCC00),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Apply Filter',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToDetail(SearchResult result, String id) async {
    await SearchServices.postToPopularSearch(id);
    await SearchServices.postToRecentSearch(id);

    final franchiseData = {
      ...result.rawData,
      'postedTime': CustomFunctions.formatDateTime(result.rawData['listed_on']),
      'currentNumberOfOutlets': CustomFunctions.toStringValue(
          result.rawData['currentNumberOfOutlets']),
      'spaceRequiredMin':
      CustomFunctions.toStringValue(result.rawData['spaceRequiredMin']),
      'spaceRequiredMax':
      CustomFunctions.toStringValue(result.rawData['spaceRequiredMax']),
      'totalInvestmentFrom':
      CustomFunctions.toStringValue(result.rawData['totalInvestmentFrom']),
      'totalInvestmentTo':
      CustomFunctions.toStringValue(result.rawData['totalInvestmentTo']),
      'brandFee': CustomFunctions.toStringValue(result.rawData['brandFee']),
      'avgNoOfStaff':
      CustomFunctions.toStringValue(result.rawData['avgNoOfStaff']),
      'avgMonthlySales':
      CustomFunctions.toStringValue(result.rawData['avgMonthlySales']),
      'avgEBITDA': CustomFunctions.toStringValue(result.rawData['avgEBITDA']),
      'brandStartOperation':
      CustomFunctions.toStringValue(result.rawData['brandStartOperation']),
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FranchiseDetailPage(
          franchise: FranchiseExplr(
            singleLineDescription: '',
            title : '',
            id: result.id,
            imageUrl: result.imageUrl,
            image2: CustomFunctions.toStringValue(franchiseData['image2']),
            image3: CustomFunctions.toStringValue(franchiseData['image3']),
            image4: CustomFunctions.toStringValue(franchiseData['image4']),
            brandName: result.name,
            city: result.location,
            postedTime: franchiseData['postedTime'],
            state: CustomFunctions.toStringValue(franchiseData['state']),
            industry: CustomFunctions.toStringValue(franchiseData['industry']),
            description: result.description,
            url: CustomFunctions.toStringValue(franchiseData['url']),
            initialInvestment: CustomFunctions.toStringValue(
                franchiseData['initialInvestment']),
            projectedRoi:
            CustomFunctions.toStringValue(franchiseData['projectedRoi']),
            iamOffering:
            CustomFunctions.toStringValue(franchiseData['iamOffering']),
            currentNumberOfOutlets: franchiseData['currentNumberOfOutlets'],
            franchiseTerms:
            CustomFunctions.toStringValue(franchiseData['franchiseTerms']),
            locationsAvailable: CustomFunctions.toStringValue(
                franchiseData['locationsAvailable']),
            kindOfSupport:
            CustomFunctions.toStringValue(franchiseData['kindOfSupport']),
            allProducts:
            CustomFunctions.toStringValue(franchiseData['allProducts']),
            brandStartOperation: franchiseData['brandStartOperation'],
            spaceRequiredMin: franchiseData['spaceRequiredMin'],
            spaceRequiredMax: franchiseData['spaceRequiredMax'],
            totalInvestmentFrom: franchiseData['totalInvestmentFrom'],
            totalInvestmentTo: franchiseData['totalInvestmentTo'],
            brandFee: franchiseData['brandFee'],
            avgNoOfStaff: franchiseData['avgNoOfStaff'],
            avgMonthlySales: franchiseData['avgMonthlySales'],
            avgEBITDA: franchiseData['avgEBITDA'],
          ),
          showEditOption: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBarWidget(title: "Advisors",
        isBackIcon: true,
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 16.0),
          // child: Icon(Icons.notifications, color: Colors.black),
        ),),
      body: SafeArea(
        child: DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      onChanged: _onTextChanged,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        filled: true,
                        fillColor: const Color(0xffF3F8FE),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_textController.text.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _textController.clear();
                                  setState(() {
                                    searchResults = [];
                                    errorMessage = null;
                                    hasSearched = false;
                                    isLoading = false;
                                  });
                                },
                              ),
                            CircleAvatar(
                              backgroundColor: const Color(0xffFFCC00),
                              child: IconButton(
                                icon: const Icon(Icons.search,
                                    color: Colors.white),
                                onPressed: () => search(_textController.text),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // const SizedBox(width: 8),
                  // CircleAvatar(
                  //   backgroundColor: const Color(0xffFFCC00),
                  //   child: IconButton(
                  //     icon: const Icon(Icons.sort_sharp, color: Colors.white),
                  //     onPressed: () {
                  //       showCustomBottomSheet(context);
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_textController.text.isEmpty && searchResults.isEmpty)
              Expanded(
                child: Column(
                  children: [
                    TabBarWidget(_tabController),
                    Expanded(
                      child: TabBarView(controller: _tabController, children: [
                        BusinessGrid(
                          tabName: "recent",
                        ),
                        BusinessGrid(
                          tabName: "featured",
                        ),
                        BusinessGrid(
                          tabName: "recommended",
                        ),
                      ]),
                    ),
                  ],
                ),
              ),

            // Search Results or Loading/Error States
            if (isLoading)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Color(0xffFFCC00)),
                    ),
                    SizedBox(height: 16),
                    Text('Searching...'),
                  ],
                ),
              )
            else if (errorMessage != null && hasSearched)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.search_off,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    if (filter) ...[
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            city = '';
                            state = '';
                            industry = '';
                            entityType = '';
                            establishFrom = '';
                            establishTo = '';
                            rangeStarting = '';
                            rangeEnding = '';
                            filter = false;
                          });
                          search(_textController.text);
                        },
                        child: const Text(
                          'Clear filters and try again',
                          style: TextStyle(color: Color(0xffFFCC00)),
                        ),
                      ),
                    ],
                  ],
                ),
              )
            else if (searchResults.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: searchResults.map((result) {
                      return GestureDetector(
                        onTap: () => CustomFunctions.navigateToDetail(
                            result, result.id, context),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  result.imageUrl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.error),
                                      ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      result.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on,
                                            size: 16, color: Colors.grey[600]),
                                        const SizedBox(width: 4),
                                        Text(
                                          result.location,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      result.singleLineDescription,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xffFFCC00)
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        result.type,
                                        style: const TextStyle(
                                          color: Color(0xffFFCC00),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
          ]),
        ),
      ),
    );
  }

  Widget TabBarWidget(TabController tabController) {
    return TabBar(
        controller: tabController,
        onTap: (int index) {
          setState(() {
            _currentTab = index;
          });
          print("index $index,  $_currentTab");
        },
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: Colors.transparent,
        indicatorPadding: EdgeInsets.zero,
        // dragStartBehavior: ScrollBehavior.,
        tabs: [
          _buildTab(title: "Recent", index: 0),
          _buildTab(title: "Featured", index: 1),
          _buildTab(title: "Recommended", index: 2)
        ]);
  }

  _buildTab({required String title, required int index}) {
    return Tab(
      child: Container(
        height: 45,
        // width: double.infinity,
        decoration: BoxDecoration(
            color:
            _currentTab == index ? Color(0xffFFCC00) : Colors.transparent,
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: _currentTab == index ? Colors.white : Colors.black,
                    fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BusinessGrid extends StatefulWidget {
  final String tabName;
  BusinessGrid({
    Key? key,
    required this.tabName,
  }) : super(key: key);

  @override
  State<BusinessGrid> createState() => _BusinessGridState();
}

class _BusinessGridState extends State<BusinessGrid> {
  List<AdvisorExplr> _advisorLists = [];
  List<LatestActivites> advisorLists = [];
  bool _isLoading = true;
  bool _isError = false;

  Future<void> fetchRecentPosts() async {
    if (widget.tabName == "recent") {
      final data = await LatestTransactions.fetchRecentPosts("advisor");

      if (data != null) {
        setState(() {
          _advisorLists = data["advisor_data"];
          _isLoading = false;
        });
      } else {
        _isError = true;
        _isLoading = false;
      }
    } else if (widget.tabName == "featured") {
      final data = await Featured.fetchFeaturedAdvisorData();
      if (data != null) {
        setState(() {
          _advisorLists = data;

          _isLoading = false;
        });
      } else {
        _isError = true;
        _isLoading = false;
      }
    } else {
      final data = await RecommendedAds.fetchRecommended();
      if (data != null) {
        setState(() {
          _advisorLists = data["advisor_data"];
          _isLoading = false;
        });
      } else {
        _isError = true;
        _isLoading = false;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRecentPosts();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading == true) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1 / 1.15,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            child: Container(
              height: double.infinity,
              width: 210,
              decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(15)),
            ),
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
          );
        },
      );
    }

    if (_isError == true) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 40, color: Colors.red),
          Center(
            child: Text("Something went wrong!. Please check later"),
          ),
        ],
      );
    }

    if ((widget.tabName == "recent" && _advisorLists.isEmpty) ||
        (widget.tabName == "featured" && _advisorLists.isEmpty) ||
        (widget.tabName == "recommended" && _advisorLists.isEmpty)) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/nodata.json',
            height: 80.h,
            width: 90.w,
            fit: BoxFit.cover,
          ),
          Center(child: Text("No data available")),
        ],
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.only(left: 8,top: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1 / 1.15,
      ),
      itemCount: _advisorLists.length,
      itemBuilder: (context, index) {
        final advisor = _advisorLists[index];
        return BusinessCard(
          advisor: advisor,
        );
      },
    );
  }
}

class BusinessCard extends StatelessWidget {
  final AdvisorExplr advisor;

  const BusinessCard({
    Key? key,
    required this.advisor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return InkWell(
      onTap: () async {
        await RecentActivities.recentActivities(productId: advisor.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdvisorDetailPage(
              advisor: advisor,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: isTablet ? 145.h : 120.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
                image: DecorationImage(
                  image: NetworkImage(advisor.imageUrl ?? 'assets/businessimg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: isTablet ? 8 : 2),
            Padding(
              padding: EdgeInsets.only(
                left: isTablet ? 8 : 6,
                right: isTablet ? 8 : 6,
                top: isTablet ? 3 : 0,
              ),
              child: Text(
                advisor.title ?? "N/A",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: isTablet ? 15.sp : 14.sp,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: isTablet ? 8 : 0),
            Padding(
              padding: EdgeInsets.only(
                left: isTablet ? 8 : 6,
                right: isTablet ? 8 : 6,
                top: isTablet ? 3 : 0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      advisor.singleLineDescription ?? "N/A",
                      style: TextStyle(
                        fontSize: isTablet ? 13.sp : 12.sp,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: isTablet ? 8 : 6,
                right: isTablet ? 8 : 6,
                top: isTablet ? 3 : 2,
                bottom: isTablet ? 8 : 0,
              ),
              child: Text(
                _formatDateTime(advisor.postedTime),
                style: TextStyle(
                  fontSize: isTablet ? 12.sp : 11.sp,
                  color: Colors.black54,
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

  String _formatDateTime(String postedTime) {
    try {
      final dateTime = DateTime.parse(postedTime);
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      return "Invalid date";
    }
  }

  Widget _buildNetworkImage(bool isTablet) {
    return Image.network(
      advisor.imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey[300],
          child: Center(
            child: SizedBox(
              width: isTablet ? 28 : 24,
              height: isTablet ? 28 : 24,
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: Center(
            child: Icon(
              Icons.error_outline,
              color: Colors.red,
              size: isTablet ? 36 : 32,
            ),
          ),
        );
      },
    );
  }
}