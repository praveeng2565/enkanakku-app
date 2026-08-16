import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../repositories/user_session.dart';
import '../../services/login_auth.dart';
import '../../services/progress_service.dart';
import '../../services/snackbar_service.dart';
import '../../theme/theme_view_model.dart';
import '../../utils/common.dart';
import '../../utils/enum.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _mobile;
  late final AnimationController _bubbleController;
  PageType pageType = PageType.login;
  bool loginObscure = true;
  double _bubbleTime = 0.0;
  DateTime? _lastFrameTime;
  @override
  void initState() {
    super.initState();
    if (UserSession.instance.isDev) {
      _name = TextEditingController(text: 'Praveen Keerthana');
      _email = TextEditingController(text: 'lifeledgerappdev@gmail.com');
      _password = TextEditingController(text: 'TestPassword@2026()');
      _mobile = TextEditingController(text: '9698357997');
    } else {
      _name = TextEditingController();
      _email = TextEditingController();
      _password = TextEditingController();
      _mobile = TextEditingController();
    }
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _mobile.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      resizeToAvoidBottomInset: false,
      body: AnimatedBuilder(
        animation: _bubbleController,
        builder: (context, child) {
          final now = DateTime.now();
          if (_lastFrameTime != null) {
            final elapsed =
                now.difference(_lastFrameTime!).inMicroseconds /
                Duration.microsecondsPerSecond;
            _bubbleTime += elapsed;
          }
          _lastFrameTime = now;
          return Stack(
            fit: StackFit.expand,
            children: [
              // BACKGROUND
              Positioned.fill(child: _buildBackground(context)),
              // MOVING GLASS BUBBLES
              Positioned.fill(
                child: CustomPaint(
                  painter: GlassBubblePainter(
                    time: _bubbleTime,
                    colors: Theme.of(context).colorScheme,
                  ),
                ),
              ),
              // VERY SUBTLE OVERLAY
              Positioned.fill(
                child: Container(
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.045),
                ),
              ),
              // CONTENT
              Positioned.fill(
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: _buildMainContent(context),
                  ),
                ),
              ),
              // THEME BUTTON
              Positioned(
                top: 8,
                right: 8,
                child: SafeArea(child: _buildThemeButton(context)),
              ),
            ],
          );
        },
      ),
    );
  }

  // BACKGROUND
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

  // MAIN CONTENT
  Widget _buildMainContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 44),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeader(context),
                const SizedBox(height: 25),
                _buildAuthCard(context),
                const SizedBox(height: 16),
                _buildSecurityText(context),
              ],
            ),
          ),
        );
      },
    );
  }

  // HEADER
  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Image.asset('lib/utils/images/app_logo_text.png'),
    );
  }

  // AUTH CARD
  Widget _buildAuthCard(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isLogin = pageType == PageType.login;
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 460),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // TRANSPARENT GLASS CARD
        color: colors.surface.withValues(alpha: 0.70),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.13),
            blurRadius: 35,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildAuthSelector(context),
          const SizedBox(height: 21),
          Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  isLogin
                      ? Icons.login_rounded
                      : Icons.person_add_alt_1_rounded,
                  color: colors.primary,
                  size: 21,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isLogin ? 'Welcome back' : 'Create your account',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isLogin
                          ? 'Continue managing your money'
                          : 'Start your financial journey',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 19),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  alignment: Alignment.centerLeft,
                  child: child,
                ),
              );
            },
            child: isLogin
                ? _buildLoginForm(context)
                : _buildSignupForm(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthSelector(BuildContext context) {
    final isLogin = pageType == PageType.login;
    final colors = Theme.of(context).colorScheme;
    return Container(
      height: 52,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.onSurface.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: colors.onSurface.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _selectorItem(
              context,
              title: 'Sign In',
              selected: isLogin,
              onTap: () {
                if (!isLogin) {
                  _changePage(PageType.login);
                }
              },
            ),
          ),
          Expanded(
            child: _selectorItem(
              context,
              title: 'Sign Up',
              selected: !isLogin,
              onTap: () {
                if (isLogin) {
                  _changePage(PageType.signUp);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectorItem(
    BuildContext context, {
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 230),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: selected ? colors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.20),
                    blurRadius: 11,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: selected ? colors.onPrimary : colors.onSurfaceVariant,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Column(
      key: const ValueKey('login_form'),
      children: [
        _textField(
          context,
          controller: _email,
          label: 'Email or mobile',
          hint: 'Enter email or mobile number',
          icon: Icons.person_outline_rounded,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        _passwordField(context),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _forgotPassword,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
            child: Text(
              'Forgot password?',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 3),
        _mainButton(
          context,
          title: 'Sign In',
          icon: Icons.arrow_forward_rounded,
        ),
      ],
    );
  }

  // =========================================================================
  // SIGNUP FORM
  // =========================================================================
  Widget _buildSignupForm(BuildContext context) {
    return Column(
      key: const ValueKey('signup_form'),
      children: [
        _textField(
          context,
          controller: _name,
          label: 'Full name',
          hint: 'Enter your full name',
          icon: Icons.person_outline_rounded,
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: 13),
        _textField(
          context,
          controller: _email,
          label: 'Email',
          hint: 'Enter your email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 13),
        _textField(
          context,
          controller: _mobile,
          label: 'Mobile number',
          hint: 'Enter 10 digit mobile number',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 13),
        _passwordField(context),
        const SizedBox(height: 18),
        _mainButton(
          context,
          title: 'Create Account',
          icon: Icons.person_add_alt_1_rounded,
        ),
      ],
    );
  }

  // =========================================================================
  // TEXT FIELD
  // =========================================================================
  Widget _textField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          decoration: _inputDecoration(context, hint: hint, icon: icon),
        ),
      ],
    );
  }

  // =========================================================================
  // PASSWORD FIELD
  // =========================================================================
  Widget _passwordField(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _password,
          obscureText: loginObscure,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) {
            _submit();
          },
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          decoration: _inputDecoration(
            context,
            hint: 'Enter your password',
            icon: Icons.lock_outline_rounded,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  loginObscure = !loginObscure;
                });
              },
              icon: Icon(
                loginObscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 20,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // INPUT DECORATION
  // =========================================================================
  InputDecoration _inputDecoration(
    BuildContext context, {
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    final colors = Theme.of(context).colorScheme;
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: colors.onSurfaceVariant.withValues(alpha: 0.55),
        fontSize: 13,
      ),
      prefixIcon: Icon(icon, color: colors.primary, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      // Slightly transparent.
      fillColor: colors.surface.withValues(alpha: 0.38),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: colors.onSurface.withValues(alpha: 0.06)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: colors.primary, width: 1.2),
      ),
    );
  }

  // =========================================================================
  // MAIN BUTTON
  // =========================================================================
  Widget _mainButton(
    BuildContext context, {
    required String title,
    required IconData icon,
  }) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: _submit,
        style: FilledButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          disabledBackgroundColor: colors.primary.withValues(alpha: 0.50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: Row(
            key: const ValueKey('button'),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 9),
              Icon(icon, size: 19),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // SECURITY TEXT
  // =========================================================================
  Widget _buildSecurityText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.lock_outline_rounded,
          size: 13,
          color: Colors.white.withValues(alpha: 0.70),
        ),
        const SizedBox(width: 5),
        Text(
          'Your financial data stays private',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
            color: Colors.white.withValues(alpha: 0.75),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // THEME BUTTON
  // =========================================================================
  Widget _buildThemeButton(BuildContext context) {
    final themeVM = context.watch<ThemeViewModel>();
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
          ),
        ],
      ),
      child: IconButton(
        tooltip: 'Change theme',
        onPressed: () {
          context.read<ThemeViewModel>().changeTheme(
            themeVM.isDark ? ThemeMode.light : ThemeMode.dark,
          );
        },
        icon: Icon(
          themeVM.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  // =========================================================================
  // CHANGE PAGE
  // =========================================================================
  void _changePage(PageType type) {
    hideKeyboard();
    setState(() {
      pageType = type;
    });
  }

  // =========================================================================
  // SUBMIT
  // =========================================================================
  Future<void> _submit() async {
    hideKeyboard();
    final isLogin = pageType == PageType.login;
    // ---------------------------------------------------------------
    // NAME
    // ---------------------------------------------------------------
    if (!isLogin && _name.text.trim().isEmpty) {
      SnackbarService.showErrorMessage('Name cannot be empty');
      return;
    }
    // ---------------------------------------------------------------
    // EMAIL
    // ---------------------------------------------------------------
    if (_email.text.trim().isEmpty) {
      SnackbarService.showErrorMessage('Email cannot be empty');
      return;
    }
    // ---------------------------------------------------------------
    // MOBILE
    // ---------------------------------------------------------------
    if (!isLogin && _mobile.text.trim().isEmpty) {
      SnackbarService.showErrorMessage('Mobile no cannot be empty');
      return;
    }
    if (!isLogin && _mobile.text.trim().length != 10) {
      SnackbarService.showErrorMessage('Mobile no should be 10 digits');
      return;
    }
    // ---------------------------------------------------------------
    // PASSWORD
    // ---------------------------------------------------------------
    if (_password.text.isEmpty) {
      SnackbarService.showErrorMessage('Password cannot be empty');
      return;
    }
    // ---------------------------------------------------------------
    // START LOADING
    // ---------------------------------------------------------------
    ProgressService.show(context);
    try {
      late bool status;
      // =============================================================
      // LOGIN
      // =============================================================
      if (isLogin) {
        status = await AuthService().loginUser(
          email: _email.text.trim(),
          password: _password.text,
        );
      }
      // =============================================================
      // SIGN UP
      // =============================================================
      else {
        status = await AuthService().createUser(
          name: _name.text.trim(),
          email: _email.text.trim(),
          password: _password.text,
          mobile: _mobile.text.trim(),
        );
      }
      if (!mounted) {
        return;
      }
      if (!status) {
        return;
      }
      ProgressService.hide(context);
      // =============================================================
      // SUCCESS
      // =============================================================
      Navigator.pushReplacementNamed(context, '/Home');
    } catch (error) {
      if (!mounted) {
        return;
      }
      ProgressService.hide(context);
      SnackbarService.showErrorMessage(error.toString());
    } finally {}
  }

  // =========================================================================
  // FORGOT PASSWORD
  // =========================================================================
  Future<void> _forgotPassword() async {
    SnackbarService.showInfoMessage('Coming soon');
  }
}

// =============================================================================
// GLASS BUBBLE PAINTER
// =============================================================================
class GlassBubblePainter extends CustomPainter {
  GlassBubblePainter({required this.time, required this.colors});
  final double time;
  final ColorScheme colors;
  static const List<_GlassBubble> bubbles = [
    _GlassBubble(x: 0.08, y: 0.15, size: 170, speed: 0.34, phase: 0.0),
    _GlassBubble(x: 0.88, y: 0.18, size: 110, speed: 0.46, phase: 1.4),
    _GlassBubble(x: 0.80, y: 0.58, size: 210, speed: 0.27, phase: 2.5),
    _GlassBubble(x: 0.12, y: 0.72, size: 125, speed: 0.40, phase: 3.5),
    _GlassBubble(x: 0.55, y: 0.05, size: 80, speed: 0.52, phase: 4.0),
    _GlassBubble(x: 0.45, y: 0.90, size: 150, speed: 0.30, phase: 5.0),
  ];
  @override
  void paint(Canvas canvas, Size size) {
    for (final bubble in bubbles) {
      _drawBubble(canvas, size, bubble);
    }
  }

  // =========================================================================
  // DRAW BUBBLE
  // =========================================================================
  void _drawBubble(Canvas canvas, Size screen, _GlassBubble bubble) {
    // ---------------------------------------------------------------
    // CONTINUOUS MOVEMENT
    // ---------------------------------------------------------------
    final movementTime = time * bubble.speed;
    final dx = math.sin(movementTime + bubble.phase) * 28;
    final dy = math.cos(movementTime * 0.8 + bubble.phase) * 32;
    final center = Offset(
      bubble.x * screen.width + dx,
      bubble.y * screen.height + dy,
    );
    final radius = bubble.size / 2;
    // =============================================================
    // SOFT SHADOW
    // =============================================================
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.055)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    canvas.drawCircle(center.translate(0, 7), radius, shadowPaint);
    // =============================================================
    // GLASS BODY
    // =============================================================
    final glassPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.35, -0.40),
        radius: 1.0,
        colors: [
          // Reduced visibility.
          Colors.white.withValues(alpha: 0.14),
          Colors.white.withValues(alpha: 0.055),
          Colors.white.withValues(alpha: 0.015),
          Colors.transparent,
        ],
        stops: const [0.0, 0.35, 0.70, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, glassPaint);
    // =============================================================
    // GLASS BORDER
    // =============================================================
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..shader = SweepGradient(
        colors: [
          Colors.white.withValues(alpha: 0.42),
          Colors.white.withValues(alpha: 0.04),
          Colors.white.withValues(alpha: 0.20),
          Colors.white.withValues(alpha: 0.04),
          Colors.white.withValues(alpha: 0.42),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius - 1, borderPaint);
    // =============================================================
    // LARGE GLASS REFLECTION
    // =============================================================
    final reflectionPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.20),
          Colors.white.withValues(alpha: 0.05),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    final reflectionRect = Rect.fromCircle(
      center: center.translate(-radius * 0.18, -radius * 0.25),
      radius: radius * 0.55,
    );
    canvas.drawOval(reflectionRect, reflectionPaint);
    // =============================================================
    // SMALL HIGHLIGHT
    // =============================================================
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(
      center.translate(-radius * 0.38, -radius * 0.38),
      radius * 0.09,
      highlightPaint,
    );
    // =============================================================
    // BOTTOM GLASS REFLECTION
    // =============================================================
    final bottomPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, Colors.white.withValues(alpha: 0.06)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.82),
      0.15,
      math.pi - 0.3,
      false,
      bottomPaint,
    );
  }

  @override
  bool shouldRepaint(covariant GlassBubblePainter oldDelegate) {
    return oldDelegate.time != time || oldDelegate.colors != colors;
  }
}

// =============================================================================
// GLASS BUBBLE MODEL
// =============================================================================
class _GlassBubble {
  const _GlassBubble({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.phase,
  });
  final double x;
  final double y;
  final double size;
  final double speed;
  final double phase;
}
