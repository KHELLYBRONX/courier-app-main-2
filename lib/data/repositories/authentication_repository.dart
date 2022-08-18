import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:truckngo/models/models.dart';
import 'package:truckngo/models/wrappers/auth_data.dart';
import 'package:truckngo/models/wrappers/auth_status.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthenticationRepository {
  final _controller = StreamController<AuthStatus>();
  final storage = const FlutterSecureStorage();
  firebase_auth.FirebaseAuth auth = firebase_auth.FirebaseAuth.instance;
  late String token;

  Stream<AuthStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield const AuthStatus.unknown();
    yield* _controller.stream;
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      firebase_auth.UserCredential result =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(result.user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      firebase_auth.UserCredential result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;
      AuthData? authData =
          AuthData((b) => b..user = User((a) => a..id = user?.uid).toBuilder());
      _controller.add(AuthStatus.authenticated(authData));
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        auth.signOut(),
      ]);
      _controller.add(
        AuthStatus.unauthenticated(
          AuthData(
            (b) => b
              ..accessToken = ""
              ..user = User((a) => a
                ..id = ""
                ..email = "").toBuilder(),
          ),
        ),
      );
    } catch (_) {
      throw LogOutFailure();
    }
  }

  // Stream<User> get user {
  //   return auth.authStateChanges().map((firebaseUser) {
  //     final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
  //     _cache.write(key: userCacheKey, value: user);
  //     return user;
  //   });
  // }

  // User get currentUser {
  //   return _cache.read<User>(key: userCacheKey) ?? User.empty;
  // }

  Future<void> persistData(dynamic data) async {
    assert(data != null);
    await storage.write(key: 'data', value: data);
  }

  Future<void> persistToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  Future<void> deleteToken() async {
    await storage.delete(key: 'token');
  }

  void dispose() => _controller.close();
}

// extension on auth.User {
//   User get toUser {
//     return User(id: uid, email: email, name: displayName, photo: photoURL);
//   }
// }

class SignUpWithEmailAndPasswordFailure implements Exception {
  /// {@macro sign_up_with_email_and_password_failure}
  const SignUpWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  /// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/createUserWithEmailAndPassword.html
  factory SignUpWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure(
          'An account already exists for that email.',
        );
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure(
          'Please enter a stronger password.',
        );
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }

  /// The associated error message.
  final String message;
}

class LogInWithEmailAndPasswordFailure implements Exception {
  const LogInWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  factory LogInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const LogInWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const LogInWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const LogInWithEmailAndPasswordFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const LogInWithEmailAndPasswordFailure(
          'Incorrect password, please try again.',
        );
      default:
        return const LogInWithEmailAndPasswordFailure();
    }
  }

  /// The associated error message.
  final String message;
}

class LogOutFailure implements Exception {}
