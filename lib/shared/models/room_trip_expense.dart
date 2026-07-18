class RoomTripExpense {
  final String id;
  final double amount;
  final String paidBy;
  final List<String> splitAmong;
  final String category;
  final DateTime date;
  final String note;
  final double perHeadSplit;

  RoomTripExpense({
    required this.id,
    required this.amount,
    required this.paidBy,
    required this.splitAmong,
    required this.category,
    required this.date,
    required this.note,
    required this.perHeadSplit,
  });

  factory RoomTripExpense.fromMap(Map<String, dynamic> map, String id) {
    return RoomTripExpense(
      id: id,
      amount: (map['amount'] as num).toDouble(),
      paidBy: map['paidBy'] ?? '',
      splitAmong: List<String>.from(map['splitAmong'] ?? []),
      category: map['category'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      note: map['note'] ?? '',
      perHeadSplit: (map['perHeadSplit'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
    'amount': amount,
    'paidBy': paidBy,
    'splitAmong': splitAmong,
    'category': category,
    'date': date,
    'note': note,
    'perHeadSplit': perHeadSplit,
  };
}
