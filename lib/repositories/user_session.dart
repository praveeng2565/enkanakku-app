class UserSession {
  UserSession._();

  static final UserSession instance = UserSession._();

  String id = '';
  String uid = '';
  String name = '';
  bool isDev = false;

  bool get isLoggedIn => id.isNotEmpty;

  void setUser({
    required String customId,
    required String uid,
    required String name,
  }) {
    id = customId;
    this.uid = uid;
    this.name = name;
  }

  void clear() {
    id = '';
    uid = '';
    name = '';
  }
}
