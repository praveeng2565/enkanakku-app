import 'package:flutter/material.dart';

import '../../models/user_expense.dart';
import '../../repositories/expense_repository.dart';
import '../../services/login_auth.dart';
import '../../services/snackbar_service.dart';
import '../../utils/base_page.dart';
import '../../utils/common.dart';
import '../../utils/drop_down_items.dart';
import '../../widgets/custom_drop_down_field.dart';
import '../../widgets/custom_text_field.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  late UserExpense _userExpense;
  late TextEditingController _amountController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _userExpense = UserExpense(id: getNewID(), date: DateTime.now());
    _amountController = TextEditingController();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Add Expense',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            CustomDropDownField(
              label: 'Category',
              hintText: 'Choose your category',
              items: getExpenseCategories(),
              onChanged: (value) {
                _userExpense.category = value!;
              },
            ),
            const SizedBox(height: 20),
            _buildField(
              label: 'Date',
              child: GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: TextField(
                    controller: TextEditingController(
                      text: _userExpense.date != null
                          ? formatDate(_userExpense.date!)
                          : '',
                    ),
                    decoration: _fieldDecoration(
                      hint: 'Enter buy category time',
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Amount',
              hintText: 'Enter your amount',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              prefixIcon: const Icon(Icons.currency_rupee, size: 18),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _userExpense.amount = double.parse(value);
                }
                if (value.isEmpty) {
                  _userExpense.amount = 0;
                }
              },
            ),

            const SizedBox(height: 20),
            CustomTextField(
              label: 'Note',
              hintText: 'Enter your notes',
              prefixIcon: const Icon(Icons.edit_note_rounded, size: 18),
              onChanged: (value) {
                _userExpense.note = value;
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _saveExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Expense',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final currentDate = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _userExpense.date ?? currentDate,
      firstDate: currentDate.subtract(const Duration(days: 15)),

      lastDate: DateTime(currentDate.year, currentDate.month + 1, 0),
    );
    if (picked != null) {
      setState(() => _userExpense.date = picked);
    }
  }

  Widget _buildField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  void _saveExpense() {
    showProgressCircle(context);
    ExpenseRepository().addExpense(AuthService().currentUid, _userExpense);
    removeProgressCircle(context);
    Navigator.of(context).pop();
    SnackbarService.showInfoMessage('Expense added successfullt !!!');
  }

  InputDecoration _fieldDecoration({required String hint, Widget? prefixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: const Color(0xFFEFF1F5),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}
