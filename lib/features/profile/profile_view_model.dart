import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import '../../models/user_profile.dart';
import '../../repositories/user_session.dart';
import '../../repositories/users_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel(this._userRepository);
  final UsersRepository _userRepository;
  UserProfile? profile;
  Future<void> loadProfile() async {
    final user = await _userRepository.getUserData(UserSession.instance.id);
    profile = user;
    notifyListeners();
  }

  Future<bool> updateProfile(UserProfile updated) async {
    try {
      await _userRepository.createOrUpdateUser(updated);
      profile = updated;
      return true;
    } catch (e) {
      return false;
    } finally {
      notifyListeners();
    }
  }

  /// Uploads a new profile photo and returns its download URL.
  /// Wire the picked File in from image_picker in the edit screen.
  /* Future<String?> uploadProfilePhoto(File imageFile) async {
    try {
      return await _userRepository.uploadProfileImage(file: imageFile);
    } catch (e) {
      return null;
    }
  } */
}
