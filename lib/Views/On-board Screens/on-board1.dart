import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_emergio/Views/Auth%20Screens/login.dart';
import 'package:project_emergio/generated/constants.dart';

class OnBoardingScreen1 extends StatelessWidget {
  final VoidCallback onNext;
  const OnBoardingScreen1({Key? key, required this.onNext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                ClipPath(
                  clipper: BottomCurveClipper(),
                  child: Container(
                    width: double.infinity,
                    height: 420.h,
                    child: Image.asset(
                      'assets/business option.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                Text(
                    'Business Options',
                    style: AppTheme.headingText(lightTextColor)
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                      'A platform for buying and selling businesses, securing stakes in successful ventures, and exploring real estate portfolios. It connects investors, franchise seekers, sellers, and advisors. Your hub for business opportunities and partnerships.',
                      textAlign: TextAlign.center,
                      style: AppTheme.bodyMediumTitleText(lightTextColor.withOpacity(0.7))
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const SignInPage()),
                            (Route<dynamic> route) => false
                    );
                  },
                  child: const Text('Skip'),
                ),
                ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  child: const Text('Next'),
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
    path.lineTo(0, 0); // Start from top-left
    path.lineTo(0, size.height - 60); // Increased space for bigger curve

    // Create a more pronounced curved bottom
    path.quadraticBezierTo(
        size.width * 0.25, size.height, // First control point
        size.width * 0.5, size.height - 50 // First ending point, higher curve
    );

    path.quadraticBezierTo(
        size.width * 0.75, size.height - 100, // Second control point, more dramatic
        size.width, size.height - 60 // Second ending point
    );

    path.lineTo(size.width, 0); // Complete the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}