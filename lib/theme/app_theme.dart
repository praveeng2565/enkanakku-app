import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_view_model.dart';

ThemeData get lightTheme {
  return ThemeData.light();
}

ThemeData get darkTheme {
  return ThemeData.dark();
}

void showThemePicker(BuildContext context) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (_) {
      final provider = context.read<ThemeViewModel>();
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.brightness_auto),
              title: const Text('System'),
              onTap: () {
                provider.changeTheme(ThemeMode.system);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text('Light'),
              onTap: () {
                provider.changeTheme(ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark'),
              onTap: () {
                provider.changeTheme(ThemeMode.dark);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
