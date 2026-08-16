import 'package:flutter/material.dart';

import '../services/login_auth.dart';
import '../services/progress_service.dart';

class BasePage extends StatefulWidget {
  const BasePage({
    super.key,
    required this.title,
    required this.child,
    this.showNotifications = false,
    this.drawer,
    this.showLogout = false,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  final String title;
  final Widget child;
  final bool showNotifications;
  final Widget? drawer;
  final bool showLogout;
  final Widget? floatingActionButton;
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
                ProgressService.show(context);
                await AuthService().logout();
                ProgressService.hide(context);
                Navigator.pushReplacementNamed(context, '/Login');
              },
            ),
        ],
      ),
      drawer: widget.drawer,
      body: SafeArea(child: widget.child),
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}
