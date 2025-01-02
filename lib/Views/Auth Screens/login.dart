// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:lottie/lottie.dart';
// import 'package:project_emergio/Views/Auth%20Screens/ForgotPassword/forgot%20password.dart';
// import 'package:project_emergio/Views/Auth%20Screens/register.dart';
// import 'package:project_emergio/generated/constants.dart';
// import 'package:project_emergio/services/social.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../Widgets/bottom navbar_widget.dart';
// import '../../Widgets/custom textfeild.dart';
//
// import '../../services/auth screens/signIn.dart';
//
//
// class SignInPage extends StatefulWidget {
//   const SignInPage({Key? key}) : super(key: key);
//
//   @override
//   State<SignInPage> createState() => _SignInPageState();
// }
//
// class _SignInPageState extends State<SignInPage> {
//   final phoneNumberController = TextEditingController();
//   final passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _obscureText = true;
//   bool _isLoading = false;
//   bool _isGoogleLoading = false;
//   bool _showLottie = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Scaffold(
//           body: SafeArea(
//             child: Center(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 22.w),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         _buildHeaderSection(),
//                         SizedBox(height: 35.h),
//                         _buildTextField(
//                           label: 'Phone Number',
//                           controller: phoneNumberController,
//                           validator: _validatePhoneNumber,
//                           keyboardType: TextInputType.number,
//                           prefixIcon: Icon(Icons.phone,
//                               color: greyTextColor!, size: 18.r),
//                         ),
//                         SizedBox(height: 14.h),
//                         _buildTextField(
//                           label: 'Password',
//                           controller: passwordController,
//                           validator: _validatePassword,
//                           obscureText: _obscureText,
//                           prefixIcon: Icon(Icons.lock,
//                               color: greyTextColor!, size: 18.r),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _obscureText
//                                   ? Icons.visibility_off
//                                   : Icons.visibility,
//                               color: boxShadowColor,
//                               size: 18.r,
//                             ),
//                             onPressed: () =>
//                                 setState(() => _obscureText = !_obscureText),
//                           ),
//                         ),
//                         SizedBox(height: 6.h),
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: TextButton(
//                             onPressed: () => Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       Forgot_passwordScreen()),
//                             ),
//                             child: Text(
//                               'Forgot Password?',
//                               style: AppTheme.smallText(lightTextColor),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 20.h),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: buttonColor,
//                             padding: EdgeInsets.symmetric(vertical: 12.h),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(7.r),
//                             ),
//                           ),
//                           onPressed: _isLoading ? null : _handleSignIn,
//                           child: _isLoading
//                               ? SizedBox(
//                             height: 20.r,
//                             width: 20.r,
//                             child: CircularProgressIndicator(
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                   backgroundColor),
//                               strokeWidth: 2.5,
//                             ),
//                           )
//                               : Text(
//                             'Sign In',
//                             style:
//                             AppTheme.mediumSmallText(backgroundColor),
//                           ),
//                         ),
//                         SizedBox(height: 50.h),
//                         _buildGoogleSignInSection(),
//                         SizedBox(height: 50.h),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Don\'t have an account?',
//                               style: AppTheme.mediumSmallText(lightTextColor),
//                             ),
//                             TextButton(
//                               onPressed: () => Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => SignUpScreen()),
//                               ),
//                               child: Text(
//                                 'Sign Up',
//                                 style: AppTheme.mediumSmallText(buttonColor)
//                                     .copyWith(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         if (_showLottie)
//           Container(
//             color: Colors.white.withOpacity(0.8),
//             child: Center(
//               child: SizedBox(
//                   height: 120.h,
//                   child: Lottie.asset('assets/google_loading.json')),
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildHeaderSection() {
//     return Column(
//       children: [
//         SizedBox(height: 30.h),
//         Text(
//           'Welcome Back',
//           style: AppTheme.headingText(buttonColor).copyWith(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 6.h),
//         Text(
//           'Sign in to continue',
//           style: AppTheme.mediumTitleText(greyTextColor!),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTextField({
//     required String label,
//     required TextEditingController controller,
//     required String? Function(String?) validator,
//     bool obscureText = false,
//     Widget? suffixIcon,
//     Widget? prefixIcon,
//     TextInputType? keyboardType,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: AppTheme.smallText(lightTextColor)
//               .copyWith(fontWeight: FontWeight.w500),
//         ),
//         SizedBox(height: 6.h),
//         CustomTextFormField(
//           controller: controller,
//           obscureText: obscureText,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(7.r),
//               borderSide: BorderSide(color: buttonColor),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(7.r),
//               borderSide: BorderSide(color: buttonColor),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(7.r),
//               borderSide: BorderSide(color: businessContainerColor),
//             ),
//             prefixIcon: prefixIcon,
//             suffixIcon: suffixIcon,
//             contentPadding:
//             EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
//           ),
//           validator: validator,
//           keyboardType: keyboardType,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildGoogleSignInSection() {
//     return Column(
//       children: [
//         Text('Or sign in with',
//             style: AppTheme.mediumSmallText(greyTextColor!)),
//         SizedBox(height: 25.h),
//         InkWell(
//           onTap: _isGoogleLoading ? null : () => signInWithGoogle(context),
//           child: Container(
//             padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
//             decoration: BoxDecoration(
//               border: Border.all(color: buttonColor),
//               borderRadius: BorderRadius.circular(7.r),
//             ),
//             child: _isGoogleLoading
//                 ? SizedBox(
//               height: 20.r,
//               width: 20.r,
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(errorIconColor),
//                 strokeWidth: 2.5,
//               ),
//             )
//                 : Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(FontAwesomeIcons.google,
//                     color: errorIconColor, size: 20.r),
//                 SizedBox(width: 10.w),
//                 Text(
//                   'Sign in with Google',
//                   style: AppTheme.bodyMediumTitleText(lightTextColor)
//                       .copyWith(fontWeight: FontWeight.w500),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Future<User?> signInWithGoogle(BuildContext context) async {
//     try {
//       setState(() => _isGoogleLoading = true); // Show loading spinner in button
//
//       // Sign out before signing in to force account selection
//       await GoogleSignIn().signOut();
//
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       if (googleUser == null) {
//         setState(() => _isGoogleLoading = false);
//         return null;
//       }
//
//       // After user selects account, show Lottie animation
//       setState(() {
//         _showLottie = true;
//         _isGoogleLoading = false; // Hide the button loading spinner
//       });
//
//       final GoogleSignInAuthentication googleAuth =
//       await googleUser.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//
//       final UserCredential userCredential =
//       await FirebaseAuth.instance.signInWithCredential(credential);
//       final User? user = userCredential.user;
//
//       if (user != null) {
//         final response = await Social.google(email: user.email.toString());
//         if (response == true) {
//           Navigator.pushReplacement(context,
//               MaterialPageRoute(builder: (context) => CustomBottomNavBar()));
//         } else {
//           setState(() => _showLottie = false);
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//                 content: Text(
//                   'User not registered',
//                   style: AppTheme.mediumHeadingText(lightTextColor),
//                 ),
//                 duration: Duration(seconds: 2)),
//           );
//         }
//       }
//
//       return user;
//     } catch (e) {
//       print("Error during Google sign-in: $e");
//       setState(() {
//         _showLottie = false;
//         _isGoogleLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text(
//               'Error signing in with Google',
//               style: AppTheme.mediumHeadingText(lightTextColor),
//             ),
//             duration: Duration(seconds: 2)),
//       );
//       return null;
//     }
//   }
//
//   void _handleSignIn() async {
//     if (_formKey.currentState!.validate()) {
//       final phoneNumber = phoneNumberController.text.trim();
//       final password = passwordController.text.trim();
//
//       final response = await signIn(phoneNumber, password);
//
//       if (response == true) {
//         await saveCredentials(phoneNumber, password);
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => CustomBottomNavBar()),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'Invalid Credentials: Incorrect Username and Password',
//               style: AppTheme.mediumHeadingText(lightTextColor),
//             ),
//             duration: Duration(seconds: 2),
//           ),
//         );
//       }
//     }
//   }
//
//   Future<void> saveCredentials(String phoneNumber, String password) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('phoneNumber', phoneNumber);
//     await prefs.setString('password', password);
//   }
//
//   String? _validatePhoneNumber(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Phone number is required';
//     } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
//       return 'Enter a valid 10-digit phone number';
//     }
//     return null;
//   }
//
//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Password is required';
//     } else if (value.length < 6) {
//       return 'Password must be at least 6 characters long';
//     }
//     return null;
//     }
// }


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:project_emergio/Views/Auth%20Screens/ForgotPassword/forgot%20password.dart';
import 'package:project_emergio/Views/Auth%20Screens/register.dart';
import 'package:project_emergio/generated/constants.dart';
import 'package:project_emergio/services/social.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Widgets/bottom navbar_widget.dart';
import '../../Widgets/custom textfeild.dart';
import '../../services/auth screens/signIn.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _showLottie = false;

  void _showSnackBar(String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error : Icons.check_circle,
              color: Colors.white,
              size: 20.r,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeaderSection(),
                        SizedBox(height: 35.h),
                        _buildTextField(
                          label: 'Phone Number',
                          controller: phoneNumberController,
                          validator: _validatePhoneNumber,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icon(Icons.phone,
                              color: greyTextColor!, size: 18.r),
                        ),
                        SizedBox(height: 14.h),
                        _buildTextField(
                          label: 'Password',
                          controller: passwordController,
                          validator: _validatePassword,
                          obscureText: _obscureText,
                          prefixIcon: Icon(Icons.lock,
                              color: greyTextColor!, size: 18.r),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: boxShadowColor,
                              size: 18.r,
                            ),
                            onPressed: () =>
                                setState(() => _obscureText = !_obscureText),
                          ),
                        ),
                        _buildForgotPasswordButton(),
                        SizedBox(height: 20.h),
                        _buildSignInButton(),
                        SizedBox(height: 50.h),
                        _buildGoogleSignInSection(),
                        SizedBox(height: 50.h),
                        _buildSignUpSection(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_showLottie) _buildLottieOverlay(),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        SizedBox(height: 30.h),
        Text(
          'Welcome Back',
          style: AppTheme.headingText(buttonColor).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Sign in to continue',
          style: AppTheme.mediumTitleText(greyTextColor!),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool obscureText = false,
    Widget? suffixIcon,
    Widget? prefixIcon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.smallText(lightTextColor)
              .copyWith(fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 6.h),
        CustomTextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7.r),
              borderSide: BorderSide(color: buttonColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7.r),
              borderSide: BorderSide(color: buttonColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7.r),
              borderSide: BorderSide(color: businessContainerColor),
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding:
            EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          ),
          validator: validator,
          keyboardType: keyboardType,
        ),
      ],
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Forgot_passwordScreen()),
        ),
        child: Text(
          'Forgot Password?',
          style: AppTheme.smallText(lightTextColor),
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.r),
        ),
      ),
      onPressed: _isLoading ? null : _handleSignIn,
      child: _isLoading
          ? SizedBox(
        height: 20.r,
        width: 20.r,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(backgroundColor),
          strokeWidth: 2.5,
        ),
      )
          : Text(
        'Sign In',
        style: AppTheme.mediumSmallText(backgroundColor),
      ),
    );
  }

  Widget _buildGoogleSignInSection() {
    return Column(
      children: [
        Text('Or sign in with',
            style: AppTheme.mediumSmallText(greyTextColor!)),
        SizedBox(height: 25.h),
        InkWell(
          onTap: _isGoogleLoading ? null : () => signInWithGoogle(context),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            decoration: BoxDecoration(
              border: Border.all(color: buttonColor),
              borderRadius: BorderRadius.circular(7.r),
              color: Colors.white,
            ),
            child: _isGoogleLoading
                ? SizedBox(
              height: 20.r,
              width: 20.r,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(errorIconColor),
                strokeWidth: 2.5,
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24.r,
                  height: 24.r,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/google_logo.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  'Sign in with Google',
                  style: AppTheme.bodyMediumTitleText(lightTextColor)
                      .copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account?',
          style: AppTheme.mediumSmallText(lightTextColor),
        ),
        TextButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignUpScreen()),
          ),
          child: Text(
            'Sign Up',
            style: AppTheme.mediumSmallText(buttonColor).copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLottieOverlay() {
    return Container(
      color: Colors.white.withOpacity(0.8),
      child: Center(
        child: SizedBox(
          height: 120.h,
          child: Lottie.asset('assets/google_loading.json'),
        ),
      ),
    );
  }

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      setState(() => _isGoogleLoading = true);

      // Clear previous Google sign-in session
      await GoogleSignIn().signOut();

      // Initiate Google sign-in
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // Sign-in canceled by user
        setState(() => _isGoogleLoading = false);
        return null;
      }

      // Show a loading indicator
      setState(() {
        _showLottie = true;
        _isGoogleLoading = false;
      });

      // Authenticate with Firebase using Google credentials
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Custom server-side authentication call
        final response = await Social.google(email: user.email.toString());
        if (response == true) {
          _showSnackBar('Successfully signed in with Google', false);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CustomBottomNavBar()),
          );
        } else {
          setState(() => _showLottie = false);
          _showSnackBar('User not registered', true);
        }
      }
      return user;
    } catch (e) {
      print("Error during Google sign-in: $e");
      setState(() {
        _showLottie = false;
        _isGoogleLoading = false;
      });
      _showSnackBar('Error signing in with Google', true);
      return null;
    }
  }

  void _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final phoneNumber = phoneNumberController.text.trim();
      final password = passwordController.text.trim();

      final response = await signIn(phoneNumber, password);

      setState(() => _isLoading = false);

      if (response == true) {
        await saveCredentials(phoneNumber, password);
        _showSnackBar('Successfully signed in', false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CustomBottomNavBar(
            isFirstTime: true,
          )),
        );
      } else {
        _showSnackBar('Invalid username or password', true);
      }
    }
  }

  Future<void> saveCredentials(String phoneNumber, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('phoneNumber', phoneNumber);
    await prefs.setString('password', password);
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }
}