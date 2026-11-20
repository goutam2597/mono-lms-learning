import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';


import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const _introDuration = Duration(milliseconds: 1500);
  static const _progressDuration = Duration(milliseconds: 2800);
  static const _holdDuration = Duration(milliseconds: 3100);

  late final AnimationController _intro;
  late final AnimationController _progress;
  late final AnimationController _ambient;

  late final Animation<double> _markScale;
  late final Animation<double> _markOpacity;
  late final Animation<double> _wordmarkOpacity;
  late final Animation<double> _wordmarkShift;
  late final Animation<double> _progressOpacity;
  late final Animation<double> _hintOpacity;

  Timer? _navTimer;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    _intro = AnimationController(vsync: this, duration: _introDuration);
    _progress = AnimationController(vsync: this, duration: _progressDuration);
    _ambient = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _markScale = Tween<double>(begin: 0.86, end: 1).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0, 0.62, curve: Curves.easeOutCubic),
      ),
    );
    _markOpacity = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0, 0.42, curve: Curves.easeOut),
    );
    _wordmarkOpacity = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.30, 0.86, curve: Curves.easeOut),
    );
    _wordmarkShift = Tween<double>(begin: 14, end: 0).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0.30, 1, curve: Curves.easeOutCubic),
      ),
    );
    _progressOpacity = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.55, 1, curve: Curves.easeOut),
    );
    _hintOpacity = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.80, 1, curve: Curves.easeOut),
    );

    _intro.forward();
    _progress.forward();
    _navTimer = Timer(_holdDuration, _navigateToNext);
  }

  void _navigateToNext() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;
    _navTimer?.cancel();

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 620),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: Tween<double>(begin: 1.02, end: 1).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _intro.dispose();
    _progress.dispose();
    _ambient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _navigateToNext,
      child: Scaffold(
        backgroundColor: const Color(0xFF07160F),
        body: Stack(
          fit: StackFit.expand,
          children: [
            _AuroraBackdrop(animation: _ambient),
            const IgnorePointer(child: CustomPaint(painter: _GrainPainter())),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    const Spacer(flex: 3),
                    _buildMark(),
                    const SizedBox(height: 40),
                    _buildWordmark(),
                    const Spacer(flex: 4),
                    _buildProgress(),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMark() {
    return FadeTransition(
      opacity: _markOpacity,
      child: ScaleTransition(
        scale: _markScale,
        child: SizedBox(
          width: 148,
          height: 148,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Soft halo
              Container(
                width: 148,
                height: 148,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Color(0x3D6FBF95), Color(0x006FBF95)],
                    stops: [0.35, 1],
                  ),
                ),
              ),
              // Slow rotating orbit ring
              AnimatedBuilder(
                animation: _ambient,
                builder: (context, child) => Transform.rotate(
                  angle: _ambient.value * math.pi * 2,
                  child: child,
                ),
                child: const CustomPaint(
                  size: Size(148, 148),
                  painter: _OrbitRingPainter(),
                ),
              ),
              // Glass tile with the monogram
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2A4A38), Color(0xFF17301F)],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.14),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.34),
                      blurRadius: 28,
                      offset: const Offset(0, 14),
                    ),
                    BoxShadow(
                      color: const Color(0xFF7FC9A3).withValues(alpha: 0.16),
                      blurRadius: 40,
                      spreadRadius: -6,
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    // The web favicon mark, not the full wordmark.
                    'assets/images/favicon.png',
                    width: 52,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWordmark() {
    return FadeTransition(
      opacity: _wordmarkOpacity,
      child: AnimatedBuilder(
        animation: _wordmarkShift,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, _wordmarkShift.value),
          child: child,
        ),
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _intro,
              builder: (context, child) {
                final t = Curves.easeOutCubic.transform(
                  const Interval(0.30, 1).transform(_intro.value),
                );
                return Text(
                  'MONO LMS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 8.5 - (4.0 * t),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            Text(
              'LEARNING, REIMAGINED',
              style: TextStyle(
                color: const Color(0xFFB9D9C6).withValues(alpha: 0.62),
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 3.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgress() {
    return FadeTransition(
      opacity: _progressOpacity,
      child: Column(
        children: [
          SizedBox(
            height: 3,
            width: 168,
            child: AnimatedBuilder(
              animation: Listenable.merge([_progress, _ambient]),
              builder: (context, _) => CustomPaint(
                painter: _ProgressPainter(
                  progress: Curves.easeInOutCubic.transform(_progress.value),
                  shimmer: _ambient.value,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          FadeTransition(
            opacity: _hintOpacity,
            child: Text(
              'PREPARING YOUR NEXT CHAPTER',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.38),
                fontSize: 8.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 2.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Three drifting radial blooms over a deep evergreen base.
class _AuroraBackdrop extends StatelessWidget {
  final Animation<double> animation;

  const _AuroraBackdrop({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final t = animation.value * math.pi * 2;
        return Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF061410),
                    Color(0xFF0C2318),
                    Color(0xFF07180F),
                  ],
                  stops: [0, 0.55, 1],
                ),
              ),
            ),
            _bloom(
              alignment: Alignment(
                0.45 + 0.08 * math.cos(t),
                -0.55 + 0.05 * math.sin(t),
              ),
              size: 420,
              color: const Color(0xFF3E8F68),
              opacity: 0.22,
            ),
            _bloom(
              alignment: Alignment(
                -0.95 + 0.07 * math.sin(t + 0.9),
                0.35 + 0.06 * math.cos(t),
              ),
              size: 340,
              color: const Color(0xFF2A6C93),
              opacity: 0.14,
            ),
            _bloom(
              alignment: Alignment(
                0.55 + 0.10 * math.cos(t * 0.75),
                0.95,
              ),
              size: 380,
              color: const Color(0xFF2E7A54),
              opacity: 0.18,
            ),
          ],
        );
      },
    );
  }

  Widget _bloom({
    required Alignment alignment,
    required double size,
    required Color color,
    required double opacity,
  }) {
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: opacity),
                color.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OrbitRingPainter extends CustomPainter {
  const _OrbitRingPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 1;

    final guide = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.055);
    canvas.drawCircle(center, radius, guide);
    canvas.drawCircle(
      center,
      radius - 9,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = const Color(0xFF9AD3B2).withValues(alpha: 0.10),
    );

    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: [Color(0x00A9DEC0), Color(0xFFA9DEC0)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.42,
      math.pi * 0.52,
      false,
      arc,
    );

    canvas.drawCircle(
      Offset(center.dx + radius * 0.99, center.dy - radius * 0.12),
      2.4,
      Paint()..color = const Color(0xFFF3DCAE),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ProgressPainter extends CustomPainter {
  final double progress;
  final double shimmer;

  const _ProgressPainter({required this.progress, required this.shimmer});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.circular(size.height);
    final track = RRect.fromRectAndRadius(Offset.zero & size, radius);

    canvas.drawRRect(
      track,
      Paint()..color = Colors.white.withValues(alpha: 0.09),
    );

    if (progress <= 0) return;

    final fillWidth = size.width * progress.clamp(0, 1);
    final fillRect = Rect.fromLTWH(0, 0, fillWidth, size.height);
    final fill = RRect.fromRectAndRadius(fillRect, radius);

    canvas.drawRRect(
      fill,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF6FB495), Color(0xFFCDEBD8)],
        ).createShader(fillRect),
    );

    // Travelling highlight so the bar reads as alive, not stalled.
    final bandX = (shimmer * (size.width + 60)) - 60;
    canvas.save();
    canvas.clipRRect(fill);
    canvas.drawRect(
      Rect.fromLTWH(bandX, 0, 42, size.height),
      Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0),
            Colors.white.withValues(alpha: 0.55),
            Colors.white.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromLTWH(bandX, 0, 42, size.height)),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ProgressPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.shimmer != shimmer;
}

/// Faint offset dots for texture — cheap, static, no repaint cost.
class _GrainPainter extends CustomPainter {
  const _GrainPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final dot = Paint()..color = Colors.white.withValues(alpha: 0.10);
    const spacing = 46.0;
    for (double y = spacing / 2; y < size.height; y += spacing) {
      for (double x = spacing / 2; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), 0.7, dot);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
