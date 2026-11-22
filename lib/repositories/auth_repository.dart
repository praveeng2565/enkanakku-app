import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_config_model.dart';

class AuthRepository {
  AuthRepository();
  static final FirebaseFirestore _firebaseStore = FirebaseFirestore.instance;
  // static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static DocumentReference<Map<String, dynamic>> get _appData =>
      _firebaseStore.collection('app_config').doc('version');

  Future<AppConfigModel?> getAppConfigData() async {
    final snapshot = await _appData.get();
    if (!snapshot.exists) return null;
    return AppConfigModel.fromJson(snapshot.data()!);
  }

  Future<void> logIn() async {}

  Future<void> signUp() async {}

  Future<void> resetPassword() async {}

  // Future<void> signUp() async {}

  // Future<void> signUp() async {}

  // Future<void> signUp() async {}
}
