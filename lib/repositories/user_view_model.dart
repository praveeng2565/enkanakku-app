import 'package:flutter/material.dart';

import '../models/user_profile.dart';

class UserViewModel with ChangeNotifier {
  UserProfile? _user;

  UserProfile? get user => _user;

  void setUser(UserProfile? user) {
    _user = user;
    notifyListeners();
  }
}
