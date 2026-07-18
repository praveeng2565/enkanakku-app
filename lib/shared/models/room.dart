import 'package:cloud_firestore/cloud_firestore.dart';

class RoomDetails {
  final String id;
  final String name;
  final List<String> members;
  final String createdBy;
  final DateTime lastUpdatedAt;
  final String billingCycle;

  RoomDetails({
    required this.id,
    required this.name,
    required this.members,
    required this.createdBy,
    required this.lastUpdatedAt,
    required this.billingCycle,
  });

  factory RoomDetails.fromMap(Map<String, dynamic> map, String id) {
    return RoomDetails(
      id: id,
      name: map['name'] ?? '',
      members: List<String>.from(map['members'] ?? []),
      createdBy: map['createdBy'] ?? '',
      lastUpdatedAt: (map['lastUpdatedAt'] as Timestamp).toDate(),
      billingCycle: map['billingCycle'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'members': members,
    'createdBy': createdBy,
    'lastUpdatedAt': lastUpdatedAt,
    'billingCycle': billingCycle,
  };
}
