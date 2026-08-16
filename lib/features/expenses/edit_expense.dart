import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/user_expense.dart';
import '../../repositories/expense_repository.dart';
import '../../services/progress_service.dart';
import '../../services/snackbar_service.dart';
import '../../utils/drop_down_items.dart';
import '../../widgets/custom_drop_down_field.dart';
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
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _noteController;
  late TextEditingController _titleController;
  late UserExpense _userExpense;
  late List<DropDownItems> _categories;
  @override
  void initState() {
    super.initState();
    _userExpense = widget.userExpense.copyWith();
    _amountController = TextEditingController(
      text: _userExpense.amount! % 1 == 0
          ? _userExpense.amount!.toStringAsFixed(0)
          : _userExpense.amount!.toString(),
    );
    _noteController = TextEditingController(text: _userExpense.note);
    _titleController = TextEditingController(text: _userExpense.title);
    _categories = getExpenseCategories();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAmountCard(context),
                      const SizedBox(height: 26),
                      _buildSectionLabel(context, 'Title'),
                      const SizedBox(height: 9),
                      _buildTitleField(context),
                      const SizedBox(height: 22),
                      _buildSectionLabel(context, 'Category'),
                      const SizedBox(height: 9),
                      _buildCategorySelector(context),
                      const SizedBox(height: 22),
                      _buildSectionLabel(context, 'When'),
                      const SizedBox(height: 9),
                      _buildDateSelector(context),
                      const SizedBox(height: 22),
                      _buildSectionLabel(context, 'Note'),
                      const SizedBox(height: 9),
                      _buildNoteField(context),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomActions(context),
          ],
        ),
      ),
    );
  }

  // HEADER
  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 12, 8),
      child: Row(
        children: [
          _HeaderButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.pop(context),
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
        ],
      ),
    );
  }

  // AMOUNT CARD
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
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.currency_rupee_rounded,
                  size: 17,
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
          const SizedBox(height: 14),
          TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.onSurface,
            ),
            decoration: InputDecoration(
              prefixText: '₹ ',
              prefixStyle: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.primary,
              ),
              hintText: '0.00',
              hintStyle: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.onSurfaceVariant.withValues(alpha: 0.45),
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
            onChanged: (String value) {
              _formKey.currentState!.clearError();
              if (value.isEmpty) {
                _userExpense.amount = 0;
              } else {
                _userExpense.amount = double.parse(value);
              }
            },
          ),
          const SizedBox(height: 4),
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

  // SECTION LABEL
  Widget _buildSectionLabel(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: 0.1,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CATEGORY
  // ---------------------------------------------------------------------------
  Widget _buildCategorySelector(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final DropDownItems category = _categories.firstWhere(
      (item) => item.value == _userExpense.category,
      orElse: () => const DropDownItems(label: '', value: ''),
    );
    return _InputCard(
      onTap: _showCategorySheet,
      child: Row(
        children: [
          _LeadingIcon(
            icon: category.icon,
            selected: category.value.isNotEmpty,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.label.isNotEmpty
                      ? category.label
                      : 'Choose a category',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: category.value.isNotEmpty
                        ? colors.onSurface
                        : colors.onSurfaceVariant,
                  ),
                ),
                if (category.value.isEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Tap to change category',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: colors.onSurfaceVariant),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DATE
  // ---------------------------------------------------------------------------
  Widget _buildDateSelector(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return _InputCard(
      onTap: () {},
      child: Row(
        children: [
          const _LeadingIcon(
            icon: Icons.calendar_month_outlined,
            selected: true,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('dd MMM yyyy').format(_userExpense.date),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _isToday(_userExpense.date) ? 'Today' : 'Expense date',
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

  // ---------------------------------------------------------------------------
  // NOTE
  // ---------------------------------------------------------------------------
  Widget _buildNoteField(BuildContext context) {
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
          hintText: 'Add more info about this expense',
          hintStyle: TextStyle(color: colors.onSurfaceVariant),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 15, right: 7, top: 15),
            child: Icon(Icons.edit_note_rounded, color: colors.primary),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 48),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.fromLTRB(5, 16, 16, 16),
        ),
        onChanged: (String value) {
          _userExpense.note = value;
        },
      ),
    );
  }

  Widget _buildTitleField(BuildContext context) {
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
        controller: _titleController,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: 'What was this expense for?',
          hintStyle: TextStyle(color: colors.onSurfaceVariant),
          prefixIcon: Icon(
            Icons.insert_comment_outlined,
            color: colors.primary,
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 48),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.fromLTRB(5, 16, 16, 16),
        ),
        onChanged: (String value) {
          _userExpense.title = value;
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BOTTOM ACTIONS
  // ---------------------------------------------------------------------------
  Widget _buildBottomActions(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
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
          // Cancel
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 54,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.onSurface,
                  side: BorderSide(color: colors.outlineVariant),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Save
          Expanded(
            flex: 4,
            child: SizedBox(
              height: 54,
              child: FilledButton(
                onPressed: _saveExpense,
                style: FilledButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                child: const AnimatedSwitcher(
                  duration: Duration(milliseconds: 180),
                  child: Row(
                    key: ValueKey('update'),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Update Expense',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      SizedBox(width: 7),
                      Icon(Icons.arrow_forward_rounded, size: 19),
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

  // ---------------------------------------------------------------------------
  // CATEGORY SHEET
  // ---------------------------------------------------------------------------
  Future<void> _showCategorySheet() async {
    FocusScope.of(context).unfocus();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: colors.surface,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose category',
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
                  itemBuilder: (context, index) {
                    final item = _categories[index];
                    final isSelected = item.value == _userExpense.category;
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context, item.value);
                      },
                      borderRadius: BorderRadius.circular(17),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colors.primaryContainer
                              : colors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(
                            color: isSelected
                                ? colors.primary
                                : colors.outlineVariant,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              item.icon,
                              color: isSelected
                                  ? colors.primary
                                  : colors.onSurfaceVariant,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.label,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.w700
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
    if (selected != null && mounted) {
      setState(() {
        _userExpense.category = selected;
      });
    }
  }

  Future<void> _saveExpense() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_userExpense.title.isEmpty) {
      SnackbarService.showErrorMessage('Expense Title cannot be empty');
      return;
    }
    if (_userExpense.category.isEmpty) {
      SnackbarService.showErrorMessage('Choose any one Category');
      return;
    }
    if (_userExpense.amount == null || _userExpense.amount! <= 0.0) {
      SnackbarService.showErrorMessage(
        'Expense Amount should be greater than 0',
      );
      return;
    }
    try {
      ProgressService.show(context, message: 'Updating expense...');
      await ExpenseRepository()
          .updateExpense(_userExpense, shouldValidateUpdatedDate: false)
          .whenComplete(() {
            ProgressService.hide(context);
          })
          .then((void value) {
            Provider.of<HomeViewModel>(context, listen: false)
              ..expenses.removeAt(widget.index)
              ..expenses.add(_userExpense)
              ..calculateData();
            Navigator.of(context).pop();
            SnackbarService.showSuccessMessage(
              'Expense Updated successfully !!!',
            );
          })
          .onError((Object error, StackTrace stackTrace) {
            SnackbarService.showErrorMessage(error);
          });
    } catch (e) {
      SnackbarService.showErrorMessage(e.toString());
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

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
  const _LeadingIcon({required this.icon, required this.selected});
  final IconData icon;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: selected
            ? colors.primaryContainer
            : colors.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 21,
        color: selected ? colors.primary : colors.onSurfaceVariant,
      ),
    );
  }
}

// =============================================================================
// HEADER BUTTON
// =============================================================================
class _HeaderButton extends StatelessWidget {
  const _HeaderButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
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
          height: 42,
          width: 42,
          child: Icon(icon, color: colors.onSurface, size: 22),
        ),
      ),
    );
  }
}
