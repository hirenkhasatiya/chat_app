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
    apiKey: 'AIzaSyD5MDCblA0bbRzmtQRCrr0XOhswiKSjFEk',
    appId: '1:917806569967:web:d0fe50996f187adfa13e1a',
    messagingSenderId: '917806569967',
    projectId: 'chat-application-d14c0',
    authDomain: 'chat-application-d14c0.firebaseapp.com',
    storageBucket: 'chat-application-d14c0.appspot.com',
    measurementId: 'G-C9EG21F520',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD-GUIGpIOPFZioP7OZFZa4eIKp5Uy4nsI',
    appId: '1:917806569967:android:f272fa337b5cb394a13e1a',
    messagingSenderId: '917806569967',
    projectId: 'chat-application-d14c0',
    storageBucket: 'chat-application-d14c0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDgyD6TTqNc2-XHVlO2Wi7Y_SkgoLEXsHM',
    appId: '1:917806569967:ios:00eef1e1550d40c6a13e1a',
    messagingSenderId: '917806569967',
    projectId: 'chat-application-d14c0',
    storageBucket: 'chat-application-d14c0.appspot.com',
    iosBundleId: 'com.example.chatApplication',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDgyD6TTqNc2-XHVlO2Wi7Y_SkgoLEXsHM',
    appId: '1:917806569967:ios:3820681874d6d31ba13e1a',
    messagingSenderId: '917806569967',
    projectId: 'chat-application-d14c0',
    storageBucket: 'chat-application-d14c0.appspot.com',
    iosBundleId: 'com.example.chatApplication.RunnerTests',
  );
}