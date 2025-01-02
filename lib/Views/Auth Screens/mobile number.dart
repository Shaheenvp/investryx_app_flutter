import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/Views/Auth%20Screens/reg_otp%20verification.dart';
import 'package:project_emergio/Views/Auth%20Screens/register.dart';

import 'package:project_emergio/generated/constants.dart';
import '../../services/auth screens/registerOtp.dart';

class MobileNumberScreen extends StatefulWidget {
  final String? name;
  final String? email;
  final String? image;

  const MobileNumberScreen({super.key, this.name, this.email, this.image});

  @override
  State<MobileNumberScreen> createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen> {
  final TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: transparentColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.black,
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
                  'Verify Your Number',
                  style: AppTheme.headingText(buttonColor).copyWith(fontWeight: FontWeight.bold,),

                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                Text(
                  'We\'ll send you a one-time verification code',
                  style: AppTheme.bodyMediumTitleText(greyTextColor!),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40.h),
                _buildPhoneTextField(),
                SizedBox(height: 24.h),
                _buildSubmitButton(),
                const Spacer(),
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
      controller: phoneController,
      keyboardType: TextInputType.phone,
      style: AppTheme.bodyMediumTitleText(lightTextColor),
      decoration: InputDecoration(
        labelText: 'Phone Number',
        labelStyle: AppTheme.bodyMediumTitleText(greyTextColor!),
        hintText: 'Enter your phone number',
        hintStyle: AppTheme.bodyMediumTitleText(greyTextColor!),
        prefixIcon: Icon(Icons.phone, color: businessContainerColor, size: 20.r),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: shimmerBaseColor!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: shimmerBaseColor!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: businessContainerColor),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        }
        final phonePattern = RegExp(r'^[0-9]{10}$');
        if (!phonePattern.hasMatch(value)) {
          return 'Enter a valid 10-digit phone number';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 14.h),
      ),
      onPressed: _handleSubmit,
      child: Text(
        'Send Verification Code',
        style:  AppTheme.mediumTitleText(Colors.white).copyWith(fontWeight: FontWeight.bold),

      ),
    );
  }

  Widget _buildPrivacyNote() {
    return Text(
      'By continuing, you agree to our Terms of Service and Privacy Policy',
      style: AppTheme.smallText(greyTextColor!),
      textAlign: TextAlign.center,
    );
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final String phoneNumber = phoneController.text;
      final response = await RegisterOtp.registerOtp(phone: phoneNumber, email: widget.email!);

      if (response == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Reg_OTPVerificationScreen(
              phone: phoneNumber,
              image: widget.image,
              name: widget.name!,
              email: widget.email!,
              password: "",
              otp: '',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(milliseconds: 800),
            content: Text('User with same phone number or email already exists',  style: AppTheme.smallText(lightTextColor),),
          ),
        );
    }
    }
    }
}
