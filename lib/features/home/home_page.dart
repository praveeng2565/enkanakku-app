import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../repositories/expense_repository.dart';
import '../../services/login_auth.dart';
import '../../theme/app_theme.dart';
import '../../theme/color.dart';
import '../../utils/base_page.dart';
import '../../utils/common.dart';
import '../../widgets/custom_navigation_bar.dart';
import '../auth/user_view_model.dart';
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
                Navigator.pushNamed(context, '/profile');
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
}
