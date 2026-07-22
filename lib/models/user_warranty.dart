class UserWarranty {
  final String id;
  final String productName;
  final DateTime purchaseDate;
  final int warrantyMonths;
  final String retailer;
  final String imageUrl;
  const UserWarranty({
    required this.id,
    required this.productName,
    required this.purchaseDate,
    required this.warrantyMonths,
    required this.retailer,
    required this.imageUrl,
  });
  Map<String, dynamic> toMap() => {
    'id': id,
    'productName': productName,
    'purchaseDate': purchaseDate.toIso8601String(),
    'warrantyMonths': warrantyMonths,
    'retailer': retailer,
    'imageUrl': imageUrl,
  };
  factory UserWarranty.fromMap(Map<String, dynamic> m) => UserWarranty(
    id: m['id'] as String,
    productName: m['productName'] as String,
    purchaseDate: DateTime.parse(m['purchaseDate']),
    warrantyMonths: m['warrantyMonths'] as int,
    retailer: m['retailer'] as String,
    imageUrl: m['imageUrl'] as String,
  );
  Map<String, dynamic> toJson() => toMap();
  factory UserWarranty.fromJson(Map<String, dynamic> j) =>
      UserWarranty.fromMap(j);
}
