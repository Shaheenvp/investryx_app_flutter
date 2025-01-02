//
// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:project_emergio/Views/pricing%20screen.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
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
//               Image.asset(
//                 'assets/logo1.png', // Replace with your logo asset
//                 width: 150,
//                 height: 150,
//               ),
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