

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../Widgets/razorpay widget.dart';
import '../services/check subscribe.dart';
import '../services/pricings.dart';

class PricingScreenNew extends StatefulWidget {
  @override
  _PricingScreenNewState createState() => _PricingScreenNewState();
}

class _PricingScreenNewState extends State<PricingScreenNew> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  String _selectedPlan = 'Advisor';
  List<Map<String, dynamic>> _allPlans = [];
  List<Map<String, dynamic>> _filteredPlans = [];
  bool _isLoading = true;
  Map<String, bool> _subscriptionStatus = {
    'Advisor': false,
    'Business': false,
    'Investment': false,
    'Franchise': false,
  };
  Map<String, int?> _subscribedPlanIds = {
    'Advisor': null,
    'Business': null,
    'Investment': null,
    'Franchise': null,
  };
  late Razorpay _razorpay;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final Map<String, String> _planTypeMap = {
    'Advisor': 'advisor',
    'Business': 'business',
    'Investment': 'investor',
    'Franchise': 'franchise'
  };

  @override
  void initState() {
    super.initState();
    _initializeRazorpay();
    _initializeAnimations();
    _initializeSubscriptionStatus();
    _fetchAllPlans();
  }

  Future<void> _initializeSubscriptionStatus() async {
    setState(() => _isLoading = true);

    // Check subscription status for all plan types
    for (String planType in _planTypeMap.keys) {
      await _checkSubscriptionStatus(planType);
    }

    setState(() => _isLoading = false);
  }

  Future<void> _checkSubscriptionStatus(String planType) async {
    try {
      final subscriptionStatus = await CheckSubscription.checkfetchSubscription(_planTypeMap[planType] ?? 'advisor');

      if (mounted) {
        setState(() {
          _subscriptionStatus[planType] = subscriptionStatus['status'] ?? false;
          if (subscriptionStatus['id'] != null) {
            _subscribedPlanIds[planType] = int.tryParse(subscriptionStatus['id'].toString());
          } else {
            _subscribedPlanIds[planType] = null;
          }
        });
      }
    } catch (e) {
      print('Error checking subscription status for $planType: $e');
      if (mounted) {
        setState(() {
          _subscriptionStatus[planType] = false;
          _subscribedPlanIds[planType] = null;
        });
      }
    }
  }

  void _handleSubscription(Map<String, dynamic> plan) {
    final String userEmail = "user@example.com";  // Replace with actual user email
    final String userId = "user123";  // Replace with actual user ID

    int amount;
    try {
      amount = NumberFormatter.parseAmount(plan['rate'].toString());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid amount format')),
      );
      return;
    }

    final String planId = plan['id']?.toString() ?? '';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PayMoney(
          amount: amount,
          name: plan['name'] ?? 'Subscription Plan',
          description: '${_selectedPlan} - ${plan['name']} Plan',
          email: userEmail,
          id: planId,
        ),
      ),
    ).then((result) async {
      if (result != null && result is Map<String, dynamic>) {
        if (result['success'] == true) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Subscription updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Refresh subscription status
          await _checkSubscriptionStatus(_selectedPlan);

          // Refresh plans
          await _fetchAllPlans();
        }
      }
    });
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> _fetchAllPlans() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String planType = _planTypeMap[_selectedPlan] ?? 'advisor';
      var plans = await PlansGet.fetchPlans(planType);

      if (mounted) {
        setState(() {
          if (plans != null) {
            _filteredPlans = List<Map<String, dynamic>>.from(plans);
          } else {
            _filteredPlans = [];
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching plans: $e');
      if (mounted) {
        setState(() {
          _filteredPlans = [];
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred while loading plans.')),
        );
      }
    }
  }

  Future<void> _onPlanTypeChanged(String newPlanType) async {
    setState(() {
      _selectedPlan = newPlanType;
      _isLoading = true;
      _currentIndex = 0;
    });

    await _fetchAllPlans();
  }

  Future<void> _filterPlans() async {
    String selectedType = _planTypeMap[_selectedPlan] ?? 'advisor';
    print('Filtering plans for type: $selectedType'); // Debug log

    try {
      // Fetch new plans when type changes
      var plans = await PlansGet.fetchPlans(selectedType);
      print('Received filtered plans: $plans'); // Debug log

      if (plans != null) {
        setState(() {
          _filteredPlans = List<Map<String, dynamic>>.from(plans);
          _currentIndex = 0;
        });
      } else {
        setState(() {
          _filteredPlans = [];
        });
      }
    } catch (e) {
      print('Error filtering plans: $e');
      setState(() {
        _filteredPlans = [];
      });
    }
  }


  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Successful: ${response.paymentId}')),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Failed: ${response.message}')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External Wallet Selected: ${response.walletName}')),
    );
  }


  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildPlanTypeSelector(),
            _buildPlansList(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leadingWidth: 64.w,
      leading: Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xff323232), size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: Text(
        'Subscription Plans',
        style: TextStyle(
          color: Color(0xff1E293B),
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      // actions: [
      //   Padding(
      //     padding: EdgeInsets.only(right: 16.w),
      //     child: Container(
      //       width: 44.w,
      //       decoration: BoxDecoration(
      //         color: Color(0xFFF3F8FE),
      //         borderRadius: BorderRadius.circular(12.r),
      //       ),
      //       child: IconButton(
      //         icon: Icon(Icons.help_outline, color: Color(0xff323232), size: 20.sp),
      //         onPressed: () {},
      //       ),
      //     ),
      //   ),
      // ],
    );
  }


  Widget _buildPricingShimmer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Plan Header
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
              child: Column(
                children: [
                  // Plan title
                  Container(
                    width: 120.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Plan subtitle
                  Container(
                    width: 160.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Pricing Container
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    // Price
                    Container(
                      width: 120.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // Per month text
                    Container(
                      width: 80.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // Features section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // What's included text
                  Container(
                    width: 120.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Feature items
                  ...List.generate(4, (index) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Row(
                      children: [
                        // Checkbox
                        Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        // Feature text
                        Expanded(
                          child: Container(
                            height: 16.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            Spacer(),

            // Subscribe button
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Container(
                height: 48.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildPlanTypeSelector() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: _planTypeMap.keys.map((type) {
          bool isSelected = type == _selectedPlan;
          return Expanded(
            child: GestureDetector(
              onTap: () => _onPlanTypeChanged(type),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFFFFCC00) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  type,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Color(0xFF64748B),
                    fontSize: 14.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPlansList() {
    if (_isLoading) {
      return Expanded(
        child: Center(
            child: _buildPricingShimmer()
        ),
      );
    }

    if (_filteredPlans.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 48.sp,
                color: Color(0xFF94A3B8),
              ),
              SizedBox(height: 16.h),
              Text(
                'No plans available',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: PageView.builder(
        controller: PageController(
          initialPage: _currentIndex,
          viewportFraction: 0.9,
        ),
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: _filteredPlans.length,
        itemBuilder: (context, index) {
          final plan = _filteredPlans[index];
          final planId = int.tryParse(plan['id']?.toString() ?? '');
          final bool isPlanSubscribed =
              _subscriptionStatus[_selectedPlan] == true &&
                  planId != null &&
                  _subscribedPlanIds[_selectedPlan] != null &&
                  planId == _subscribedPlanIds[_selectedPlan];

          return EnhancedPlanCard(
            title: _selectedPlan,
            plan: plan['name']?.toString() ?? 'Unknown Plan',
            price: '₹${plan['rate']?.toString() ?? '0'}',
            recommended: plan['recommend'] ?? false,
            features: (plan['description'] as Map<String, dynamic>?)
                ?.values
                ?.map((e) => e.toString())
                ?.toList() ??
                [],
            isSubscribed: isPlanSubscribed,
            onSubscribe: () {
              if (!isPlanSubscribed) {
                _handleSubscription(plan);
              }
            },
          );
        },
      ),
    );
  }
    }

class EnhancedPlanCard extends StatefulWidget {
  final String title;
  final String plan;
  final String price;
  final bool recommended;
  final List<String> features;
  final VoidCallback onSubscribe;
  final bool isSubscribed;


  const EnhancedPlanCard({
    required this.title,
    required this.plan,
    required this.price,
    required this.features,
    required this.recommended,
    required this.onSubscribe,
    this.isSubscribed = false,

  });

  @override
  State<EnhancedPlanCard> createState() => _EnhancedPlanCardState();
}

class _EnhancedPlanCardState extends State<EnhancedPlanCard> {
  bool isExpanded = false;
  static const int initialFeatureCount = 4;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: widget.recommended ? Color(0xFFFFCC00) : Color(0xFFE2E8F0),
          width: widget.recommended ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          if (widget.recommended) _buildRecommendedBadge(),
          Expanded(
            child: Column(
              children: [
                // Fixed content section
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildPlanHeader(),
                      SizedBox(height: 24.h),
                      _buildPricing(),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
                // Scrollable features section
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFeaturesList(),
                        if (widget.features.length > initialFeatureCount)
                          _buildExpandButton(),
                        SizedBox(height: 20.h), // Space for the button
                      ],
                    ),
                  ),
                ),
                // Fixed bottom section with button
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: _buildSubscribeButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedBadge() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Color(0xFFFFCC00),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14.r),
          topRight: Radius.circular(14.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star_rounded,
            color: Colors.white,
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            'RECOMMENDED PLAN',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanHeader() {
    return Column(
      children: [
        Text(
          widget.plan,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
            height: 1.2,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Best for ${widget.title.toLowerCase()} users',
          style: TextStyle(
            fontSize: 14.sp,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildPricing() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '₹',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                widget.price.substring(1),
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'per month',
            style: TextStyle(
              fontSize: 14.sp,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    final displayFeatures = isExpanded
        ? widget.features
        : widget.features.take(initialFeatureCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What\'s included:',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        SizedBox(height: 16.h),
        ...displayFeatures.map((feature) =>
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 4.h),
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      color: widget.recommended ? Color(0xFFFFCC00) : Color(
                          0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 12.sp,
                      color: widget.recommended ? Colors.white : Color(
                          0xFF1E293B),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      feature,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Color(0xFF475569),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
      ],
    );
  }

  Widget _buildExpandButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isExpanded ? 'Show Less' : 'Show All Features',
            style: TextStyle(
              color: Color(0xFFFFCC00),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 4.w),
          Icon(
            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Color(0xFFFFCC00),
            size: 18.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildSubscribeButton() {
    if (widget.isSubscribed) {
      return Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Subscribed',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: widget.recommended ? Color(0xFFFFCC00) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: widget.recommended
            ? null
            : Border.all(color: Color(0xFFFFCC00)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isSubscribed ? null : widget.onSubscribe,
          borderRadius: BorderRadius.circular(12.r),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Subscribe Now',
                  style: TextStyle(
                    color: widget.recommended ? Colors.white : Color(0xFFFFCC00),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: widget.recommended ? Colors.white : Color(0xFFFFCC00),
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NumberFormatter {
  static int parseAmount(String amount) {
    String cleanAmount = amount.replaceAll('₹', '')
        .replaceAll(',', '')
        .replaceAll(' ', '');
    return int.parse(cleanAmount);
  }
}