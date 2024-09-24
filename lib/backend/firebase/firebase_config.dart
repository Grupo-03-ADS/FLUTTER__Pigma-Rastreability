import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (!kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBEJVdwwkuI94EttqMjelz5sIaSwFQDs18",
            authDomain: "maps-tracking-oky45h.firebaseapp.com",
            projectId: "maps-tracking-oky45h",
            storageBucket: "maps-tracking-oky45h.appspot.com",
            messagingSenderId: "29338838690",
            appId: "1:29338838690:web:001e6c3892037ef84c19fb"));
  } else {
    await Firebase.initializeApp();
  }
}
