import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerLoading extends StatelessWidget {
  final int itemCount;

  const CustomShimmerLoading({Key? key, required this.itemCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: itemCount, // Use the itemCount passed to the widget
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 200.0,
                color: Colors.white,
              ),
              const SizedBox(height: 8.0),
              Container(
                width: 200.0,
                height: 20.0,
                color: Colors.white,
              ),
              const SizedBox(height: 8.0),
              Container(
                width: 150.0,
                height: 15.0,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
