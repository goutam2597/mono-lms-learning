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
  late final AnimationController _introController;
  late final AnimationController _orbitController;
  late final AnimationController _progressController;
  late final Animation<double> _markScale;
  late final Animation<double> _contentOpacity;
  late final Animation<double> _illustrationFloat;

  Timer? _navTimer;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1050),
    );
    _markScale = Tween<double>(begin: 0.84, end: 1).animate(
      CurvedAnimation(parent: _introController, curve: Curves.easeOutBack),
    );
    _contentOpacity = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.12, 0.84, curve: Curves.easeOut),
    );
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);
    _illustrationFloat = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _orbitController, curve: Curves.easeInOut),
    );
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2900),
    )..forward();

    _introController.forward();
    _navTimer = Timer(const Duration(milliseconds: 3200), _navigateToNext);
  }

  void _navigateToNext() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;
    _navTimer?.cancel();

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: child,
            ),
      ),
    );
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _introController.dispose();
    _orbitController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _navigateToNext,
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF081B12), Color(0xFF102D20), Color(0xFF0A2117)],
              stops: [0, 0.54, 1],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              const IgnorePointer(child: CustomPaint(painter: _StarPainter())),
              SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        FadeTransition(
                          opacity: _contentOpacity,
                          child: const _BrandHeader(),
                        ),
                        const Spacer(flex: 1),
                        Expanded(
                          flex: 5,
                          child: Center(
                            child: FadeTransition(
                              opacity: _contentOpacity,
                              child: ScaleTransition(
                                scale: _markScale,
                                child: _buildArtwork(constraints.maxWidth),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeTransition(
                          opacity: _contentOpacity,
                          child: const _WelcomeCopy(),
                        ),
                        const Spacer(flex: 1),
                        _buildLoadingIndicator(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArtwork(double availableWidth) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math
            .min(
              math.min(availableWidth - 56, 330.0),
              constraints.maxHeight - 4,
            )
            .clamp(0.0, 330.0);

        return SizedBox(
          width: size,
          height: size,
          child: AnimatedBuilder(
            animation: _orbitController,
            builder: (context, child) => Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: size * 0.95,
                  height: size * 0.95,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Color(0xFFB6DFC1),
                        Color(0xFF619774),
                        Color(0xFF163C29),
                        Color(0x000C281A),
                      ],
                      stops: [0, 0.35, 0.68, 1],
                    ),
                  ),
                ),
                Transform.rotate(
                  angle: _orbitController.value * math.pi * 0.16,
                  child: Container(
                    width: size * 0.92,
                    height: size * 0.92,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFB6DFC1).withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                ),
                Transform.rotate(
                  angle: -_orbitController.value * math.pi * 0.22,
                  child: SizedBox(
                    width: size * 0.82,
                    height: size * 0.82,
                    child: const CustomPaint(painter: _OrbitPainter()),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, _illustrationFloat.value),
                  child: Image.asset(
                    'assets/images/app_mark.png',
                    width: size * 0.88,
                    height: size * 0.88,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                Positioned(
                  top: size * 0.12,
                  right: size * 0.07,
                  child: const _FloatingBadge(
                    icon: Icons.auto_awesome_rounded,
                    text: 'A BRIGHTER FUTURE',
                  ),
                ),
                Positioned(
                  bottom: size * 0.14,
                  left: size * 0.005,
                  child: const _FloatingBadge(
                    icon: Icons.menu_book_rounded,
                    text: 'LEARN & GROW',
                  ),
                ),
                Positioned(
                  top: size * 0.24,
                  left: size * 0.12,
                  child: _Sparkle(
                    size: size * 0.034,
                    color: const Color(0xFFF1D9A8),
                  ),
                ),
                Positioned(
                  bottom: size * 0.27,
                  right: size * 0.09,
                  child: _Sparkle(
                    size: size * 0.023,
                    color: const Color(0xFFB6DFC1),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 3,
          child: AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) => ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _progressController.value,
                backgroundColor: Colors.white.withValues(alpha: 0.12),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFB6DFC1),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 13),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _LoadingDot(),
              const SizedBox(width: 9),
              Text(
                'PREPARING YOUR NEXT CHAPTER',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.62),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.8,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: const Icon(
            Icons.school_rounded,
            color: Color(0xFFB6DFC1),
            size: 21,
          ),
        ),
        const SizedBox(width: 11),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mono LMS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.1,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'LEARNING, REIMAGINED',
              style: TextStyle(
                color: Color(0xFFB6DFC1),
                fontSize: 8,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.35,
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
            color: Color(0xFFB6DFC1),
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Color(0x6675C793), blurRadius: 8)],
          ),
        ),
      ],
    );
  }
}

class _WelcomeCopy extends StatelessWidget {
  const _WelcomeCopy();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Your next chapter\nstarts here.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            height: 1.14,
            fontWeight: FontWeight.w700,
            letterSpacing: -1.1,
          ),
        ),
        const SizedBox(height: 11),
        Text(
          'Learn at your pace. Grow into your potential.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFFE0EDE3).withValues(alpha: 0.8),
            fontSize: 13,
            height: 1.5,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}

class _FloatingBadge extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FloatingBadge({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF163B29).withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: const Color(0xFFB6DFC1)),
            const SizedBox(width: 5),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 7,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Sparkle extends StatelessWidget {
  final double size;
  final Color color;

  const _Sparkle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.auto_awesome_rounded, size: size, color: color);
  }
}

class _LoadingDot extends StatefulWidget {
  const _LoadingDot();

  @override
  State<_LoadingDot> createState() => _LoadingDotState();
}

class _LoadingDotState extends State<_LoadingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.35, end: 1).animate(_controller),
      child: Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: Color(0xFFB6DFC1),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  const _OrbitPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0xFFB6DFC1).withValues(alpha: 0.55);

    canvas.drawArc(rect, -0.7, 1.35, false, paint);
    canvas.drawArc(rect, math.pi - 0.5, 0.85, false, paint);

    final dot = Paint()..color = const Color(0xFFF1D9A8);
    canvas.drawCircle(Offset(size.width * 0.18, size.height * 0.28), 2.3, dot);
    canvas.drawCircle(Offset(size.width * 0.82, size.height * 0.76), 1.7, dot);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StarPainter extends CustomPainter {
  const _StarPainter();

  static const _stars = <(double, double, double, double)>[
    (0.11, 0.15, 1.3, 0.45),
    (0.82, 0.11, 1.8, 0.36),
    (0.73, 0.27, 1.1, 0.5),
    (0.91, 0.36, 1.5, 0.31),
    (0.08, 0.51, 1.6, 0.28),
    (0.87, 0.62, 1.3, 0.42),
    (0.16, 0.79, 1.1, 0.35),
    (0.78, 0.88, 1.7, 0.3),
    (0.94, 0.8, 1.1, 0.47),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in _stars) {
      canvas.drawCircle(
        Offset(size.width * star.$1, size.height * star.$2),
        star.$3,
        Paint()..color = Colors.white.withValues(alpha: star.$4),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
