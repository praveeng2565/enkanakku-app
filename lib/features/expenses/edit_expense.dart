import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/user_expense.dart';

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
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _amountController;
  late final TextEditingController _noteController;

  late DateTime _selectedDate;
  late String _selectedCategory;

  bool _isUpdating = false;

  final List<_ExpenseCategory> _categories = const [
    _ExpenseCategory(name: 'Food', icon: Icons.restaurant_rounded),
    _ExpenseCategory(name: 'Travel', icon: Icons.directions_car_rounded),
    _ExpenseCategory(name: 'Shopping', icon: Icons.shopping_bag_rounded),
    _ExpenseCategory(name: 'Bills', icon: Icons.receipt_long_rounded),
    _ExpenseCategory(name: 'Entertainment', icon: Icons.movie_rounded),
    _ExpenseCategory(name: 'Health', icon: Icons.favorite_rounded),
    _ExpenseCategory(name: 'Education', icon: Icons.school_rounded),
    _ExpenseCategory(name: 'EMI', icon: Icons.account_balance_rounded),
    _ExpenseCategory(name: 'Other', icon: Icons.category_rounded),
  ];

  @override
  void initState() {
    super.initState();

    _amountController = TextEditingController(
      text: widget.userExpense.amount! % 1 == 0
          ? widget.userExpense.amount!.toStringAsFixed(0)
          : widget.userExpense.amount!.toString(),
    );

    _noteController = TextEditingController(text: widget.userExpense.note);

    _selectedDate = widget.userExpense.date;
    _selectedCategory = widget.userExpense.category;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed header
            _buildHeader(context),

            // Scrollable form
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAmountCard(context),

                      const SizedBox(height: 26),

                      _buildSectionTitle(context, 'Category'),

                      const SizedBox(height: 9),

                      _buildCategoryCard(context),

                      const SizedBox(height: 22),

                      _buildSectionTitle(context, 'Date'),

                      const SizedBox(height: 9),

                      _buildDateCard(context),

                      const SizedBox(height: 22),

                      _buildSectionTitle(context, 'Note'),

                      const SizedBox(height: 9),

                      _buildNoteCard(context),
                    ],
                  ),
                ),
              ),
            ),

            // Fixed bottom action
            _buildBottomAction(context),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // HEADER
  // ===========================================================================

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 12, 10),
      child: Row(
        children: [
          _CircleButton(
            icon: Icons.arrow_back_rounded,
            onTap: _isUpdating ? null : () => Navigator.pop(context),
          ),

          Expanded(
            child: Column(
              children: [
                Text(
                  'Edit Expense',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Update your expense details',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Keeps title centered
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  // ===========================================================================
  // AMOUNT
  // ===========================================================================

  Widget _buildAmountCard(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primaryContainer, colors.secondaryContainer],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.primary.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.currency_rupee_rounded,
                  size: 18,
                  color: colors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'EXPENSE AMOUNT',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: colors.onSurface,
            ),
            decoration: InputDecoration(
              prefixText: '₹ ',
              prefixStyle: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: colors.primary,
              ),
              hintText: '0.00',
              hintStyle: theme.textTheme.headlineMedium?.copyWith(
                color: colors.onSurfaceVariant.withValues(alpha: 0.45),
                fontWeight: FontWeight.w700,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter amount';
              }

              final amount = double.tryParse(value.trim());

              if (amount == null || amount <= 0) {
                return 'Enter a valid amount';
              }

              return null;
            },
          ),

          const SizedBox(height: 3),

          Text(
            'Change the amount if required',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SECTION TITLE
  // ===========================================================================

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
    );
  }

  // ===========================================================================
  // CATEGORY
  // ===========================================================================

  Widget _buildCategoryCard(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final category = _categories.firstWhere(
      (item) => item.name == _selectedCategory,
      orElse: () =>
          const _ExpenseCategory(name: 'Other', icon: Icons.category_rounded),
    );

    return _InputCard(
      onTap: _showCategorySheet,
      child: Row(
        children: [
          _LeadingIcon(icon: category.icon),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Tap to change category',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          Icon(Icons.chevron_right_rounded, color: colors.onSurfaceVariant),
        ],
      ),
    );
  }

  // ===========================================================================
  // DATE
  // ===========================================================================

  Widget _buildDateCard(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return _InputCard(
      onTap: _selectDate,
      child: Row(
        children: [
          const _LeadingIcon(icon: Icons.calendar_month_rounded),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('dd MMM yyyy').format(_selectedDate),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _isToday(_selectedDate) ? 'Today' : 'Tap to change date',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          Icon(Icons.chevron_right_rounded, color: colors.onSurfaceVariant),
        ],
      ),
    );
  }

  // ===========================================================================
  // NOTE
  // ===========================================================================

  Widget _buildNoteCard(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.65),
        ),
      ),
      child: TextFormField(
        controller: _noteController,
        minLines: 3,
        maxLines: 5,
        textCapitalization: TextCapitalization.sentences,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: 'What was this expense for?',
          hintStyle: TextStyle(color: colors.onSurfaceVariant),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 15, right: 7, top: 15),
            child: Icon(Icons.edit_note_rounded, color: colors.primary),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 48),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.fromLTRB(5, 16, 16, 16),
        ),
      ),
    );
  }

  // ===========================================================================
  // BOTTOM ACTION
  // ===========================================================================

  Widget _buildBottomAction(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.35)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 54,
              child: OutlinedButton(
                onPressed: _isUpdating
                    ? null
                    : () => Navigator.pop(context, false),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.onSurface,
                  side: BorderSide(color: colors.outlineVariant),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            flex: 4,
            child: SizedBox(
              height: 54,
              child: FilledButton(
                onPressed: _isUpdating ? null : _updateExpense,
                style: FilledButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: _isUpdating
                      ? SizedBox(
                          key: const ValueKey('loading'),
                          height: 21,
                          width: 21,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.3,
                            color: colors.onPrimary,
                          ),
                        )
                      : const Row(
                          key: ValueKey('update'),
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_rounded, size: 20),
                            SizedBox(width: 7),
                            Text(
                              'Update Expense',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // CATEGORY SHEET
  // ===========================================================================

  Future<void> _showCategorySheet() async {
    FocusScope.of(context).unfocus();

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: colors.surface,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Change category',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Select a category for this expense',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 18),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (_, index) {
                    final item = _categories[index];

                    final selected = item.name == _selectedCategory;

                    return InkWell(
                      onTap: () {
                        Navigator.pop(sheetContext, item.name);
                      },
                      borderRadius: BorderRadius.circular(17),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        decoration: BoxDecoration(
                          color: selected
                              ? colors.primaryContainer
                              : colors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(
                            color: selected
                                ? colors.primary
                                : colors.outlineVariant,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              item.icon,
                              color: selected
                                  ? colors.primary
                                  : colors.onSurfaceVariant,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: selected
                                    ? FontWeight.w800
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result != null && mounted) {
      setState(() {
        _selectedCategory = result;
      });
    }
  }

  // ===========================================================================
  // DATE
  // ===========================================================================

  Future<void> _selectDate() async {
    FocusScope.of(context).unfocus();

    final result = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (result != null && mounted) {
      setState(() {
        _selectedDate = result;
      });
    }
  }

  // ===========================================================================
  // UPDATE
  // ===========================================================================

  Future<void> _updateExpense() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      // final amount = double.parse(_amountController.text.trim());

      // ==============================================================
      // YOUR REPOSITORY
      // ==============================================================

      // await ExpenseRepository().updateExpense(
      //   expenseId: widget.expenseId,
      //   category: _selectedCategory,
      //   date: _selectedDate,
      //   amount: amount,
      //   note: _noteController.text.trim(),
      // );

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      // true = expense was changed.
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isUpdating = false;
      });

      _showMessage('Unable to update expense. Please try again.');
    }
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  bool _isToday(DateTime date) {
    final now = DateTime.now();

    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }
}

// =============================================================================
// INPUT CARD
// =============================================================================

class _InputCard extends StatelessWidget {
  const _InputCard({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: 0.65),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

// =============================================================================
// LEADING ICON
// =============================================================================

class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: colors.primary, size: 21),
    );
  }
}

// =============================================================================
// HEADER BUTTON
// =============================================================================

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surfaceContainerLow,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          height: 44,
          width: 44,
          child: Icon(icon, size: 22, color: colors.onSurface),
        ),
      ),
    );
  }
}

// =============================================================================
// CATEGORY MODEL
// =============================================================================

class _ExpenseCategory {
  const _ExpenseCategory({required this.name, required this.icon});
  final String name;
  final IconData icon;
}
