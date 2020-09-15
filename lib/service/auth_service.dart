import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<User> signIn(String email, String password);
  Future<void> signOut();
  Future<User> register(String email, String password);
  Future<void> sendEmailVerification();
  Future<bool> isVerifiedMail();
  Future<User> getCurrentUser();
}

class AuthService implements BaseAuth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<User> register(String email, String password) async {
    User user = (await auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user;
  }

  @override
  Future<User> signIn(String email, String password) async {
    User user = (await auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user;
  }

  @override
  Future<User> getCurrentUser() async => auth.currentUser;

  @override
  Future<bool> isVerifiedMail() async => auth.currentUser.emailVerified;

  @override
  Future<void> sendEmailVerification() async =>
      auth.currentUser.sendEmailVerification();

  @override
  Future<void> signOut() async => auth.signOut();
}
