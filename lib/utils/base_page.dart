import 'package:flutter/material.dart';

import '../features/auth/login_page.dart';
import '../services/login_auth.dart';
import '../theme/app_theme.dart';
import '../theme/color.dart';
import 'common.dart';

class BasePage extends StatefulWidget {
  const BasePage({
    super.key,
    required this.title,
    required this.child,
    this.showNotifications = false,
    this.showDrawer = false,
    this.showLogout = false,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  final String title;
  final Widget child;
  final bool showNotifications;
  final bool showDrawer;
  final bool showLogout;
  final FloatingActionButton? floatingActionButton;
  final Widget? bottomNavigationBar;

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          if (widget.showNotifications)
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                Navigator.pushNamed(context, '/notification');
              },
            ),
          if (widget.showLogout)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                showProgressCircle(context);
                await AuthService().logout();
                removeProgressCircle(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const LoginPage(),
                  ),
                );
              },
            ),
        ],
      ),
      drawer: widget.showDrawer
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
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
                    decoration: const BoxDecoration(
                      color: Palette.primaryColor,
                    ),
                    onDetailsPressed: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
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
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () async {
                      Navigator.pop(context);
                      showProgressCircle(context);
                      await AuthService().logout();
                      removeProgressCircle(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const LoginPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          : null,
      body: SafeArea(child: widget.child),
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: widget.bottomNavigationBar,
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
