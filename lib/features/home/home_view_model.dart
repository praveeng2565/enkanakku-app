import 'package:flutter/material.dart';
import '../../models/user_expense.dart';

class HomeViewModel with ChangeNotifier {
  late DateTime currentDate;
  late DateTime dashMonthYear;
  late double totalBudget;
  late double totalSpent;
  late double totalRemaining;
  late double spentToday;
  late double totalSpentPerc;
  List<UserExpense> expenses = [];
  int currentPageIndex = 0;
  void changePage(int index) {
    currentPageIndex = index;
    refresh();
  }

  void refresh() {
    notifyListeners();
  }

  void calculateData() {
    reset();
    for (final UserExpense element in expenses) {
      totalSpent += element.amount ?? 0;
      if (element.date.day == currentDate.day) {
        spentToday += element.amount ?? 0;
      }
    }
    this
      ..totalRemaining = totalBudget - totalSpent
      ..totalSpentPerc = totalSpent == 0
          ? 0
          : (totalSpent / totalBudget).clamp(0.0, 1.0)
      ..refresh();
  }

  void reset() {
    totalBudget = 10000;
    totalSpent = 0;
    totalRemaining = 0;
    spentToday = 0;
    totalSpentPerc = 0;
  }
}
