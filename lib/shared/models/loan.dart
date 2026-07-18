import 'package:cloud_firestore/cloud_firestore.dart';

class LoanDetails {
  final String id;
  final String type;
  final double principal;
  final double emiAmount;
  final DateTime dueDate;
  final int tenureMonths;
  final DateTime startDate;
  final String billImageUrl;

  LoanDetails({
    required this.id,
    required this.type,
    required this.principal,
    required this.emiAmount,
    required this.dueDate,
    required this.tenureMonths,
    required this.startDate,
    required this.billImageUrl,
  });

  factory LoanDetails.fromMap(Map<String, dynamic> map, String id) {
    return LoanDetails(
      id: id,
      type: map['type'] ?? '',
      principal: (map['principal'] as num).toDouble(),
      emiAmount: (map['emiAmount'] as num).toDouble(),
      dueDate: (map['dueDate'] as Timestamp).toDate(),
      tenureMonths: map['tenureMonths'] ?? 0,
      startDate: (map['startDate'] as Timestamp).toDate(),
      billImageUrl: map['billImageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'type': type,
    'principal': principal,
    'emiAmount': emiAmount,
    'dueDate': dueDate,
    'tenureMonths': tenureMonths,
    'startDate': startDate,
    'billImageUrl': billImageUrl,
  };
}
