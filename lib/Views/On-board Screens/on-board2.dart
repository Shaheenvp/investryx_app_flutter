import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/generated/constants.dart';

class OnBoardingScreen2 extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const OnBoardingScreen2({Key? key, required this.onNext, required this.onBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipPath(
                  clipper: OppositeCurveClipper(),
                  child: Image.asset(
                    'assets/investment & franchise.jpg',
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
                      SizedBox(height: 400.h),
                      Text(
                          'Investment And\nFranchise',
                          style: AppTheme.headingText(lightTextColor)
                      ),
                      const SizedBox(height: 20),
                      Text(
                          'InveStryx offers a dynamic marketplace for investment and franchise opportunities. Users can explore businesses for sale, connect with investors, and franchise top brands. Whether you are looking to invest in a promising venture or expand your brand through franchising, InveStryx provides a seamless platform to discover, connect, and grow',
                          style: AppTheme.bodyMediumTitleText(lightTextColor.withOpacity(0.7))
                      ),
                    ],
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
                  onPressed: onBack,
                  child: const Text('Back',
                      style: TextStyle(color: Colors.black54)),
                ),
                ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
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

class OppositeCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 45);        // Balanced starting point

    path.quadraticBezierTo(
        size.width * 0.25, size.height - 80,   // More pronounced curve
        size.width * 0.5, size.height - 45     // Balanced peak
    );

    path.quadraticBezierTo(
        size.width * 0.75, size.height - 10,   // Deeper curve
        size.width, size.height - 50           // Increased from 40
    );

    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}