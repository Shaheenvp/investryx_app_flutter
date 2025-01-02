// import 'package:flutter/material.dart';
// import 'package:project_emergio/Views/Auth%20Screens/login.dart';
//
// import 'on-board3.dart';
// class OnBoardingScreen4 extends StatefulWidget {
//   const OnBoardingScreen4({super.key});
//
//   @override
//   State<OnBoardingScreen4> createState() => _OnBoardingScreen4State();
// }
//
// class _OnBoardingScreen4State extends State<OnBoardingScreen4> {
//   @override
//   Widget build(BuildContext context) {
//     final h =MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(children: [
//           SizedBox(
//             height: h,
//             width: w,
//             child: Image.asset(
//               'assets/onboard4.png',
//               fit: BoxFit.cover,
//             ),
//           ),
//           Container(
//             height: h,
//             width: w,
//             color: Colors.black45,
//           ),
//           Positioned(
//             top: 180,
//             left: 01,
//             right: 1,
//             child: Padding(
//               padding: const EdgeInsets.all(6.0),
//               child: Text('Advisor Options',style: TextStyle(color: Color(0xffF57C51)
//                   ,fontWeight: FontWeight.bold,
//                   fontSize: w*0.123,
//                   height: 1.3
//               ),),
//             ),
//           ),
//           Positioned(
//             top: h*0.27,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text('Our advisors are dedicated to strategic decision\nmaking guiding you towards your goals with\npurpose and precision. With their expertise, every\nstep is a deliberate move towards success',style: TextStyle(color: Colors.white,
//                   fontSize: w*0.041
//               ),),
//             ),
//           ),
//           Positioned(
//               top: h*0.42,
//               left: 10,
//               child: SizedBox(
//                 height: 45,
//                 width: 177,
//                 child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xff000000),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
//                     ),
//                     onPressed: (){
//                     }, child: Text('500+ Trusted Advisors',style: TextStyle(color: Colors.white,fontSize: h*0.014),)),
//               )),
//           Positioned(
//               top: 720,
//               left: 25,
//               child: TextButton( onPressed: () {
//                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OnBoardingScreen3()));
//               }, child: Text('Back',style: TextStyle(
//                   fontSize: 17,
//                   color: Colors.white),))),
//           Positioned(
//               top: 720,
//               left: 310,
//               child: TextButton(onPressed: () {
//                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignInPage()));
//               }, child: Text('Next',style: TextStyle(
//                   fontSize: 17,
//                   color: Colors.white),),)),
//         ]),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/Views/Auth%20Screens/login.dart';
import 'on-board3.dart';

class OnBoardingScreen4 extends StatefulWidget {
  const OnBoardingScreen4({super.key});

  @override
  State<OnBoardingScreen4> createState() => _OnBoardingScreen4State();
}

class _OnBoardingScreen4State extends State<OnBoardingScreen4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Image.asset(
                'assets/onboard4.png',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black45,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 160.h,
                  ),
                  Padding(
                    padding: EdgeInsets.all(6.w),
                    child: Text(
                      'Advisor Options',
                      style: TextStyle(
                        color: Color(0xffF57C51),
                        fontWeight: FontWeight.bold,
                        fontSize: 30.sp,
                        height: 1.3,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(6.w),
                    child: Text(
                      'Our advisors are dedicated to strategic decision\nmaking guiding you towards your goals with\npurpose and precision. With their expertise, every\nstep is a deliberate move towards success',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.all(6.w),
                    child: SizedBox(
                      height: 45.h,
                      width: 177.w,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff000000),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          '500+ Trusted Advisors',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 290.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(6.w),
                        child: TextButton(
                          onPressed: () {
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => OnBoardingScreen3()),
                            // );
                          },
                          child: Text(
                            'Back',
                            style: TextStyle(
                              fontSize: 17.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(6.w),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()),
                            );
                          },
                          child: Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 17.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
