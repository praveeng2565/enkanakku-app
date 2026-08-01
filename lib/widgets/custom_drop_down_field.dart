import 'package:flutter/material.dart';

class CustomDropDownField extends StatefulWidget {
  const CustomDropDownField({
    super.key,
    required this.label,
    this.initialValue,
    this.hintText,
    this.isDisabled = false,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String? hintText;
  final String? initialValue;
  final bool isDisabled;
  final List<DropDownItems> items;
  final Function(String?) onChanged;

  @override
  State<CustomDropDownField> createState() => _CustomDropDownFieldState();
}

class _CustomDropDownFieldState extends State<CustomDropDownField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
        DropdownButtonFormField<String>(
          initialValue: widget.initialValue,
          onChanged: widget.isDisabled ? null : widget.onChanged,
          items: widget.items
              .map(
                (c) => DropdownMenuItem(
                  value: c.value,
                  child: Text(c.label, style: const TextStyle(fontSize: 14)),
                ),
              )
              .toList(),
          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
          decoration: InputDecoration(
            hintText: widget.hintText,
            // hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
            filled: true,
            fillColor: Theme.of(context).inputDecorationTheme.fillColor,
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

class DropDownItems {
  const DropDownItems({
    required this.value,
    required this.label,
    this.show = true,
    this.iconData = Icons.shopping_cart_checkout_sharp,
    this.iconColor = const Color(0xFF3D8BFD),
  });
  final String value;
  final String label;
  final bool show;
  final IconData iconData;
  final Color iconColor;
}
