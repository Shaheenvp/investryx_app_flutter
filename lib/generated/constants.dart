import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// colors
const backgroundColor = Colors.white;
const buttonColor = Color(0xffFFCC00);
final boxShadowColor = Colors.grey.withOpacity(0.3);
const containerColor = Colors.white;
const businessContainerColor = Color(0xff6B89B7);
const investorContainerColor = Color(0xffBDD0E7);
const franchiseContainerColor = Color(0xffF6E18D);
const advisorContainerColor = Color(0xffC3C3C3);
final greyTextColor = Colors.grey[600];
const lightTextColor = Colors.black;
final shimmerBaseColor = Colors.grey[300];
final shimmerHighlightColor = Colors.grey[100];
final errorIconColor = Colors.red.shade900;
const whiteTextColor = Colors.white;
final textLightGreyColor = Colors.grey[300];
final borderColor = Colors.grey[200];
final iconColor = Colors.grey[600];
final transparentColor = Colors.transparent;

final Color primaryYellow = const Color(0xFFFFB800); // Bright yellow
final Color lightYellow = const Color(0xFFFFF8E1);   // Light yellow background
final Color darkYellow = const Color(0xFFFF9800);    // Darker yellow for text
final Color textColor = const Color(0xFF333333);     // Dark text color



final LinearGradient gradient = LinearGradient(
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
);

// fontsize
final headingFont = 25.sp;
final mediumHeadingFont = 18.sp;
final titleFont = 16.sp;
final bodyMediumTitleFont = 14.sp;
  final mediumTitleFont = 15.sp;
final mediumSmallFont = 13.sp;
final smallTextFont = 12.sp;

// fontWeight
FontWeight titleFontWeight = FontWeight.bold;
FontWeight normalFontWeight = FontWeight.normal;

// radius
final borderRadius = 15.r;

class AppTheme {
  static TextStyle headingText(Color color) {
    return TextStyle(
      fontSize: headingFont,
      color: color,
      fontWeight: FontWeight.w600,
    );
  }
  static TextStyle mediumHeadingText(Color color) {
    return TextStyle(
      fontSize: mediumHeadingFont,
      color: color,
      fontWeight: titleFontWeight,
    );
  }

  static TextStyle titleText(Color color) {
    return TextStyle(
      fontSize: titleFont,
      color: color,
      fontWeight: titleFontWeight,
    );
  }

  static TextStyle mediumTitleText(Color color) {
    return TextStyle(
      fontSize: mediumTitleFont,
      color: color,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle bodyMediumTitleText(Color color) {
    return TextStyle(
      fontSize: bodyMediumTitleFont,
      color: color,
    );
  }

  static TextStyle mediumSmallText(Color color) {
    return TextStyle(
      fontSize: mediumSmallFont,
      color: color,
      fontWeight: normalFontWeight,
    );
  }

  static TextStyle smallText(Color color) {
    return TextStyle(
        fontSize: smallTextFont,
        color: color,
        fontWeight: normalFontWeight,
        );
    }


}
