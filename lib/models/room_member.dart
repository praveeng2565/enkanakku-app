class RoomMember {
  final String userid;
  final bool isAdmin;
  final String nickname;
  const RoomMember({
    required this.userid,
    required this.isAdmin,
    required this.nickname,
  });
  Map<String, dynamic> toMap() => {
    'userid': userid,
    'isAdmin': isAdmin,
    'nickname': nickname,
  };
  factory RoomMember.fromMap(Map<String, dynamic> m) => RoomMember(
    userid: m['userid'] as String,
    isAdmin: m['isAdmin'] as bool,
    nickname: m['nickname'] as String,
  );
  Map<String, dynamic> toJson() => toMap();
  factory RoomMember.fromJson(Map<String, dynamic> j) => RoomMember.fromMap(j);
}
