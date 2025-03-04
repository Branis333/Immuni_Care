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
    apiKey: 'AIzaSyAxoq_iqcCZno-EoL_GcwaDk1zP5P9ImtQ',
    appId: '1:1005232117970:web:1083a1c54fdbf1cba3350b',
    messagingSenderId: '1005232117970',
    projectId: 'immunicare-f7f24',
    authDomain: 'immunicare-f7f24.firebaseapp.com',
    storageBucket: 'immunicare-f7f24.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAwwtCuPL9fIVcWVenbuAKCKOcsXuKeKQ0',
    appId: '1:1005232117970:android:43ee21ad3e0361b2a3350b',
    messagingSenderId: '1005232117970',
    projectId: 'immunicare-f7f24',
    storageBucket: 'immunicare-f7f24.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCZ1oOBW9SrBoizbRFfRsJjdmHoQObYlC8',
    appId: '1:1005232117970:ios:4044d68974c21557a3350b',
    messagingSenderId: '1005232117970',
    projectId: 'immunicare-f7f24',
    storageBucket: 'immunicare-f7f24.firebasestorage.app',
    iosBundleId: 'com.example.immunicare',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCZ1oOBW9SrBoizbRFfRsJjdmHoQObYlC8',
    appId: '1:1005232117970:ios:4044d68974c21557a3350b',
    messagingSenderId: '1005232117970',
    projectId: 'immunicare-f7f24',
    storageBucket: 'immunicare-f7f24.firebasestorage.app',
    iosBundleId: 'com.example.immunicare',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAxoq_iqcCZno-EoL_GcwaDk1zP5P9ImtQ',
    appId: '1:1005232117970:web:602759a3dbe133b3a3350b',
    messagingSenderId: '1005232117970',
    projectId: 'immunicare-f7f24',
    authDomain: 'immunicare-f7f24.firebaseapp.com',
    storageBucket: 'immunicare-f7f24.firebasestorage.app',
  );
}
