import 'package:cloud_firestore/cloud_firestore.dart';

class RoomModel {
  const RoomModel({
    required this.id,
    required this.name,
    this.description = '',
    this.emoji = '👥',
    required this.createdBy,
    required this.createdAt,
    this.memberIds = const [],
  });

  factory RoomModel.fromMap(Map<String, dynamic> m, String id) {
    return RoomModel(
      id: id,
      name: m['name'] as String? ?? '',
      description: m['description'] as String? ?? '',
      emoji: m['emoji'] as String? ?? '👥',
      createdBy: m['createdBy'] as String? ?? '',
      // serverTimestamp() is null in the local snapshot until the server
      // confirms the write, so fall back to "now" instead of crashing.
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      memberIds: List<String>.from(m['memberIds'] ?? const []),
    );
  }
  final String id;
  final String name;
  final String description;
  final String emoji;
  final String createdBy;
  final DateTime createdAt;
  final List<String> memberIds;
}
