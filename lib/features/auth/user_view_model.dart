import 'package:flutter/material.dart';

import '../../models/user_expense.dart';
import '../../models/user_insurance.dart';
import '../../models/user_loan.dart';
import '../../models/user_profile.dart';
import '../../models/user_remainder.dart';
import '../../models/user_warranty.dart';

class UserViewModel with ChangeNotifier {
  bool appVersionValidated = true;
  String appVersionErrorMsg = '';
  String appVersion = '';
  UserProfile? _userData;

  UserProfile? get user => _userData;

  set user(UserProfile? user) {
    _userData = user;
  }

  List<UserExpense> _expenseList = [];
  List<UserExpense> get expenses => _expenseList;

  set expenses(List<UserExpense> expenses) {
    _expenseList = expenses;
  }

  List<UserLoan> _loanList = [];
  List<UserLoan> get loans => _loanList;

  set loans(List<UserLoan> loans) {
    _loanList = loans;
  }

  List<UserInsurance> _insuranceList = [];
  List<UserInsurance> get insurances => _insuranceList;

  set insurances(List<UserInsurance> insurance) {
    _insuranceList = insurance;
  }

  List<UserWarranty> _warrantyList = [];
  List<UserWarranty> get warrantys => _warrantyList;

  set warrantys(List<UserWarranty> warranty) {
    _warrantyList = warranty;
  }

  List<UserRemainder> _remainderList = [];
  List<UserRemainder> get remainders => _remainderList;

  set remainders(List<UserRemainder> remainder) {
    _remainderList = remainder;
  }
}
