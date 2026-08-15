import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_expense.dart';
import '../../repositories/expense_repository.dart';
import '../../services/snackbar_service.dart';
import '../../utils/base_page.dart';
import '../../utils/common.dart';
import '../../utils/drop_down_items.dart';
import '../../widgets/custom_date_picker.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/custom_drop_down_field.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_text_field.dart';
import '../home/home_view_model.dart';

class EditExpense extends StatefulWidget {
  const EditExpense({
    super.key,
    required this.userExpense,
    required this.index,
  });
  final UserExpense userExpense;
  final int index;
  @override
  State<EditExpense> createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {
  late UserExpense _userExpense;
  late TextEditingController _amountController;
  late TextEditingController _noteController;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    _userExpense = widget.userExpense.copyWith();
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
      title: 'Expense Details',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: .end,
              children: [
                if (!isEdit)
                  CustomIconButton(
                    icon: Icons.edit,
                    onTap: () => setState(() {
                      isEdit = true;
                    }),
                  ),
                if (!isEdit)
                  CustomIconButton(
                    icon: Icons.delete,
                    onTap: () {
                      showAlertDialog(
                        context: context,
                        subtitle: 'Are you sure want to delete?',
                        onOkPressed: () async {
                          Navigator.of(context).pop();
                          showProgressCircle(context);
                          await ExpenseRepository()
                              .deleteExpense(_userExpense)
                              .whenComplete(() {
                                removeProgressCircle(context);
                              })
                              .then((void value) {
                                Provider.of<HomeViewModel>(
                                    context,
                                    listen: false,
                                  )
                                  ..expenses.removeAt(widget.index)
                                  ..calculateData();
                                Navigator.of(context).pop();
                                SnackbarService.showInfoMessage(
                                  'Deleted successfully !!!',
                                );
                              })
                              .onError((Object error, StackTrace stackTrace) {
                                SnackbarService.showErrorMessage(error);
                              });
                        },
                      );
                    },
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomDropDownField(
                      label: 'Category',
                      hintText: 'Choose your category',
                      items: getExpenseCategories(),
                      initialValue: _userExpense.category,
                      isDisabled: !isEdit,
                      onChanged: (value) {
                        _userExpense.category = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomDatePicker(
                      label: 'Date',
                      hintText: 'Enter buy category time',
                      initialValue: _userExpense.date,
                      isDisabled: true,
                      onChanged: (DateTime p0) {
                        _userExpense.date = p0;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Amount',
                      hintText: 'Enter your amount',
                      isDisabled: !isEdit,
                      initialValue: formatAmount(_userExpense.amount),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      prefixIcon: Icons.currency_rupee,
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
                      isDisabled: !isEdit,
                      initialValue: _userExpense.note,
                      prefixIcon: Icons.edit_note_rounded,
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
                  if (isEdit)
                    ElevatedButton(
                      onPressed: _validateAndUpdateExpense,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Update Expense',
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

  Future<void> _validateAndUpdateExpense() async {
    hideKeyboard();
    final val = _validate();
    if (!val) return;
    showProgressCircle(context);
    await ExpenseRepository()
        .updateExpense(_userExpense, shouldValidateUpdatedDate: false)
        .whenComplete(() {
          removeProgressCircle(context);
        })
        .then((void value) {
          Provider.of<HomeViewModel>(context, listen: false)
            ..expenses.removeAt(widget.index)
            ..expenses.add(_userExpense)
            ..calculateData();
          Navigator.of(context).pop();
          SnackbarService.showInfoMessage('Expense updated successfully !!!');
        })
        .onError((Object error, StackTrace stackTrace) {
          SnackbarService.showErrorMessage(error);
        });
  }

  bool _validate() {
    if (_userExpense.category.isEmpty) {
      SnackbarService.showErrorMessage('Expense Category cannot be empty');
      return false;
    }
    if (_userExpense.amount == null || _userExpense.amount! <= 0.0) {
      SnackbarService.showErrorMessage(
        'Expense Amount should be greater than 0',
      );
      return false;
    }
    return true;
  }
}
