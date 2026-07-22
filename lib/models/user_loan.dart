class UserLoan {
  final String id;
  final String type;
  final double principal;
  final double emiAmount;
  final DateTime dueDate;
  final int tenureMonths;
  final DateTime startDate;
  final String billImageUrl;
  const UserLoan({
    required this.id,
    required this.type,
    required this.principal,
    required this.emiAmount,
    required this.dueDate,
    required this.tenureMonths,
    required this.startDate,
    required this.billImageUrl,
  });
  Map<String, dynamic> toMap() => {
    'id': id,
    'type': type,
    'principal': principal,
    'emiAmount': emiAmount,
    'dueDate': dueDate.toIso8601String(),
    'tenureMonths': tenureMonths,
    'startDate': startDate.toIso8601String(),
    'billImageUrl': billImageUrl,
  };
  factory UserLoan.fromMap(Map<String, dynamic> m) => UserLoan(
    id: m['id'] as String,
    type: m['type'] as String,
    principal: (m['principal'] as num).toDouble(),
    emiAmount: (m['emiAmount'] as num).toDouble(),
    dueDate: DateTime.parse(m['dueDate']),
    tenureMonths: m['tenureMonths'] as int,
    startDate: DateTime.parse(m['startDate']),
    billImageUrl: m['billImageUrl'] as String,
  );
  Map<String, dynamic> toJson() => toMap();
  factory UserLoan.fromJson(Map<String, dynamic> j) => UserLoan.fromMap(j);
}
