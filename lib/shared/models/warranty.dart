import 'package:cloud_firestore/cloud_firestore.dart';

class WarrantyDetails {
  final String id;
  final String productName;
  final DateTime purchaseDate;
  final int warrantyMonths;
  final String retailer;
  final String billImageUrl;

  WarrantyDetails({
    required this.id,
    required this.productName,
    required this.purchaseDate,
    required this.warrantyMonths,
    required this.retailer,
    required this.billImageUrl,
  });

  factory WarrantyDetails.fromMap(Map<String, dynamic> map, String id) {
    return WarrantyDetails(
      id: id,
      productName: map['productName'] ?? '',
      purchaseDate: (map['purchaseDate'] as Timestamp).toDate(),
      warrantyMonths: map['warrantyMonths'] ?? 0,
      retailer: map['retailer'] ?? '',
      billImageUrl: map['billImageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'productName': productName,
    'purchaseDate': purchaseDate,
    'warrantyMonths': warrantyMonths,
    'retailer': retailer,
    'billImageUrl': billImageUrl,
  };
}
