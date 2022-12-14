// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC5nDTfuBxLCe-Wp28igKQWZVNLc3YO-sQ',
    appId: '1:1087163962327:web:0f25122e9e1204c2ef3192',
    messagingSenderId: '1087163962327',
    projectId: 'study-app-f3379',
    authDomain: 'study-app-f3379.firebaseapp.com',
    storageBucket: 'study-app-f3379.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCqU1g-Fhei1y2Cl53Z-If2YKUDJnMzw08',
    appId: '1:1087163962327:android:e819947ac4bf1918ef3192',
    messagingSenderId: '1087163962327',
    projectId: 'study-app-f3379',
    storageBucket: 'study-app-f3379.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC7wHsgBCeHQ4_SpJUx2QMMej4vJFo2HZw',
    appId: '1:1087163962327:ios:441c2b68f35a6fbcef3192',
    messagingSenderId: '1087163962327',
    projectId: 'study-app-f3379',
    storageBucket: 'study-app-f3379.appspot.com',
    iosClientId: '1087163962327-a3a9qbh21jcuf2ig2dpresqu1e473eqi.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatapplication',
  );
}
