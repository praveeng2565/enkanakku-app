import 'package:flutter/material.dart';

import '../theme/color.dart';

class FloatingNavigationBar extends StatelessWidget {
  const FloatingNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .08),
                blurRadius: 30,
                spreadRadius: 2,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            children: [
              _item(context, 0, Icons.home_rounded, 'Home'),
              _item(context, 1, Icons.people, 'Friends'),
              _item(context, 2, Icons.groups, 'Groups'),
              _item(context, 3, Icons.person_rounded, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(BuildContext context, int index, IconData icon, String label) {
    final selected = currentIndex == index;
    const primary = Palette.primaryColor;

    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        onTap: () => onTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? primary.withValues(alpha: .12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 250),
                scale: selected ? 1.15 : 1,
                child: Icon(
                  icon,
                  color: selected ? primary : Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? primary : Colors.grey.shade500,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
