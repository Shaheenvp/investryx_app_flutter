import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/Widgets/BVC%20calculator_widget.dart';
import 'package:project_emergio/generated/constants.dart';

class BusinessValuationPromoCard extends StatelessWidget {
  const BusinessValuationPromoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        elevation: .5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Business valuation\nCalculator',
                      style: AppTheme.headingText(Color(0xFF1A237E)).copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 22.sp
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'In the office, remote, or a mix of\nthe two, with Miro, your team ca\nn connect, collaborate, and co-cr',
                      style: AppTheme.smallText(lightTextColor),
                    ),
                    SizedBox(height: 15.h),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BusinessValuationScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'See More',
                        style: AppTheme.smallText(Colors.white).copyWith(

                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 160,
                  child: Image.asset(
                    'assets/BVC.png',
                  ),
                ),
              ],
            ),
            ),
        );
    }
}
