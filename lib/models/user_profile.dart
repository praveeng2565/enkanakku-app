import 'package:enkanakku_app/utils/app_constants.dart';

import 'notification_model.dart';

class UserProfile {
  final String id;
  String name;
  String email;
  String mobileno;
  String photoUrl;
  List<String> roomList;
  List<NotificationModel> notificationList;
  List<String> dataSharing;
  UserProfile({
    required this.id,
    this.name = AppConstants.emptyString,
    this.email = AppConstants.emptyString,
    this.mobileno = AppConstants.emptyString,
    this.photoUrl = AppConstants.emptyString,
    this.roomList = const [],
    this.notificationList = const [],
    this.dataSharing = const [],
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'mobileno': mobileno,
    'photoUrl': photoUrl,
    'roomList': roomList,
    'notificationList': notificationList.map((e) => e.toMap()).toList(),
    'dataSharing': dataSharing,
  };

  factory UserProfile.fromMap(Map<String, dynamic> m) => UserProfile(
    id: m['id'] as String,
    name: m['name'] as String,
    email: m['email'] as String,
    mobileno: m['mobileno'] as String,
    photoUrl: m['photoUrl'] as String,
    roomList: List<String>.from(m['roomList'] ?? []),
    notificationList: (m['notificationList'] as List? ?? [])
        .map((e) => NotificationModel.fromMap(e))
        .toList(),
    dataSharing: List<String>.from(m['dataSharing'] ?? []),
  );

  Map<String, dynamic> toJson() => toMap();

  factory UserProfile.fromJson(Map<String, dynamic> j) =>
      UserProfile.fromMap(j);
}
