import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class ForumSampleFirebaseUser {
  ForumSampleFirebaseUser(this.user);
  User? user;
  bool get loggedIn => user != null;
}

ForumSampleFirebaseUser? currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<ForumSampleFirebaseUser> forumSampleFirebaseUserStream() =>
    FirebaseAuth.instance
        .authStateChanges()
        .debounce((user) => user == null && !loggedIn
            ? TimerStream(true, const Duration(seconds: 1))
            : Stream.value(user))
        .map<ForumSampleFirebaseUser>(
      (user) {
        currentUser = ForumSampleFirebaseUser(user);
        return currentUser!;
      },
    );
