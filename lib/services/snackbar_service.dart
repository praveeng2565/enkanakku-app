import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/enum.dart';

class SnackbarService {
  SnackbarService._();
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();
  static const Duration _defaultDuration = Duration(seconds: 4);
  // ===========================================================================
  // INFO
  // ===========================================================================
  static void showInfoMessage(dynamic message, {BuildContext? context}) {
    _showMessage(message, context: context, type: SnackType.info);
  }

  // ===========================================================================
  // SUCCESS
  // ===========================================================================
  static void showSuccessMessage(dynamic message, {BuildContext? context}) {
    _showMessage(message, context: context, type: SnackType.success);
  }

  // ===========================================================================
  // ERROR
  // ===========================================================================
  static void showErrorMessage(dynamic error, {BuildContext? context}) {
    _showMessage(error, context: context, type: SnackType.error);
  }

  // ===========================================================================
  // MAIN
  // ===========================================================================
  static void _showMessage(
    dynamic message, {
    BuildContext? context,
    required SnackType type,
  }) {
    final messenger = context != null
        ? ScaffoldMessenger.of(context)
        : messengerKey.currentState;
    if (messenger == null) return;
    final text = _parseMessage(message);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: _PremiumSnackbar(
            message: text,
            type: type,
            duration: _defaultDuration,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
          showCloseIcon: false,
        ),
      );
  }

  // ===========================================================================
  // MESSAGE PARSER
  // ===========================================================================
  static String _parseMessage(dynamic message) {
    if (message is FirebaseAuthException) {
      return message.message ?? 'Technical error. Please try again.';
    }
    if (message is Exception) {
      return message.toString().replaceFirst('Exception: ', '');
    }
    if (message == null) {
      return 'Technical error. Please try again.';
    }
    return message.toString();
  }
}

// =============================================================================
// PREMIUM SNACKBAR
// =============================================================================
class _PremiumSnackbar extends StatefulWidget {
  const _PremiumSnackbar({
    required this.message,
    required this.type,
    required this.duration,
  });
  final String message;
  final SnackType type;
  final Duration duration;
  @override
  State<_PremiumSnackbar> createState() => _PremiumSnackbarState();
}

class _PremiumSnackbarState extends State<_PremiumSnackbar>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _progressController;
  late AnimationController _messageController;
  late Animation<double> _fade;
  late Animation<double> _scale;
  late Animation<Offset> _slide;
  late Animation<double> _messageFade;
  late Animation<Offset> _messageSlide;
  bool _isClosing = false;
  // ===========================================================================
  // COLORS
  // ===========================================================================
  static const Color _successColor = Color(0xFF00A878);
  static const Color _errorColor = Color(0xFFE5484D);
  static const Color _infoColor = Color(0xFF4F6BED);
  Color get accentColor {
    switch (widget.type) {
      case SnackType.success:
        return _successColor;
      case SnackType.error:
        return _errorColor;
      case SnackType.info:
        return _infoColor;
    }
  }

  Color get iconBackground {
    switch (widget.type) {
      case SnackType.success:
        return const Color(0xFFE5F7F1);
      case SnackType.error:
        return const Color(0xFFFDEBEC);
      case SnackType.info:
        return const Color(0xFFEBEEFF);
    }
  }

  IconData get icon {
    switch (widget.type) {
      case SnackType.success:
        return Icons.check_rounded;
      case SnackType.error:
        return Icons.close_rounded;
      case SnackType.info:
        return Icons.info_outline_rounded;
    }
  }

  String get title {
    switch (widget.type) {
      case SnackType.success:
        return 'Success';
      case SnackType.error:
        return 'Error';
      case SnackType.info:
        return 'Info';
    }
  }

  // ===========================================================================
  // INIT
  // ===========================================================================
  @override
  void initState() {
    super.initState();
    // -------------------------------------------------------------------------
    // ENTRY
    // -------------------------------------------------------------------------
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
      reverseDuration: const Duration(milliseconds: 250),
    );
    _fade = CurvedAnimation(parent: _entryController, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
    );
    _slide = Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
        );
    // -------------------------------------------------------------------------
    // MESSAGE
    // -------------------------------------------------------------------------
    _messageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _messageFade = CurvedAnimation(
      parent: _messageController,
      curve: Curves.easeOut,
    );
    _messageSlide =
        Tween<Offset>(begin: const Offset(0.04, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _messageController,
            curve: Curves.easeOutCubic,
          ),
        );
    // -------------------------------------------------------------------------
    // PROGRESS
    // -------------------------------------------------------------------------
    _progressController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _start();
  }

  Future<void> _start() async {
    _entryController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;
    _messageController.forward();
    _progressController.forward();
  }

  // ===========================================================================
  // CLOSE
  // ===========================================================================
  Future<void> _close() async {
    if (_isClosing) return;
    _isClosing = true;
    _progressController.stop();
    await _entryController.reverse();
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================
  @override
  void dispose() {
    _entryController.dispose();
    _progressController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF1E2025) : Colors.white;
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF17181C);
    final secondaryTextColor = isDark
        ? Colors.white.withValues(alpha: 0.62)
        : const Color(0xFF62666F);
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: ScaleTransition(
          scale: _scale,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: accentColor.withValues(alpha: 0.15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.30 : 0.12),
                  blurRadius: 22,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildContent(primaryTextColor, secondaryTextColor),
                _buildProgress(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // CONTENT
  // ===========================================================================
  Widget _buildContent(Color primaryTextColor, Color secondaryTextColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 13, 8, 13),
      child: Row(
        children: [
          // -------------------------------------------------------------------
          // ICON
          // -------------------------------------------------------------------
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: accentColor, size: 24),
          ),
          const SizedBox(width: 12),
          // -------------------------------------------------------------------
          // MESSAGE
          // -------------------------------------------------------------------
          Expanded(
            child: SlideTransition(
              position: _messageSlide,
              child: FadeTransition(
                opacity: _messageFade,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.message,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // -------------------------------------------------------------------
          // CLOSE
          // -------------------------------------------------------------------
          const SizedBox(width: 4),
          _buildCloseButton(),
        ],
      ),
    );
  }

  // ===========================================================================
  // CLOSE BUTTON
  // ===========================================================================
  Widget _buildCloseButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _close,
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          width: 38,
          height: 38,
          child: Center(
            child: Icon(
              Icons.close_rounded,
              size: 19,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.40),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // PROGRESS BAR
  // ===========================================================================
  Widget _buildProgress() {
    return SizedBox(
      height: 3,
      child: AnimatedBuilder(
        animation: _progressController,
        builder: (context, child) {
          return Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 1 - _progressController.value,
              child: Container(decoration: BoxDecoration(color: accentColor)),
            ),
          );
        },
      ),
    );
  }
}
