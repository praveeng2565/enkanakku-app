import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/room_expense_model.dart';
import '../models/room_model.dart';
import '../models/settlement_model.dart';

/// Pure Firestore access. No Flutter imports, no ChangeNotifier.
///
/// rooms/{roomId}                  name, description, emoji, createdBy,
///                                 createdAt, memberIds
/// rooms/{roomId}/expenses/{id}    one doc per expense
/// rooms/{roomId}/settlements/{id} one doc per recorded payment
class RoomRepository {
  RoomRepository();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _rooms =>
      _firestore.collection('rooms');

  /// Creates a group with the creator as its only member.
  /// The auto-generated document ID keeps two groups with the same
  /// name completely separate.
  Future<String> createRoom({
    required String uid,
    required String name,
    String description = '',
    String emoji = '👥',
  }) async {
    final doc = await _rooms.add({
      'name': name,
      'description': description,
      'emoji': emoji,
      'createdBy': uid,
      'memberIds': [uid],
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  /// Live list of every group this user belongs to. The filter runs on
  /// the server, so other people's groups are never downloaded.
  Stream<List<RoomModel>> watchMyRooms(String uid) {
    return _rooms.where('memberIds', arrayContains: uid).snapshots().map((s) {
      final rooms = s.docs
          .map((d) => RoomModel.fromMap(d.data(), d.id))
          .toList();
      // Sorted here, so no composite index is needed.
      rooms.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return rooms;
    });
  }

  Stream<RoomModel?> watchRoom(String roomId) {
    return _rooms.doc(roomId).snapshots().map((doc) {
      final data = doc.data();
      if (!doc.exists || data == null) return null;
      return RoomModel.fromMap(data, doc.id);
    });
  }

  /// arrayUnion is atomic and ignores duplicates, so adding the same
  /// person twice, or two people at once, is safe.
  Future<void> addMember(String roomId, String uid) {
    return _rooms.doc(roomId).update({
      'memberIds': FieldValue.arrayUnion([uid]),
    });
  }

  Stream<List<RoomExpenseModel>> watchExpenses(String roomId) {
    return _rooms
        .doc(roomId)
        .collection('expenses')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (s) => s.docs
              .map((d) => RoomExpenseModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  Future<void> addExpense(String roomId, RoomExpenseModel expense) {
    return _rooms.doc(roomId).collection('expenses').add(expense.toMap());
  }

  Stream<List<SettlementModel>> watchSettlements(String roomId) {
    return _rooms
        .doc(roomId)
        .collection('settlements')
        .snapshots()
        .map(
          (s) => s.docs
              .map((d) => SettlementModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  Future<void> addSettlement(String roomId, SettlementModel settlement) {
    return _rooms.doc(roomId).collection('settlements').add(settlement.toMap());
  }
}
