// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:project_emergio/Views/Auth%20Screens/ForgotPassword/forgot%20password%20otp.dart';
// import 'package:project_emergio/Views/Auth%20Screens/login.dart';
// import '../../../Widgets/custom textfeild.dart';
// import '../../../services/auth screens/forgot password.dart';
//
// class Forgot_passwordScreen extends StatefulWidget {
//   const Forgot_passwordScreen({super.key});
//
//   @override
//   State<Forgot_passwordScreen> createState() => _ForgotPasswordScreenState();
// }
//
// class _ForgotPasswordScreenState extends State<Forgot_passwordScreen> {
//   final TextEditingController phonecntrl = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   Future<void> _submitPhoneNumber() async {
//     final String phoneNumber = phonecntrl.text.trim();
//
//     if (_formKey.currentState!.validate()) {
//       final statusMap = await forgotPassword(phoneNumber);
//       bool status = statusMap['status'];
//       if (status) { // Extract OTP from response
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ForgotPasswordOtpScreen(
//               phoneNumber: phoneNumber,
//             ),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               duration: Duration(milliseconds: 800),
//               content: Text('User does not exist')),
//         );
//       }
//     }
//   }
//
//   String? _validatePhoneNumber(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your phone number';
//     } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
//       return 'Enter a valid 10-digit phone number';
//     }
//     return null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pushReplacement(
//                 context, MaterialPageRoute(builder: (context) => SignInPage()));
//           },
//           icon: Icon(
//             Icons.arrow_back_outlined,
//             color: Colors.black,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               SizedBox(height: 60.h),
//               Center(
//                 child: Image.asset(
//                   'assets/logo.jpg',
//                   height: 25.h,
//                   width: 100.w,
//                 ),
//               ),
//               SizedBox(height: 100.h),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   'Provide the contact number linked with your account',
//                   style:
//                   TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               SizedBox(height: 50.h),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 18.w),
//                 child: CustomTextFormField(
//                   controller: phonecntrl,
//                   decoration: InputDecoration(
//                       hintText: 'Number', border: OutlineInputBorder()),
//                   validator: _validatePhoneNumber,
//                 ),
//               ),
//               SizedBox(height: 150.h),
//               SizedBox(
//                 height: 45.h,
//                 width: 220.w,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xff37498B),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10.r),
//                     ),
//                   ),
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       _submitPhoneNumber();
//                     }
//                   },
//                   child: Text('Submit',
//                       style: TextStyle(color: Colors.white, fontSize: 13.sp)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/Views/Auth%20Screens/ForgotPassword/forgot%20password%20otp.dart';
import 'package:project_emergio/Views/Auth%20Screens/login.dart';
import 'package:project_emergio/generated/constants.dart';
import '../../../services/auth screens/forgot password.dart';

class Forgot_passwordScreen extends StatefulWidget {
  const Forgot_passwordScreen({super.key});

  @override
  State<Forgot_passwordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<Forgot_passwordScreen> {
  final TextEditingController phonecntrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: transparentColor,
        leading: IconButton(
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignInPage()),
              );
            }
          },
          icon: Icon(
            Icons.arrow_back_outlined,
            color: lightTextColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40.h),
                Text(
                  'Forgot Password',
                  style: AppTheme.headingText(buttonColor)
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Provide the contact number linked with your account',
                  style: AppTheme.mediumTitleText(greyTextColor!),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40.h),
                _buildPhoneTextField(),
                SizedBox(height: 24.h),
                _buildSubmitButton(),
                Spacer(),
                _buildPrivacyNote(),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneTextField() {
    return TextFormField(
      controller: phonecntrl,
      keyboardType: TextInputType.phone,
      style: AppTheme.bodyMediumTitleText(greyTextColor!),
      decoration: InputDecoration(
        labelText: 'Phone Number',
        labelStyle: AppTheme.smallText(lightTextColor),
        hintText: 'Enter your phone number',
        prefixIcon: Icon(Icons.phone, color: greyTextColor, size: 20.r),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: buttonColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: buttonColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: buttonColor),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      ),
      validator: _validatePhoneNumber,
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 16.h),
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _submitPhoneNumber();
        }
      },
      child: Text(
        'Submit',
        style: AppTheme.titleText(backgroundColor)
            .copyWith(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPrivacyNote() {
    return Text(
      'We\'ll send a verification code to this number',
      style: AppTheme.smallText(greyTextColor!),
      textAlign: TextAlign.center,
    );
  }

  Future<void> _submitPhoneNumber() async {
    final String phoneNumber = phonecntrl.text.trim();

    final statusMap = await forgotPassword(phoneNumber);
    bool status = statusMap['status'];
    if (status) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForgotPasswordOtpScreen(
            phoneNumber: phoneNumber,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            duration: Duration(milliseconds: 800),
            content: Text('User does not exist', style: AppTheme.smallText(lightTextColor),)),
      );
    }
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }
}
