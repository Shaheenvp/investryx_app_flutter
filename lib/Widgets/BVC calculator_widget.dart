import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BusinessValuationScreen extends StatefulWidget {
  const BusinessValuationScreen({super.key});

  @override
  State<BusinessValuationScreen> createState() => _BusinessValuationScreenState();
}

class _BusinessValuationScreenState extends State<BusinessValuationScreen> {
  static const primaryYellow = Color(0xFFFFB800);
  static const lightYellow = Color(0xFFFFF4D9);

  final _scrollController = ScrollController();
  bool _showElevation = false;

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

  @override
  void dispose() {
    _scrollController.dispose();
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
                    color: Colors.white
                    ,
                    height: 1.2,
                    // letterSpacing: -0.5,
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
        ]),
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
            'DCF Analysis',
            'Future value calculation using discounted cash flows',
            Icons.timeline_rounded,
          ),
          _buildMethodItem(
            'Market Comparables',
            'Compare with similar market businesses',
            Icons.compare_arrows_rounded,
          ),
          _buildMethodItem(
            'Asset Based',
            'Total assets minus total liabilities',
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
      IconData icon,
      {bool isLast = false}
      ) {
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
          _buildInputField(
            'Country',
            'Select your country',
            Icons.public_rounded,
          ),
          SizedBox(height: 16.h),
          _buildInputField(
            'Industry',
            'Select your industry',
            Icons.category_rounded,
          ),
          SizedBox(height: 16.h),
          _buildInputField(
            'Annual Revenue',
            'Enter annual revenue',
            Icons.attach_money_rounded,
          ),
          SizedBox(height: 16.h),
          _buildInputField(
            'EBITDA Margin',
            'Enter EBITDA margin',
            Icons.trending_up_rounded,
          ),
          SizedBox(height: 24.h),
          _buildCalculateButton(),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String hint, IconData icon) {
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
          child: TextField(
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
          onTap: () {},
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
}