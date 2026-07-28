class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.action,
  });
  factory NotificationModel.fromMap(Map<String, dynamic> m) =>
      NotificationModel(
        id: m['id'] as String,
        title: m['title'] as String,
        subtitle: m['subtitle'] as String,
        action: m['action'] as String,
      );
  factory NotificationModel.fromJson(Map<String, dynamic> j) =>
      NotificationModel.fromMap(j);
  final String id;
  final String title;
  final String subtitle;
  final String action;
  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'action': action,
  };
  Map<String, dynamic> toJson() => toMap();
}
