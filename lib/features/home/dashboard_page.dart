import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../repositories/expense_repository.dart';
import '../../services/login_auth.dart';
import '../../theme/app_theme.dart';
import '../../theme/color.dart';
import '../../utils/base_page.dart';
import '../../utils/common.dart';
import '../../utils/drop_down_items.dart';
import '../../widgets/custom_drop_down_field.dart';
import '../../widgets/custom_icon_button.dart';
import '../auth/user_view_model.dart';
import 'home_view_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late HomeViewModel dashboardViewModel;
  bool hasData = true;
  @override
  void initState() {
    super.initState();
    hasData = false;
    dashboardViewModel = Provider.of<HomeViewModel>(context, listen: false);
    dashboardViewModel
      ..currentDate = DateTime.now()
      ..dashMonthYear = DateTime.now()
      ..reset();
  }

  Future<void> loadData([bool showProgress = true]) async {
    if (showProgress) showProgressCircle(context);
    dashboardViewModel
      ..reset()
      ..expenses = (await ExpenseRepository().getExpensesForMonth(
        dashboardViewModel.dashMonthYear,
      ))
      ..calculateData();
    if (showProgress) removeProgressCircle(context);
    hasData = true;
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Dashboard',
      showNotifications: true,
      showLogout: true,
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                'Hello, ${AuthService().getUser?.displayName ?? ''}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              accountEmail: Text(
                '${getGreeting()}! Welcome back.',
                style: const TextStyle(color: Colors.white70),
              ),
              currentAccountPicture: const Padding(
                padding: EdgeInsets.all(3.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Palette.primaryColor,
                  ),
                ),
              ),
              decoration: const BoxDecoration(color: Palette.primaryColor),
              onDetailsPressed: () {
                Navigator.pop(context);
                Provider.of<HomeViewModel>(
                  context,
                  listen: false,
                ).changePage(3);
              },
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.palette_outlined),
                    title: const Text('Switch Theme'),
                    onTap: () => showThemePicker(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                Navigator.pop(context);
                showProgressCircle(context);
                await AuthService().logout();
                removeProgressCircle(context);
                Navigator.pushReplacementNamed(context, '/Login');
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'version ${context.read<UserViewModel>().appVersion}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),

      child: Consumer<HomeViewModel>(
        builder: (BuildContext context, HomeViewModel dashVm, Widget? child) {
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
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                size: 64,
                                color: Theme.of(context).colorScheme.primary,
                              ),

                              const SizedBox(height: 24),

                              Text(
                                'Something went wrong',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),

                              const SizedBox(height: 12),

                              Text(
                                "We're unable to load your data at the moment.\nPlease refresh or try again later.",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),

                              const SizedBox(height: 32),

                              FilledButton.icon(
                                onPressed: loadData,
                                icon: const Icon(Icons.refresh_rounded),
                                label: const Text('Refresh'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return const Center(child: CircularProgressIndicator());
                  },
                );
        },
      ),
    );
  }

  Widget pageBody() {
    return Column(
      children: [
        _buildMonthSelector(),
        const SizedBox(height: 24),
        _buildProgressRing(),
        const SizedBox(height: 24),
        _buildSummaryCard(),
        const SizedBox(height: 24),
        _buildRecentSpendingsHeader(),
        const SizedBox(height: 12),
        _buildExpenseList(),
      ],
    );
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    }
    if (hour < 17) {
      return 'Good afternoon';
    }
    return 'Good evening';
  }

  /* Expanded _buildExpenseList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: StreamBuilder(
          stream: ExpenseRepository().watchExpensesForMonth(
            AuthService().currentUid,
          ),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              final e = snapshot.data as List<UserExpense>;
              if (e.isNotEmpty) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: e.length,
                  itemBuilder: (context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context.mounted
                              ? context
                              : throw Exception('Context is not mounted'),
                          '/EditExpense',
                          arguments: e[index],
                        );
                      },
                      child: _SpendingTile(
                        title: e[index].category,
                        subtitle: e[index].date,
                        amount: e[index].amount,
                      ),
                    );
                  },
                );
              }
            }
            return const Center(
              child: Text(
                'No data found.\nAdd new expense using "+" icon',
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
    );
  } */

  Widget _buildExpenseList() {
    final e = dashboardViewModel.expenses;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: e.isEmpty
            ? const Center(
                child: Text(
                  'No data found\nAdd new expense using "+" icon',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: e.length,
                itemBuilder: (context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/EditExpense',
                        arguments: {'userExpense': e[index], 'index': index},
                      );
                    },
                    child: _SpendingTile(
                      title: e[index].category,
                      subtitle: e[index].date,
                      amount: e[index].amount,
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: canGoLeft
              ? () {
                  dashboardViewModel.dashMonthYear = DateTime(
                    dashboardViewModel.dashMonthYear.year,
                    dashboardViewModel.dashMonthYear.month - 1,
                  );
                  loadData();
                }
              : null,
          icon: const Icon(Icons.arrow_back, size: 20),
        ),
        const SizedBox(width: 8),
        Text(
          DateFormat('MMMM yyyy').format(dashboardViewModel.dashMonthYear),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: canGoRight
              ? () {
                  dashboardViewModel.dashMonthYear = DateTime(
                    dashboardViewModel.dashMonthYear.year,
                    dashboardViewModel.dashMonthYear.month + 1,
                  );
                  loadData();
                }
              : null,
          icon: const Icon(Icons.arrow_forward, size: 20),
        ),
      ],
    );
  }

  bool get canGoLeft {
    final minMonth = DateTime(
      dashboardViewModel.currentDate.year,
      dashboardViewModel.currentDate.month - 3,
    );
    final selectedMonth = DateTime(
      dashboardViewModel.dashMonthYear.year,
      dashboardViewModel.dashMonthYear.month - 1,
    );

    return selectedMonth.isAfter(minMonth);
  }

  bool get canGoRight {
    final selectedMonth = DateTime(
      dashboardViewModel.dashMonthYear.year,
      dashboardViewModel.dashMonthYear.month + 1,
    );
    return selectedMonth.isBefore(dashboardViewModel.currentDate);
  }

  Widget _buildProgressRing() {
    return SizedBox(
      width: 190,
      height: 190,
      child: CustomPaint(
        painter: _RingPainter(progress: dashboardViewModel.totalSpentPerc),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(dashboardViewModel.totalSpentPerc * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Palette.primaryColor,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'spent',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryColumn(
              label: 'Spent so far',
              value: formatAmountWithSymbol(dashboardViewModel.totalSpent),
            ),
          ),
          const _VerticalDivider(),
          Expanded(
            child: _SummaryColumn(
              label: 'Total budget',
              value: formatAmountWithSymbol(dashboardViewModel.totalBudget),
            ),
          ),
          const _VerticalDivider(),
          Expanded(
            child: _SummaryColumn(
              label: 'Remaining',
              value: formatAmountWithSymbol(dashboardViewModel.totalRemaining),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSpendingsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Recent spendings',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  'spent ${formatAmountWithSymbol(dashboardViewModel.spentToday)} today',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          CustomIconButton(
            onTap: () => Navigator.pushNamed(context, '/AddExpense'),
            icon: Icons.add,
          ),
        ],
      ),
    );
  }
}

class _SummaryColumn extends StatelessWidget {
  const _SummaryColumn({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: Colors.black.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 32, color: Colors.black12);
  }
}

class _SpendingTile extends StatelessWidget {
  const _SpendingTile({
    required this.title,
    required this.subtitle,
    required this.amount,
  });
  final String title;
  final DateTime? subtitle;
  final double? amount;

  @override
  Widget build(BuildContext context) {
    final item = getExpenseCategories().firstWhere(
      (DropDownItems element) => element.show && element.value == title,
      orElse: () => const DropDownItems(value: 'Item', label: 'Expense'),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(item.iconData, color: item.iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('dd MMM yyyy').format(subtitle!),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withValues(alpha: 0.45),
                  ),
                ),
              ],
            ),
          ),
          Text(
            formatAmountWithSymbol(amount),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  // 0.0 - 1.0

  _RingPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 18) / 2;

    final trackPaint = Paint()
      ..color = const Color(0xFFE9ECF3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = Palette.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );

    // Small knob dot at the end of the progress arc
    final knobAngle = startAngle + sweepAngle;
    final knobOffset = Offset(
      center.dx + radius * cos(knobAngle),
      center.dy + radius * sin(knobAngle),
    );
    final knobPaint = Paint()..color = Colors.white;
    final knobBorderPaint = Paint()
      ..color = Palette.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawCircle(knobOffset, 7, knobPaint);
    canvas.drawCircle(knobOffset, 7, knobBorderPaint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
