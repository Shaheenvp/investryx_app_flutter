import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/generated/constants.dart';

class OnBoardingScreen3 extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onFinish;
  const OnBoardingScreen3({Key? key, required this.onBack, required this.onFinish})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipPath(
                    clipper: BottomCurveClipper(),
                    child: Image.asset(
                      'assets/advisor option.jpg',
                      width: double.infinity,
                      height: 420.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Advisor Options',
                            style: AppTheme.headingText(lightTextColor)
                        ),
                        SizedBox(height: 20),
                        Text(
                            'InveStryx provides a dedicated platform for advisors to connect with entrepreneurs, investors, and business owners. Advisors can showcase their expertise, offer professional guidance, and help users make informed investment and business decisions. Whether you are a business consultant, financial expert, or industry specialist, InveStryx enables you to expand your reach and connect with potential clients',
                            style: AppTheme.bodyMediumTitleText(lightTextColor.withOpacity(0.7))
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: onBack,
                  child: const Text('Back',
                      style: TextStyle(color: Colors.black54)),
                ),
                ElevatedButton(
                  onPressed: onFinish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Finish'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 50);    // Increased from 40

    path.quadraticBezierTo(
        size.width * 0.25, size.height - 10,   // Deeper curve
        size.width * 0.5, size.height - 45     // More noticeable peak
    );

    path.quadraticBezierTo(
        size.width * 0.75, size.height - 80,   // More pronounced curve
        size.width, size.height - 45           // Balanced ending
    );

    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}