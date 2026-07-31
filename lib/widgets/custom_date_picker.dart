import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({
    super.key,
    required this.label,
    this.initialValue,
    this.hintText,
    this.prefixIcon,
    required this.onChanged,
  });

  final String label;
  final String? hintText;
  final Widget? prefixIcon;
  final DateTime? initialValue;
  final Function(DateTime) onChanged;

  @override
  State<CustomDatePicker> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomDatePicker> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _formatDate(widget.initialValue));
  }

  @override
  void dispose() {
    _controller.dispose();
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
        InkWell(
          onTap: _pickDate,
          child: AbsorbPointer(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
                suffixIcon: const Icon(Icons.calendar_month_outlined, size: 18),
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                contentPadding: const EdgeInsets.all(14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final currentDate = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_controller.text) ?? currentDate,
      firstDate: DateTime(currentDate.year, currentDate.month),

      lastDate: DateTime(currentDate.year, currentDate.month + 1, 0),
    );
    if (picked != null) {
      _controller.text = _formatDate(picked);
      widget.onChanged(picked);
    }
  }

  String _formatDate(DateTime? date) {
    final currentDate = date ?? DateTime.now();
    return DateFormat('dd-MMM-yyyy').format(currentDate);
  }
}
