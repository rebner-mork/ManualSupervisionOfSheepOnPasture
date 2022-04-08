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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCRxlk2vXTO0z8FYNGEyt9wNE_yWc8M5c0',
    appId: '1:867330479261:android:a2909a54354bcec03c3074',
    messagingSenderId: '867330479261',
    projectId: 'master-backend-93896',
    storageBucket: 'master-backend-93896.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCHPU3HI9R8NLNod_BEEOx8_x2YfD1PdlI',
    appId: '1:867330479261:ios:4d9cd24b698481e73c3074',
    messagingSenderId: '867330479261',
    projectId: 'master-backend-93896',
    storageBucket: 'master-backend-93896.appspot.com',
    iosClientId: '867330479261-rm5k0la2clbg9p4t6mlugshumg7a5nlv.apps.googleusercontent.com',
    iosBundleId: 'ios.master.sheep',
  );
}