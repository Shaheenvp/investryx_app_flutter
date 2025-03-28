// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBgbxQ6LZxyM1YCnDdniixjuDj_z5kfc6c',
    appId: '1:548448996262:web:c414f7b822dd69094c5d67',
    messagingSenderId: '548448996262',
    projectId: 'investryx',
    authDomain: 'investryx.firebaseapp.com',
    storageBucket: 'investryx.firebasestorage.app',
    measurementId: 'G-52TVHYH5BL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBj49fTPZzx14jDMrLGG_yuFI2YkV-a7ak',
    appId: '1:548448996262:android:7c824da04bd925ea4c5d67',
    messagingSenderId: '548448996262',
    projectId: 'investryx',
    storageBucket: 'investryx.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCU-QOCJ4_u6_mn2rM4nwCvGput6f0wMt4',
    appId: '1:548448996262:ios:06127908764916c04c5d67',
    messagingSenderId: '548448996262',
    projectId: 'investryx',
    storageBucket: 'investryx.firebasestorage.app',
    iosBundleId: 'com.investryx.projectEmergio',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCU-QOCJ4_u6_mn2rM4nwCvGput6f0wMt4',
    appId: '1:548448996262:ios:06127908764916c04c5d67',
    messagingSenderId: '548448996262',
    projectId: 'investryx',
    storageBucket: 'investryx.firebasestorage.app',
    iosBundleId: 'com.investryx.projectEmergio',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBgbxQ6LZxyM1YCnDdniixjuDj_z5kfc6c',
    appId: '1:548448996262:web:eb33f96a3a0c7eb64c5d67',
    messagingSenderId: '548448996262',
    projectId: 'investryx',
    authDomain: 'investryx.firebaseapp.com',
    storageBucket: 'investryx.firebasestorage.app',
    measurementId: 'G-0VCT6F5BQM',
  );
}
