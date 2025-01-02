import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExploreShimmerWidget extends StatelessWidget {
  final double width;
  final double height;

  ExploreShimmerWidget({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 8, // Number of shimmer cards you want
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of cards in each row
        childAspectRatio: 0.7, // Adjust to change height
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        return _buildShimmerCard();
      },
    );
  }

  Widget _buildShimmerCard() {
    return Padding(
      padding:  EdgeInsets.only(top: 20.h,left: 4,right: 4),
      child: Card(
       // color: Colors.grey[300],
        elevation: 2,
        child: Container(
          width: width * 0.5, // Adjusted width to fit the grid
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.black12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!, // Slightly darker grey
                  highlightColor: Colors.grey[300]!, // Light grey for the shimmer effect
                  child: Container(
                    height: 120.h, // Reduced height for smaller cards
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[500]!,
                  highlightColor: Colors.grey[200]!,
                  child: Container(
                    width: double.infinity,
                    height: height * 0.015, // Adjusted height for text
                    color: Colors.grey[300],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 6),
                child: Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[400]!,
                      highlightColor: Colors.grey[200]!,
                      child: Container(
                        width: 20,
                        height: height * 0.015, // Adjusted height for icons
                        color: Colors.grey[300],
                      ),
                    ),
                    SizedBox(width: 5),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[400]!,
                      highlightColor: Colors.grey[200]!,
                      child: Container(
                        width: width * 0.3,
                        height: height * 0.015, // Adjusted height for text
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[400]!,
                      highlightColor: Colors.grey[200]!,
                      child: Container(
                        width: 20,
                        height: height * 0.015, // Adjusted height for icons
                        color: Colors.grey[300],
                      ),
                    ),
                    SizedBox(width: 5),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[400]!,
                      highlightColor: Colors.grey[200]!,
                      child: Container(
                        width: width * 0.25,
                        height: height * 0.015, // Adjusted height for text
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
