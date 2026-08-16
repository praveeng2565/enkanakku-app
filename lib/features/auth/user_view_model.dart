import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants.dart';
import '../../models/user_expense.dart';
import '../../models/user_insurance.dart';
import '../../models/user_loan.dart';
import '../../models/user_profile.dart';
import '../../models/user_remainder.dart';
import '../../models/user_warranty.dart';
import '../../repositories/user_session.dart';
import '../../repositories/users_repository.dart';
import '../../services/login_auth.dart';
import '../../services/update_service.dart';
import 'update_app_dialog.dart';

class UserViewModel with ChangeNotifier {
  bool appVersionValidated = false;
  String appVersionErrorMsg = '';
  String appVersion = '';
  String loginVersion = '';
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

  Future<bool> validateAppUpdate(BuildContext context) async {
    final updateInfo = await UpdateService().checkForUpdate();
    final packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
    appVersionErrorMsg = '';
    if (updateInfo != null) {
      if (updateInfo.apkUrl.isNotEmpty) {
        appVersionValidated = false;
        showUpdateDialog(context, updateInfo);
      } else if (updateInfo.loginVersion != null &&
          updateInfo.loginVersion!.isNotEmpty) {
        appVersionValidated = true;
        loginVersion = updateInfo.loginVersion!;
      }
    } else {
      appVersionValidated = true;
    }
    return appVersionValidated;
  }

  Future<String> getInitialPageRoute() async {
    final hasUser = AuthService().getUser != null;
    if (hasUser && !await shouldUserRelogin()) {
      if (await fetchCustomerId()) {
        return '/Home';
      }
    }
    return '/Login';
  }

  Future<bool> shouldUserRelogin() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLoginVerison = prefs.getString(AppConstants.loginVersionKey);
    if (lastLoginVerison == null ||
        lastLoginVerison.isEmpty ||
        lastLoginVerison != loginVersion) {
      await AuthService().logout();
      return true;
    }

    return false;
  }

  Future<bool> fetchCustomerId() async {
    final val = await UsersRepository().getUserUniqueId();
    if (val == null || val.isEmpty) return false;
    UserSession.instance.id = val;
    return true;
  }
}
