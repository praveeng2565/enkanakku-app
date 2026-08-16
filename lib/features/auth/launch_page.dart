import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  late UserViewModel userViewModel;

  @override
  void initState() {
    super.initState();
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
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
      ..addStatusListener(statusListener);
  }

  Future<void> statusListener(AnimationStatus status) async {
    if (status == AnimationStatus.completed) {
      await userViewModel.validateAppUpdate(context);
      if (userViewModel.appVersionValidated) {
        final route = await userViewModel.getInitialPageRoute();
        Future.delayed(const Duration(milliseconds: 250), () {
          if (!context.mounted) return;
          Navigator.pushReplacementNamed(context, route);
        });
      }
    }
  }

  @override
  void dispose() {
    _controller
      ..stop()
      ..removeStatusListener(statusListener)
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
}
