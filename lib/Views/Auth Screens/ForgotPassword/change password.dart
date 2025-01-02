// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:project_emergio/Views/Auth%20Screens/ForgotPassword/password%20changed%20successfully.dart';
// import 'package:project_emergio/services/auth%20screens/change%20password.dart';
// import '../../../Widgets/custom textfeild.dart';
//
// class ChangePasswordScreen extends StatefulWidget {
//   final String phoneNumber;
//
//   const ChangePasswordScreen({super.key, required this.phoneNumber});
//
//   @override
//   State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
// }
//
// class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   bool _isPasswordVisible = false;
//
//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your password';
//     }
//     if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$').hasMatch(value)) {
//       return 'Password must be at least 8 characters long and include:\n- One uppercase letter\n- One lowercase letter\n- One digit\n- One special character';
//     }
//     return null;
//   }
//
//   String? _validateConfirmPassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please confirm your password';
//     }
//     if (value != passwordController.text) {
//       return 'Passwords do not match';
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
//             Navigator.pop(context);
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
//               Text(
//                 'Change Password for ${widget.phoneNumber}',
//                 style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 50.h),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 18.w),
//                 child: CustomTextFormField(
//                   controller: passwordController,
//                   obscureText: !_isPasswordVisible,
//                   decoration: InputDecoration(
//                     hintText: 'New Password',
//                     border: OutlineInputBorder(),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _isPasswordVisible = !_isPasswordVisible;
//                         });
//                       },
//                     ),
//                   ),
//                   validator: _validatePassword,
//                 ),
//               ),
//               SizedBox(height: 20.h),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 18.w),
//                 child: CustomTextFormField(
//                   controller: confirmPasswordController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     hintText: 'Confirm Password',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: _validateConfirmPassword,
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
//                         borderRadius: BorderRadius.circular(10.r)),
//                   ),
//                   onPressed: () async {
//                     if (_formKey.currentState!.validate()) {
//                       final response = await ChangePassword.changePassword(
//                         password: passwordController.text,
//                         phoneNumber: widget.phoneNumber,
//                       );
//                       if (response == true) {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 PasswordChangeSuccessfullyScreen(),
//                           ),
//                         );
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             duration: Duration(milliseconds: 800),
//                             content: Text('Change password failed'),
//                           ),
//                         );
//                       }
//                     }
//                   },
//                   child: Text(
//                     'Submit',
//                     style: TextStyle(color: Colors.white, fontSize: 13.sp),
//                   ),
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
import 'package:project_emergio/Views/Auth%20Screens/ForgotPassword/password%20changed%20successfully.dart';
import 'package:project_emergio/services/auth%20screens/change%20password.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String? phoneNumber;

  const ChangePasswordScreen({super.key, this.phoneNumber});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool _hasUpperCase = false;
  bool _hasLowerCase = false;
  bool _hasDigit = false;
  bool _hasSpecialChar = false;
  bool _hasMinLength = false;

  @override
  void initState() {
    super.initState();
    passwordController.addListener(_updatePasswordStrength);
  }

  @override
  void dispose() {
    passwordController.removeListener(_updatePasswordStrength);
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePasswordStrength() {
    setState(() {
      _hasUpperCase = passwordController.text.contains(RegExp(r'[A-Z]'));
      _hasLowerCase = passwordController.text.contains(RegExp(r'[a-z]'));
      _hasDigit = passwordController.text.contains(RegExp(r'\d'));
      _hasSpecialChar = passwordController.text.contains(RegExp(r'[@$!%*?&+-/#]'));
      _hasMinLength = passwordController.text.length >= 8;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_outlined,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 40.h),
                    Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffFFCC00),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Create a new password for ${widget.phoneNumber}',
                      style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40.h),
                    _buildPasswordField(),
                    SizedBox(height: 20.h),
                    _buildConfirmPasswordField(),
                    SizedBox(height: 10.h),
                    _buildPasswordStrengthIndicator(),
                    SizedBox(height: 40.h),
                    _buildSubmitButton(),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: !_isPasswordVisible,
      onChanged: (_) => _updatePasswordStrength(),
      decoration: InputDecoration(
        labelText: 'New Password',
        hintText: 'Enter your new password',
        prefixIcon: Icon(Icons.lock, color: Colors.black54, size: 20.r),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.black54,
            size: 20.r,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Color(0xffFFCC00)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Color(0xffFFCC00),),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Color(0xffFFCC00)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      ),
      validator: _validatePassword,
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStrengthCheckbox(_hasUpperCase, 'One uppercase letter'),
        _buildStrengthCheckbox(_hasLowerCase, 'One lowercase letter'),
        _buildStrengthCheckbox(_hasDigit, 'One digit'),
        _buildStrengthCheckbox(_hasSpecialChar, 'One special character'),
        _buildStrengthCheckbox(_hasMinLength, 'At least 8 characters'),
      ],
    );
  }

  Widget _buildStrengthCheckbox(bool isChecked, String label) {
    return Row(
      children: [
        Icon(
          isChecked ? Icons.check_box : Icons.check_box_outline_blank,
          color: isChecked ? Colors.green : Colors.grey,
          size: 20.r,
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: confirmPasswordController,
      obscureText: !_isConfirmPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        hintText: 'Confirm your new password',
        prefixIcon: Icon(Icons.lock, color: Colors.black54, size: 20.r),
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.black54,
            size: 20.r,
          ),
          onPressed: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Color(0xffFFCC00),),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Color(0xffFFCC00),),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Color(0xffFFCC00)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      ),
      validator: _validateConfirmPassword,
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xffFFCC00),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 16.h),
      ),
      onPressed: _handleSubmit,
      child: Text(
        'Change Password',
        style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final response = await ChangePassword.changePassword(
        password: passwordController.text,
        phoneNumber: widget.phoneNumber,
      );
      if (response == true) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => PasswordChangeSuccessfullyScreen(),
          ),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 800),
            content: Text('Change password failed'),
          ),
        );
      }
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (!_hasUpperCase || !_hasLowerCase || !_hasDigit || !_hasSpecialChar || !_hasMinLength) {
      return 'Please meet all password requirements';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}