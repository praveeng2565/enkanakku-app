class NotificationModel {
  final String id;
  final String title;
  final String subtitle;
  final String action;
  const NotificationModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.action,
  });
  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'action': action,
  };
  factory NotificationModel.fromMap(Map<String, dynamic> m) =>
      NotificationModel(
        id: m['id'] as String,
        title: m['title'] as String,
        subtitle: m['subtitle'] as String,
        action: m['action'] as String,
      );
  Map<String, dynamic> toJson() => toMap();
  factory NotificationModel.fromJson(Map<String, dynamic> j) =>
      NotificationModel.fromMap(j);
}
