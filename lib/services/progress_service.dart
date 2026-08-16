import 'dart:ui';

import 'package:flutter/material.dart';

class ProgressService {
  ProgressService._();

  static bool _isShowing = false;

  static void show(BuildContext context, {String message = 'Loading....'}) {
    if (_isShowing) return;

    _isShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ---------------------------------------------------------------
              // BACKGROUND
              // ---------------------------------------------------------------
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(color: Colors.black.withValues(alpha: 0.20)),
              ),

              // ---------------------------------------------------------------
              // LOADER
              // ---------------------------------------------------------------
              Center(child: _LoadingIndicator(message: message)),
            ],
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    if (!_isShowing) return;

    _isShowing = false;

    final navigator = Navigator.of(context, rootNavigator: true);

    if (navigator.canPop()) {
      navigator.pop();
    }
  }
}

class _LoadingIndicator extends StatelessWidget {

  const _LoadingIndicator({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final primaryColor = theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ---------------------------------------------------------------------
          // CIRCULAR LOADER
          // ---------------------------------------------------------------------
          SizedBox(
            width: 42,
            height: 42,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              color: primaryColor,
              backgroundColor: primaryColor.withValues(alpha: 0.18),
            ),
          ),

          const SizedBox(height: 14),

          // ---------------------------------------------------------------------
          // MESSAGE
          // ---------------------------------------------------------------------
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: primaryColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
