import 'package:cloud_firestore/cloud_firestore.dart';

class RoomExpenseModel {
  const RoomExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.paidBy,
    required this.splitAmong,
    this.category = 'General',
    required this.date,
    this.note = '',
  });

  factory RoomExpenseModel.fromMap(Map<String, dynamic> m, String id) {
    return RoomExpenseModel(
      id: id,
      title: m['title'] as String? ?? '',
      amount: (m['amount'] as num?)?.toDouble() ?? 0,
      paidBy: m['paidBy'] as String? ?? '',
      splitAmong: List<String>.from(m['splitAmong'] ?? const []),
      category: m['category'] as String? ?? 'General',
      date: (m['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      note: m['note'] as String? ?? '',
    );
  }
  final String id;
  final String title;
  final double amount; // rupees, as entered by the user
  final String paidBy; // uid of the payer
  final List<String> splitAmong; // uids sharing this expense equally
  final String category;
  final DateTime date;
  final String note;

  /// Money math is done in integer paise to avoid floating-point drift.
  int get amountInPaise => (amount * 100).round();

  Map<String, dynamic> toMap() => {
    'title': title,
    'amount': amount,
    'paidBy': paidBy,
    'splitAmong': splitAmong,
    'category': category,
    'date': Timestamp.fromDate(date),
    'note': note,
  };
}
