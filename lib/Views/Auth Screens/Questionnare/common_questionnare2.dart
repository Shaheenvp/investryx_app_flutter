import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/generated/constants.dart';

import '../../../Widgets/state_and_cities_widget.dart';
import 'comon_questionnare3.dart';

class CommonQuestionnareScreen2 extends StatefulWidget {
  final String city;
  final String state;
  final String businessStage;
  final String businessGoal;
  final String operationDuration;
  final String budget;
  final String industry;
  final String? type;
  final String? investmentInterest;
  final String? investmentHorizon;
  final String? riskTolerance;
  final String? priorExperience;
  final String? buyOrStart;
  final String? franchiseTypes;
  final String? brands;
  final String? expertise;
  final String? clientType;
  final String? experience;
  final String? advisoryDuration;

  const CommonQuestionnareScreen2({
    super.key,
    required this.city,
    required this.state,
    required this.businessStage,
    required this.businessGoal,
    required this.operationDuration,
    required this.budget,
    required this.industry,
    this.type,
    this.investmentInterest,
    this.investmentHorizon,
    this.riskTolerance,
    this.priorExperience,
    this.buyOrStart,
    this.franchiseTypes,
    this.brands,
    this.expertise,
    this.clientType,
    this.experience,
    this.advisoryDuration,
  });

  @override
  State<CommonQuestionnareScreen2> createState() =>
      _CommonQuestionnareScreen2State();
}

class _CommonQuestionnareScreen2State extends State<CommonQuestionnareScreen2> {
  final Color customYellow = buttonColor;
  List<String> selectedStates = [];
  Map<String, List<String>> selectedCities = {};
  bool isAllIndiaSelected = false;
  final TextEditingController _stateSearchController = TextEditingController();
  final TextEditingController _citySearchController = TextEditingController();
  final FocusNode _stateFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  List<String> allIndiaStates = [];
  List<String> allIndiaCities = [];


  @override
  void initState() {
    super.initState();
    allIndiaStates = IndianLocations.getStates();
    for (var state in allIndiaStates) {
      allIndiaCities.addAll(IndianLocations.getCitiesForState(state));
    }
  }

  @override
  void dispose() {
    _stateSearchController.dispose();
    _citySearchController.dispose();
    _stateFocusNode.dispose();
    _cityFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          automaticallyImplyLeading: false,
          leadingWidth: 80.w,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
              child: Text(
                'Back',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
              child: Row(
                children: [
                  Text('07/', style: AppTheme.titleText(lightTextColor)),
                  Text('08',
                      style: AppTheme.bodyMediumTitleText(greyTextColor!)),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Progress Bar
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: LinearProgressIndicator(
                value: 0.90,
                minHeight: 8.h,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(customYellow),
              ),
            ),
          ),

          // Title Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What are your preferred locations?',
                  style: AppTheme.headingText(lightTextColor),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Select states and cities where you plan to operate',
                  style: AppTheme.bodyMediumTitleText(greyTextColor!),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // All India Selection
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: CheckboxListTile(
                      title: Text(
                        'Select All India',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      value: isAllIndiaSelected,
                      onChanged: (value) {
                        setState(() {
                          isAllIndiaSelected = value ?? false;
                          if (isAllIndiaSelected) {
                            selectedStates = List.from(allIndiaStates);
                            // Use pre-fetched cities
                            for (var state in selectedStates) {
                              selectedCities[state] = IndianLocations.getCitiesForState(state);
                            }
                          } else {
                            selectedStates.clear();
                            selectedCities.clear();
                          }
                        });
                      },
                      activeColor: customYellow,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                    ),
                  ),
                  // State Selection
                  if (!isAllIndiaSelected) ...[
                    Text(
                      'Select States',
                      style: AppTheme.titleText(lightTextColor!)
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: () {
                        _showStateSelectionDialog();
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: selectedStates.isEmpty
                                  ? Text(
                                      'Select states',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Colors.grey[600],
                                      ),
                                    )
                                  : Wrap(
                                      spacing: 8.w,
                                      runSpacing: 8.h,
                                      children: selectedStates.map((state) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                customYellow.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(4.r),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                state,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              SizedBox(width: 4.w),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedStates
                                                        .remove(state);
                                                    selectedCities
                                                        .remove(state);
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.close,
                                                  size: 16.sp,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  SizedBox(height: 24.h),

                  // City Selection
                  if (selectedStates.isNotEmpty) ...[
                    ...selectedStates.map((state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  state,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              // Quick select all cities checkbox
                              Row(
                                children: [
                                  Checkbox(
                                    value: selectedCities[state]?.length ==
                                        IndianLocations.getCitiesForState(state)
                                            .length,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value ?? false) {
                                          selectedCities[state] =
                                              IndianLocations.getCitiesForState(
                                                  state);
                                        } else {
                                          selectedCities[state]?.clear();
                                        }
                                      });
                                    },
                                    activeColor: customYellow,
                                  ),
                                  Text(
                                    'Select All Cities',
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          GestureDetector(
                            onTap: () {
                              _showCitySelectionDialog(state);
                            },
                            child: Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: selectedCities[state]?.isEmpty ??
                                            true
                                        ? Text(
                                            'Select cities in $state',
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              color: Colors.grey[600],
                                            ),
                                          )
                                        : Wrap(
                                            spacing: 8.w,
                                            runSpacing: 8.h,
                                            children:
                                                (selectedCities[state] ?? [])
                                                    .map((city) {
                                              return Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 4.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: customYellow
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.r),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      city,
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    SizedBox(width: 4.w),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedCities[state]
                                                              ?.remove(city);
                                                        });
                                                      },
                                                      child: Icon(
                                                        Icons.close,
                                                        size: 16.sp,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey[600],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                        ],
                      );
                    }).toList(),
                  ],
                ],
              ),
            ),
          ),

          // Continue Button
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: (selectedStates.isNotEmpty &&
                              selectedCities.values
                                  .any((cities) => cities.isNotEmpty)) ||
                          isAllIndiaSelected
                      ? () {

                          List<String> allSelectedCities = [];
                          selectedCities.forEach((state, cities) {
                            allSelectedCities.addAll(cities);
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommonQuestionnaireScreen3(
                                city: widget.city,
                                state: widget.state,
                                businessStage: widget.businessStage,
                                businessGoal: widget.businessGoal,
                                operationDuration: widget.operationDuration,
                                budget: widget.budget,
                                industry: widget.industry,
                                selectedStates: selectedStates,
                                selectedCities: allSelectedCities,
                                type: widget.type,
                                investmentInterest: widget.investmentInterest,
                                investmentHorizon: widget.investmentHorizon,
                                riskTolerance: widget.riskTolerance,
                                priorExperience: widget.priorExperience,
                                brands: widget.brands,
                                buyOrStart: widget.buyOrStart,
                                franchiseTypes: widget.franchiseTypes,
                                advisoryDuration: widget.advisoryDuration,
                                clientType: widget.clientType,
                                experience: widget.experience,
                                expertise: widget.expertise,
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customYellow,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showStateSelectionDialog() {
    final TextEditingController searchController = TextEditingController();
    List<String> filteredStates = allIndiaStates; // Use pre-fetched states
    List<String> tempSelectedStates = List.from(selectedStates);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: BoxConstraints(maxHeight: 600.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Select States',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  searchController.clear();
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(Icons.close, color: Colors.grey[600]),
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                hintText: 'Search states...',
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 15.sp,
                                ),
                                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                              ),
                              onChanged: (value) {
                                setDialogState(() {
                                  filteredStates = allIndiaStates
                                      .where((state) => state
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                      .toList();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // States List
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        itemCount: filteredStates.length,
                        itemBuilder: (context, index) {
                          final state = filteredStates[index];
                          return Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey[200]!,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: CheckboxListTile(
                              title: Text(
                                state,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              value: tempSelectedStates.contains(state),
                              activeColor: customYellow,
                              checkColor: Colors.white,
                              onChanged: (bool? value) {
                                setDialogState(() {
                                  if (value ?? false) {
                                    if (!tempSelectedStates.contains(state)) {
                                      tempSelectedStates.add(state);
                                    }
                                  } else {
                                    tempSelectedStates.remove(state);
                                  }
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              dense: true,
                            ),
                          );
                        },
                      ),
                    ),

                    // Action Buttons
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                searchController.clear();
                                Navigator.of(context).pop();
                              },
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                side: BorderSide(color: Colors.grey[300]!),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedStates = List.from(tempSelectedStates);
                                  // Optimize city list initialization
                                  selectedCities.clear();
                                  for (var state in selectedStates) {
                                    selectedCities[state] = [];
                                  }
                                });
                                searchController.clear();
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: customYellow,
                                elevation: 0,
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: Text(
                                'Done',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
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
          },
        );
      },
    );
  }

  void _showCitySelectionDialog(String state) {
    final TextEditingController searchController = TextEditingController();
    List<String> filteredCities = IndianLocations.getCitiesForState(state);
    List<String> tempSelectedCities = List.from(selectedCities[state] ?? []);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: BoxConstraints(maxHeight: 600.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          topRight: Radius.circular(16.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Select Cities in $state',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  searchController.clear();
                                  Navigator.of(context).pop();
                                },
                                icon:
                                    Icon(Icons.close, color: Colors.grey[600]),
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: 'Search cities...',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 15.sp,
                              ),
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.grey[400]),
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                            ),
                            onChanged: (value) {
                              setDialogState(() {
                                filteredCities =
                                    IndianLocations.getCitiesForState(state)
                                        .where((city) => city
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                        .toList();
                              });
                            },
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  setDialogState(() {
                                    tempSelectedCities.clear();
                                  });
                                },
                                child: Text(
                                  'Clear All',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              TextButton(
                                onPressed: () {
                                  setDialogState(() {
                                    tempSelectedCities =
                                        List.from(filteredCities);
                                  });
                                },
                                child: Text(
                                  'Select All',
                                  style: TextStyle(
                                    color: customYellow,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Cities List
                    Flexible(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        shrinkWrap: true,
                        itemCount: filteredCities.length,
                        itemBuilder: (context, index) {
                          final city = filteredCities[index];
                          return Theme(
                            data: Theme.of(context).copyWith(
                              checkboxTheme: CheckboxThemeData(
                                fillColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return customYellow;
                                  }
                                  return Colors.transparent;
                                }),
                              ),
                            ),
                            child: CheckboxListTile(
                              title: Text(
                                city,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.black87,
                                ),
                              ),
                              value: tempSelectedCities.contains(city),
                              activeColor: customYellow,
                              checkColor: Colors.black,
                              onChanged: (bool? value) {
                                setDialogState(() {
                                  if (value ?? false) {
                                    if (!tempSelectedCities.contains(city)) {
                                      tempSelectedCities.add(city);
                                    }
                                  } else {
                                    tempSelectedCities.remove(city);
                                  }
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              dense: true,
                            ),
                          );
                        },
                      ),
                    ),

                    // Actions
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16.r),
                          bottomRight: Radius.circular(16.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                searchController.clear();
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedCities[state] =
                                      List.from(tempSelectedCities);
                                });
                                searchController.clear();
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: customYellow,
                                elevation: 0,
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: Text(
                                'Done',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
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
          },
        );
      },
    );
  }
}
