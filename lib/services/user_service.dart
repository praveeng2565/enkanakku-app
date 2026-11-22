import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  UserService._();
  static final UserService instance = UserService._();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  Future<String?> getUserUniqueId(String uid) async {
    final snapshot = await _fireStore
        .collection('AllUsersProfile')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) {
      return null;
    }
    return snapshot.docs.first.id;
  }
}
