import 'package:enkanakku_app/models/user_profile.dart';
import 'package:flutter/material.dart';

class UserViewModel with ChangeNotifier {
  UserProfile? _user;

  UserProfile? get user => _user;

  void setUser(UserProfile? user) {
    _user = user;
    notifyListeners();
  }
}