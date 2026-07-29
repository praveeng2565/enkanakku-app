// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../models/user_profile.dart';

// /// Handles all Firestore reads/writes for the `users/{uid}` collection.
// /// No Flutter UI imports, no ChangeNotifier — pure data access, kept
// /// testable and reusable by any ViewModel that needs user data.
// class UserRepository {
//   UserRepository({FirebaseFirestore? firestore})
//     : _firestore = firestore ?? FirebaseFirestore.instance;
//   final FirebaseFirestore _firestore;

//   CollectionReference<Map<String, dynamic>> get _usersRef =>
//       _firestore.collection('users');

//   /// Creates the user doc on first sign-in, or merges basic profile
//   /// fields if it already exists (safe to call every login).
//   Future<void> createOrUpdateUser(UserProfile user) async {
//     await _usersRef
//         .doc(user.uid)
//         .set(user.toFirestore(), SetOptions(merge: true));
//   }

//   /// One-time fetch — use for screens that just need the current
//   /// snapshot once (e.g. a profile edit form on open).
//   Future<UserProfile?> getUser(String uid) async {
//     final doc = await _usersRef.doc(uid).get();
//     if (!doc.exists) return null;
//     return UserProfile.fromFirestore(doc.data()!, doc.id);
//   }

//   /// Live stream — use this in ViewModels backing screens that should
//   /// reflect changes in real time (e.g. profile photo updated elsewhere).
//   Stream<UserProfile?> watchUser(String uid) {
//     return _usersRef.doc(uid).snapshots().map((doc) {
//       if (!doc.exists) return null;
//       return UserProfile.fromFirestore(doc.data()!, doc.id);
//     });
//   }

//   /// Called by NotificationService after FCM token registration/refresh.
//   Future<void> updateFcmToken(String uid, String token) async {
//     await _usersRef.doc(uid).update({
//       'fcmTokens': FieldValue.arrayUnion([token]),
//     });
//   }

//   /// Used when a user looks up another member by uid — e.g. showing
//   /// a payer's name on a room expense without a separate lookup screen.
//   Future<UserProfile?> getUserOnce(String uid) => getUser(uid);
// }
