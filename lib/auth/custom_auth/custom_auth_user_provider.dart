import 'package:rxdart/rxdart.dart';

import 'custom_auth_manager.dart';

class PigmaAuthUser {
  PigmaAuthUser({required this.loggedIn, this.uid});

  bool loggedIn;
  String? uid;
}

/// Generates a stream of the authenticated user.
BehaviorSubject<PigmaAuthUser> pigmaAuthUserSubject =
    BehaviorSubject.seeded(PigmaAuthUser(loggedIn: false));
Stream<PigmaAuthUser> pigmaAuthUserStream() =>
    pigmaAuthUserSubject.asBroadcastStream().map((user) => currentUser = user);
