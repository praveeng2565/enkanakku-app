import 'package:flutter/material.dart';
import '../theme/color.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onTap,
    required this.inputText,
    this.isFilled = true,
  });
  final String inputText;
  final VoidCallback? onTap;
  final bool isFilled;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isFilled ? Palette.primaryColor : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: isFilled
            ? null
            : const BorderSide(color: Palette.primaryColor, width: 2.0),
      ),
      child: Text(
        inputText,
        style: TextStyle(
          fontSize: 16,
          color: isFilled ? Colors.white : Palette.primaryColor,
        ),
      ),
    );
  }
}
