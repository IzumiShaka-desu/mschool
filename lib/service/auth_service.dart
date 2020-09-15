import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  final GoogleSignIn googleSignIn=GoogleSignIn();

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
  Future<User> signInWithGoogle()async{
    final GoogleSignInAccount googleSignInAccount=await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication=await googleSignInAccount.authentication;
    final AuthCredential credential=GoogleAuthProvider.credential(idToken:googleSignInAuthentication.idToken,accessToken: googleSignInAuthentication.accessToken);
    final User user=(await auth.signInWithCredential(credential)).user;
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
