// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:project_emergio/Views/Auth%20Screens/location%20access%20page.dart';
// import 'package:project_emergio/Views/Auth%20Screens/register.dart';
// import '../../services/auth screens/registerOtp.dart';
// import '../../services/auth screens/signUp.dart';
//
//
// class Reg_OTPVerificationScreen extends StatefulWidget {
//   final String phone;
//   final String? image;
//   final String name;
//   final String email;
//   final String password;
//   final String otp;
//
//   const Reg_OTPVerificationScreen({
//     Key? key,
//     required this.phone,
//     required this.name,
//     this.image,
//     required this.email,
//     required this.password,
//     required this.otp,
//   }) : super(key: key);
//
//   @override
//   _Reg_OTPVerificationScreenState createState() => _Reg_OTPVerificationScreenState();
// }
//
// class _Reg_OTPVerificationScreenState extends State<Reg_OTPVerificationScreen> {
//   bool isButtonDisabled = true;
//   int _timerSeconds = 30;
//   Timer? _timer;
//   bool _isSubmitting = false;
//   bool _isResending = false;
//   String _enteredOtp = '';
//   final TextEditingController _otpController = TextEditingController();
//   StreamController<ErrorAnimationType>? errorController;
//
//   @override
//   void initState() {
//     super.initState();
//     errorController = StreamController<ErrorAnimationType>();
//     startTimer();
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     errorController?.close();
//     _otpController.dispose();
//     super.dispose();
//   }
//
//   void startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (_timerSeconds > 0) {
//         setState(() {
//           _timerSeconds--;
//         });
//       } else {
//         setState(() {
//           isButtonDisabled = false;
//         });
//         _timer?.cancel();
//       }
//     });
//   }
//
//   void resendOtp() async {
//     setState(() {
//       _isResending = true;
//     });
//
//     final String phoneNumber = widget.phone;
//     final String email = widget.email;
//
//     if (phoneNumber.isNotEmpty && email.isNotEmpty) {
//       final response = await RegisterOtp.registerOtp(phone: phoneNumber, email: email);
//       if (response == true) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('OTP resent successfully'),
//             duration: Duration(seconds: 2),
//           ),
//         );
//         setState(() {
//           _timerSeconds = 30;
//           isButtonDisabled = true;
//           _enteredOtp = '';
//           _otpController.clear();
//         });
//         startTimer();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to resend OTP. Try again later.'),
//             duration: Duration(seconds: 2),
//           ),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Invalid phone number or email.'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     }
//
//     setState(() {
//       _isResending = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => SignUpScreen()),
//             );
//           },
//           icon: Icon(
//             Icons.arrow_back_outlined,
//             color: Color(0xff37498B),
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 SizedBox(height: 30.h),
//                 Icon(
//                   Icons.lock_outline,
//                   size: 60.sp,
//                   color: Color(0xffFFCC00),
//                 ),
//                 SizedBox(height: 20.h),
//                 Text(
//                   'Verification',
//                   style: TextStyle(
//                     fontSize: 24.sp,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xffFFCC00),
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 12.h),
//                 Text(
//                   'Enter OTP code sent to',
//                   style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 6.h),
//                 Text(
//                   widget.phone,
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xff37498B),
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 30.h),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 20.w),
//                   child: PinCodeTextField(
//                     appContext: context,
//                     length: 4,
//                     obscureText: false,
//                     animationType: AnimationType.fade,
//                     pinTheme: PinTheme(
//                       shape: PinCodeFieldShape.box,
//                       borderRadius: BorderRadius.circular(12.r),
//                       fieldHeight: 50.h,
//                       fieldWidth: 50.w,
//                       activeFillColor: Colors.white,
//                       inactiveFillColor: Colors.grey[100],
//                       selectedFillColor: Colors.white,
//                       activeColor: Color(0xffFFCC00),
//                       inactiveColor: Colors.grey[300],
//                       selectedColor: Color(0xff37498B),
//                     ),
//                     cursorColor: Color(0xff37498B),
//                     animationDuration: Duration(milliseconds: 300),
//                     backgroundColor: Colors.transparent,
//                     enableActiveFill: true,
//                     errorAnimationController: errorController,
//                     controller: _otpController,
//                     keyboardType: TextInputType.number,
//                     boxShadows: [
//                       BoxShadow(
//                         offset: Offset(0, 1),
//                         color: Colors.black12,
//                         blurRadius: 8,
//                       )
//                     ],
//                     onCompleted: (v) {
//                       _enteredOtp = v;
//                     },
//                     onChanged: (value) {
//                       setState(() {
//                         _enteredOtp = value;
//                       });
//                     },
//                     beforeTextPaste: (text) {
//                       return text != null && text.length == 4 && int.tryParse(text) != null;
//                     },
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   ),
//                 ),
//                 SizedBox(height: 20.h),
//                 Text(
//                   'Didn\'t receive the OTP?',
//                   style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
//                   textAlign: TextAlign.center,
//                 ),
//                 TextButton(
//                   onPressed: (isButtonDisabled || _isResending) ? null : resendOtp,
//                   child: _isResending
//                       ? CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(Color(0xff37498B)),
//                   )
//                       : Text(
//                     isButtonDisabled
//                         ? 'Resend OTP in $_timerSeconds seconds'
//                         : 'Resend OTP',
//                     style: TextStyle(
//                       color: isButtonDisabled ? Colors.grey : Color(0xff37498B),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14.sp,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 30.h),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xffFFCC00),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                     padding: EdgeInsets.symmetric(vertical: 14.h),
//                     elevation: 4,
//                   ),
//                   onPressed: (_isSubmitting || _enteredOtp.length != 4) ? null : _handleSubmit,
//                   child: _isSubmitting
//                       ? CircularProgressIndicator(color: Colors.white)
//                       : Text(
//                     'Verify',
//                     style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 SizedBox(height: 20.h),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _handleSubmit() async {
//     setState(() {
//       _isSubmitting = true;
//     });
//     try {
//       bool? response = await SignUp.signUp(
//         name: widget.name,
//         email: widget.email,
//         phone: widget.phone,
//         password: widget.password,
//         image: widget.image,
//         otp: int.parse(_enteredOtp),
//       );
//       if (response == true) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => LocationAccessScreen(),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             duration: Duration(milliseconds: 800),
//             content: Text('Incorrect OTP'),
//           ),
//         );
//       }
//     } finally {
//       setState(() {
//         _isSubmitting = false;
//       });
//     }
//   }
// }



import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:project_emergio/Views/Auth%20Screens/location%20access%20page.dart';
import '../../services/auth screens/registerOtp.dart';
import '../../services/auth screens/signUp.dart';


class Reg_OTPVerificationScreen extends StatefulWidget {
  final String phone;
  final String? image;
  final String name;
  final String email;
  final String password;
  final String otp;

  const Reg_OTPVerificationScreen({
    Key? key,
    required this.phone,
    required this.name,
    this.image,
    required this.email,
    required this.password,
    required this.otp,
  }) : super(key: key);

  @override
  _Reg_OTPVerificationScreenState createState() => _Reg_OTPVerificationScreenState();
}

class _Reg_OTPVerificationScreenState extends State<Reg_OTPVerificationScreen> {
  bool isButtonDisabled = true;
  int _timerSeconds = 30;
  Timer? _timer;
  bool _isSubmitting = false;
  bool _isResending = false;
  String _enteredOtp = '';
  final TextEditingController _otpController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    errorController?.close();
    _otpController.dispose();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() {
          _timerSeconds--;
        });
      } else {
        setState(() {
          isButtonDisabled = false;
        });
        _timer?.cancel();
      }
    });
  }

  void resendOtp() async {
    setState(() {
      _isResending = true;
    });

    final String phoneNumber = widget.phone;
    final String email = widget.email;

    if (phoneNumber.isNotEmpty && email.isNotEmpty) {
      final response = await RegisterOtp.registerOtp(phone: phoneNumber, email: email);
      if (response == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP resent successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          _timerSeconds = 30;
          isButtonDisabled = true;
          _enteredOtp = '';
          _otpController.clear();
        });
        startTimer();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to resend OTP. Try again later.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid phone number or email.'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    setState(() {
      _isResending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                Text(
                  'Verification',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'You will get OTP in Whatsapp SMS',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 40.h),
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter OTP Number',
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: PinCodeTextField(
                          appContext: context,
                          length: 4,
                          obscureText: false,
                          animationType: AnimationType.fade,
                          textStyle: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(12.r),
                            fieldHeight: 52.h,
                            fieldWidth: 52.w,
                            activeFillColor: Colors.grey[50],
                            inactiveFillColor: Colors.grey[50],
                            selectedFillColor: Colors.grey[100],
                            activeColor: Color(0xFFFFD60A),
                            inactiveColor: Colors.grey[300],
                            selectedColor: Color(0xFFFFD60A),
                            borderWidth: 1.5,
                          ),
                          cursorColor: Color(0xFFFFD60A),
                          animationDuration: Duration(milliseconds: 300),
                          backgroundColor: Colors.transparent,
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          boxShadows: [
                            BoxShadow(
                              offset: Offset(0, 2),
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              spreadRadius: 1,
                            )
                          ],
                          onCompleted: (v) {
                            _enteredOtp = v;
                          },
                          onChanged: (value) {
                            setState(() {
                              _enteredOtp = value;
                            });
                          },
                          beforeTextPaste: (text) {
                            return text != null && text.length == 4 && int.tryParse(text) != null;
                          },
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                Container(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFD60A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      elevation: 0,
                    ),
                    onPressed: (_isSubmitting || _enteredOtp.length != 4) ? null : _handleSubmit,
                    child: _isSubmitting
                        ? SizedBox(
                      height: 20.h,
                      width: 20.h,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : Text(
                      'Verify',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t Receive the verification OTP ? ',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.black54,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextButton(
                      onPressed: (isButtonDisabled || _isResending) ? null : resendOtp,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Resend',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                if (isButtonDisabled)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      'Resend available in $_timerSeconds seconds',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit() async {
    setState(() {
      _isSubmitting = true;
    });
    try {
      bool? response = await SignUp.signUp(
        name: widget.name,
        email: widget.email,
        phone: widget.phone,
        password: widget.password,
        image: widget.image,
        otp: int.parse(_enteredOtp),
      );
      if (response == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LocationAccessScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 800),
            content: Text('Incorrect OTP'),
          ),
        );
      }
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }
}