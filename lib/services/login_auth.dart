import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_profile.dart';
import '../utils/common.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> get getUser => Future.value(_auth.currentUser);

  // Stream<User> get user => _auth.authStateChanges();

  // wrappinhg the firebase calls
  Future<void> logout() {
    return FirebaseAuth.instance.signOut();
  }

  // wrappinhg the firebase calls
  Future<void> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final u = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final UserProfile info = UserProfile(id: getNewID());
    info.name = '$firstName $lastName';
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
