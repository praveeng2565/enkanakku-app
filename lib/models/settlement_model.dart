import 'package:cloud_firestore/cloud_firestore.dart';

/// A payment already made between two members to clear a debt.
/// Stored at rooms/{roomId}/settlements/{id} and counted when balances
/// are calculated, so "Mark as paid" actually reduces what is owed.
class SettlementModel {
  const SettlementModel({
    required this.id,
    required this.fromUid,
    required this.toUid,
    required this.amount,
    required this.createdAt,
  });

  factory SettlementModel.fromMap(Map<String, dynamic> m, String id) {
    return SettlementModel(
      id: id,
      fromUid: m['fromUid'] as String? ?? '',
      toUid: m['toUid'] as String? ?? '',
      amount: (m['amount'] as num?)?.toDouble() ?? 0,
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
  final String id;
  final String fromUid; // the person who paid
  final String toUid; // the person who received
  final double amount; // rupees
  final DateTime createdAt;

  int get amountInPaise => (amount * 100).round();

  Map<String, dynamic> toMap() => {
    'fromUid': fromUid,
    'toUid': toUid,
    'amount': amount,
    'createdAt': FieldValue.serverTimestamp(),
  };
}
