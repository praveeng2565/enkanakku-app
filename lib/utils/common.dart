import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getNewID() {
  return DateFormat('yyyyMMMdd#HHmmss#SSS').format(DateTime.now());
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
            color: Colors.blue,
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
