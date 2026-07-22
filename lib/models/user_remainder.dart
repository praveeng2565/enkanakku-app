class UserRemainder {
  final String id;
  final DateTime startdatetime;
  final String title;
  final String subtitle;
  final bool reoccurring;
  final DateTime enddatetime;
  const UserRemainder({
    required this.id,
    required this.startdatetime,
    required this.title,
    required this.subtitle,
    required this.reoccurring,
    required this.enddatetime,
  });
  Map<String, dynamic> toMap() => {
    'id': id,
    'startdatetime': startdatetime.toIso8601String(),
    'title': title,
    'subtitle': subtitle,
    'reoccurring': reoccurring,
    'enddatetime': enddatetime.toIso8601String(),
  };
  factory UserRemainder.fromMap(Map<String, dynamic> m) => UserRemainder(
    id: m['id'] as String,
    startdatetime: DateTime.parse(m['startdatetime']),
    title: m['title'] as String,
    subtitle: m['subtitle'] as String,
    reoccurring: m['reoccurring'] as bool,
    enddatetime: DateTime.parse(m['enddatetime']),
  );
  Map<String, dynamic> toJson() => toMap();
  factory UserRemainder.fromJson(Map<String, dynamic> j) =>
      UserRemainder.fromMap(j);
}
