import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../repositories/expense_repository.dart';
import '../../utils/base_page.dart';
import '../../utils/common.dart';
import '../../widgets/custom_navigation_bar.dart';
import 'analytics_page.dart';
import 'dashboard_page.dart';
import 'home_view_model.dart';
import 'profile_page.dart';
import 'rooms_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    final vm = context.watch<HomeViewModel>();
    return BasePage(
      title: 'Dashboard',
      showNotifications: true,
      showDrawer: true,
      showLogout: true,
      bottomNavigationBar: FloatingNavigationBar(
        currentIndex: vm.currentPageIndex,
        onTap: vm.changePage,
      ),
      child: IndexedStack(
        index: vm.currentPageIndex,
        children: const [
          DashboardPage(),
          AnalyticsPage(),
          RoomsPage(),
          ProfilePage(),
        ],
      ),
    );
  }
}
