import 'package:flutter/material.dart';

import '../../models/user_expense.dart';
import '../../repositories/expense_repository.dart';
import '../../services/login_auth.dart';
import '../../services/snackbar_service.dart';
import '../../utils/base_page.dart';
import '../../utils/common.dart';
import '../../utils/drop_down_items.dart';
import '../../widgets/custom_date_picker.dart';
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomDropDownField(
                      label: 'Category',
                      hintText: 'Choose your category',
                      items: getExpenseCategories(),
                      onChanged: (value) {
                        _userExpense.category = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomDatePicker(
                      label: 'Date',
                      hintText: 'Enter buy category time',
                      initialValue: _userExpense.date,
                      onChanged: (DateTime p0) {
                        _userExpense.date = p0;
                      },
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
                      minLines: 2,
                      maxLines: 4,
                      prefixIcon: const Icon(Icons.edit_note_rounded, size: 18),
                      onChanged: (value) {
                        _userExpense.note = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(
                        color: Color(0xFF1E3A8A),
                        width: 2.0,
                      ),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ElevatedButton(
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
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _saveExpense() {
    hideKeyboard();
    showProgressCircle(context);
    ExpenseRepository().addExpense(AuthService().currentUid, _userExpense);
    removeProgressCircle(context);
    Navigator.of(context).pop();
    SnackbarService.showInfoMessage('Expense added successfully !!!');
  }
}
