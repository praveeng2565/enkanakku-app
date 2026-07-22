class Room {
  final String id;
  final String name;
  final String createdBy;
  final int billingDay;
  final String note;
  final bool allowAddingPreviousDatesExpenses;
  final int maxPreviousDatesCount;
  const Room({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.billingDay,
    required this.note,
    required this.allowAddingPreviousDatesExpenses,
    required this.maxPreviousDatesCount,
  });
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'createdBy': createdBy,
    'billingDay': billingDay,
    'note': note,
    'allowAddingPreviousDatesExpenses': allowAddingPreviousDatesExpenses,
    'maxPreviousDatesCount': maxPreviousDatesCount,
  };
  factory Room.fromMap(Map<String, dynamic> m) => Room(
    id: m['id'] as String,
    name: m['name'] as String,
    createdBy: m['createdBy'] as String,
    billingDay: m['billingDay'] as int,
    note: m['note'] as String,
    allowAddingPreviousDatesExpenses:
        m['allowAddingPreviousDatesExpenses'] as bool,
    maxPreviousDatesCount: m['maxPreviousDatesCount'] as int,
  );
  Map<String, dynamic> toJson() => toMap();
  factory Room.fromJson(Map<String, dynamic> j) => Room.fromMap(j);
}
