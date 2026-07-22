import 'notification_model.dart';

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String mobileno;
  final String photoUrl;
  final List<String> roomList;
  final List<NotificationModel> notificationList;
  final List<String> dataSharing;
  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.mobileno,
    required this.photoUrl,
    required this.roomList,
    required this.notificationList,
    required this.dataSharing,
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
