// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import flutter_secure_storage
// import 'package:lottie/lottie.dart';
// import 'dart:async';
// import '../../Widgets/bottom navbar_widget.dart';
// import 'onboarding_flow.dart';
//
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   // Create an instance of FlutterSecureStorage
//   final FlutterSecureStorage _storage = FlutterSecureStorage();
//
//   @override
//   void initState() {
//     super.initState();
//     checkLoginStatus();
//   }
//
//   Future<void> checkLoginStatus() async {
//     // Retrieve the token from secure storage
//     String? token = await _storage.read(key: 'token');
//
//     if (token != null && token.isNotEmpty) {
//       // Token exists, navigate to HomeScreen
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (context) => CustomBottomNavBar(), // Replace with your actual home screen widget
//         ),
//       );
//     } else {
//       // No token found, navigate to OnBoardingScreen1
//       navigateToOnBoardingScreen();
//     }
//   }
//
//   void navigateToOnBoardingScreen() {
//     Timer(const Duration(seconds: 2), () {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (context) => OnboardingFlow(),
//         ),
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Lottie.asset('assets/investryx_logo_splash.json'),
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import '../../Widgets/bottom navbar_widget.dart';
import '../../services/Questionnaire.dart';
import '../Auth Screens/location access page.dart';
import 'on-board1.dart';
import 'onboarding_flow.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationController.forward().then((_) => _handleNavigation());
  }

  Future<void> _handleNavigation() async {
    try {
      Map<String, dynamic>? response;
      try {
        response = await QuestionnairePost.questionnaireGet();
      } catch (e) {
        if (e is QuestionnaireException && e.statusCode == 404) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LocationAccessScreen(),
            ),
          );
          return;
        }
        print('Error fetching questionnaire: $e');
      }

      String? token = await storage.read(key: 'token');
      if (!mounted) return;

      if (token != null && token.isNotEmpty) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const CustomBottomNavBar(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const OnboardingFlow(),
          ),
        );
      }
    } catch (e) {
      print('Error during navigation: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Lottie.asset(
                'assets/investryx_logo_splash.json',
                controller: _animationController,
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                fit: BoxFit.contain,
                onLoaded: (composition) {
                  _animationController.duration = composition.duration;
                },
              );
            },
          ),
        ),
      ),
    );
  }
}