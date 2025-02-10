import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'; // kIsWeb

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      // Web configuration
      return const FirebaseOptions(
        apiKey: 'AIzaSyBfZl7xI7oIpKKEAPMNaeKyeFpAUcYBm2Q',
        appId: '1:427931711458:web:72246de49bbeb303b02bbb',
        messagingSenderId: '427931711458',
        projectId: 'tera-flow',
        authDomain: 'tera-flow.firebaseapp.com',
        //databaseURL: 'your-database-url',
        storageBucket: 'tera-flow.firebasestorage.app',
        //measurementId: 'your-measurement-id',
      );
    } else {
      // Mobile (Android/iOS) configuration
      return const FirebaseOptions(
        apiKey: 'AIzaSyDe8O_Yp_KydmKJ0L1A_gh9RXsTZqYq3KE',
        appId: '1:427931711458:android:96a13b8033ed4b74b02bbb',
        messagingSenderId: '427931711458 ',
        projectId: 'tera-flow',
        authDomain: 'tera-flow.firebaseapp.com',
        // databaseURL: 'your-database-url',
        storageBucket: 'tera-flow.firebasestorage.app',
        //measurementId: 'your-measurement-id',
      );
    }
  }
}
