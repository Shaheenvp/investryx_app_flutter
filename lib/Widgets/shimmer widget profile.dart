import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AdvisorDetailShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(height: h * 0.03),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: CircleAvatar(
            radius: h * .08,
            backgroundColor: Colors.grey[300], // Placeholder color
          ),
        ),
        SizedBox(height: h * 0.02),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 20.0,
                width: 150.0,
                color: Colors.grey[300],
              ),
            ),
            SizedBox(height: h * 0.01),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 16.0,
                width: 100.0,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
        SizedBox(height: h * 0.015),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40.0,
                  width: 100.0,
                  color: Colors.grey[300],
                ),
                Container(
                  height: 40.0,
                  width: 100.0,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: h * 0.02),
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.05),
              child: Column(
                children: [
                  Container(
                    height: 230,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(height: h * 0.015),
                  Container(
                    height: h * 0.25,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(height: h * 0.015),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
