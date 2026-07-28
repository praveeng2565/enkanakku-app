class UserExpense {
  const UserExpense({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
    required this.isMandatory,
    required this.isRecurring,
  });
  factory UserExpense.fromMap(Map<String, dynamic> m) => UserExpense(
    id: m['id'] as String,
    amount: (m['amount'] as num).toDouble(),
    category: m['category'] as String,
    date: DateTime.parse(m['date']),
    note: m['note'] as String,
    isMandatory: m['isMandatory'] as bool,
    isRecurring: m['isRecurring'] as bool,
  );
  factory UserExpense.fromJson(Map<String, dynamic> j) =>
      UserExpense.fromMap(j);
  final String id;
  final double amount;
  final String category;
  final DateTime date;
  final String note;
  final bool isMandatory;
  final bool isRecurring;
  Map<String, dynamic> toMap() => {
    'id': id,
    'amount': amount,
    'category': category,
    'date': date.toIso8601String(),
    'note': note,
    'isMandatory': isMandatory,
    'isRecurring': isRecurring,
  };
  Map<String, dynamic> toJson() => toMap();
}
