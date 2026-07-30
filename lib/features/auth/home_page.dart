import 'dart:math';
import 'package:flutter/material.dart';

import '../../models/user_expense.dart';
import '../../repositories/expense_repository.dart';
import '../../services/login_auth.dart';
import '../../utils/base_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Dashboard',
      showNotifications: true,
      showDrawer: true,
      showLogout: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context.mounted
                ? context
                : throw Exception('Context is not mounted'),
            '/AddExpense',
          );
        },
        backgroundColor: const Color(0xFF1E3A8A),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
      bottomNavigationBar: _buildBottomBar(),
      child: Column(
        children: [
          _buildMonthSelector(),
          const SizedBox(height: 24),
          _buildProgressRing(),
          const SizedBox(height: 24),
          _buildSummaryCard(),
          const SizedBox(height: 24),
          _buildRecentSpendingsHeader(),
          const SizedBox(height: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: StreamBuilder(
                stream: ExpenseRepository().watchExpensesForMonth(
                  AuthService().currentUid,
                ),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator.adaptive();
                      }
                      if (snapshot.hasData) {
                        final e = snapshot.data as List<UserExpense>;
                        if (e.isNotEmpty) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: e.length,
                            itemBuilder: (context, int index) {
                              return _SpendingTile(
                                icon: Icons.restaurant,
                                iconColor: const Color(0xFF3D8BFD),
                                title: e[index].category,
                                subtitle: e[index].date.toString(),
                                amount: '₹${e[index].amount}',
                              );
                            },
                          );
                        }
                      }
                      return const Center(
                        child: Text(
                          'No data found. Add new expense using "+" icon',
                        ),
                      );
                    },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 62,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Color(0xFF1E3A8A),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.home, color: Colors.white, size: 20),
            ),
            const Icon(Icons.bar_chart, size: 24, color: Colors.black45),
            const Icon(Icons.access_time, size: 24, color: Colors.black45),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back, size: 20),
        ),
        const SizedBox(width: 8),
        const Text(
          'February 2026',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_forward, size: 20),
        ),
      ],
    );
  }

  Widget _buildProgressRing() {
    return SizedBox(
      width: 190,
      height: 190,
      child: CustomPaint(
        painter: _RingPainter(progress: 0.5),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '50%',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E3A8A),
                ),
              ),
              SizedBox(height: 2),
              Text(
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
      child: const Row(
        children: [
          Expanded(
            child: _SummaryColumn(label: 'Spent so far', value: '5,000'),
          ),
          _VerticalDivider(),
          Expanded(
            child: _SummaryColumn(label: 'Total budget', value: '10,000'),
          ),
          _VerticalDivider(),
          Expanded(
            child: _SummaryColumn(label: 'Remaining', value: '3,200'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSpendingsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent spendings',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'spent ₹1,800 today',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black.withValues(alpha: 0.5),
            ),
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
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.amount,
  });
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withValues(alpha: 0.45),
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

/// Custom-painted ring: grey track + blue progress arc with a rounded
/// stroke cap and a small circular knob marking the progress end,
/// matching the mockup's ring style (not achievable with the default
/// CircularProgressIndicator alone).
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
      ..color = const Color(0xFF1E3A8A)
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
      ..color = const Color(0xFF1E3A8A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawCircle(knobOffset, 7, knobPaint);
    canvas.drawCircle(knobOffset, 7, knobBorderPaint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
