// modern_popup.dart
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

import '../../ui/state/providers/utility_provider.dart';


enum PopupType { info, success, error, warning }

class CustomPopup extends StatefulWidget {
  final String title;
  final String message;
  final PopupType type;
  final List<Widget>? actions;
  final bool showCloseButton;
  final Duration animationDuration;
  final VoidCallback? onClose;
  final Widget? customIcon;

  const CustomPopup({
    Key? key,
    required this.title,
    required this.message,
    this.type = PopupType.info,
    this.actions,
    this.showCloseButton = true,
    this.animationDuration = const Duration(milliseconds: 400),
    this.onClose,
    this.customIcon,
  }) : super(key: key);

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String message,
    PopupType type = PopupType.info,
    List<Widget>? actions,
    bool showCloseButton = true,
    Duration animationDuration = const Duration(milliseconds: 400),
    VoidCallback? onClose,
    Widget? customIcon,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: animationDuration,
      pageBuilder: (context, animation1, animation2) {
        return CustomPopup(
          title: title,
          message: message,
          type: type,
          actions: actions,
          showCloseButton: showCloseButton,
          animationDuration: animationDuration,
          onClose: onClose,
          customIcon: customIcon,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return _buildTransition(animation, child);
      },
    );
  }

  static Widget _buildTransition(Animation<double> animation, Widget child) {
    const begin = Offset(0.0, 0.2);
    const end = Offset.zero;
    const curve = Curves.easeOutExpo;

    var slideAnimation = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var scaleAnimation = Tween(begin: 0.8, end: 1.0).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(slideAnimation),
      child: ScaleTransition(
        scale: animation.drive(scaleAnimation),
        child: child,
      ),
    );
  }

  @override
  State<CustomPopup> createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> with SingleTickerProviderStateMixin {
  late AnimationController _iconAnimationController;
  late Animation<double> _iconAnimation;
  late UtilityProvider utilityProvider;
  @override
  void initState() {
    super.initState();
    _iconAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  utilityProvider = UtilityProvider();
    _iconAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _iconAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _iconAnimationController.forward();
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        margin: const EdgeInsets.all(24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: _getAccentColor().withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(),
                  _buildBody(),
                  if (widget.actions != null) _buildActions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        CustomPaint(
          painter: HeaderPainter(
            color: _getAccentColor(),
            type: widget.type,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            width: double.infinity,
            child: Column(
              children: [
                _buildAnimatedIcon(),
                const SizedBox(height: 16),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _getAccentColor(),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.showCloseButton)
          Positioned(
            right: 8,
            top: 8,
            child: IconButton(
              icon: Icon(Icons.close, color: _getAccentColor()),
              onPressed: widget.onClose ?? () => Navigator.of(context).pop(),
            ),
          ),
      ],
    );
  }

  Widget _buildAnimatedIcon() {
    return ScaleTransition(
      scale: _iconAnimation,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getAccentColor().withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: widget.customIcon ?? Icon(
          _getIcon(),
          color: _getAccentColor(),
          size: 40,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Text(
        widget.message,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.actions!.map((action) {
          if (action is TextButton) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _styleTextButton(action),
            );
          }
          if (action is ElevatedButton) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _styleElevatedButton(action),
            );
          }
          return action;
        }).toList(),
      ),
    );
  }

  Widget _styleTextButton(TextButton button) {
    return TextButton(
      onPressed: button.onPressed,
      style: TextButton.styleFrom(
        foregroundColor: _getAccentColor(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: button.child!,
    );
  }

  Widget _styleElevatedButton(ElevatedButton button) {
    return ElevatedButton(
      onPressed: button.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _getAccentColor(),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: button.child!,
    );
  }

  IconData _getIcon() {
    switch (widget.type) {
      case PopupType.success:
        return Icons.check_circle_rounded;
      case PopupType.error:
        return Icons.error_rounded;
      case PopupType.warning:
        return Icons.warning_rounded;
      case PopupType.info:
      default:
        return Icons.info_rounded;
    }
  }

  Color _getAccentColor() {
    switch (widget.type) {
      case PopupType.success:
        return const Color(0xFF00C853);
      case PopupType.error:
        return const Color(0xFFFF3D00);
      case PopupType.warning:
        return const Color(0xFFFFAB00);
      case PopupType.info:
      default:
        return const Color(0xFF2196F3);
    }
  }
}

class HeaderPainter extends CustomPainter {
  final Color color;
  final PopupType type;

  HeaderPainter({required this.color, required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();

    switch (type) {
      case PopupType.success:
        _drawSuccessPattern(canvas, size, paint);
        break;
      case PopupType.error:
        _drawErrorPattern(canvas, size, paint);
        break;
      case PopupType.warning:
        _drawWarningPattern(canvas, size, paint);
        break;
      case PopupType.info:
        _drawInfoPattern(canvas, size, paint);
        break;
    }
  }

  void _drawSuccessPattern(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height,
      size.width * 0.5,
      size.height * 0.8,
    );
    path.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.6,
      0,
      size.height,
    );
    path.close();
    canvas.drawPath(path, paint);

    // Add decorative circles
    for (var i = 0; i < 5; i++) {
      final circlePaint = Paint()
        ..color = color.withOpacity(0.05)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(size.width * (0.2 * i), size.height * 0.3),
        10,
        circlePaint,
      );
    }
  }

  void _drawErrorPattern(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    for (var i = 0; i < 3; i++) {
      path.moveTo(size.width * (0.2 + i * 0.3), 0);
      path.lineTo(size.width * (0.3 + i * 0.3), size.height);
    }
    canvas.drawPath(path, paint);

    // Add X patterns
    paint.strokeWidth = 2;
    paint.style = PaintingStyle.stroke;
    for (var i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(size.width * (0.1 + i * 0.25), size.height * 0.2),
        Offset(size.width * (0.2 + i * 0.25), size.height * 0.4),
        paint,
      );
      canvas.drawLine(
        Offset(size.width * (0.2 + i * 0.25), size.height * 0.2),
        Offset(size.width * (0.1 + i * 0.25), size.height * 0.4),
        paint,
      );
    }
  }

  void _drawWarningPattern(Canvas canvas, Size size, Paint paint) {
    for (var i = 0; i < 8; i++) {
      final trianglePath = Path();
      trianglePath.moveTo(size.width * (0.1 + i * 0.12), size.height * 0.2);
      trianglePath.lineTo(size.width * (0.15 + i * 0.12), size.height * 0.4);
      trianglePath.lineTo(size.width * (0.05 + i * 0.12), size.height * 0.4);
      trianglePath.close();
      canvas.drawPath(trianglePath, paint);
    }
  }

  void _drawInfoPattern(Canvas canvas, Size size, Paint paint) {
    final wavePaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (var i = 0; i < 3; i++) {
      final path = Path();
      path.moveTo(0, size.height * (0.3 + i * 0.2));

      for (var x = 0; x < size.width; x += 20) {
        path.lineTo(
          x.toDouble(),
          size.height * (0.3 + i * 0.2) +
              math.sin(x * 0.05) * 10,
        );
      }

      canvas.drawPath(path, wavePaint);
    }

    // Add dots
    final dotPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    for (var i = 0; i < 20; i++) {
      canvas.drawCircle(
        Offset(
          size.width * (math.Random().nextDouble()),
          size.height * (math.Random().nextDouble()),
        ),
        2,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(HeaderPainter oldDelegate) =>
      color != oldDelegate.color || type != oldDelegate.type;
}

