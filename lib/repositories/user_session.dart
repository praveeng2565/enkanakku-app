class UserSession {
  UserSession._();
  static final UserSession instance = UserSession._();
  String uniqueId = '';
  String uid = '';
  String name = '';
  String emailId = '';
  String appVersion = '';
  String? loginVersion;
  bool isDev = false;
  bool get isLoggedIn => uniqueId.isNotEmpty;

  void setUser({
    required String uniqueId,
    required String uid,
    required String name,
    required String emailId,
  }) {
    this.uniqueId = uniqueId;
    this.uid = uid;
    this.name = name;
    this.emailId = emailId;
  }
}
