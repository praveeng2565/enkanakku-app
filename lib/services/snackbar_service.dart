import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../theme/color.dart';
import '../utils/enum.dart';

class SnackbarService {
  SnackbarService._();

  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showInfoMessage(dynamic message, {BuildContext? context}) {
    _showMessage(message, context: context);
  }

  static void showSuccessMessage(dynamic message, {BuildContext? context}) {
    _showMessage(message, context: context, type: SnackType.success);
  }

  static void showErrorMessage(dynamic error, {BuildContext? context}) {
    _showMessage(error, context: context, type: SnackType.error);
  }

  static void _showMessage(
    dynamic msg, {
    BuildContext? context,
    SnackType type = SnackType.info,
  }) {
    final state = (context == null)
        ? messengerKey.currentState!
        : ScaffoldMessenger.of(context);
    final message = (msg is FirebaseAuthException)
        ? (msg.message ?? 'Technical Error. Please try later.')
        : msg.toString();
    state
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
          showCloseIcon: true,
          backgroundColor: ((type == SnackType.error)
              ? Colors.redAccent
              : ((type == SnackType.success)
                    ? Colors.greenAccent
                    : Palette.color7)),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
