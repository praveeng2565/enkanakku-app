class Room {
  Room({
    required this.id,
    this.name = '',
    required this.createdBy,
    this.billingDay = 1,
    this.note = '',
    this.allowAddingPreviousDatesExpenses = true,
    this.maxPreviousDatesCount = 0,
  });
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
  factory Room.fromJson(Map<String, dynamic> j) => Room.fromMap(j);
  final String id;
  String name;
  final String createdBy;
  int billingDay;
  String note;
  bool allowAddingPreviousDatesExpenses;
  int maxPreviousDatesCount;
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'createdBy': createdBy,
    'billingDay': billingDay,
    'note': note,
    'allowAddingPreviousDatesExpenses': allowAddingPreviousDatesExpenses,
    'maxPreviousDatesCount': maxPreviousDatesCount,
  };
  Map<String, dynamic> toJson() => toMap();
}
