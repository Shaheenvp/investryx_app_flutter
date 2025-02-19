//
// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:project_emergio/Views/pricing%20screen.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import '../generated/constants.dart';
// import '../services/check subscribe.dart';
//
// class PayMoney extends StatefulWidget {
//   final int amount;
//   final String name;
//   final String description;
//   final String email;
//   final String id;
//
//   const PayMoney({
//     Key? key,
//     required this.amount,
//     required this.name,
//     required this.description,
//     required this.email,
//     required this.id,
//   }) : super(key: key);
//
//   @override
//   State<PayMoney> createState() => _PayMoneyState();
// }
//
// class _PayMoneyState extends State<PayMoney> {
//   late Razorpay _razorpay;
//
//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       openCheckout(); // Call openCheckout after the widget is built
//     });
//   }
//
//   @override
//   void dispose() {
//     _razorpay.clear();
//     super.dispose();
//   }
//
//   void _handlePaymentSuccess(PaymentSuccessResponse response) async {
//     print('Success Response: ${response.paymentId}');
//
//     // Post the transaction details after successful payment
//     bool success = await CheckSubscription.postTransactionDetails(
//       transactionId: response.paymentId!,
//       id:widget.id,
//     );
//
//     if (success) {
//       print('Transaction details posted successfully');
//       // Navigate to the appropriate screen or update UI
//     } else {
//       print('Failed to post transaction details');
//       // Handle failure (e.g., show an error message)
//     }
//   }
//
//   void _handlePaymentError(PaymentFailureResponse response) {
//     print('Error Response: $response');
//     // Handle payment error here
//   }
//
//   void _handleExternalWallet(ExternalWalletResponse response) {
//     print('External SDK Response: $response');
//     // Handle external wallet response here
//   }
//
//   void openCheckout() async {
//     var options = {
//       'key': 'rzp_test_l5y7T0LlpGjuTh',
//       'amount': widget.amount * 100,
//       'name': widget.name,
//       'description': widget.description,
//       'retry': {'enabled': true, 'max_count': 1},
//       'send_sms_hash': true,
//       'prefill': {
//         'contact': '9544453993',
//         'email': widget.email,
//       },
//       'external': {
//         'wallets': ['paytm'],
//       }
//     };
//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       debugPrint('Error: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     Timer(Duration(seconds: 2), () {
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> PricingScreenNew()));
//
//     });
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Colors.blue.shade300, Colors.blue.shade700],
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Image.asset(
//               //   'assets/logo1.png',
//               //   width: 150,
//               //   height: 150,
//               // ),
//               Container(
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 20,
//                       offset: Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Text.rich(
//                   TextSpan(
//                     children: [
//                       TextSpan(
//                         text: 'Inve',
//                         style: TextStyle(
//                           fontSize: 36.sp,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.grey[800],
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                       TextSpan(
//                         text: 'Stry',
//                         style: TextStyle(
//                           fontSize: 36.sp,
//                           fontWeight: FontWeight.w600,
//                           color: buttonColor,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                       TextSpan(
//                         text: 'x',
//                         style: TextStyle(
//                           fontSize: 36.sp,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.grey[800],
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: 30),
//               CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 'Processing Payment...',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Amount: ₹${widget.amount}',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/Views/pricing%20screen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../generated/constants.dart';
import '../services/check subscribe.dart';

class PayMoney extends StatefulWidget {
  final int amount;
  final String name;
  final String description;
  final String email;
  final String id;

  const PayMoney({
    Key? key,
    required this.amount,
    required this.name,
    required this.description,
    required this.email,
    required this.id,
  }) : super(key: key);

  @override
  State<PayMoney> createState() => _PayMoneyState();
}

class _PayMoneyState extends State<PayMoney> {
  late Razorpay _razorpay;
  bool _isProcessing = false;
  String _statusMessage = '';
  bool _isSuccess = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _initializeRazorpay();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      openCheckout();
    });
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    setState(() {
      _isProcessing = true;
      _statusMessage = 'Processing payment...';
    });

    try {
      bool success = await CheckSubscription.postTransactionDetails(
        transactionId: response.paymentId!,
        id: widget.id,
      );

      if (mounted) {
        setState(() {
          _isSuccess = success;
          _isError = !success;
          _statusMessage = success
              ? 'Payment successful!'
              : 'Failed to update subscription. Please contact support.';
        });

        if (success) {
          await Future.delayed(Duration(seconds: 2));

          if (mounted) {
            Navigator.pop(context, {
              'success': true,
              'planId': widget.id,
              'transactionId': response.paymentId,
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isError = true;
          _isSuccess = false;
          _statusMessage = 'An error occurred. Please try again.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      _isError = true;
      _statusMessage = 'Payment failed: ${response.message}';
      _isProcessing = false;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Failed'),
        content: Text(response.message ?? 'Please try again'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, {'success': false});
            },
          ),
          TextButton(
            child: Text('Retry'),
            onPressed: () {
              Navigator.pop(context);
              openCheckout();
            },
          ),
        ],
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    setState(() {
      _statusMessage = 'Processing external wallet payment...';
    });
  }

  void openCheckout() async {
    var options = {
      // 'key': 'rzp_live_5MsiGMuSQ2YP3m',
      'key': 'rzp_test_l5y7T0LlpGjuTh',
      'amount': widget.amount * 100,
      'name': widget.name,
      'description': widget.description,
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': '9544453993',
        'email': widget.email,
      },
      'external': {
        'wallets': ['paytm'],
      }
    };

    try {
      setState(() {
        _isProcessing = true;
        _statusMessage = 'Initializing payment...';
        _isError = false;
      });
      _razorpay.open(options);
    } catch (e) {
      setState(() {
        _isError = true;
        _statusMessage = 'Failed to initialize payment';
        _isProcessing = false;
      });
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isProcessing) return false;
        Navigator.pop(context, {'success': false});
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Inve',
                            style: TextStyle(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          TextSpan(
                            text: 'Stry',
                            style: TextStyle(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFFFCC00),
                            ),
                          ),
                          TextSpan(
                            text: 'x',
                            style: TextStyle(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 48.h),

                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _isSuccess
                          ? Colors.green[50]
                          : _isError
                          ? Colors.red[50]
                          : Color(0xFFFFF9E6),
                      shape: BoxShape.circle,
                    ),
                    child: _isProcessing
                        ? SizedBox(
                      width: 32.w,
                      height: 32.w,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFFFFCC00)),
                        strokeWidth: 3,
                      ),
                    )
                        : Icon(
                      _isSuccess
                          ? Icons.check_circle
                          : _isError
                          ? Icons.error
                          : Icons.payments_outlined,
                      size: 32.sp,
                      color: _isSuccess
                          ? Colors.green
                          : _isError
                          ? Colors.red
                          : Color(0xFFFFCC00),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  Text(
                    _statusMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 24.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '₹${widget.amount}',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),

                  if (_isError) ...[
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: openCheckout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFCC00),
                        padding: EdgeInsets.symmetric(
                            horizontal: 32.w, vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Retry Payment',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}