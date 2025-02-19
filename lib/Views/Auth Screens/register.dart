import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:project_emergio/Views/Auth%20Screens/login.dart';
import 'package:project_emergio/Views/Auth%20Screens/mobile%20number.dart';
import 'package:project_emergio/Views/Auth%20Screens/reg_otp%20verification.dart';
import 'package:project_emergio/generated/constants.dart';
import '../../services/auth screens/registerOtp.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
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
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 60.h),
                      Text('Create Account',
                          style: AppTheme.headingText(buttonColor)),
                      SizedBox(height: 60.h),
                      _buildTextField(
                        controller: _nameController,
                        label: 'Name',
                        icon: Icons.person,
                        validator: _validateName,
                      ),
                      SizedBox(height: 20.h),
                      _buildTextField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: _validatePhoneNumber,
                      ),
                      SizedBox(height: 20.h),
                      _buildTextField(
                        controller: _emailController,
                        label: 'E-Mail',
                        icon: Icons.email,
                        validator: _validateEmail,
                      ),
                      SizedBox(height: 20.h),
                      _buildTextField(
                        controller: _passwordController,
                        label: 'Password',
                        icon: Icons.lock,
                        obscureText: !_isPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: greyTextColor,
                            size: 20.r,
                          ),
                          onPressed: () => setState(
                                  () => _isPasswordVisible = !_isPasswordVisible),
                        ),
                        validator: _validatePassword,
                      ),
                      SizedBox(height: 20.h),
                      _buildTextField(
                        controller: _confirmPasswordController,
                        label: 'Repeat Password',
                        icon: Icons.lock,
                        obscureText: !_isConfirmPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: greyTextColor,
                            size: 20.r,
                          ),
                          onPressed: () => setState(() =>
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                        ),
                        validator: _validateConfirmPassword,
                      ),
                      SizedBox(height: 25.h),
                      _buildSignUpButton(),
                      SizedBox(height: 30.h),
                      Text('Or sign up with',
                          style: AppTheme.mediumSmallText(greyTextColor!),
                          textAlign: TextAlign.center),
                      SizedBox(height: 16.h),
                      _buildGoogleSignInSection(),
                      SizedBox(height: 16.h),
                      _buildLoginPrompt(),
                    ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTheme.bodyMediumTitleText(lightTextColor),
        prefixIcon: Icon(icon, color: greyTextColor, size: 20.r),
        suffixIcon: suffixIcon,
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
      validator: validator,
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: _handleSignUp,
      style: ElevatedButton.styleFrom(
        foregroundColor: backgroundColor,
        backgroundColor: buttonColor,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        elevation: 2,
      ),
      child: Text(
        'Sign Up',
        style: AppTheme.titleText(backgroundColor)
            .copyWith(fontWeight: FontWeight.bold),
      ),
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

  Widget _buildGoogleSignInSection() {
    return InkWell(
      onTap: _isGoogleLoading ? null : () => signInWithGoogle(context),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          border: Border.all(color: buttonColor),
          borderRadius: BorderRadius.circular(10.r),
          color: Colors.white,
        ),
        child: _isGoogleLoading
            ? Center(
          child: SizedBox(
            height: 20.r,
            width: 20.r,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(errorIconColor),
              strokeWidth: 2.5,
            ),
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
              'Sign up with Google',
              style: AppTheme.mediumTitleText(lightTextColor)
                  .copyWith(fontWeight: FontWeight.w500,
                fontSize: 14.sp
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
          style: AppTheme.bodyMediumTitleText(lightTextColor),
        ),
        TextButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignInPage()),
          ),
          child: Text(
            'Log In',
            style: AppTheme.bodyMediumTitleText(buttonColor)
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      final String phoneNumber = _phoneController.text;
      final String email = _emailController.text;
      final response =
      await RegisterOtp.registerOtp(phone: phoneNumber, email: email);
      if (response == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Reg_OTPVerificationScreen(
              phone: phoneNumber,
              name: _nameController.text,
              email: _emailController.text,
              password: _passwordController.text,
              otp: '',
            ),
          ),
        );
      } else {
        _showSnackBar(
          'User with the same phone number or email already exists',
          true,
        );
      }
    }
  }

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      setState(() => _isGoogleLoading = true);
      debugPrint("Sign-in process started");

      await GoogleSignIn().signOut();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        setState(() => _isGoogleLoading = false);
        debugPrint('Sign-in aborted by user');
        return null;
      }

      // Show Lottie animation after user selects account
      setState(() {
        _showLottie = true;
        _isGoogleLoading = false;
      });

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        String? email = user.email;
        String? phone = user.phoneNumber;
        String? name = user.displayName;
        String? image = user.photoURL;

        debugPrint('Email: $email');
        debugPrint('Phone: ${phone ?? 'Not available'}');
        debugPrint('Name: $name');
        debugPrint('Image URL: $image');

        setState(() => _showLottie = false);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MobileNumberScreen(
              name: name,
              email: email,
              image: image,
            ),
          ),
        );
      }

      return user;
    } catch (e) {
      debugPrint("Error occurred during sign-in: $e");
      setState(() {
        _showLottie = false;
        _isGoogleLoading = false;
      });
      _showSnackBar('Error signing in with Google', true);
      return null;
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    final namePattern = RegExp(r'^[a-zA-Z ]{1,20}$');
    if (!namePattern.hasMatch(value)) {
      return 'Name must contain only alphabets and spaces, and be up to 20 characters';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    final phonePattern = RegExp(r'^[0-9]{10}$');
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!phonePattern.hasMatch(value)) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailPattern = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+\.[a-zA-Z]{2,}$');
    if (!emailPattern.hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
      return 'Password must contain at least one digit';
    }
    if (!RegExp(r'(?=.[@$!%?&#])').hasMatch(value)) {
      return 'Password must contain at least one special character (@, #, \$, etc.)';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

}
