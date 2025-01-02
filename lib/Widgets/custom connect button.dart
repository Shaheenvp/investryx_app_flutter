import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomConnectButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? textColor;
  final Color? buttonColor;
  final double? buttonWidth;
  final double? buttonHeight;

  CustomConnectButton({
    required this.text,
    required this.onPressed,
    this.textColor = Colors.white,
    this.buttonColor,
    this.buttonWidth,
    this.buttonHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: buttonHeight,
        width: buttonWidth, // Set a fixed width for the button
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: textColor,
              backgroundColor: buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(vertical: 13.h),
              elevation: 5,
            ),
            onPressed: onPressed,
            child: FittedBox(
              // Ensures text scales down if too long
              fit: BoxFit.scaleDown,
              child: Text(
                text,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            ),
        );
    }
}
