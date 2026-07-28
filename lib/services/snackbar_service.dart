import 'package:flutter/material.dart';

class SnackbarService {
  SnackbarService._();

  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showInfoMessage(String message) {
    _showMessage(message);
  }

  static void showErrorMessage(String error) {
    _showMessage(error, isError: true);
  }

  static void _showMessage(String msg, {bool isError = false}) {
    if (messengerKey.currentState != null) {
      messengerKey.currentState!
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
}
