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

  Widget _buildBackground(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color darken(Color color, [double amount = 0.25]) {
      final hsl = HSLColor.fromColor(color);

      return hsl
          .withLightness((hsl.lightness * (1 - amount)).clamp(0.0, 1.0))
          .toColor();
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  darken(colors.primary, 0.15),
                  darken(colors.secondary),
                  darken(colors.tertiary, 0.30),
                  darken(colors.primaryContainer, 0.45),
                ]
              : [
                  colors.primary,
                  colors.secondary,
                  colors.tertiary,
                  colors.primaryContainer,
                ],
          stops: const [0.0, 0.34, 0.70, 1.0],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(child: _buildBackground(context)),
          ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(
              opacity: _animation,
              child: Image.asset('lib/utils/images/app_logo_text.png'),
            ),
          ),
        ],
      ),
    );
  }
}
