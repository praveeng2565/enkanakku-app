import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';
import '../services/login_auth.dart';

/// Handles all Firestore reads/writes for the `users/{uid}` collection.
/// No Flutter UI imports, no ChangeNotifier — pure data access, kept
/// testable and reusable by any ViewModel that needs user data.
class UsersRepository {
  UsersRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;
  DocumentReference<Map<String, dynamic>> _usersRef(String id) =>
      _firestore.collection('AllUsersProfile').doc(id);

  /// Creates or updates the nested profile doc. Safe to call on every
  /// login (merge: true won't wipe fields you don't pass).
  Future<void> createOrUpdateUser(UserProfile profile) async {
    final normalizedMobile = normalizeMobile(profile.mobileno);
    profile.mobileno = normalizedMobile;
    await _usersRef(profile.id).set(profile.toMap(), SetOptions(merge: true));
  }

  Future<String?> getUserUniqueId() async {
    final uid = AuthService().currentUid;
    if (uid.isEmpty) return null;
    final snapshot = await _firestore
        .collection('AllUsersProfile')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) {
      return null;
    }
    return snapshot.docs.first.id;
  }

  Future<String?> getEmailFromMobile(String mobile) async {
    final normalizedMobile = normalizeMobile(mobile);
    final snapshot = await _firestore
        .collection('AllUsersProfile')
        .where('mobileno', isEqualTo: normalizedMobile)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) {
      return null;
    }
    final data = snapshot.docs.first.data();
    return data['email'] as String?;
  }

  Future<bool> checkUserAlreadyExists({
    required String email,
    required String mobile,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedMobile = normalizeMobile(mobile);
    final results = await Future.wait([
      _firestore
          .collection('AllUsersProfile')
          .where('mobileno', isEqualTo: normalizedMobile)
          .limit(1)
          .get(),
      _firestore
          .collection('AllUsersProfile')
          .where('email', isEqualTo: normalizedEmail)
          .limit(1)
          .get(),
    ]);
    final mobileSnapshot = results[0];
    final emailSnapshot = results[1];
    if (mobileSnapshot.docs.isNotEmpty) {
      throw FirebaseAuthException(
        code: 'mobile-already-in-use',
        message: 'This mobile number is already registered.',
      );
    }
    if (emailSnapshot.docs.isNotEmpty) {
      throw FirebaseAuthException(
        code: 'email-already-in-use',
        message: 'This email address is already registered.',
      );
    }
    return true;
  }

  String normalizeMobile(String mobile) {
    var value = mobile.trim();
    value = value.replaceAll(RegExp(r'[\s()-]'), '');
    if (value.startsWith('+91')) {
      return value;
    }
    if (value.startsWith('91') && value.length == 12) {
      return '+$value';
    }
    if (value.length == 10) {
      return '+91$value';
    }
    return value;
  }

  /// One-time fetch.
  Future<UserProfile?> getUserData(String id) async {
    final doc = await _usersRef(id).get();
    if (!doc.exists) return null;
    return UserProfile.fromMap(doc.data()!);
  }

  // Future<String> uploadProfileImage({required File file}) async {
  //   final ref = FirebaseStorage.instance.ref(
  //     'profile_photos/${UserSession.instance.id}/profile.jpg',
  //   );
  //   await ref.putFile(file);
  //   return ref.getDownloadURL();
  // }
  /// Live stream — use in ProfileViewModel so profile screens update
  /// in real time if edited elsewhere (e.g. another device).
  // Stream<UserProfile?> watchUser(String uid) {
  //   return _profileRef(uid).snapshots().map((doc) {
  //     if (!doc.exists) return null;
  //     return UserProfile.fromMap(doc.data()!);
  //   });
  // }
  // Future<void> updateFcmToken(String uid, String token) async {
  //   await _profileRef(uid).update({
  //     'fcmTokens': FieldValue.arrayUnion([token]),
  //   });
  // }
  /// Used when a user looks up another member by uid — e.g. showing
  /// a payer's name on a room expense without a separate lookup screen.
  Future<UserProfile?> getUserOnce(String id) => getUserData(id);
}
