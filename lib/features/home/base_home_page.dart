import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants.dart';
import '../../services/login_auth.dart';
import '../../theme/app_theme.dart';
import '../../utils/common.dart';
import '../auth/user_view_model.dart';
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
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();
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
    setLoginVerison();
  }

  Future<void> setLoginVerison() async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(AppConstants.loginVersionKey, userViewModel.loginVersion);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<Widget> _pages = [
    DashboardPage(scaffoldKey: scaffoldKey),
    const FriendsSplitPage(),
    const GroupPage(),
    const ProfilePage(),
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
          key: scaffoldKey,
          drawer: getDrawer(context),
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

  Widget getDrawer(BuildContext context) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.82,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),

      child: SafeArea(
        child: Column(
          children: [
            // ============================================================
            // PROFILE HEADER
            // ============================================================
            _buildDrawerHeader(context),

            const SizedBox(height: 10),

            // ============================================================
            // MENU
            // ============================================================
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),

                children: [
                  _drawerItem(
                    context,

                    icon: Icons.home_rounded,

                    title: 'Home',

                    selected: true,

                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  _drawerItem(
                    context,

                    icon: Icons.palette_outlined,

                    title: 'Appearance',

                    subtitle: 'Theme & display',

                    onTap: () {
                      showThemePicker(context);
                    },
                  ),

                  _drawerItem(
                    context,

                    icon: Icons.settings_rounded,

                    title: 'Settings',

                    subtitle: 'App preferences',

                    onTap: () {
                      Navigator.pop(context);

                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                ],
              ),
            ),

            // ============================================================
            // BOTTOM SECTION
            // ============================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),

              child: Column(
                children: [
                  Divider(
                    height: 1,

                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.12),
                  ),

                  const SizedBox(height: 8),

                  // ------------------------------------------------------
                  // LOGOUT
                  // ------------------------------------------------------
                  _drawerItem(
                    context,

                    icon: Icons.logout_rounded,

                    title: 'Logout',

                    danger: true,

                    onTap: () async {
                      Navigator.pop(context);
                      showLogoutDialog(context);
                    },
                  ),

                  const SizedBox(height: 8),

                  // ------------------------------------------------------
                  // VERSION
                  // ------------------------------------------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Icon(
                        Icons.account_balance_wallet_rounded,

                        size: 13,

                        color: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withValues(alpha: 0.65),
                      ),

                      const SizedBox(width: 5),

                      Text(
                        '${AppConstants.appName}  •  v${context.read<UserViewModel>().appVersion}',

                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.65),

                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final user = AuthService().getUser;

    final name = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!.trim()
        : 'User';

    final email = user?.email ?? '';

    return Container(
      width: double.infinity,

      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),

      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),

        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [
            colors.primary,
            colors.primary.withValues(alpha: 0.78),
            colors.secondary.withValues(alpha: 0.72),
          ],
        ),

        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.20),

            blurRadius: 20,

            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ============================================================
          // TOP ROW
          // ============================================================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // --------------------------------------------------------
              // PROFILE IMAGE
              // --------------------------------------------------------
              Container(
                padding: const EdgeInsets.all(3),

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: Colors.white.withValues(alpha: 0.22),

                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                  ),
                ),

                child: CircleAvatar(
                  radius: 30,

                  backgroundColor: Colors.white,

                  child: Text(
                    _getInitials(name),

                    style: TextStyle(
                      color: colors.primary,

                      fontSize: 20,

                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 13),

              // --------------------------------------------------------
              // NAME
              // --------------------------------------------------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      getGreeting(),

                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.72),

                        fontSize: 12,

                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      name,

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        color: Colors.white,

                        fontSize: 17,

                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    if (email.isNotEmpty) ...[
                      const SizedBox(height: 3),

                      Text(
                        email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.70),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // --------------------------------------------------------
              // EDIT
              // --------------------------------------------------------
              Material(
                color: Colors.white.withValues(alpha: 0.12),

                shape: const CircleBorder(),

                child: InkWell(
                  customBorder: const CircleBorder(),

                  onTap: () {
                    Navigator.pop(context);
                    _onBottomItemTap(3);
                  },

                  child: const Padding(
                    padding: EdgeInsets.all(9),

                    child: Icon(
                      Icons.edit_outlined,

                      color: Colors.white,

                      size: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ============================================================
          // MINI BRAND
          // ============================================================
          Row(
            children: [
              Container(
                height: 26,
                width: 26,

                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),

                  borderRadius: BorderRadius.circular(8),
                ),

                child: const Icon(
                  Icons.account_balance_wallet_rounded,

                  color: Colors.white,

                  size: 14,
                ),
              ),

              const SizedBox(width: 8),

              const Text(
                AppConstants.appName,

                style: TextStyle(
                  color: Colors.white,

                  fontSize: 12,

                  fontWeight: FontWeight.w800,

                  letterSpacing: 0.2,
                ),
              ),

              const Spacer(),

              Text(
                'Manage smarter',

                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.62),

                  fontSize: 10,

                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,

    String? subtitle,

    bool selected = false,

    bool danger = false,
  }) {
    final colors = Theme.of(context).colorScheme;

    final itemColor = danger
        ? colors.error
        : selected
        ? colors.primary
        : colors.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),

      child: Material(
        color: selected
            ? colors.primary.withValues(alpha: 0.10)
            : Colors.transparent,

        borderRadius: BorderRadius.circular(17),

        child: InkWell(
          onTap: onTap,

          borderRadius: BorderRadius.circular(17),

          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),

            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),

              border: selected
                  ? Border.all(color: colors.primary.withValues(alpha: 0.10))
                  : null,
            ),

            child: Row(
              children: [
                // ========================================================
                // ICON
                // ========================================================
                Container(
                  height: 40,
                  width: 40,

                  decoration: BoxDecoration(
                    color: danger
                        ? colors.error.withValues(alpha: 0.08)
                        : selected
                        ? colors.primary.withValues(alpha: 0.12)
                        : colors.onSurface.withValues(alpha: 0.045),

                    borderRadius: BorderRadius.circular(13),
                  ),

                  child: Icon(icon, size: 20, color: itemColor),
                ),

                const SizedBox(width: 13),

                // ========================================================
                // TEXT
                // ========================================================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        title,

                        style: TextStyle(
                          color: itemColor,

                          fontSize: 13.5,

                          fontWeight: selected
                              ? FontWeight.w800
                              : FontWeight.w600,
                        ),
                      ),

                      if (subtitle != null) ...[
                        const SizedBox(height: 2),

                        Text(
                          subtitle,

                          style: TextStyle(
                            color: colors.onSurfaceVariant.withValues(
                              alpha: 0.72,
                            ),

                            fontSize: 10.5,

                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // ========================================================
                // SELECTED ARROW
                // ========================================================
                if (selected)
                  Icon(
                    Icons.arrow_forward_ios_rounded,

                    size: 13,

                    color: colors.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return 'U';
    }

    if (parts.length == 1) {
      return parts.first
          .substring(0, math.min(2, parts.first.length))
          .toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
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
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 15),
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
