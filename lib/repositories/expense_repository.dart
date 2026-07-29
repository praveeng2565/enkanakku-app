import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/exceptions.dart';
import '../models/user_expense.dart';

/// Handles all Firestore reads/writes for `users/{uid}/expenses`.
/// Includes optimistic-locking on updates so two people editing the
/// same expense at once don't silently overwrite each other (see the
/// concurrency discussion from earlier — this is where that gets
/// implemented, not in the ViewModel or the UI).
class ExpenseRepository {
  ExpenseRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _expensesRef(String uid) =>
      _firestore.collection('users').doc(uid).collection('expenses');

  /// Add a new expense. Firestore assigns the doc ID.
  Future<String> addExpense(String uid, UserExpense expense) async {
    final docRef = await _expensesRef(uid).add(expense.toMap());
    return docRef.id;
  }

  /// Live stream of a user's expenses for one month — this is what
  /// ExpenseViewModel watches; the list screen never queries Firestore
  /// directly.
  Stream<List<UserExpense>> watchExpensesForMonth(
    String uid,
    // int year,
    // int month,
  ) {
    // final start = DateTime(year, month, 1);
    // final end = DateTime(year, month + 1, 1);

    return _expensesRef(uid)
        // .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        // .where('date', isLessThan: Timestamp.fromDate(end))
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserExpense.fromMap(doc.data()))
              .toList(),
        );
  }

  /// Update an expense with a conflict check. Throws
  /// [ConcurrentEditException] if someone else modified it since this
  /// copy was loaded — the ViewModel catches this and the UI shows
  /// "This was updated by someone else, please refresh."
  Future<void> updateExpense(
    String uid,
    UserExpense expense,
    DateTime expectedUpdatedAt,
  ) async {
    final docRef = _expensesRef(uid).doc(expense.id);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        throw ExpenseNotFoundException();
      }

      final currentUpdatedAt = (snapshot.data()!['updatedAt'] as Timestamp)
          .toDate();

      if (currentUpdatedAt.isAfter(expectedUpdatedAt)) {
        throw ConcurrentEditException();
      }

      transaction.update(docRef, expense.toMap());
    });
  }

  Future<void> deleteExpense(String uid, String expenseId) async {
    await _expensesRef(uid).doc(expenseId).delete();
  }
}
