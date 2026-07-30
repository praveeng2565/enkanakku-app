import 'package:flutter/material.dart';

class SnackbarService {
  SnackbarService._();

  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showInfoMessage(String message, {BuildContext? context}) {
    _showMessage(message, context: context);
  }

  static void showErrorMessage(String error, {BuildContext? context}) {
    _showMessage(error, context: context, isError: true);
  }

  static void _showMessage(
    String msg, {
    BuildContext? context,
    bool isError = false,
  }) {
    final state = (context == null)
        ? messengerKey.currentState!
        : ScaffoldMessenger.of(context);
    state
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(msg),
          duration: const Duration(seconds: 3),
          showCloseIcon: true,
          backgroundColor: isError ? Colors.redAccent : Colors.grey,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
