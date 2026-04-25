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
        return iOS;
      case TargetPlatform.macOS:
        return macOS;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by specifying the FirebaseOptions '
          'object manually',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by specifying the FirebaseOptions '
          'object manually',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyBVhFVKKg3gFsqYSYqcrvvjgA0qRjKrQ8U",
    appId: "1:194169244316:web:placeholder",
    messagingSenderId: "194169244316",
    projectId: "shifor-385ea",
    authDomain: "shifor-385ea.firebaseapp.com",
    storageBucket: "shifor-385ea.firebasestorage.app",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyBVhFVKKg3gFsqYSYqcrvvjgA0qRjKrQ8U",
    appId: "1:194169244316:android:3e7a7dede16696499ebb59",
    messagingSenderId: "194169244316",
    projectId: "shifor-385ea",
    storageBucket: "shifor-385ea.firebasestorage.app",
  );

  static const FirebaseOptions iOS = FirebaseOptions(
    apiKey: "AIzaSyBVhFVKKg3gFsqYSYqcrvvjgA0qRjKrQ8U",
    appId: "1:194169244316:ios:placeholder",
    messagingSenderId: "194169244316",
    projectId: "shifor-385ea",
    storageBucket: "shifor-385ea.firebasestorage.app",
    iosBundleId: "com.altijan.shifor",
  );

  static const FirebaseOptions macOS = FirebaseOptions(
    apiKey: "AIzaSyBVhFVKKg3gFsqYSYqcrvvjgA0qRjKrQ8U",
    appId: "1:194169244316:ios:placeholder",
    messagingSenderId: "194169244316",
    projectId: "shifor-385ea",
    storageBucket: "shifor-385ea.firebasestorage.app",
    iosBundleId: "com.altijan.shifor",
  );
}