import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  late final FirebaseAuth _firebaseAuth;

  static AuthService instance = AuthService._();

  AuthService._() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  User? get currentUser => _firebaseAuth.currentUser;

  bool get isLoggedIn => _firebaseAuth.currentUser == null ? false : true;

  Future login(String email, String password) async {
    try {
      var res = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return res;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } on Exception {
      return 'Error while logging in';
    }
  }

  Future signup(String email, String password) async {
    try {
      var res = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return res;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } on Exception {
      return 'Error while signing up';
    }
  }

  Future logout() async {
    await _firebaseAuth.signOut();
  }

  Future updateDisplayNameAndPhoneNumber(String name, String phone) async {
    try {
      await _firebaseAuth.currentUser?.updateDisplayName(name);
      await _firebaseAuth.currentUser?.reload();
    } on Exception {
      return 'Error updating data';
    }
  }
}
