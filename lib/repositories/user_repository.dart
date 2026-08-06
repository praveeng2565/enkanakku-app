import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_profile.dart';
import '../services/login_auth.dart';

/// Handles all Firestore reads/writes for the `users/{uid}` collection.
/// No Flutter UI imports, no ChangeNotifier — pure data access, kept
/// testable and reusable by any ViewModel that needs user data.
class UserRepository {
  UserRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection('users').doc(AuthService().currentUid);

  DocumentReference<Map<String, dynamic>> _profileRef(String id) =>
      _usersRef.collection('profile').doc(id);

  /// Creates or updates the nested profile doc. Safe to call on every
  /// login (merge: true won't wipe fields you don't pass).
  Future<void> createOrUpdateUser(UserProfile profile) async {
    await _profileRef(profile.id).set(profile.toMap(), SetOptions(merge: true));
  }

  /// One-time fetch.
  Future<UserProfile?> getUser() async {
    final doc = await _profileRef(AuthService().currentUid).get();
    if (!doc.exists) return null;
    return UserProfile.fromMap(doc.data()!);
  }

  /// Live stream — use in ProfileViewModel so profile screens update
  /// in real time if edited elsewhere (e.g. another device).
  Stream<UserProfile?> watchUser(String uid) {
    return _profileRef(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserProfile.fromMap(doc.data()!);
    });
  }

  Future<void> updateFcmToken(String uid, String token) async {
    await _profileRef(uid).update({
      'fcmTokens': FieldValue.arrayUnion([token]),
    });
  }

  /// Used when a user looks up another member by uid — e.g. showing
  /// a payer's name on a room expense without a separate lookup screen.
  Future<UserProfile?> getUserOnce() => getUser();
}
