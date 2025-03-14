import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/Widgets/custom_funtions.dart';
import 'package:project_emergio/Widgets/custom_profile_appbar_widget.dart';
import 'package:project_emergio/Widgets/popular_search_widget.dart';
import 'package:project_emergio/generated/constants.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/all profile model.dart';
import '../models/places.dart';
import '../services/recent activities.dart';
import '../services/search.dart';
import 'detail page/advisor detail page.dart';
import 'detail page/business deatil page.dart';
import 'detail page/franchise detail page.dart';
import 'detail page/invester detail page.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController textController = TextEditingController();
  final SearchServices _searchServices = SearchServices();
  List<SearchResult> searchResults = [];
  List<SearchResult> recentResults = [];
  List<String> recentSearches = [];
  bool isLoading = false;
  Timer? _debounce;
  String? errorMessage;
  bool hasSearched = false;
  List<Recent> _recentSearchLists = [];
  bool showPopRec = false;

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

  final CarouselController carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    // _loadRecentResults();
  }

  Future<void> _loadRecentSearches() async {
    final searches = await _searchServices.loadRecentSearches();
    setState(() {
      recentSearches = searches;
    });
  }

  Future<void> _clearRecentSearches() async {
    await _searchServices.clearRecentSearches();
    setState(() {
      recentSearches = [];
      hasSearched = false;
    });
  }

  String formatDateTime(String dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr);
    return timeago.format(dateTime, allowFromNow: true);
  }

  String toStringValue(dynamic value) {
    if (value == null) return '';
    if (value is int || value is double) return value.toString();
    if (value is List) return value.join(', ');
    return value.toString();
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
        searchResults = result['results'];
        errorMessage = null;
      } else {
        searchResults = [];
        errorMessage = result['error'];
      }
    });

    if (result['success']) {
      await _searchServices.saveRecentSearch(query, recentSearches);
      await _loadRecentSearches();
    }
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

  Widget _buildStyledChip(String label) {
    return GestureDetector(
      onTap: () {
        textController.text = label;
        search(label);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Chip(
          label: Text(
            label,
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          deleteIcon: const Icon(
            Icons.close,
            size: 18,
            color: Color(0xffFFCC00),
          ),
          onDeleted: () async {
            setState(() {
              recentSearches.remove(label);
            });

            final searches = await _searchServices.loadRecentSearches();
            searches.remove(label);
            await _searchServices.saveRecentSearch('', searches);
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          labelPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          visualDensity: VisualDensity.compact,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide.none,
          ),
        ),
      ),
    );
  }

  void showCustomBottomSheet(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
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
                            Text(
                              'Filters',
                              style: AppTheme.titleText(lightTextColor),
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
                                search(textController.text);
                              },
                              child: Text(
                                'Remove',
                                style: AppTheme.titleText(Colors.red),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        //transaction types
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 3,
                                  color: boxShadowColor,
                                  offset: const Offset(1, 1))
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: '',
                              border: const OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                const BorderSide(color: buttonColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                const BorderSide(color: buttonColor),
                              ),
                            ),
                            value: transaction_type,
                            items: [
                              DropdownMenuItem(
                                  value: 'Investment',
                                  child: Text(
                                    'Investment opportunities',
                                    style:
                                    AppTheme.mediumTitleText(lightTextColor)
                                        .copyWith(
                                        fontWeight: FontWeight.w400),
                                  )),
                              DropdownMenuItem(
                                  value: 'Franchise',
                                  child: Text(
                                    'Franchise opportunities',
                                    style:
                                    AppTheme.mediumTitleText(lightTextColor)
                                        .copyWith(
                                        fontWeight: FontWeight.w400),
                                  )),
                              DropdownMenuItem(
                                  value: 'Selling',
                                  child: Text('Business for sale',
                                      style: AppTheme.mediumTitleText(
                                          lightTextColor)
                                          .copyWith(
                                          fontWeight: FontWeight.w400))),
                              DropdownMenuItem(
                                  value: 'All',
                                  child: Text(
                                    'All transactions',
                                    style: AppTheme.mediumTitleText(
                                        lightTextColor),
                                  )),
                            ],
                            onChanged: (String? newValue) {
                              setState(() {
                                transaction_type = newValue ?? '';
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 25),

                        // // Location Filter
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 3,
                                color: boxShadowColor,
                                offset: const Offset(1, 1),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownSearch<String>(
                            decoratorProps: DropDownDecoratorProps(
                              decoration: InputDecoration(
                                labelText: 'Location',
                                labelStyle:
                                AppTheme.mediumTitleText(lightTextColor)
                                    .copyWith(fontWeight: FontWeight.w400),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                  const BorderSide(color: buttonColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                  const BorderSide(color: buttonColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                  const BorderSide(color: buttonColor),
                                ),
                              ),
                            ),
                            items: (filter, infiniteScrollProps) =>
                            AllPlaces().places,
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
                                    const BorderSide(color: buttonColor),
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
                                    color: boxShadowColor,
                                    offset: const Offset(1, 1))
                              ],
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Industry',
                              border: const OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                const BorderSide(color: buttonColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                const BorderSide(color: buttonColor),
                              ),
                            ),
                            value: industry.isEmpty ? null : industry,
                            items: [
                              DropdownMenuItem(
                                  value: 'Technology',
                                  child: Text(
                                    'Technology',
                                    style:
                                    AppTheme.mediumTitleText(lightTextColor)
                                        .copyWith(
                                        fontWeight: FontWeight.w400),
                                  )),
                              DropdownMenuItem(
                                  value: 'Healthcare',
                                  child: Text(
                                    'Healthcare',
                                    style:
                                    AppTheme.mediumTitleText(lightTextColor)
                                        .copyWith(
                                        fontWeight: FontWeight.w400),
                                  )),
                              DropdownMenuItem(
                                  value: 'Retail',
                                  child: Text(
                                    'Retail',
                                    style:
                                    AppTheme.mediumTitleText(lightTextColor)
                                        .copyWith(
                                        fontWeight: FontWeight.w400),
                                  )),
                            ],
                            onChanged: (String? newValue) {
                              setState(() {
                                industry = newValue ?? '';
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 25),
                        // Business Type Filter
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 3,
                                    color: boxShadowColor,
                                    offset: const Offset(1, 1)),
                              ],
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Business Type',
                              border: const OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                const BorderSide(color: buttonColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                const BorderSide(color: buttonColor),
                              ),
                            ),
                            value: entityType.isEmpty ? null : entityType,
                            items: [
                              DropdownMenuItem(
                                  value: 'business',
                                  child: Text(
                                    'Business',
                                    style:
                                    AppTheme.mediumTitleText(lightTextColor)
                                        .copyWith(
                                        fontWeight: FontWeight.w400),
                                  )),
                              DropdownMenuItem(
                                  value: 'investor',
                                  child: Text(
                                    'Investor',
                                    style:
                                    AppTheme.mediumTitleText(lightTextColor)
                                        .copyWith(
                                        fontWeight: FontWeight.w400),
                                  )),
                              DropdownMenuItem(
                                  value: 'franchise',
                                  child: Text(
                                    'Franchise',
                                    style:
                                    AppTheme.mediumTitleText(lightTextColor)
                                        .copyWith(
                                        fontWeight: FontWeight.w400),
                                  )),
                              DropdownMenuItem(
                                  value: 'advisor',
                                  child: Text(
                                    'Advisor',
                                    style:
                                    AppTheme.mediumTitleText(lightTextColor)
                                        .copyWith(
                                        fontWeight: FontWeight.w400),
                                  )),
                            ],
                            onChanged: (String? newValue) {
                              setState(() {
                                entityType = newValue ?? '';
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 25),
                        entityType == "investor"
                            ? Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 3,
                                    color: boxShadowColor,
                                    offset: Offset(1, 1)),
                              ],
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Preference',
                              border: const OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                BorderSide(color: buttonColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                const BorderSide(color: buttonColor),
                              ),
                            ),
                            value: preference.isEmpty ? null : preference,
                            items: [
                              DropdownMenuItem(
                                  value: 'Buying a business',
                                  child: Text(
                                    'Buying a business',
                                    style: AppTheme.mediumTitleText(
                                        lightTextColor)
                                        .copyWith(
                                        fontWeight: FontWeight.w400),
                                  )),
                              DropdownMenuItem(
                                  value: 'Investing in a business',
                                  child: Text(
                                    'Investing in a business',
                                    style: AppTheme.mediumTitleText(
                                        lightTextColor)
                                        .copyWith(
                                        fontWeight: FontWeight.w400),
                                  )),
                              DropdownMenuItem(
                                  value: 'Lending to a business',
                                  child: Text(
                                    'Lending to a business',
                                    style: AppTheme.mediumTitleText(
                                        lightTextColor)
                                        .copyWith(
                                        fontWeight: FontWeight.w400),
                                  )),
                              DropdownMenuItem(
                                  value: 'Buying business assets',
                                  child: Text(
                                    'Buying business assets',
                                    style: AppTheme.mediumTitleText(
                                        lightTextColor)
                                        .copyWith(
                                        fontWeight: FontWeight.w400),
                                  )),
                            ],
                            onChanged: (String? newValue) {
                              setState(() {
                                preference = newValue ?? '';
                              });
                            },
                          ),
                        )
                            : const SizedBox.shrink(),

                        const SizedBox(height: 19),
                        const Text(
                          'EBITDA',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Selected range: " + ebitaRange.toString(),
                          style: AppTheme.mediumTitleText(lightTextColor)
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        Slider(
                          label: "Select range",
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
                                  color: boxShadowColor,
                                  offset: const Offset(1, 1))
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Legal entity',
                              border: const OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                const BorderSide(color: buttonColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                const BorderSide(color: buttonColor),
                              ),
                            ),
                            value: entity.isEmpty ? null : entity,
                            items: [
                              DropdownMenuItem(
                                  value: 'Proprietorship',
                                  child: Text(
                                    'Proprietorship',
                                    style:
                                    AppTheme.mediumTitleText(lightTextColor)
                                        .copyWith(
                                        fontWeight: FontWeight.w400),
                                  )),
                              DropdownMenuItem(
                                  value: 'Public Limited Company',
                                  child: Text(
                                    'Public Limited Company',
                                    style:
                                    AppTheme.mediumTitleText(lightTextColor)
                                        .copyWith(
                                        fontWeight: FontWeight.w400),
                                  )),
                              DropdownMenuItem(
                                  value: 'Private Limited Company',
                                  child: Text(
                                    'Private Limited Company',
                                    style:
                                    AppTheme.mediumTitleText(lightTextColor)
                                        .copyWith(
                                        fontWeight: FontWeight.w400),
                                  )),
                              DropdownMenuItem(
                                  value: 'Limited Liability Company',
                                  child: Text(
                                    'Limited Liability Company',
                                    style:
                                    AppTheme.mediumTitleText(lightTextColor)
                                        .copyWith(
                                        fontWeight: FontWeight.w400),
                                  )),
                              DropdownMenuItem(
                                  value: 'Limited Liability Partnership',
                                  child: Text(
                                    'Limited Liability Partnership',
                                    style:
                                    AppTheme.mediumTitleText(lightTextColor)
                                        .copyWith(
                                        fontWeight: FontWeight.w400),
                                  )),
                              DropdownMenuItem(
                                  value: 'C Corporation',
                                  child: Text(
                                    'C Corporation',
                                    style:
                                    AppTheme.mediumTitleText(lightTextColor)
                                        .copyWith(
                                        fontWeight: FontWeight.w400),
                                  )),
                              DropdownMenuItem(
                                  value: 'S Corporation',
                                  child: Text(
                                    'S Corporation',
                                    style:
                                    AppTheme.mediumTitleText(lightTextColor)
                                        .copyWith(
                                        fontWeight: FontWeight.w400),
                                  )),
                              DropdownMenuItem(
                                  value: 'Other',
                                  child: Text(
                                    'Other',
                                    style:
                                    AppTheme.mediumTitleText(lightTextColor)
                                        .copyWith(
                                        fontWeight: FontWeight.w400),
                                  )),
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
                        Text(
                          'Investment Range',
                          style: AppTheme.mediumTitleText(lightTextColor),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Min Investment',
                                  border: const OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                    const BorderSide(color: buttonColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                    const BorderSide(color: buttonColor),
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
                                decoration: InputDecoration(
                                  labelText: 'Max Investment',
                                  labelStyle:
                                  AppTheme.mediumTitleText(lightTextColor)
                                      .copyWith(
                                      fontWeight: FontWeight.w400),
                                  border: const OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                    const BorderSide(color: buttonColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                    const BorderSide(color: buttonColor),
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
                        Text(
                          'Year Established',
                          style: AppTheme.mediumTitleText(lightTextColor),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'From Year',
                                  labelStyle:
                                  AppTheme.mediumTitleText(lightTextColor)
                                      .copyWith(
                                      fontWeight: FontWeight.w400),
                                  border: const OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                    const BorderSide(color: buttonColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                    const BorderSide(color: buttonColor),
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
                                decoration: InputDecoration(
                                  labelText: 'To Year',
                                  border: const OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                    const BorderSide(color: buttonColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                    const BorderSide(color: buttonColor),
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
                              Navigator.pop(context);
                              search(textController.text);
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
                            child: Text('Apply Filter',
                                style: AppTheme.mediumTitleText(lightTextColor)
                                    .copyWith(fontWeight: FontWeight.w400)),
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

  // Future<void> _loadRecentResults() async {
  //   final data = await SearchServices.fetchRecentSearches();
  //   if (data != null) {
  //     setState(() {
  //       _recentSearchLists = data;
  //     });
  //   }
  // }

    void _recentSearchNavigation(Recent product) {
      switch (product.entityType) {
        case "business":
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BusinessDetailPage(
                      buisines: BusinessInvestorExplr(
                          id: product.id,
                          imageUrl: product.imageUrl,
                          image2: product.image2,
                          image3: product.image3,
                          name: product.name,
                          city: city,
                          postedTime: product.postedTime,
                          topSelling: product.topSelling,
                          address_1: product.address_1,
                          address_2: product.address_2,
                          avg_monthly: product.avg_monthly,
                          brandName: product.brandName,
                          companyName: product.companyName,
                          description: product.description,
                          ebitda: product.ebitda,
                          employees: product.employees,
                          entity: product.entity,
                          entityType: product.entityType,
                          establish_yr: product.establish_yr,
                          evaluatingAspects: product.evaluatingAspects,
                          facility: product.facility,
                          features: product.features,
                          image4: product.image4,
                          income_source: product.income_source,
                          industry: product.industry,
                          latest_yearly: product.latest_yearly,
                          locationIntrested: product.locationIntrested,
                          locationsAvailable: product.locationsAvailable,
                          pin: product.pin,
                          rangeEnding: product.rangeEnding,
                          rangeStarting: product.rangeStarting,
                          rate: product.rate,
                          reason: product.reason,
                          state: product.state,
                          type_sale: product.type_sale,
                          singleLineDescription: '',
                          title: '',
                          url: product.url),
                      showEditOption: false)));

          break;
        case "investor":
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InvestorDetailPage(
                    showEditOption: false,
                    investor: BusinessInvestorExplr(
                        id: product.id,
                        imageUrl: product.imageUrl,
                        image2: product.image2,
                        image3: product.image3,
                        name: product.name,
                        city: city,
                        postedTime: product.postedTime,
                        topSelling: product.topSelling,
                        address_1: product.address_1,
                        address_2: product.address_2,
                        avg_monthly: product.avg_monthly,
                        brandName: product.brandName,
                        companyName: product.companyName,
                        description: product.description,
                        ebitda: product.ebitda,
                        employees: product.employees,
                        entity: product.entity,
                        entityType: product.entityType,
                        establish_yr: product.establish_yr,
                        evaluatingAspects: product.evaluatingAspects,
                        facility: product.facility,
                        features: product.features,
                        image4: product.image4,
                        income_source: product.income_source,
                        industry: product.industry,
                        latest_yearly: product.latest_yearly,
                        locationIntrested: product.locationIntrested,
                        locationsAvailable: product.locationsAvailable,
                        pin: product.pin,
                        rangeEnding: product.rangeEnding,
                        rangeStarting: product.rangeStarting,
                        rate: product.rate,
                        reason: product.reason,
                        state: product.state,
                        type_sale: product.type_sale,
                        singleLineDescription: '',
                        title: '',
                        url: product.url),
                  )));

          break;

        case "franchise":
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FranchiseDetailPage(
                    showEditOption: false,
                    franchise: FranchiseExplr(
                        title: '',
                        singleLineDescription: 'N/A',
                        imageUrl: product.imageUrl,
                        image2: product.image2,
                        image3: product.image3,
                        image4: product.image4.toString(),
                        brandName: product.brandName.toString(),
                        city: city,
                        postedTime: product.postedTime,
                        id: product.id,
                        allProducts: product.allProducts,
                        avgEBITDA: product.ebitda,
                        avgMonthlySales: product.avgMonthlySales,
                        avgNoOfStaff: product.avgNoOfStaff,
                        brandFee: product.brandFee,
                        brandStartOperation: product.brandStartOperation,
                        companyName: product.companyName,
                        currentNumberOfOutlets:
                        product.currentNumberOfOutlets,
                        description: product.description,
                        entityType: product.entityType,
                        established_year: product.establish_yr,
                        franchiseTerms: product.franchiseTerms,
                        iamOffering: product.iamOffering,
                        industry: product.industry,
                        initialInvestment: product.initialInvestment,
                        kindOfSupport: product.kindOfSupport,
                        locationsAvailable: product.locationsAvailable,
                        projectedRoi: product.projectedRoi,
                        spaceRequiredMax: product.spaceRequiredMax,
                        spaceRequiredMin: product.spaceRequiredMin,
                        state: product.state,
                        totalInvestmentFrom: product.totalInvestmentFrom,
                        totalInvestmentTo: product.totalInvestmentTo,
                        url: product.url),
                  )));
          break;
        case "advisor":
          if (product.title != null && product.imageUrl != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdvisorDetailPage(
                  advisor: AdvisorExplr(
                    title: product.title!,
                    singleLineDescription: product.singleLineDescription!,
                    imageUrl: product.imageUrl,
                    id: product.id,
                    user: product.user.toString(),
                    name: product.name,
                    location: product.location.toString(),
                    postedTime: product.postedTime,
                    brandLogo: product.brandLogo,
                    businessDocuments: product.businessDocuments,
                    businessPhotos: product.businessPhotos,
                    businessProof: product.businessProof,
                    contactNumber: product.contactNumber,
                    description: product.description,
                    designation: product.designation,
                    expertise: product.expertise,
                    interest: product.interest,
                    state: product.state,
                    type: product.type_sale,
                    url: product.url,
                  ),
                ),
              ),
            );
          } else {
            // Handle the case where the product data is incomplete
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Incomplete advisor data.')),
            );
          }
          break;
      }
    }

  Widget _buildRecentResults() {
    if (_recentSearchLists.isEmpty || hasSearched) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 300,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 0.0, right: 16, top: 16, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Search',
                  style: AppTheme.titleText(lightTextColor),
                ),
                GestureDetector(
                  onTap: () {
                    // Implement see all functionality
                  },
                  child: Text(
                    'See all',
                    style: AppTheme.titleText(buttonColor),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final item = _recentSearchLists[index];
                  return InkWell(
                    onTap: () {
                      _recentSearchNavigation(item);
                    },
                    child: Container(
                      height: double.infinity,
                      width: 210,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          gradient: gradient,
                          borderRadius: BorderRadius.circular(borderRadius),
                          image: DecorationImage(
                              image: NetworkImage(item.imageUrl),
                              fit: BoxFit.cover)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 150.w,
                            decoration: BoxDecoration(
                                color: containerColor,
                                borderRadius: BorderRadius.circular(50)),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                CustomFunctions.toSentenceCase(item.name),
                                style: AppTheme.mediumTitleText(lightTextColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: containerColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on,
                                      color: buttonColor, size: 18.h),
                                  SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      item.city,
                                      style: AppTheme.bodyMediumTitleText(
                                          lightTextColor),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
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
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    width: 10,
                  );
                },
                itemCount: _recentSearchLists.length),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const CustomAppBarWidget(
        title: "Search",

      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
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
                        if (textController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              textController.clear();
                              setState(() {
                                searchResults = [];
                                errorMessage = null;
                                hasSearched = false;
                                isLoading = false;
                                // _loadRecentResults();
                              });
                            },
                          ),
                        CircleAvatar(
                          backgroundColor: buttonColor,
                          child: IconButton(
                            icon: const Icon(Icons.search, color: Colors.white),
                            onPressed: () => search(textController.text),
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
          // Previous Searches Section
          if (recentSearches.isNotEmpty && !hasSearched) ...[
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Previous Searches',
                      style: AppTheme.titleText(lightTextColor),
                    ),
                    GestureDetector(
                      onTap: _clearRecentSearches,
                      child: Text('Clear All',
                          style: AppTheme.bodyMediumTitleText(buttonColor)
                              .copyWith(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: recentSearches
                      .map((search) => _buildStyledChip(search))
                      .toList(),
                ),
              ],
            ),
          ],

          // Recent Posts Section
          if (recentSearches.isNotEmpty && !hasSearched) _buildRecentResults(),

          const SizedBox(height: 16),
          // Popular search Section
          if (textController.text.isEmpty) const PopularSearchWidget(),
          // const SizedBox(height: 20),
          // if (textController.text.isEmpty) const SearchRecommendedWidget(),

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
                        search(textController.text);
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
              Column(
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
                                Text(CustomFunctions.toSentenceCase(result.title),
                                    style:
                                    AppTheme.mediumTitleText(lightTextColor)
                                        .copyWith(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.location_on,
                                        size: 16, color: Colors.grey[600]),
                                    const SizedBox(width: 4),
                                    Text(result.location,
                                        style: AppTheme.mediumSmallText(
                                            greyTextColor!)
                                            .copyWith(
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                    CustomFunctions.toSentenceCase(
                                        result.description),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                    AppTheme.mediumSmallText(lightTextColor)
                                        .copyWith(
                                        fontWeight: FontWeight.w400)),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: buttonColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(result.type,
                                      style: AppTheme.smallText(buttonColor)
                                          .copyWith(fontWeight: FontWeight.bold)),
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
        ],
      ),
      floatingActionButton: recentSearches.isNotEmpty
          ? Padding(
        padding:  EdgeInsets.only(bottom: 90.h),
        child: SizedBox(
          width: 220,
          height: 40,
          child: FloatingActionButton(
            onPressed: _clearRecentSearches,
            backgroundColor: const Color(0xffFFCC00),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.close, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'Clear Search History',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    textController.dispose();
    super.dispose();
  }
}
