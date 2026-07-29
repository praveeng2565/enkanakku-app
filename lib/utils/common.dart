import 'package:flutter/material.dart';

import '../core/constants.dart';

String getNewID() {
  final date = DateTime.now();
  return date.year.toString() +
      date.month.toString() +
      date.day.toString() +
      AppConstants.hash +
      date.hour.toString() +
      date.minute.toString() +
      date.second.toString();
}

void showProgressCircle(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.grey[200],
          color: Colors.blue,
          strokeWidth: 4.0,
        ),
      );
    },
  );
}

void removeProgressCircle(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop('dialog');
}

String formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}
