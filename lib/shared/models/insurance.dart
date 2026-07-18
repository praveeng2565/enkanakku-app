class InsuranceDetails {
  final String id;
  final String type;
  final String provider;
  final double premiumAmount;
  final DateTime dueDate;
  final String policyNumber;
  final String remarks;

  InsuranceDetails({
    required this.id,
    required this.type,
    required this.provider,
    required this.premiumAmount,
    required this.dueDate,
    required this.policyNumber,
    required this.remarks,
  });

  factory InsuranceDetails.fromMap(Map<String, dynamic> map, String id) {
    return InsuranceDetails(
      id: id,
      type: map['type'] ?? '',
      provider: map['provider'] ?? '',
      premiumAmount: (map['premiumAmount'] as num).toDouble(),
      dueDate: (map['dueDate'] as Timestamp).toDate(),
      policyNumber: map['policyNumber'] ?? '',
      remarks: map['remarks'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'type': type,
    'provider': provider,
    'premiumAmount': premiumAmount,
    'dueDate': dueDate,
    'policyNumber': policyNumber,
    'remarks': remarks,
  };
}
