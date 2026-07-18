class Reminder {
  final String id;
  final DateTime startDateTime;
  final String title;
  final String subtitle;
  final bool recurring;
  final DateTime endDateTime;

  Reminder({
    required this.id,
    required this.startDateTime,
    required this.title,
    required this.subtitle,
    required this.recurring,
    required this.endDateTime,
  });

  factory Reminder.fromMap(Map<String, dynamic> map, String id) {
    return Reminder(
      id: id,
      startDateTime: (map['startDateTime'] as Timestamp).toDate(),
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      recurring: map['recurring'] ?? false,
      endDateTime: (map['endDateTime'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    'startDateTime': startDateTime,
    'title': title,
    'subtitle': subtitle,
    'recurring': recurring,
    'endDateTime': endDateTime,
  };
}
