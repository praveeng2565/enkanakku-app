import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import '../../models/user_profile.dart';
import '../../repositories/user_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel(this._userRepository);
  final UserRepository _userRepository;

  UserProfile? profile;
  bool isLoading = false;
  bool isSaving = false;

  Future<void> loadProfile() async {
    isLoading = true;
    notifyListeners();
    final user = await _userRepository.getUser();
    profile = user;
    isLoading = false;
    notifyListeners();
  }

  Future<bool> updateProfile(UserProfile updated) async {
    isSaving = true;
    notifyListeners();
    try {
      await _userRepository.createOrUpdateUser(updated);
      profile = updated;
      return true;
    } catch (e) {
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  /// Uploads a new profile photo and returns its download URL.
  /// Wire the picked File in from image_picker in the edit screen.
  // Future<String?> uploadProfilePhoto( File imageFile) async {
  //   try {
  //     // final ref = FirebaseStorage.instance.ref('profile_photos/$uid.jpg');
  //     // await ref.putFile(imageFile);
  //     // return await ref.getDownloadURL();
  //   } catch (e) {
  //     return null;
  //   }
  // }
}
