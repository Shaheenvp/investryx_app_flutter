import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class EditScreenShimmerWidget extends StatelessWidget {
  const EditScreenShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('Update Advisor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: h * 0.03),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                children: [
                  // Placeholder for Advisor Name
                  Container(
                    height: h * 0.07,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  SizedBox(height: h * 0.03),

                  // Placeholder for Designation
                  Container(
                    height: h * 0.07,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  SizedBox(height: h * 0.03),

                  // Placeholder for Company Website URL
                  Container(
                    height: h * 0.07,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  SizedBox(height: h * 0.03),

                  // Placeholder for Dropdowns (State & City)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: h * 0.07,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Container(
                          height: h * 0.07,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.03),

                  // Placeholder for Contact Number
                  Container(
                    height: h * 0.07,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  SizedBox(height: h * 0.03),

                  // Placeholder for Description
                  Container(
                    height: h * 0.14,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  SizedBox(height: h * 0.03),

                  // Placeholder for Area of Interest
                  Container(
                    height: h * 0.14,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  SizedBox(height: h * 0.03),

                  // Placeholder for Photos, Documents & Proof
                  Container(
                    height: h * 0.2,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  SizedBox(height: h * 0.03),
                ],
              ),
            ),
          ],
        ),
      ),
    );;
  }
}
