import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/exceptions.dart';
import '../models/user_expense.dart';
import '../utils/common.dart';
import 'user_session.dart';

class ExpenseRepository {
  ExpenseRepository();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DocumentReference<Map<String, dynamic>> get _userData =>
      _firestore.collection('Personal').doc(UserSession.instance.id);
  DocumentReference<Map<String, dynamic>> _expensesYearRef(String yearID) =>
      _userData.collection('expenses').doc(yearID);
  CollectionReference<Map<String, dynamic>> _expensesMonthRef(
    String yearID,
    String monthID,
  ) => _expensesYearRef(yearID).collection(monthID);
  Future<void> addExpense(UserExpense expense) async {
    final yearID = getYearID(expense.date);
    final monthID = getMonthID(expense.date);
    await _expensesMonthRef(
      yearID,
      monthID,
    ).doc(expense.id).set(expense.toMap());
  }

  Future<List<UserExpense>> getExpensesForMonth(DateTime date) async {
    final yearID = getYearID(date);
    final monthID = getMonthID(date);
    final snapshot = await _expensesMonthRef(yearID, monthID).get();
    return snapshot.docs.map((doc) => UserExpense.fromMap(doc.data())).toList();
  }

  /// Live stream of a user's expenses for one month — this is what
  /// ExpenseViewModel watches; the list screen never queries Firestore
  /// directly.
  /* Stream<List<UserExpense>> watchExpensesForMonth(String yearMonthID) {
    // final start = DateTime(year, month, 1);
    // final end = DateTime(year, month + 1, 1);
    return _expensesRef(yearMonthID)
        // .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        // .where('date', isLessThan: Timestamp.fromDate(end))
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserExpense.fromMap(doc.data()))
              .toList(),
        );
  } */
  /// Update an expense with a conflict check. Throws
  /// [ConcurrentEditException] if someone else modified it since this
  /// copy was loaded — the ViewModel catches this and the UI shows
  /// "This was updated by someone else, please refresh."
  Future<void> updateExpense(
    UserExpense expense, {
    bool shouldValidateUpdatedDate = true,
  }) async {
    final yearID = getYearID(expense.date);
    final monthID = getMonthID(expense.date);
    final docRef = _expensesMonthRef(yearID, monthID).doc(expense.id);
    if (shouldValidateUpdatedDate) {
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        if (!snapshot.exists) {
          throw ExpenseNotFoundException();
        }
        final currentUpdatedAt = (snapshot.data()!['updatedAt'] as Timestamp)
            .toDate();
        if (currentUpdatedAt.isAfter(DateTime.now())) {
          throw ConcurrentEditException();
        }
        transaction.update(docRef, expense.toMap());
      });
    } else {
      docRef.update(expense.toMap());
    }
  }

  Future<void> deleteExpense(UserExpense expense) async {
    final yearID = getYearID(expense.date);
    final monthID = getMonthID(expense.date);
    await _expensesMonthRef(yearID, monthID).doc(expense.id).delete();
  }
}
