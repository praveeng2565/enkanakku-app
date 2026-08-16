import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/user_expense.dart';
import '../../repositories/expense_repository.dart';
import '../../repositories/user_session.dart';
import '../../services/progress_service.dart';
import '../../utils/common.dart';
import '../../utils/drop_down_items.dart';
import '../../widgets/custom_drop_down_field.dart';
import 'home_view_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, required this.scaffoldKey});
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<ReminderModel> upcoming = const [
    ReminderModel(
      title: 'Home Loan',
      subtitle: 'EMI payment',
      amount: '₹12,500',
      dueText: 'Due in 3 days',
      icon: Icons.account_balance_rounded,
      type: ReminderType.loan,
    ),
    ReminderModel(
      title: 'Health Insurance',
      subtitle: 'Premium payment',
      amount: '₹4,200',
      dueText: 'Due in 8 days',
      icon: Icons.shield_outlined,
      type: ReminderType.insurance,
    ),
    ReminderModel(
      title: 'Laptop Warranty',
      subtitle: 'Warranty expires',
      amount: null,
      dueText: '12 days left',
      icon: Icons.verified_outlined,
      type: ReminderType.warranty,
    ),
  ];
  late HomeViewModel dashboardViewModel;
  bool hasData = true;
  @override
  void initState() {
    super.initState();
    super.initState();
    hasData = false;
    dashboardViewModel = Provider.of<HomeViewModel>(context, listen: false);
    dashboardViewModel
      ..currentDate = DateTime.now()
      ..dashMonthYear = DateTime.now()
      ..reset();
  }

  Future<void> loadData([bool showProgress = true]) async {
    if (showProgress) {
      ProgressService.show(context, message: 'Fetching data...');
    }
    dashboardViewModel.reset();
    await ExpenseRepository()
        .getExpensesForMonth(dashboardViewModel.dashMonthYear)
        .then((List<UserExpense>? value) {
          dashboardViewModel.expenses = value!;
          dashboardViewModel.calculateData();
        })
        .catchError((_) {});
    if (showProgress) ProgressService.hide(context);
    hasData = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Consumer<HomeViewModel>(
                builder:
                    (
                      BuildContext context,
                      HomeViewModel dashVm,
                      Widget? child,
                    ) {
                      return hasData
                          ? pageBody()
                          : FutureBuilder(
                              future: loadData(false),
                              builder: (context, asyncSnapshot) {
                                if (asyncSnapshot.hasData && hasData) {
                                  return pageBody();
                                }
                                if (asyncSnapshot.hasError) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 32,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.error_outline_rounded,
                                            size: 64,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          ),
                                          const SizedBox(height: 24),
                                          Text(
                                            'Something went wrong',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            "We're unable to load your data at the moment.\nPlease refresh or try again later.",
                                            textAlign: TextAlign.center,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                          ),
                                          const SizedBox(height: 32),
                                          FilledButton.icon(
                                            onPressed: loadData,
                                            icon: const Icon(
                                              Icons.refresh_rounded,
                                            ),
                                            label: const Text('Refresh'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            );
                    },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/AddExpense');
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Expense'),
        heroTag: 'dashboard_page',
      ),
    );
  }

  Widget pageBody() {
    return RefreshIndicator.noSpinner(
      onRefresh: () async {
        if (UserSession.instance.isDev) await loadData();
      },
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildMonthCard(context)),
          SliverToBoxAdapter(child: _buildQuickStats(context)),
          if (dashboardViewModel.expenses.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildSectionHeader(
                context,
                title: 'Previous Expenses',
                actionText: 'View all',
                onTap: () {
                  // Open expenses page
                },
              ),
            ),
          if (dashboardViewModel.expenses.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              sliver: SliverList.separated(
                itemCount: dashboardViewModel.expenses.length > 3
                    ? 3
                    : dashboardViewModel.expenses.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return _ExpenseTile(
                    expense: dashboardViewModel.expenses[index],
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/EditExpense',
                        arguments: {
                          'userExpense': dashboardViewModel.expenses[index],
                          'index': index,
                        },
                      );
                    },
                  );
                },
              ),
            ),
          SliverToBoxAdapter(
            child: _buildSectionHeader(
              context,
              title: 'Upcoming',
              actionText: 'View all',
              onTap: () {
                // Open reminders
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverList.separated(
              itemCount: upcoming.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return _ReminderTile(
                  reminder: upcoming[index],
                  onTap: () {
                    // Open respective page
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 12, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back 👋',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Here's your financial overview",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: () {
              // Notifications
            },
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          IconButton.filledTonal(
            onPressed: () {
              widget.scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(Icons.more_horiz_outlined),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthCard(BuildContext context) {
    final theme = Theme.of(context);
    final monthName = DateFormat(
      'MMMM yyyy',
    ).format(dashboardViewModel.dashMonthYear);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withValues(alpha: 0.82),
            ],
          ),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    monthName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                InkWell(
                  child: Icon(
                    Icons.calendar_month_rounded,
                    size: 19,
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                  ),
                  onTap: () async {
                    final selectedDate = await showMonthYearPicker(
                      context,
                      initialDate: dashboardViewModel.dashMonthYear,
                    );
                    if (selectedDate != null) {
                      dashboardViewModel.dashMonthYear = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                      );
                      loadData();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              formatAmountWithSymbol(dashboardViewModel.totalSpent),
              style: theme.textTheme.displaySmall?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Total spent',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.75),
              ),
            ),
            const SizedBox(height: 22),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: dashboardViewModel.totalSpentPerc,
                minHeight: 8,
                backgroundColor: theme.colorScheme.onPrimary.withValues(
                  alpha: 0.18,
                ),
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  '${(dashboardViewModel.totalSpentPerc * 100).round()}% used',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  '${formatAmountWithSymbol(dashboardViewModel.totalRemaining)} remaining',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _AmountInfo(
                    title: 'Budget',
                    value: formatAmountWithSymbol(
                      dashboardViewModel.monthlyBudget,
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 32,
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.18),
                ),
                Expanded(
                  child: _AmountInfo(
                    title: 'Spent',
                    value: formatAmountWithSymbol(
                      dashboardViewModel.totalSpent,
                    ),
                    alignEnd: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> showMonthYearPicker(
    BuildContext context, {
    DateTime? initialDate,
  }) async {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    final firstEnabledMonth = DateTime(now.year, now.month - 2);
    DateTime selectedMonth = DateTime(
      initialDate?.year ?? now.year,
      initialDate?.month ?? now.month,
    );
    // Make sure initial date is inside allowed range.
    if (selectedMonth.isBefore(firstEnabledMonth)) {
      selectedMonth = firstEnabledMonth;
    }
    if (selectedMonth.isAfter(currentMonth)) {
      selectedMonth = currentMonth;
    }
    return showDialog<DateTime>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Select Month'),
              content: SizedBox(
                width: 320,
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: 3,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.25,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    final month = DateTime(now.year, now.month - 2 + index);
                    final isSelected =
                        month.year == selectedMonth.year &&
                        month.month == selectedMonth.month;
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() {
                          selectedMonth = month;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          DateFormat('MMM\nyyyy').format(month),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context, selectedMonth);
                  },
                  child: const Text('Select'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.today_rounded,
              title: 'Today',
              value: formatAmountWithSymbol(dashboardViewModel.spentToday),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              icon: Icons.receipt_long_rounded,
              title: 'Expenses',
              value: '${dashboardViewModel.expenses.length}',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              icon: Icons.event_rounded,
              title: 'Upcoming',
              value: '${upcoming.length}',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required String actionText,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 16, 12),
      child: Row(
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          TextButton(onPressed: onTap, child: Text(actionText)),
        ],
      ),
    );
  }
}

class _AmountInfo extends StatelessWidget {
  const _AmountInfo({
    required this.title,
    required this.value,
    this.alignEnd = false,
  });
  final String title;
  final String value;
  final bool alignEnd;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
  });
  final IconData icon;
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 19, color: theme.colorScheme.primary),
          const SizedBox(height: 7),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseTile extends StatelessWidget {
  const _ExpenseTile({required this.expense, required this.onTap});
  final UserExpense expense;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = getExpenseCategories().firstWhere(
      (DropDownItems element) =>
          element.show && element.value == expense.category,
      orElse: () => const DropDownItems(value: 'Item', label: 'Expense'),
    );
    final String time = formatTime(expense.date);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  item.icon,
                  color: theme.colorScheme.secondary,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${item.label} · $time',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                formatAmountWithSymbol(expense.amount),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({required this.reminder, required this.onTap});
  final ReminderModel reminder;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(19),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(19),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  reminder.icon,
                  color: theme.colorScheme.tertiary,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      reminder.subtitle,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      reminder.dueText,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              if (reminder.amount != null)
                Text(
                  reminder.amount!,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpenseModel {
  const ExpenseModel({
    required this.title,
    required this.category,
    required this.amount,
    required this.icon,
    required this.time,
  });
  final String title;
  final String category;
  final double amount;
  final IconData icon;
  final String time;
}

enum ReminderType { loan, insurance, warranty }

class ReminderModel {
  const ReminderModel({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.dueText,
    required this.icon,
    required this.type,
  });
  final String title;
  final String subtitle;
  final String? amount;
  final String dueText;
  final IconData icon;
  final ReminderType type;
}
