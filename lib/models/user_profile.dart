import '../core/constants.dart';
import 'notification_model.dart';

class UserProfile {
  UserProfile({
    required this.id,
    required this.uid,
    this.name = AppConstants.emptyString,
    this.email = AppConstants.emptyString,
    this.mobileno = AppConstants.emptyString,
    this.photoUrl = AppConstants.emptyString,
    this.roomList = const [],
    this.notificationList = const [],
    this.dataSharing = const [],
  });
  factory UserProfile.fromMap(Map<String, dynamic> m) => UserProfile(
    id: m['id'] as String,
    uid: m['uid'] as String,
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
  factory UserProfile.fromJson(Map<String, dynamic> j) =>
      UserProfile.fromMap(j);
  final String id;
  final String uid;
  String name;
  String email;
  String mobileno;
  String photoUrl;
  List<String> roomList;
  List<NotificationModel> notificationList;
  List<String> dataSharing;
  Map<String, dynamic> toMap() => {
    'id': id,
    'uid': uid,
    'name': name,
    'email': email,
    'mobileno': mobileno,
    'photoUrl': photoUrl,
    'roomList': roomList,
    'notificationList': notificationList.map((e) => e.toMap()).toList(),
    'dataSharing': dataSharing,
  };
  Map<String, dynamic> toJson() => toMap();
}
