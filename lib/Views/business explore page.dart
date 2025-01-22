import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:project_emergio/Views/detail%20page/business%20deatil%20page.dart';
import 'package:project_emergio/Widgets/custom_profile_appbar_widget.dart';
import 'package:project_emergio/controller/explore_filter_controller.dart';
import 'package:project_emergio/generated/constants.dart';
import 'package:project_emergio/models/all%20profile%20model.dart';
import 'package:project_emergio/services/featured.dart';
import 'package:project_emergio/services/latest%20transactions%20and%20activites.dart';
import 'package:project_emergio/services/recent%20activities.dart';
import 'package:project_emergio/services/search.dart';

import 'package:shimmer/shimmer.dart';

import '../models/places.dart';
import '../services/recommended ads.dart';

class BusinessExplorePage extends StatefulWidget {
  final int? currentIndex;
  const BusinessExplorePage({Key? key, this.currentIndex}) : super(key: key);

  @override
  State<BusinessExplorePage> createState() => _BusinessExplorePageState();
}

class _BusinessExplorePageState extends State<BusinessExplorePage>
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

  int ebitaRange = 1;

  String transaction_type = "All";

  String entity = "";

  String preference = '';
  bool isLoading = false;
  late TextEditingController minRnageController =
  TextEditingController(text: rangeStarting);
  late TextEditingController maxRangeContoller =
  TextEditingController(text: rangeEnding);
  late TextEditingController fromYearController =
  TextEditingController(text: establishFrom);
  late TextEditingController toYearContoller =
  TextEditingController(text: establishTo);

  int _currentTab = 0;
  late TabController _tabController;
  final TextEditingController _textController = TextEditingController();
  final ExploreFilterController controller = Get.put(ExploreFilterController());

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

    controller.isFilter.value = false;
    controller.clearSearchFilter();
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
      hasSearched = true;
    });

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
        transaction: transaction_type);

    setState(() {
      isLoading = false;
      if (result['success']) {
        final List<SearchResult> rawResults =
        result['results'] as List<SearchResult>;

        searchResults =
            rawResults.where((item) => item.entityType == "business").toList();

        errorMessage = null;
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
                                  toYearContoller.text = "";
                                  fromYearController.text = "";
                                  minRnageController.text = "";
                                  maxRangeContoller.text = "";
                                });
                                Navigator.pop(context);
                                search(_textController.text);
                                controller.isFilter.value = false;
                                controller.clearSearchFilter();
                              },
                              child: const Text(
                                'Remove',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        // // Location Filter
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
                                  borderSide: BorderSide(color: buttonColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: buttonColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: buttonColor),
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
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),
                        // Industry Filter
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 3,
                                    color: const Color.fromARGB(
                                        255, 200, 199, 199),
                                    offset: Offset(1, 1))
                              ],
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Industry',
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: buttonColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: buttonColor),
                              ),
                            ),
                            value: industry.isEmpty ? null : industry,
                            items: const [
                              DropdownMenuItem(
                                  value: 'Technology',
                                  child: Text('Technology')),
                              DropdownMenuItem(
                                  value: 'Healthcare',
                                  child: Text('Healthcare')),
                              DropdownMenuItem(
                                  value: 'Retail', child: Text('Retail')),
                            ],
                            onChanged: (String? newValue) {
                              setState(() {
                                industry = newValue ?? '';
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 25),
                        const Text(
                          'EBITDA',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Selected range: " + ebitaRange.toString(),
                        ),
                        Slider(
                          label: "Select Age",
                          activeColor: buttonColor,
                          value: ebitaRange.toDouble(),
                          onChanged: (value) {
                            setState(() {
                              ebitaRange = value.toInt();
                            });
                          },
                          min: 1,
                          max: 100,
                        ),

                        const SizedBox(height: 15),

                        //transaction types
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 3,
                                  color:
                                  const Color.fromARGB(255, 200, 199, 199),
                                  offset: Offset(1, 1))
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Legal entity',
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: buttonColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: buttonColor),
                              ),
                            ),
                            value: entity.isEmpty ? null : entity,
                            items: const [
                              DropdownMenuItem(
                                  value: 'Proprietorship',
                                  child: Text('Proprietorship')),
                              DropdownMenuItem(
                                  value: 'Public Limited Company',
                                  child: Text('Public Limited Company')),
                              DropdownMenuItem(
                                  value: 'Private Limited Company',
                                  child: Text('Private Limited Company')),
                              DropdownMenuItem(
                                  value: 'Limited Liability Company',
                                  child: Text('Limited Liability Company')),
                              DropdownMenuItem(
                                  value: 'Limited Liability Partnership',
                                  child: Text('Limited Liability Partnership')),
                              DropdownMenuItem(
                                  value: 'C Corporation',
                                  child: Text('C Corporation')),
                              DropdownMenuItem(
                                  value: 'S Corporation',
                                  child: Text('S Corporation')),
                              DropdownMenuItem(
                                  value: 'Other', child: Text('Other')),
                            ],
                            onChanged: (String? newValue) {
                              setState(() {
                                entity = newValue ?? '';
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 25),

                        // Investment Range
                        const Text(
                          'Investment Range',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: minRnageController,
                                decoration: InputDecoration(
                                  labelText: 'Min Investment',
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    rangeStarting = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: maxRangeContoller,
                                decoration: InputDecoration(
                                  labelText: 'Max Investment',
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    rangeEnding = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        // Year Established Range
                        const Text(
                          'Year Established',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: fromYearController,
                                decoration: InputDecoration(
                                  labelText: 'From Year',
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    establishFrom = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: toYearContoller,
                                decoration: InputDecoration(
                                  labelText: 'To Year',
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    establishTo = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              filter = true;
                              print(
                                  "filter optios $city, $industry, $ebitaRange, $entity, $preference");

                              if ((city == "" &&
                                  industry == "" &&
                                  ebitaRange == 1 &&
                                  entity == "" &&
                                  establishFrom == "" &&
                                  establishTo == "" &&
                                  rangeStarting == "" &&
                                  rangeEnding == "")) {
                                Get.snackbar(
                                    "Error", "Please choose any filter option");
                              } else {
                                if ((rangeStarting != "" &&
                                    rangeEnding != "") &&
                                    (int.parse(rangeStarting) >
                                        int.parse(rangeEnding))) {
                                  Get.snackbar(
                                      "Error", "Please enter valid range");
                                } else {
                                  // search(_textController.text);
                                  controller.isFilter.value = true;
                                  controller.filterExploreScreens(
                                      type: "business",
                                      city: city,
                                      industry: industry,
                                      ebitda: ebitaRange == 1
                                          ? ""
                                          : ebitaRange.toString(),
                                      entity: entity,
                                      establishYearFrom: establishFrom,
                                      establishYearTo: establishTo,
                                      rangeStarting: rangeStarting,
                                      rangeEnding: rangeEnding);
                                  Navigator.pop(context);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBarWidget(
        title: "Business",
        isBackIcon: true,
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Icon(Icons.notifications, color: Colors.black),
        ),
      ),
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
                              backgroundColor: buttonColor,
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
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: buttonColor,
                    child: IconButton(
                      icon: const Icon(Icons.sort_sharp, color: Colors.white),
                      onPressed: () {
                        showCustomBottomSheet(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_textController.text.isEmpty && searchResults.isEmpty)
              Expanded(child: Obx(() {
                return Column(
                  children: [
                    TabBarWidget(_tabController),
                    controller.isFilter.value == true
                        ? Expanded(
                        child: TabBarView(
                            controller: _tabController,
                            children: [
                              Obx(() {
                                return filterTab(
                                    businessLists: controller
                                        .recentBusinessInvestorLists,
                                    tabName: "recent");
                              }),
                              Obx(() {
                                return filterTab(
                                    businessLists: controller
                                        .featuredBusinessInvestorLists,
                                    tabName: "featured");
                              }),
                              Obx(() {
                                return filterTab(
                                    businessLists: controller
                                        .recommednedBusinessInvestorLists,
                                    tabName: "recommended");
                              }),
                            ]))
                        : Expanded(
                      child: TabBarView(
                          controller: _tabController,
                          children: [
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
                );
              })),

            // Search Results or Loading/Error States
            if (isLoading)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
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
                          style: TextStyle(color: buttonColor),
                        ),
                      ),
                    ],
                  ],
                ),
              )
            else if (searchResults.isNotEmpty)
                Column(
                  children: searchResults.map((result) {
                    return GestureDetector(
                      onTap: () => _navigateToDetail(result, result.id),
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
                                    result.description,
                                    maxLines: 2,
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
                                      color: buttonColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      result.type,
                                      style: const TextStyle(
                                        color: buttonColor,
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
            color: _currentTab == index ? buttonColor : Colors.transparent,
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

  Widget filterTab(
      {required RxList<BusinessInvestorExplr> businessLists,
        required String tabName}) {
    if (tabName == "recent") {
      if (businessLists.isEmpty && controller.isLoading.value == true) {
        return _buildShimmerWidget();
      }

      return businessLists.isEmpty
          ? _buildNoDataWidget()
          : _buildGridView(businessLists: businessLists);
    }

    if (tabName == "featured") {
      if (businessLists.isEmpty && controller.isLoading.value == true) {
        return _buildShimmerWidget();
      }
      return businessLists.isEmpty
          ? _buildNoDataWidget()
          : _buildGridView(businessLists: businessLists);
    }

    if (businessLists.isEmpty && controller.isLoading.value == true) {
      return _buildShimmerWidget();
    }

    return businessLists.isEmpty
        ? _buildNoDataWidget()
        : _buildGridView(businessLists: businessLists);
  }

  Widget _buildNoDataWidget() {
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

  Widget _buildShimmerWidget() {
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
                color: Colors.yellow, borderRadius: BorderRadius.circular(15)),
          ),
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
        );
      },
    );
  }

  void _navigateToDetail(SearchResult result, String id) async {
    await SearchServices.postToPopularSearch(id);
    await SearchServices.postToRecentSearch(id);

    final businessData = BusinessInvestorExplr(
        id: result.id,
        imageUrl: result.imageUrl,
        image2: result.rawData['image2']?.toString() ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
        image3: result.rawData['image3']?.toString() ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
        image4: result.rawData['image4']?.toString(),
        name: result.title, // Using title as name since it's required
        title: result.title,
        singleLineDescription: result.description,
        city: result.location,
        postedTime: result.rawData['listed_on'] ?? DateTime.now().toIso8601String(),
        topSelling: result.rawData['top_selling']?.toString() ?? 'N/A',

        // Optional fields
        industry: result.rawData['industry']?.toString(),
        establish_yr: result.rawData['establish_yr']?.toString(),
        description: result.description,
        address_1: result.rawData['address_1']?.toString(),
        address_2: result.rawData['address_2']?.toString(),
        pin: result.rawData['pin']?.toString(),
        state: result.rawData['state']?.toString(),
        employees: result.rawData['employees']?.toString(),
        entity: result.rawData['entity']?.toString(),
        avg_monthly: result.rawData['avg_monthly']?.toString(),
        latest_yearly: result.rawData['latest_yearly']?.toString(),
        ebitda: result.rawData['ebitda']?.toString(),
        rate: result.rawData['rate']?.toString(),
        type_sale: result.rawData['type_sale']?.toString(),
        url: result.rawData['url']?.toString(),
        features: result.rawData['features']?.toString(),
        facility: result.rawData['facility']?.toString(),
        income_source: result.rawData['income_source']?.toString(),
        reason: result.rawData['reason']?.toString(),
        evaluatingAspects: result.rawData['evaluating_aspects']?.toString(),
        companyName: result.rawData['company']?.toString(),
        rangeStarting: result.rawData['range_starting']?.toString(),
        rangeEnding: result.rawData['range_ending']?.toString(),
        locationIntrested: result.rawData['location_interested']?.toString(),
        brandName: result.rawData['brand_name']?.toString(),
        entityType: result.rawData['entity_type']?.toString() ?? '',
        preference: result.rawData['preference'] as List<dynamic>? ?? [],
        profileSummary: result.rawData['profile_summary']?.toString() ?? 'N/A',
        askingPrice: result.rawData['asking_price']?.toString() ?? 'N/A'
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BusinessDetailPage(
          buisines: businessData,
          showEditOption: false,
        ),
      ),
    );
  }
// Helper function to safely convert values to string
  String toStringValue(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  Widget _buildGridView(
      {required RxList<BusinessInvestorExplr> businessLists}) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1 / 1.15,
      ),
      itemCount: businessLists.length,
      itemBuilder: (context, index) {
        final business = businessLists[index];
        return BusinessCard(
          business: business,
        );
      },
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
  List<BusinessInvestorExplr> _businessLists = [];
  List<LatestActivites> businessLists = [];
  bool _isLoading = true;
  bool _isError = false;

  Future<void> fetchRecentPosts() async {
    if (widget.tabName == "recent") {
      final data = await LatestTransactions.fetchRecentPosts("business");

      if (data != null) {
        setState(() {
          _businessLists = data["business_data"];
          _isLoading = false;
        });
      } else {
        _isError = true;
        _isLoading = false;
      }
    } else if (widget.tabName == "featured") {
      final data = await Featured.fetchFeaturedLists(profile: "business");
      if (data != null) {
        setState(() {
          _businessLists = data["business_data"];
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
          _businessLists = data["business_data"];
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

    if ((widget.tabName == "recent" && _businessLists.isEmpty) ||
        (widget.tabName == "featured" && _businessLists.isEmpty) ||
        (widget.tabName == "recommended" && _businessLists.isEmpty)) {
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
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1 / 1.15,
      ),
      itemCount: _businessLists.length,
      itemBuilder: (context, index) {
        final business = _businessLists[index];
        return BusinessCard(

          business: business,
        );
      },
    );
  }
}

// lib/widgets/business_card.dart

class BusinessCard extends StatelessWidget {
  final BusinessInvestorExplr business;

  const BusinessCard({
    Key? key,
    required this.business,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return InkWell(
      onTap: () async {
        await RecentActivities.recentActivities(productId: business.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BusinessDetailPage(
              showEditOption: false,
              buisines: business,
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
              height: isTablet ? 150.h : 100.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
                image: DecorationImage(
                  image: NetworkImage(business.imageUrl ?? 'assets/businessimg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: isTablet ? 8 : 6),
            Padding(
              padding: EdgeInsets.only(
                left: isTablet ? 8 : 6,
                right: isTablet ? 8 : 6,
                top: isTablet ? 3 : 2,
              ),
              child: Text(
                business.title ?? "N/A",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: isTablet ? 15.sp : 14.sp,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: isTablet ? 8 : 6,
                right: isTablet ? 8 : 6,
                top: isTablet ? 3 : 2,
              ),
              child: Row(
                children: [
                  SizedBox(width: isTablet ? 5 : 4),
                  Expanded(
                    child: Text(
                      business.singleLineDescription ?? "N/A",
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
                bottom: isTablet ? 8 : 6,
              ),
              child: Text(
                _formatDateTime(business.postedTime),
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
      business.imageUrl,
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