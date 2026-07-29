import '../core/constants.dart';

class UserExpense {
  UserExpense({
    required this.id,
    this.amount,
    this.category = AppConstants.emptyString,
    this.date,
    this.note = AppConstants.emptyString,
  });
  factory UserExpense.fromMap(Map<String, dynamic> m) => UserExpense(
    id: m['id'] as String,
    amount: (m['amount'] as num?)?.toDouble(),
    category: m['category'] as String,
    date: m['date'] != null ? DateTime.parse(m['date']) : null,
    note: m['note'] as String,
  );
  factory UserExpense.fromJson(Map<String, dynamic> j) =>
      UserExpense.fromMap(j);
  final String id;
  double? amount;
  String category;
  DateTime? date;
  String note;
  Map<String, dynamic> toMap() => {
    'id': id,
    'amount': amount,
    'category': category,
    'date': date?.toIso8601String(),
    'note': note,
  };
  Map<String, dynamic> toJson() => toMap();
}
