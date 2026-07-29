import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/auth/login_page.dart';
import '../services/login_auth.dart';
import '../theme/theme_view_model.dart';
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
                // Handle notifications action
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
                  const DrawerHeader(
                    decoration: BoxDecoration(color: Colors.blue),
                    child: Text('Hello...'),
                  ),
                  ListTile(
                    title: const Text('Theme Toggle'),
                    onTap: () {
                      context.read<ThemeViewModel>().toggleTheme();
                    },
                  ),
                  ListTile(
                    title: const Text('Item 2'),
                    onTap: () {
                      // Handle item 2 tap
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
}
