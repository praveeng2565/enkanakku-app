import 'package:enkanakku_app/models/user_profile.dart';
import 'package:enkanakku_app/utils/common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> get getUser => Future.value(_auth.currentUser);

  // Stream<User> get user => _auth.authStateChanges();

  // wrappinhg the firebase calls
  Future logout() {
    return FirebaseAuth.instance.signOut();
  }

  // wrappinhg the firebase calls
  Future createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    var u = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    UserProfile info = UserProfile(id: getNewID());
    info.name = "$firstName $lastName";
    return await u.user?.updateProfile(displayName: info.name);
  }

  // wrappinhg the firebase calls
  Future<UserCredential> loginUser({
    required String email,
    required String password,
  }) {
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
