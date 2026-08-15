import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_profile.dart';
import '../repositories/user_session.dart';
import '../repositories/users_repository.dart';
import '../utils/common.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get getUser => _auth.currentUser;

  String get currentUid => _auth.currentUser?.uid ?? '';

  String get userEmailId => _auth.currentUser?.email ?? '';

  // Stream<User> get user => _auth.authStateChanges();

  // wrappinhg the firebase calls
  Future<void> logout() {
    return FirebaseAuth.instance.signOut();
  }

  // wrappinhg the firebase calls
  Future<bool> createUser({
    required String name,
    required String email,
    required String password,
    required String mobile,
  }) async {
    final u = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final User? user = u.user;
    final UserProfile info = UserProfile(
      id: await generateUniqueId(),
      uid: user?.uid ?? '',
      email: email,
      name: name,
      mobileno: mobile,
      photoUrl: user?.photoURL ?? '',
    );
    info.name = name;
    await u.user?.updateProfile(displayName: info.name);
    await UsersRepository().createOrUpdateUser(info);
    return true;
  }

  // wrappinhg the firebase calls
  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final val = await UsersRepository().getUserUniqueId();
    if (val == null || val.isEmpty) return false;
    UserSession.instance.id = val;
    return true;
  }

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
