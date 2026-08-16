import 'package:flutter/material.dart';
import '../../models/user_expense.dart';

class ExpenseViewModel with ChangeNotifier {
  List<UserExpense> expenses = [];
  void refresh() {
    notifyListeners();
  }
}
