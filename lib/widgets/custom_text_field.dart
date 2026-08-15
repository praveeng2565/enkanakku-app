import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.label,
    this.initialValue,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.minLines,
    this.maxLines = 1,
    this.isDisabled = false,
    this.obscure = false,
    required this.onChanged,
  });

  final String label;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? initialValue;
  final int? minLines;
  final int maxLines;
  final bool isDisabled;
  final bool obscure;
  final TextInputType? keyboardType;
  final Function(String) onChanged;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    if (oldWidget.obscure != widget.obscure ||
        oldWidget.isDisabled != widget.isDisabled) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          obscureText: widget.obscure,
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            hintText: widget.hintText,
            // hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, size: 18)
                : null,
            suffixIcon: widget.suffixIcon,
            filled: true,
            enabled: !widget.isDisabled,
            fillColor: Theme.of(context).inputDecorationTheme.fillColor,
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                color: Color(0xFF2347D9),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
