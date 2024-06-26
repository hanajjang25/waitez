// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCL2p5aFu6A7_VfEMpnYd63HtnY5OLde2c',
    appId: '1:924566005196:web:92b0b25585a71aefabe969',
    messagingSenderId: '924566005196',
    projectId: 'waitez-39bfc',
    authDomain: 'waitez-39bfc.firebaseapp.com',
    storageBucket: 'waitez-39bfc.appspot.com',
    measurementId: 'G-BX8HMNTVS4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyANwdKJdYovhhc3yPGGiye7yXFwA6QSZ68',
    appId: '1:924566005196:android:3acf1d05a88ff670abe969',
    messagingSenderId: '924566005196',
    projectId: 'waitez-39bfc',
    storageBucket: 'waitez-39bfc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDcYLAxC8TtPD61p0iVbzMxlappHH8dN3w',
    appId: '1:924566005196:ios:16abb097811561c6abe969',
    messagingSenderId: '924566005196',
    projectId: 'waitez-39bfc',
    storageBucket: 'waitez-39bfc.appspot.com',
    iosBundleId: 'com.example.waitez',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDcYLAxC8TtPD61p0iVbzMxlappHH8dN3w',
    appId: '1:924566005196:ios:dafe6b67441cb85dabe969',
    messagingSenderId: '924566005196',
    projectId: 'waitez-39bfc',
    storageBucket: 'waitez-39bfc.appspot.com',
    iosBundleId: 'com.example.waitez.RunnerTests',
  );
}
