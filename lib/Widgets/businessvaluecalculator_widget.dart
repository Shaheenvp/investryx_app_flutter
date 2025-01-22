// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:project_emergio/Widgets/BVC%20calculator_widget.dart';
// import 'package:project_emergio/generated/constants.dart';
//
// class BusinessValuationPromoCard extends StatelessWidget {
//   const BusinessValuationPromoCard({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//         color: Colors.white,
//         elevation: .5,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Business valuation\nCalculator',
//                       style: AppTheme.headingText(Color(0xFF1A237E)).copyWith(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 22.sp
//                       ),
//                     ),
//                     SizedBox(height: 5),
//                     Text(
//                       'In the office, remote, or a mix of\nthe two, with Miro, your team ca\nn connect, collaborate, and co-cr',
//                       style: AppTheme.smallText(lightTextColor),
//                     ),
//                     SizedBox(height: 15.h),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const BusinessValuationScreen()));
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: buttonColor,
//                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: Text(
//                         'See More',
//                         style: AppTheme.smallText(Colors.white).copyWith(
//
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 SizedBox(
//                   height: 160,
//                   child: Image.asset(
//                     'assets/BVC.png',
//                   ),
//                 ),
//               ],
//             ),
//             ),
//         );
//     }
// }




import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/Views/roi_calculator.dart';
import 'BVC calculator_widget.dart';


class BusinessToolsWidget extends StatelessWidget {
  const BusinessToolsWidget({Key? key}) : super(key: key);

  // Theme colors
  static const primaryYellow = Color(0xFFFFB800);
  static const lightYellow = Color(0xFFFFF4D9);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 15.h),
          _buildToolsGrid(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Hub',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: Colors.grey[900],
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Unlock your business potential with our powerful tools',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildToolsGrid(BuildContext context) {
    final tools = [
      ToolData(
        title: 'Business Valuation',
        subtitle: 'Calculate worth & insights',
        icon: Icons.analytics_rounded,
        color: primaryYellow,
        backgroundColor: lightYellow,
        features: [
          'Market value analysis',
          'Asset evaluation',
          'Growth projections',
          'Competitor insights'
        ],
      ),
      ToolData(
        title: 'Profit Calculator',
        subtitle: 'Track performance metrics',
        icon: Icons.account_balance_rounded,
        color: primaryYellow,
        backgroundColor: lightYellow,
        features: [
          'Revenue tracking',
          'Cost analysis',
          'Margin calculations',
          'Profit forecasting'
        ],
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.8,
      ),
      itemCount: tools.length,
      itemBuilder: (context, index) =>
          _ToolCard(
            tool: tools[index],
            onTap: () => _navigateToTool(context, index == 0),
          ),
    );
  }

  void _navigateToTool(BuildContext context, bool isValuation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        isValuation
            ? const BusinessValuationScreen()
            : const ModernROICalculator(),
      ),
    );
  }
}

class ToolData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final List<String> features;

  const ToolData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.features,
  });
}

class _ToolCard extends StatefulWidget {
  final ToolData tool;
  final VoidCallback onTap;

  const _ToolCard({
    Key? key,
    required this.tool,
    required this.onTap,
  }) : super(key: key);

  @override
  State<_ToolCard> createState() => _ToolCardState();
}

class _ToolCardState extends State<_ToolCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 0.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    isHovered ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: _buildCard(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: _isHovered ? widget.tool.color : Colors.grey.shade100,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.tool.color.withOpacity(_isHovered ? 0.15 : 0.08),
              blurRadius: _isHovered ? 16 : 8,
              offset: Offset(0, _isHovered ? 6 : 3),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader(),
            _buildCardContent(),
            _buildFeaturesList(),
            _buildCardFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: widget.tool.color.withOpacity(0.05),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: widget.tool.color.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              widget.tool.icon,
              color: widget.tool.color,
              size: 18.w,
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            '',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: widget.tool.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.tool.title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: Colors.grey[900],
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            widget.tool.subtitle,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.tool.features.length,
          itemBuilder: (_, index) => _FeatureItem(
            feature: widget.tool.features[index],
            color: widget.tool.color,
          ),
        ),
      ),
    );
  }

  Widget _buildCardFooter() {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ActionButton(
            label: 'Get Started',
            isHovered: _isHovered,
            color: widget.tool.color,
            onTap: widget.onTap,
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: _isHovered ? widget.tool.color.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.arrow_forward_rounded,
              color: _isHovered ? widget.tool.color : Colors.grey[400],
              size: 18.w,
            ),
          ),
        ],
      ),
    );
  }


}


class _FeatureItem extends StatelessWidget {
  final String feature;
  final Color color;
  final bool isLast;

  const _FeatureItem({
    required this.feature,
    required this.color,
    this.isLast = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Container(
              width: 4.w,
              height: 4.w,
              decoration: BoxDecoration(
                color: color.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[700],
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
class _ActionButton extends StatelessWidget {
  final String label;
  final bool isHovered;
  final Color color;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.label,
    required this.isHovered,
    required this.color,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isHovered ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: isHovered ? Colors.white : color,
          ),
        ),
      ),
    );
  }
}