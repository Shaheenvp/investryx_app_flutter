import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_emergio/Views/On-board%20Screens/splash.dart';
import 'package:project_emergio/firebase_options.dart';
import 'Views/chat_screens/websocket integration.dart';
import 'demo.dart';
import 'demo2.dart';
import 'generated/constants.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    // options: const FirebaseOptions(
    //   apiKey: "AIzaSyDnmhOunkR9ubo-I011H9wj9FNMnmQWi-I",
    //   appId: "1:921940068975:android:1cc22aefdf1a645469db9a",
    //   messagingSenderId: "921940068975",
    //   projectId: "emergio-2abb8",
    // ),
  );

  // Initialize WebSocket Service
  await WebSocketManager().connect();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Investryx',
          theme: ThemeData(
            // textTheme: GoogleFonts.poppinsTextTheme(),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            scaffoldBackgroundColor: backgroundColor,
            appBarTheme: const AppBarTheme(
              backgroundColor: backgroundColor,
            ),
          ),
          navigatorKey: navigatorKey,
          home: SplashScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}