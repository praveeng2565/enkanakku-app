import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/login/login_page.dart';
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
    this.showLogout = true,
  });

  final String title;
  final Widget child;
  final bool showNotifications;
  final bool showDrawer;
  final bool showLogout;

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
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
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
      drawer: Drawer(
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
      ),
      body: SafeArea(child: widget.child),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF1E3A8A),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _buildBottomBar(),
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
}
