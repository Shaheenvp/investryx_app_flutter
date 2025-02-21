import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:project_emergio/Views/Auth%20Screens/ForgotPassword/change%20password.dart';
import 'package:project_emergio/generated/constants.dart';
import 'package:project_emergio/services/auth%20screens/forgot%20password.dart';
import 'package:project_emergio/services/auth%20screens/forgotOtp%20confirm%20service.dart';
import 'package:sms_autofill/sms_autofill.dart';

class ForgotPasswordOtpScreen extends StatefulWidget {
  final String phoneNumber;

  const ForgotPasswordOtpScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<ForgotPasswordOtpScreen> createState() =>
      _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen>
    with CodeAutoFill {
  final TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  String currentText = "";
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  bool _isResending = false;
  int _timerSeconds = 30;
  Timer? _timer;

  @override
  void codeUpdated() {
    setState(() {
      currentText = code ?? "";
      textEditingController.text = currentText;
    });
  }

  String get maskedPhoneNumber {
    if (widget.phoneNumber.length <= 4) return widget.phoneNumber;
    return widget.phoneNumber.substring(0, 1) +
        '*' * (widget.phoneNumber.length - 4) +
        widget.phoneNumber.substring(widget.phoneNumber.length - 3);
  }

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
    startTimer();
    _initSmsListener();
  }

  Future<void> _initSmsListener() async {
    await SmsAutoFill().listenForCode();
  }

  @override
  void dispose() {
    errorController?.close();
    _timer?.cancel();
    textEditingController.dispose();
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() {
          _timerSeconds--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> resendOtp() async {
    if (_isResending) return;

    setState(() {
      _isResending = true;
    });

    try {
      Map<String, dynamic> response = await forgotPassword(widget.phoneNumber);

      if (response['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'OTP resent successfully'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          ),
        );
        setState(() {
          textEditingController.clear();
          currentText = "";
          _timerSeconds = 30;
        });
        startTimer();
        await _initSmsListener();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Failed to resend OTP. Please try again.'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isResending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: transparentColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_outlined,
            color: businessContainerColor,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30.h),
                Icon(
                  Icons.lock_outline,
                  size: 60.sp,
                  color: greyTextColor,
                ),
                SizedBox(height: 20.h),
                Text(
                  'Verification',
                  style: AppTheme.titleText(buttonColor).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Text(
                  'Enter the OTP code sent to',
                  style: AppTheme.bodyMediumTitleText(greyTextColor!),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 6.h),
                Text(
                  maskedPhoneNumber,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: greyTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.h),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: PinCodeTextField(
                      appContext: context,
                      length: 4,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(12.r),
                        fieldHeight: 50.h,
                        fieldWidth: 50.w,
                        activeFillColor: backgroundColor,
                        inactiveFillColor: shimmerHighlightColor,
                        selectedFillColor: shimmerHighlightColor,
                        activeColor: businessContainerColor,
                        inactiveColor: buttonColor,
                        selectedColor: businessContainerColor,
                      ),
                      cursorColor: businessContainerColor,
                      animationDuration: Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      boxShadows: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: boxShadowColor,
                          blurRadius: 8,
                        )
                      ],
                      onCompleted: (v) {
                        print("Completed");
                      },
                      onChanged: (value) {
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        return text != null &&
                            text.length == 4 &&
                            int.tryParse(text) != null;
                      },
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter OTP";
                        } else if (value.length != 4) {
                          return "Please enter a valid 4-digit OTP";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                TextButton(
                  onPressed:
                  (_timerSeconds > 0 || _isResending) ? null : resendOtp,
                  child: _isResending
                      ? CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(lightTextColor),
                  )
                      : Text(
                      _timerSeconds > 0
                          ? 'Resend OTP in $_timerSeconds seconds'
                          : 'Resend OTP',
                      style: AppTheme.bodyMediumTitleText(
                        _timerSeconds > 0
                            ? greyTextColor!
                            : businessContainerColor,
                      ).copyWith(fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 30.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    elevation: 4,
                  ),
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  child: _isSubmitting
                      ? CircularProgressIndicator(color: backgroundColor)
                      : Text(
                    'Verify',
                    style: AppTheme.mediumTitleText(backgroundColor)
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      var response = await ForgotOtpConfirm.forgotOtp(
        phone: widget.phoneNumber,
        otp: currentText,
      );

      if (response == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChangePasswordScreen(
              phoneNumber: widget.phoneNumber,
            ),
          ),
        );
      } else if (response == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                'Invalid OTP',
                style: AppTheme.mediumTitleText(lightTextColor),
              )),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('An error occurred. Please try again.',
                  style: AppTheme.mediumTitleText(lightTextColor))),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
}
   }
    }
}
