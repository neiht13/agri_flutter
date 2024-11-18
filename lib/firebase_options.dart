// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyBC7OYvBIC_u835qd0yMTtNn8mDQZZHo2c',
    appId: '1:542478251453:web:0036bbbd188a040ca64ed4',
    messagingSenderId: '542478251453',
    projectId: 'agribean-c8a33',
    authDomain: 'agribean-c8a33.firebaseapp.com',
    storageBucket: 'agribean-c8a33.appspot.com',
    measurementId: 'G-G1NRV398NS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCcShlklRLEjCOtU-KF9AZ3CA1Q_732XAQ',
    appId: '1:542478251453:android:9d83debf4a35c3c2a64ed4',
    messagingSenderId: '542478251453',
    projectId: 'agribean-c8a33',
    storageBucket: 'agribean-c8a33.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBPxadFlylLaC2HAsIm_jQOWA7gUg_j8sQ',
    appId: '1:542478251453:ios:06e4b1eb4bca18e2a64ed4',
    messagingSenderId: '542478251453',
    projectId: 'agribean-c8a33',
    storageBucket: 'agribean-c8a33.appspot.com',
    iosBundleId: 'com.example.agricplant.agriplant',
  );
}
