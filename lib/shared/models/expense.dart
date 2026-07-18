import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseDetails {
  final String id;
  final double amount;
  final String category;
  final DateTime date;
  final String note;
  final bool isMandatory;
  final bool isRecurring;
  final DateTime lastUpdatedAt;

  ExpenseDetails({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
    required this.isMandatory,
    required this.isRecurring,
    required this.lastUpdatedAt,
  });

  factory ExpenseDetails.fromMap(Map<String, dynamic> map, String id) {
    return ExpenseDetails(
      id: id,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      note: map['note'] ?? '',
      isMandatory: map['isMandatory'] ?? false,
      isRecurring: map['isRecurring'] ?? false,
      lastUpdatedAt: (map['lastUpdatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    'amount': amount,
    'category': category,
    'date': date,
    'note': note,
    'isMandatory': isMandatory,
    'isRecurring': isRecurring,
    'lastUpdatedAt': lastUpdatedAt,
  };
}
