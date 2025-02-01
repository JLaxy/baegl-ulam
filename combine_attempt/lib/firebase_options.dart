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
    apiKey: 'AIzaSyB9Um8-4GYihnJ_A-J-L9juabJrwl0by70',
    appId: '1:631058400303:web:22f7abf65a19d14f9372da',
    messagingSenderId: '631058400303',
    projectId: 'proj-98b6e',
    authDomain: 'proj-98b6e.firebaseapp.com',
    databaseURL: 'https://proj-98b6e-default-rtdb.firebaseio.com',
    storageBucket: 'proj-98b6e.appspot.com',
    measurementId: 'G-TPS8ZL8Q2L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAptq5IVTHGGybSdnGJcrJ0gdNNg9INieA',
    appId: '1:631058400303:android:4330e40b871af7dd9372da',
    messagingSenderId: '631058400303',
    projectId: 'proj-98b6e',
    databaseURL: 'https://proj-98b6e-default-rtdb.firebaseio.com',
    storageBucket: 'proj-98b6e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBogaLrrz-pV7ogM0V551Zf93uERS4SObw',
    appId: '1:631058400303:ios:667180732b26fd3f9372da',
    messagingSenderId: '631058400303',
    projectId: 'proj-98b6e',
    databaseURL: 'https://proj-98b6e-default-rtdb.firebaseio.com',
    storageBucket: 'proj-98b6e.appspot.com',
    iosBundleId: 'com.example.login',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBogaLrrz-pV7ogM0V551Zf93uERS4SObw',
    appId: '1:631058400303:ios:5c58931e378ed8be9372da',
    messagingSenderId: '631058400303',
    projectId: 'proj-98b6e',
    databaseURL: 'https://proj-98b6e-default-rtdb.firebaseio.com',
    storageBucket: 'proj-98b6e.appspot.com',
    iosBundleId: 'com.example.login.RunnerTests',
  );
}
