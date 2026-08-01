import 'package:flutter/material.dart';

class LoadingOverlay {
  LoadingOverlay._();

  static final LoadingOverlay instance = LoadingOverlay._();

  OverlayEntry? _overlayEntry;

  void show() {
    if (_overlayEntry != null) return;

    final overlayState = navigatorKey.currentState?.overlay;

    if (overlayState == null) return;

    _overlayEntry = OverlayEntry(
      builder: (_) => const Material(
        color: Colors.black45,
        child: Center(child: CircularProgressIndicator()),
      ),
    );

    overlayState.insert(_overlayEntry!);
  }

  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
