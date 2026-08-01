import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/enum.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({
    super.key,
    required this.label,
    this.initialValue,
    this.hintText,
    this.prefixIcon,
    this.type = DatePickerType.allowAllDates,
    required this.onChanged,
    this.isDisabled = false,
  });

  final String label;
  final String? hintText;
  final bool isDisabled;
  final Widget? prefixIcon;
  final DatePickerType type;
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
                enabled: !widget.isDisabled,
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
    if (widget.isDisabled) return;
    final currentDate = DateTime.now();
    final (DateTime, DateTime) date = _getDates();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_controller.text) ?? currentDate,
      firstDate: date.$1,
      lastDate: date.$2,
    );
    if (picked != null) {
      _controller.text = _formatDate(picked);
      widget.onChanged(picked);
    }
  }

  (DateTime, DateTime) _getDates() {
    final currentDate = DateTime.now();
    switch (widget.type) {
      case DatePickerType.allowAllDates:
        return (
          DateTime(currentDate.year - 50),
          DateTime(currentDate.year + 50),
        );
      case DatePickerType.monthlyExpense:
        return (
          DateTime(currentDate.year, currentDate.month),
          DateTime(currentDate.year, currentDate.month + 1, 0),
        );
      case DatePickerType.monthlyExpenseWithException:
        return (
          DateTime(currentDate.year, currentDate.month - 1),
          DateTime(currentDate.year, currentDate.month + 1, 0),
        );
    }
  }

  String _formatDate(DateTime? date) {
    final currentDate = date ?? DateTime.now();
    return DateFormat('dd-MMM-yyyy').format(currentDate);
  }
}
