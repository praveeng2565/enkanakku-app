import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/login_auth.dart';
import '../../services/update_service.dart';
import '../dashboard/home_page.dart';
import 'login_page.dart';
import 'update_app_dialog.dart';
import 'user_view_model.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _scaleAnimation;
  bool hasUser = true;

  @override
  void initState() {
    super.initState();
    hasUser = AuthService().getUser != null;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller
      ..forward()
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(const Duration(milliseconds: 300), () async {
            final status = await _onLoginSuccess(context);
            if (status && context.mounted) {
              Navigator.pushReplacement(
                context.mounted
                    ? context
                    : throw Exception('Context is not mounted'),
                MaterialPageRoute(
                  builder: (context) =>
                      hasUser ? const HomePage() : const LoginPage(),
                ),
              );
            }
          });
        }
      });
  }

  @override
  void dispose() {
    _controller
      // ..removeStatusListener(listener)
      ..stop()
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'lib/utils/images/launch_bg.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(
              opacity: _animation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('lib/utils/images/launch_logo.png'),
                  const SizedBox(height: 20),
                  const Text(
                    'EN-KANAKKU',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F4C81),
                    ),
                  ),
                  const Text(
                    'One app for every financial responsibility',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8A8A8A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _onLoginSuccess(BuildContext context) async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final updateInfo = await UpdateService().checkForUpdate();
    userViewModel.appVersionErrorMsg = '';
    if (updateInfo != null && context.mounted) {
      userViewModel.appVersionValidated = false;
      await showUpdateDialog(context, updateInfo);
    }
    return userViewModel.appVersionValidated;
  }
}
