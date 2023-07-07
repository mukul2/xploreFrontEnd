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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

    apiKey: "AIzaSyD5-B3z8MSRQYCFRhtEzqR1fKkcE2Ie5mk",
    authDomain: "xplore-education.firebaseapp.com",
    projectId: "xplore-education",
    storageBucket: "xplore-education.appspot.com",
    messagingSenderId: "236257928052",
    appId: "1:236257928052:web:f508b9f8a90f3969970221"

    // apiKey: 'AIzaSyDZp12IY9BafrRwks-W_6zHObDZWk9iQjI',
    // appId: '1:782813816644:web:00b77e0c6a4ea1191b1911',
    // messagingSenderId: '782813816644',
    // projectId: 'brain-sugar',
    // authDomain: 'brain-sugar.firebaseapp.com',
    // storageBucket: 'brain-sugar.appspot.com',
    // measurementId: 'G-3L9ERG0K95',
  );
}
