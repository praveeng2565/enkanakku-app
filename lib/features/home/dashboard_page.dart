import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/user_expense.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.scaffoldKey});
  final double monthlyBudget = 30000;
  final double totalSpent = 18450;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final List<ExpenseModel> todayExpenses = const [
    ExpenseModel(
      title: 'Lunch',
      category: 'Food',
      amount: 320,
      icon: Icons.restaurant_rounded,
      time: '1:20 PM',
    ),
    ExpenseModel(
      title: 'Auto',
      category: 'Travel',
      amount: 180,
      icon: Icons.directions_car_rounded,
      time: '10:45 AM',
    ),
    ExpenseModel(
      title: 'Coffee',
      category: 'Food',
      amount: 120,
      icon: Icons.local_cafe_rounded,
      time: '9:15 AM',
    ),
  ];
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
  @override
  Widget build(BuildContext context) {
    final remaining = monthlyBudget - totalSpent;
    final percentage = monthlyBudget == 0
        ? 0.0
        : (totalSpent / monthlyBudget).clamp(0.0, 1.0);
    final todayTotal = todayExpenses.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: _buildMonthCard(context, remaining, percentage),
                  ),
                  SliverToBoxAdapter(
                    child: _buildQuickStats(context, todayTotal),
                  ),
                  SliverToBoxAdapter(
                    child: _buildSectionHeader(
                      context,
                      title: "Today's Expenses",
                      actionText: 'View all',
                      onTap: () {
                        // Open expenses page
                      },
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                    sliver: SliverList.separated(
                      itemCount: todayExpenses.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        return _ExpenseTile(
                          expense: todayExpenses[index],
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/EditExpense',
                              arguments: {
                                'userExpense': UserExpense(
                                  id: '12354',
                                  amount: todayExpenses[index].amount,
                                  date: DateTime(2010),
                                  category: todayExpenses[index].category,
                                  note: todayExpenses[index].title,
                                ),
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
              scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(Icons.more_horiz_outlined),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthCard(
    BuildContext context,
    double remaining,
    double percentage,
  ) {
    final theme = Theme.of(context);
    final spentText = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    ).format(totalSpent);
    final budgetText = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    ).format(monthlyBudget);
    final remainingText = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    ).format(remaining);
    final monthName = DateFormat('MMMM yyyy').format(DateTime.now());
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
                Icon(
                  Icons.calendar_month_rounded,
                  size: 19,
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              spentText,
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
                value: percentage,
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
                  '${(percentage * 100).round()}% used',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  '$remainingText remaining',
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
                  child: _AmountInfo(title: 'Budget', value: budgetText),
                ),
                Container(
                  width: 1,
                  height: 32,
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.18),
                ),
                Expanded(
                  child: _AmountInfo(
                    title: 'Spent',
                    value: spentText,
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

  Widget _buildQuickStats(BuildContext context, double todayTotal) {
    final amount = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    ).format(todayTotal);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.today_rounded,
              title: 'Today',
              value: amount,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              icon: Icons.receipt_long_rounded,
              title: 'Expenses',
              value: '${todayExpenses.length}',
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
  final ExpenseModel expense;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final amount = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    ).format(expense.amount);
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
                  expense.icon,
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
                      '${expense.category} · ${expense.time}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                amount,
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
