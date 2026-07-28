class RoomMember {
  const RoomMember({
    required this.userid,
    required this.isAdmin,
    required this.nickname,
  });
  factory RoomMember.fromMap(Map<String, dynamic> m) => RoomMember(
    userid: m['userid'] as String,
    isAdmin: m['isAdmin'] as bool,
    nickname: m['nickname'] as String,
  );
  factory RoomMember.fromJson(Map<String, dynamic> j) => RoomMember.fromMap(j);
  final String userid;
  final bool isAdmin;
  final String nickname;
  Map<String, dynamic> toMap() => {
    'userid': userid,
    'isAdmin': isAdmin,
    'nickname': nickname,
  };
  Map<String, dynamic> toJson() => toMap();
}
