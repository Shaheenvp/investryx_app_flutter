// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class BusinessValuationScreen extends StatefulWidget {
//   const BusinessValuationScreen({super.key});
//
//   @override
//   State<BusinessValuationScreen> createState() => _BusinessValuationScreenState();
// }
//
// class _BusinessValuationScreenState extends State<BusinessValuationScreen> {
//   static const primaryYellow = Color(0xFFFFB800);
//   static const lightYellow = Color(0xFFFFF4D9);
//
//   final _scrollController = ScrollController();
//   bool _showElevation = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);
//   }
//
//   void _onScroll() {
//     if (_scrollController.offset > 0 && !_showElevation) {
//       setState(() => _showElevation = true);
//     } else if (_scrollController.offset <= 0 && _showElevation) {
//       setState(() => _showElevation = false);
//     }
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       extendBodyBehindAppBar: true,
//       appBar: _buildAppBar(),
//       body: CustomScrollView(
//         controller: _scrollController,
//         slivers: [
//           _buildHeroSection(),
//           _buildMainContent(),
//         ],
//       ),
//     );
//   }
//
//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       elevation: _showElevation ? 1 : 0,
//       backgroundColor: Colors.white.withOpacity(_showElevation ? 1 : 0),
//       centerTitle: true,
//       title: AnimatedOpacity(
//         duration: const Duration(milliseconds: 200),
//         opacity: _showElevation ? 1 : 0,
//         child: Text(
//           'Business Valuation',
//           style: TextStyle(
//             fontSize: 16.sp,
//             fontWeight: FontWeight.w600,
//             color: Colors.grey[900],
//           ),
//         ),
//       ),
//       leading: Padding(
//         padding: EdgeInsets.only(left: 12.w),
//         child: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: CircleAvatar(
//             backgroundColor: Colors.white70,
//             child: Icon(
//               Icons.arrow_back_rounded,
//               color: Colors.grey[800],
//               size: 20.w,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeroSection() {
//     return SliverToBoxAdapter(
//       child: Stack(
//         children: [
//           Container(
//             height: 240.h,
//             decoration: BoxDecoration(
//               color: Colors.yellow[50],
//               image: DecorationImage(
//                 image: const AssetImage('assets/business_valuation.png'),
//                 fit: BoxFit.cover,
//                 colorFilter: ColorFilter.mode(
//                   Colors.black.withOpacity(0.1),
//                   BlendMode.darken,
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             height: 240.h,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Colors.transparent,
//                   Colors.grey[400]!,
//                 ],
//                 stops: const [0.7, 1.0],
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 20.h,
//             left: 16.w,
//             right: 16.w,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 12.w,
//                     vertical: 6.h,
//                   ),
//                   decoration: BoxDecoration(
//                     color: primaryYellow,
//                     borderRadius: BorderRadius.circular(20.r),
//                   ),
//                   child: Text(
//                     'Valuation Calculator',
//                     style: TextStyle(
//                       fontSize: 12.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 12.h),
//                 Text(
//                   'Calculate Your\nBusiness Worth',
//                   style: TextStyle(
//                     fontSize: 27.sp,
//                     fontWeight: FontWeight.w800,
//                     color: Colors.white
//                     ,
//                     height: 1.2,
//                     // letterSpacing: -0.5,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMainContent() {
//     return SliverPadding(
//       padding: EdgeInsets.all(16.w),
//       sliver: SliverList(
//         delegate: SliverChildListDelegate([
//           _buildInfoCard(),
//           SizedBox(height: 20.h),
//           _buildValuationForm(),
//           SizedBox(height: 20.h),
//         ]),
//       ),
//     );
//   }
//
//   Widget _buildInfoCard() {
//     return Container(
//       padding: EdgeInsets.all(20.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(10.w),
//                 decoration: BoxDecoration(
//                   color: lightYellow,
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//                 child: Icon(
//                   Icons.insights_rounded,
//                   color: primaryYellow,
//                   size: 20.w,
//                 ),
//               ),
//               SizedBox(width: 12.w),
//               Text(
//                 'Valuation Methods',
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.grey[900],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 16.h),
//           _buildMethodItem(
//             'DCF Analysis',
//             'Future value calculation using discounted cash flows',
//             Icons.timeline_rounded,
//           ),
//           _buildMethodItem(
//             'Market Comparables',
//             'Compare with similar market businesses',
//             Icons.compare_arrows_rounded,
//           ),
//           _buildMethodItem(
//             'Asset Based',
//             'Total assets minus total liabilities',
//             Icons.account_balance_rounded,
//             isLast: true,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMethodItem(
//       String title,
//       String description,
//       IconData icon,
//       {bool isLast = false}
//       ) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: EdgeInsets.all(8.w),
//             decoration: BoxDecoration(
//               color: Colors.grey[50],
//               borderRadius: BorderRadius.circular(10.r),
//             ),
//             child: Icon(
//               icon,
//               color: primaryYellow,
//               size: 16.w,
//             ),
//           ),
//           SizedBox(width: 12.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//                 SizedBox(height: 4.h),
//                 Text(
//                   description,
//                   style: TextStyle(
//                     fontSize: 12.sp,
//                     color: Colors.grey[600],
//                     height: 1.4,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildValuationForm() {
//     return Container(
//       padding: EdgeInsets.all(20.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(10.w),
//                 decoration: BoxDecoration(
//                   color: lightYellow,
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//                 child: Icon(
//                   Icons.calculate_rounded,
//                   color: primaryYellow,
//                   size: 20.w,
//                 ),
//               ),
//               SizedBox(width: 12.w),
//               Text(
//                 'Enter Details',
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.grey[900],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 20.h),
//           _buildInputField(
//             'Country',
//             'Select your country',
//             Icons.public_rounded,
//           ),
//           SizedBox(height: 16.h),
//           _buildInputField(
//             'Industry',
//             'Select your industry',
//             Icons.category_rounded,
//           ),
//           SizedBox(height: 16.h),
//           _buildInputField(
//             'Annual Revenue',
//             'Enter annual revenue',
//             Icons.attach_money_rounded,
//           ),
//           SizedBox(height: 16.h),
//           _buildInputField(
//             'EBITDA Margin',
//             'Enter EBITDA margin',
//             Icons.trending_up_rounded,
//           ),
//           SizedBox(height: 24.h),
//           _buildCalculateButton(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInputField(String label, String hint, IconData icon) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12.sp,
//             fontWeight: FontWeight.w600,
//             color: Colors.grey[700],
//           ),
//         ),
//         SizedBox(height: 8.h),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.grey[50],
//             borderRadius: BorderRadius.circular(12.r),
//             border: Border.all(color: Colors.grey[200]!),
//           ),
//           child: TextField(
//             decoration: InputDecoration(
//               hintText: hint,
//               hintStyle: TextStyle(
//                 fontSize: 13.sp,
//                 color: Colors.grey[400],
//               ),
//               prefixIcon: Icon(
//                 icon,
//                 color: Colors.grey[400],
//                 size: 20.w,
//               ),
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.symmetric(
//                 horizontal: 16.w,
//                 vertical: 12.h,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCalculateButton() {
//     return Container(
//       width: double.infinity,
//       height: 52.h,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             primaryYellow,
//             primaryYellow.withOpacity(0.8),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(12.r),
//         boxShadow: [
//           BoxShadow(
//             color: primaryYellow.withOpacity(0.3),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () {},
//           borderRadius: BorderRadius.circular(12.r),
//           child: Center(
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Calculate Worth',
//                   style: TextStyle(
//                     fontSize: 15.sp,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(width: 8.w),
//                 Icon(
//                   Icons.arrow_forward_rounded,
//                   color: Colors.white,
//                   size: 18.w,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class BusinessValuationScreen extends StatefulWidget {
  const BusinessValuationScreen({super.key});

  @override
  State<BusinessValuationScreen> createState() =>
      _BusinessValuationScreenState();
}

class _BusinessValuationScreenState extends State<BusinessValuationScreen> {
  static const primaryYellow = Color(0xFFFFB800);
  static const lightYellow = Color(0xFFFFF4D9);

  final _scrollController = ScrollController();
  bool _showElevation = false;

  // Business Valuation Logic
  final TextEditingController revenueController = TextEditingController();
  final TextEditingController ebitdaController = TextEditingController();
  final TextEditingController netIncomeController = TextEditingController();
  final TextEditingController enterpriseValueController =
  TextEditingController();
  final TextEditingController multipleMetricController =
  TextEditingController();

  double businessValue = 0.0;
  String selectedCriteria = 'Low Profitability';
  String selectedMetric = 'Revenue';
  String selectedMultipleMetric = 'EBITDA';
  double multiple = 0.0;

  final NumberFormat currencyFormat =
  NumberFormat.currency(locale: 'en_IN', symbol: '₹');

  Map<String, String> criteriaDescriptions = {
    'Low Profitability': 'Revenue-based valuation for early-stage businesses',
    'Normal': 'EBITDA-based valuation for established businesses',
    'Profitability Based': 'Net Income-based valuation for mature businesses',
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 0 && !_showElevation) {
      setState(() => _showElevation = true);
    } else if (_scrollController.offset <= 0 && _showElevation) {
      setState(() => _showElevation = false);
    }
  }

  void updateMetric() {
    switch (selectedCriteria) {
      case 'Low Profitability':
        selectedMetric = 'Revenue';
        break;
      case 'Profitability Based':
        selectedMetric = 'Net Income';
        break;
      case 'Normal':
        selectedMetric = 'EBITDA';
        break;
    }
    setState(() {});
  }

  void calculateBusinessValue() {
    double metricValue = 0.0;
    double enterpriseValue =
        double.tryParse(enterpriseValueController.text) ?? 0.0;
    double multipleMetricValue =
        double.tryParse(multipleMetricController.text) ?? 0.0;

    multiple =
        enterpriseValue / (multipleMetricValue != 0 ? multipleMetricValue : 1);

    switch (selectedMetric) {
      case 'Revenue':
        metricValue = double.tryParse(revenueController.text) ?? 0.0;
        break;
      case 'EBITDA':
        metricValue = double.tryParse(ebitdaController.text) ?? 0.0;
        break;
      case 'Net Income':
        metricValue = double.tryParse(netIncomeController.text) ?? 0.0;
        break;
    }

    setState(() {
      businessValue = metricValue * multiple;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    revenueController.dispose();
    ebitdaController.dispose();
    netIncomeController.dispose();
    enterpriseValueController.dispose();
    multipleMetricController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildHeroSection(),
          _buildMainContent(),
        ],
      ),
    );
  }

  // Keeping existing UI methods unchanged...
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: _showElevation ? 1 : 0,
      backgroundColor: Colors.white.withOpacity(_showElevation ? 1 : 0),
      centerTitle: true,
      title: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: _showElevation ? 1 : 0,
        child: Text(
          'Business Valuation',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[900],
          ),
        ),
      ),
      leading: Padding(
        padding: EdgeInsets.only(left: 12.w),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CircleAvatar(
            backgroundColor: Colors.white70,
            child: Icon(
              Icons.arrow_back_rounded,
              color: Colors.grey[800],
              size: 20.w,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          Container(
            height: 240.h,
            decoration: BoxDecoration(
              color: Colors.yellow[50],
              image: DecorationImage(
                image: const AssetImage('assets/business_valuation.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.1),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          Container(
            height: 240.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.grey[400]!,
                ],
                stops: const [0.7, 1.0],
              ),
            ),
          ),
          Positioned(
            bottom: 20.h,
            left: 16.w,
            right: 16.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: primaryYellow,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Valuation Calculator',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Calculate Your\nBusiness Worth',
                  style: TextStyle(
                    fontSize: 27.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SliverPadding(
      padding: EdgeInsets.all(16.w),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          _buildInfoCard(),
          SizedBox(height: 20.h),
          _buildValuationForm(),
          SizedBox(height: 20.h),
          if (businessValue > 0)
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Valuation Results',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[900],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Estimated Business Value: ${currencyFormat.format(businessValue)}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: primaryYellow,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Calculated Multiple: ${multiple.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Using ${selectedMetric} Valuation Method',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
        ]),
      ),
    );
  }

  Widget _buildValuationForm() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: lightYellow,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.calculate_rounded,
                  color: primaryYellow,
                  size: 20.w,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Enter Details',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[900],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _buildDropdownField(
            'Valuation Criteria',
            selectedCriteria,
            ['Low Profitability', 'Profitability Based', 'Normal'],
                (String? value) {
              if (value != null) {
                setState(() {
                  selectedCriteria = value;
                  updateMetric();
                });
              }
            },
          ),
          SizedBox(height: 8.h),
          // Criteria description
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: lightYellow.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16.w,
                  color: primaryYellow,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    criteriaDescriptions[selectedCriteria] ?? '',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Financial Metrics Section
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Financial Metrics',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Based on your criteria, you need to provide:',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 12.h),

                // Revenue Field with indicator
                _buildInputFieldWithStatus(
                  'Revenue',
                  'Enter annual revenue',
                  Icons.attach_money_rounded,
                  revenueController,
                  enabled: selectedMetric == 'Revenue',
                  isRequired: selectedMetric == 'Revenue',
                ),
                SizedBox(height: 16.h),

                // EBITDA Field with indicator
                _buildInputFieldWithStatus(
                  'EBITDA',
                  'Enter EBITDA',
                  Icons.trending_up_rounded,
                  ebitdaController,
                  enabled: selectedMetric == 'EBITDA',
                  isRequired: selectedMetric == 'EBITDA',
                ),
                SizedBox(height: 16.h),

                // Net Income Field with indicator
                _buildInputFieldWithStatus(
                  'Net Income',
                  'Enter net income',
                  Icons.account_balance_wallet_rounded,
                  netIncomeController,
                  enabled: selectedMetric == 'Net Income',
                  isRequired: selectedMetric == 'Net Income',
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // Multiple Calculation Section
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Multiple Calculation',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Define industry multiple based on comparable data',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 12.h),
                _buildInputField(
                  'Enterprise Value',
                  'Enter enterprise value',
                  Icons.business_rounded,
                  enterpriseValueController,
                ),
                SizedBox(height: 16.h),
                _buildDropdownField(
                  'Multiple Metric',
                  selectedMultipleMetric,
                  ['Revenue', 'EBITDA'],
                      (String? value) {
                    if (value != null) {
                      setState(() {
                        selectedMultipleMetric = value;
                      });
                    }
                  },
                ),
                SizedBox(height: 16.h),
                _buildInputField(
                  selectedMultipleMetric,
                  'Enter ${selectedMultipleMetric.toLowerCase()} value',
                  Icons.analytics_rounded,
                  multipleMetricController,
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),
          _buildCalculateButton(),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
      String label,
      String value,
      List<String> items,
      void Function(String?) onChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
            ),
            items: items.map((String item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey[800],
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildInputFieldWithStatus(
      String label,
      String hint,
      IconData icon,
      TextEditingController controller, {
        bool enabled = true,
        bool isRequired = false,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: isRequired ? primaryYellow : Colors.grey[300],
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                isRequired ? 'Required' : 'Optional',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: isRequired ? Colors.white : Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: enabled ? Colors.white : Colors.grey[100],
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isRequired && enabled
                      ? primaryYellow.withOpacity(0.5)
                      : Colors.grey[200]!,
                ),
              ),
              child: TextField(
                controller: controller,
                enabled: enabled,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey[400],
                  ),
                  prefixIcon: Icon(
                    icon,
                    color: enabled ? primaryYellow : Colors.grey[400],
                    size: 20.w,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
              ),
            ),
            if (!enabled)
              Positioned(
                right: 12.w,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lock_outline,
                          size: 12.w,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Not applicable',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputField(
      String label,
      String hint,
      IconData icon,
      TextEditingController controller, {
        bool enabled = true,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: enabled ? Colors.grey[50] : Colors.grey[100],
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey[400],
              ),
              prefixIcon: Icon(
                icon,
                color: Colors.grey[400],
                size: 20.w,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalculateButton() {
    return Container(
      width: double.infinity,
      height: 52.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryYellow,
            primaryYellow.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: primaryYellow.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: calculateBusinessValue,
          borderRadius: BorderRadius.circular(12.r),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Calculate Worth',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 18.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: lightYellow,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.insights_rounded,
                  color: primaryYellow,
                  size: 20.w,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Valuation Methods',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[900],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildMethodItem(
            'Revenue Multiple',
            'Used for low profitability businesses',
            Icons.timeline_rounded,
          ),
          _buildMethodItem(
            'EBITDA Multiple',
            'Standard method for profitable businesses',
            Icons.compare_arrows_rounded,
          ),
          _buildMethodItem(
            'Net Income Multiple',
            'Based on bottom-line profitability',
            Icons.account_balance_rounded,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMethodItem(
      String title,
      String description,
      IconData icon, {
        bool isLast = false,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              color: primaryYellow,
              size: 16.w,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}