// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:project_emergio/Views/Auth%20Screens/login.dart';

// class PasswordChangeSuccessfullyScreen extends StatefulWidget {
//   const PasswordChangeSuccessfullyScreen({Key? key}) : super(key: key);

//   @override
//   State<PasswordChangeSuccessfullyScreen> createState() =>
//       _PasswordChangeSuccessfullyScreenState();
// }

// class _PasswordChangeSuccessfullyScreenState
//     extends State<PasswordChangeSuccessfullyScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _opacityAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );

//     _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
//     );

//     _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeIn),
//     );

//     _controller.forward();

//     Timer(const Duration(seconds: 3), () {
//       if (mounted) {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => const SignInPage()),
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: AnimatedBuilder(
//           animation: _controller,
//           builder: (context, child) {
//             return Opacity(
//               opacity: _opacityAnimation.value,
//               child: Transform.scale(
//                 scale: _scaleAnimation.value,
//                 child: child,
//               ),
//             );
//           },
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.check_circle_outline,
//                 color: Colors.green,
//                 size: 100,
//               ),
//               const SizedBox(height: 24),
//               Text(
//                 'Password Changed\nSuccessfully!',
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 'Redirecting to login...',
//                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                   color: Colors.black54,
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
import 'package:project_emergio/Views/Auth%20Screens/login.dart';
import 'package:project_emergio/generated/constants.dart';



class PasswordChangeSuccessfullyScreen extends StatefulWidget {
  const PasswordChangeSuccessfullyScreen({Key? key}) : super(key: key);

  @override
  State<PasswordChangeSuccessfullyScreen> createState() =>
      _PasswordChangeSuccessfullyScreenState();
}

class _PasswordChangeSuccessfullyScreenState
    extends State<PasswordChangeSuccessfullyScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SignInPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 100,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Password Changed\nSuccessfully!',
                    textAlign: TextAlign.center,
                    style: AppTheme.headingText(lightTextColor).copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Redirecting to login...',
                    style: AppTheme.bodyMediumTitleText(greyTextColor!).copyWith(

                    ),
                  ),
                ],
              ),
            ),
            ),
        );
}
}
