import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_navigation_bar.dart';
import '../profile/profile_page.dart';
import 'dashboard_page.dart';
import 'friends_page.dart';
import 'group_page.dart';
import 'home_view_model.dart';

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

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    return Scaffold(
      bottomNavigationBar: FloatingNavigationBar(
        currentIndex: vm.currentPageIndex,
        onTap: vm.changePage,
      ),
      body: IndexedStack(
        index: vm.currentPageIndex,
        children: const [
          DashboardPage(),
          FriendsPage(),
          GroupPage(),
          ProfilePage(),
        ],
      ),
    );
  }
}
