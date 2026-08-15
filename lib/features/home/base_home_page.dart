import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  late HomeViewModel homeViewModel;
  late final PageController _pageController;
  bool hasData = true;
  @override
  void initState() {
    super.initState();
    hasData = false;
    homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    homeViewModel
      ..currentDate = DateTime.now()
      ..dashMonthYear = DateTime.now()
      ..reset();
    _pageController = PageController(
      initialPage: homeViewModel.currentPageIndex,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<Widget> _pages = const [
    DashboardPage(),
    FriendsSplitPage(),
    GroupPage(),
    ProfilePage(),
  ];

  void _onBottomItemTap(int index) {
    if (index == homeViewModel.currentPageIndex) return;

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (BuildContext context, HomeViewModel value, Widget? child) {
        return Scaffold(
          bottomNavigationBar: _AnimatedBottomBar(
            currentIndex: homeViewModel.currentPageIndex,
            onItemSelected: _onBottomItemTap,
          ),
          body: PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),

            itemCount: _pages.length,

            onPageChanged: (index) {
              homeViewModel.changePage(index);
            },

            itemBuilder: (context, index) {
              return _KeepAlivePage(child: _pages[index]);
            },
          ),
        );
      },
    );
  }
}

class _AnimatedBottomBar extends StatelessWidget {

  const _AnimatedBottomBar({
    required this.currentIndex,
    required this.onItemSelected,
  });
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  static const List<_BottomItemData> _items = [
    _BottomItemData(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    _BottomItemData(
      icon: Icons.people_outline_rounded,
      activeIcon: Icons.people_rounded,
      label: 'Friends',
    ),
    _BottomItemData(
      icon: Icons.groups_outlined,
      activeIcon: Icons.groups_rounded,
      label: 'Groups',
    ),
    _BottomItemData(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              blurRadius: 22,
              offset: const Offset(0, 6),
              color: Colors.black.withValues(alpha: 0.08),
            ),
          ],
        ),
        child: Row(
          children: List.generate(_items.length, (index) {
            return Expanded(
              child: _AnimatedBottomItem(
                data: _items[index],
                selected: currentIndex == index,
                onTap: () => onItemSelected(index),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _AnimatedBottomItem extends StatelessWidget {

  const _AnimatedBottomItem({
    required this.data,
    required this.selected,
    required this.onTap,
  });
  final _BottomItemData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final primary = theme.colorScheme.primary;
    final inactive = theme.colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primaryContainer
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeOutBack,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            );
          },
          child: Column(
            key: ValueKey(selected),
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                selected ? data.activeIcon : data.icon,
                size: 21,
                color: selected ? primary : inactive,
              ),

              const SizedBox(height: 3),

              Text(
                data.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: selected ? primary : inactive,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomItemData {

  const _BottomItemData({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
  final IconData icon;
  final IconData activeIcon;
  final String label;
}

class _KeepAlivePage extends StatefulWidget {

  const _KeepAlivePage({required this.child});
  final Widget child;

  @override
  State<_KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<_KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return widget.child;
  }
}
