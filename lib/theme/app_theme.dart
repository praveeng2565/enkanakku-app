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
  final themeProvider = context.read<ThemeViewModel>();
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Theme',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              _themeTile(
                context,
                title: 'System',
                subtitle: 'Use device theme',
                icon: Icons.brightness_auto_rounded,
                mode: ThemeMode.system,
                selected: themeProvider.themeMode == ThemeMode.system,
                onTap: () {
                  themeProvider.changeTheme(ThemeMode.system);
                  Navigator.pop(context);
                },
              ),
              _themeTile(
                context,
                title: 'Light',
                subtitle: 'Always use light theme',
                icon: Icons.light_mode_rounded,
                mode: ThemeMode.light,
                selected: themeProvider.themeMode == ThemeMode.light,
                onTap: () {
                  themeProvider.changeTheme(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              _themeTile(
                context,
                title: 'Dark',
                subtitle: 'Always use dark theme',
                icon: Icons.dark_mode_rounded,
                mode: ThemeMode.dark,
                selected: themeProvider.themeMode == ThemeMode.dark,
                onTap: () {
                  themeProvider.changeTheme(ThemeMode.dark);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _themeTile(
  BuildContext context, {
  required String title,
  required String subtitle,
  required IconData icon,
  required ThemeMode mode,
  required bool selected,
  required VoidCallback onTap,
}) {
  final colors = Theme.of(context).colorScheme;
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    leading: Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: selected
            ? colors.primaryContainer
            : colors.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: selected ? colors.onPrimaryContainer : colors.onSurfaceVariant,
      ),
    ),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    subtitle: Text(subtitle),
    trailing: selected
        ? Icon(Icons.check_circle_rounded, color: colors.primary)
        : null,
    onTap: onTap,
  );
}
