import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/Views/Auth%20Screens/login.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:animated_switcher/animated_switcher.dart';
import 'on-board1.dart';
import 'on-board2.dart';
import 'on-board3.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  _OnboardingFlowState createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _currentPage = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      OnBoardingScreen1(onNext: () => _navigateToPage(1)),
      OnBoardingScreen2(
        onNext: () => _navigateToPage(2),
        onBack: () => _navigateToPage(0),
      ),
      OnBoardingScreen3(
        onBack: () => _navigateToPage(1),
        onFinish: _onFinish,
      ),
    ];
  }

  void _navigateToPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onFinish() {
    // Handle finish action
    print('Onboarding completed');
    // Navigate to the main app or home screen
    // For example:
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SignInPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: KeyedSubtree(
              key: ValueKey<int>(_currentPage),
              child: _pages[_currentPage],
            ),
          ),
          Positioned(
            bottom: 100.h,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: PageController(initialPage: _currentPage),
                count: _pages.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: Colors.amber,
                  dotColor: Colors.amber.withOpacity(0.3),
                  dotHeight: 10,
                  dotWidth: 10,
                  spacing: 5,
                ),
                onDotClicked: _navigateToPage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}