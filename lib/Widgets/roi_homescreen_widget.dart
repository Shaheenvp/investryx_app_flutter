import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/Views/roi_calculator.dart';
import 'package:project_emergio/Widgets/BVC calculator_widget.dart';
import 'package:project_emergio/generated/constants.dart';

class RoiHomeScreenWidget extends StatelessWidget {
  const RoiHomeScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      height: 140.h, // Reduced height
      child: Stack(
        children: [
          // Main Card
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.grey[50]!,
                  Colors.grey[100]!,
                ],
              ),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ModernROICalculator(),
                  ),
                ),
                borderRadius: BorderRadius.circular(20.r),
                child: Padding(
                  padding: EdgeInsets.all(16.w), // Reduced padding
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Title with modern badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: buttonColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.auto_graph_rounded,
                                    color: buttonColor,
                                    size: 16.w, // Reduced size
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    'Profit Calculator',
                                    style: TextStyle(
                                      color: buttonColor,
                                      fontSize: 13.sp, // Reduced font size
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Description
                            Text(
                              'Analyze your business metrics\nwith advanced insights',
                              style: TextStyle(
                                fontSize: 14.sp, // Reduced font size
                                color: Colors.grey[800],
                                height: 1.3,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            // Modern Action Button
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 7.h,
                              ),
                              decoration: BoxDecoration(
                                color: buttonColor,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Get Started',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp, // Reduced font size
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 14.w, // Reduced size
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Right side with illustration
                      Expanded(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              right: -15.w,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                width: 120.w, // Reduced width
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    center: Alignment.centerRight,
                                    radius: 1.2,
                                    colors: [
                                      buttonColor.withOpacity(0.1),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Image.asset(
                                'assets/profit_calculator.png',
                                height: 80.h, // Reduced height
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}