import 'package:flutter/material.dart';

class CustomBottomSheet {
  static void show(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return child;
      },
    );
  }
}
