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
    return _auth.signOut();
  }

  // wrappinhg the firebase calls
  Future<bool> createUser({
    required String name,
    required String email,
    required String password,
    required String mobile,
  }) async {
    final bool val = await UsersRepository().checkUserAlreadyExists(
      email: email,
      mobile: mobile,
    );
    if (!val) return false;
    final u = await _auth.createUserWithEmailAndPassword(
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
    await u.user?.updateProfile(displayName: info.name);
    await UsersRepository().createOrUpdateUser(info);
    final value = await UsersRepository().getUserUniqueId();
    if (value == null || value.isEmpty) return false;
    UserSession.instance.id = value;
    return true;
  }

  // wrappinhg the firebase calls
  Future<bool> loginUser({
    required String login,
    required String password,
  }) async {
    final value = login.trim();
    String email;
    if (_isEmail(value)) {
      email = value;
    } else {
      final foundEmail = await UsersRepository().getEmailFromMobile(value);
      if (foundEmail == null || foundEmail.isEmpty) {
        throw FirebaseAuthException(
          code: 'invalid-credential',
          message: 'Invalid credentials.',
        );
      }
      email = foundEmail;
    }
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    final val = await UsersRepository().getUserUniqueId();
    if (val == null || val.isEmpty) return false;
    UserSession.instance.id = val;
    return true;
  }

  bool _isEmail(String value) {
    return RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    ).hasMatch(value);
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
