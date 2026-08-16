import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  UserService._();
  static final UserService instance = UserService._();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  Future<String?> getCustomId() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    final snapshot = await _fireStore
        .collection('AllUsers')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) {
      return null;
    }
    return snapshot.docs.first.id;
  }
}
