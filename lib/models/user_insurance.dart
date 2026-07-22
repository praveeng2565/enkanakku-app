class UserInsurance {
  final String id;
  final String type;
  final String provider;
  final double premiumAmount;
  final DateTime dueDate;
  final String policyNumber;
  final String remarks;
  const UserInsurance({
    required this.id,
    required this.type,
    required this.provider,
    required this.premiumAmount,
    required this.dueDate,
    required this.policyNumber,
    required this.remarks,
  });
  Map<String, dynamic> toMap() => {
    'id': id,
    'type': type,
    'provider': provider,
    'premiumAmount': premiumAmount,
    'dueDate': dueDate.toIso8601String(),
    'policyNumber': policyNumber,
    'remarks': remarks,
  };
  factory UserInsurance.fromMap(Map<String, dynamic> m) => UserInsurance(
    id: m['id'] as String,
    type: m['type'] as String,
    provider: m['provider'] as String,
    premiumAmount: (m['premiumAmount'] as num).toDouble(),
    dueDate: DateTime.parse(m['dueDate']),
    policyNumber: m['policyNumber'] as String,
    remarks: m['remarks'] as String,
  );
  Map<String, dynamic> toJson() => toMap();
  factory UserInsurance.fromJson(Map<String, dynamic> j) =>
      UserInsurance.fromMap(j);
}
