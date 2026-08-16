import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/constants.dart';
import '../models/user_profile.dart';
import '../repositories/users_repository.dart';
import '../services/login_auth.dart';

String getNewID() {
  return DateFormat('yyyyMMMdd#HHmmss#SSS').format(DateTime.now());
}

Future<String> generateUniqueId() async {
  String finalId = '';

  do {
    final id = generateCode();

    final UserProfile? doc = await UsersRepository().getUserOnce(id);
    if (doc == null) {
      finalId = id;
    }
  } while (finalId.isEmpty);

  return finalId;
}

String generateCode() {
  return '#${List.generate(8, (_) => AppConstants.friendCodeChars[Random.secure().nextInt(AppConstants.friendCodeChars.length)]).join()}';
}

void showProgressCircle(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, dynamic result) {},
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.grey[200],
            color: Theme.of(context).colorScheme.primary,
            strokeWidth: 4.0,
          ),
        ),
      );
    },
  );
}

void removeProgressCircle(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop('dialog');
}

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Log out'),
        content: const Text(
          'Are you sure you want to log out from your account?',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              showProgressCircle(context);
              Navigator.pop(context);
              await AuthService().logout();
              removeProgressCircle(context);
              Navigator.pushReplacementNamed(context, '/Login');
            },
            child: const Text('Sure'),
          ),
        ],
      );
    },
  );
}

void hideKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

String getYearID(DateTime value) {
  return DateFormat('yyyy').format(value);
}

String getMonthID(DateTime value) {
  return DateFormat('MMM').format(value);
}

bool isDateUpdated(DateTime first, DateTime second) {
  if (first.year != second.year) return true;
  if (first.month != second.month) return true;
  return false;
}

String formatAmount(double? value) {
  if (value == null) return '0';
  if (value % 1 == 0) {
    return value.toInt().toString();
  }

  return value
      .toStringAsFixed(2)
      .replaceAll(RegExp(r'0+$'), '')
      .replaceAll(RegExp(r'\.$'), '');
}

String formatAmountWithComma(double? value) {
  if (value == null) return '0';
  final formatter = NumberFormat(
    value % 1 == 0 ? '##,##,###' : '##,##,###.##',
    'en_IN',
  );

  return formatter.format(value);
}

String formatAmountWithSymbol(double? val) {
  return '₹${formatAmountWithComma(val)}';
}
