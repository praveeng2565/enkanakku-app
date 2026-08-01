import 'package:flutter/material.dart';

import '../theme/color.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({super.key, required this.onTap, required this.icon});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => onTap.call(),
        child: Card(
          color: Palette.primaryColor,
          elevation: 5,
          child: DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(icon, size: 20, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
