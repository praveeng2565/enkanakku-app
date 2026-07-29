class RoomExpense {
  const RoomExpense({
    required this.id,
    required this.amount,
    required this.paidBy,
    required this.category,
    required this.date,
    required this.remarks,
    required this.perheadSplit,
    required this.lastModifiedDateTime,
  });
  factory RoomExpense.fromMap(Map<String, dynamic> m) => RoomExpense(
    id: m['id'] as String,
    amount: (m['amount'] as num).toDouble(),
    paidBy: m['paidBy'] as String,
    category: m['category'] as String,
    date: DateTime.parse(m['date']),
    remarks: m['remarks'] as String,
    perheadSplit: (m['perheadSplit'] as num).toDouble(),
    lastModifiedDateTime: DateTime.parse(m['lastModifiedDateTime']),
  );
  factory RoomExpense.fromJson(Map<String, dynamic> j) =>
      RoomExpense.fromMap(j);
  final String id;
  final double amount;
  final String paidBy;
  final String category;
  final DateTime date;
  final String remarks;
  final double perheadSplit;
  final DateTime lastModifiedDateTime;
  Map<String, dynamic> toMap() => {
    'id': id,
    'amount': amount,
    'paidBy': paidBy,
    'category': category,
    'date': date.toIso8601String(),
    'remarks': remarks,
    'perheadSplit': perheadSplit,
    'lastModifiedDateTime': DateTime.now().toIso8601String(),
  };
}
