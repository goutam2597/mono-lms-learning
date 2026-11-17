import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final Animation<double> _markScale;
  late final Animation<double> _contentOpacity;
  late final AnimationController _progressController;

  Timer? _navTimer;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
    _markScale = Tween<double>(begin: 0.88, end: 1).animate(
      CurvedAnimation(parent: _introController, curve: Curves.easeOutBack),
    );
    _contentOpacity = CurvedAnimation(
      parent: _introController,
      curve: Curves.easeOut,
    );
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..forward();
    _introController.forward();
    _navTimer = Timer(const Duration(milliseconds: 2800), _navigateToNext);
  }

  void _navigateToNext() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;
    _navTimer?.cancel();

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
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
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _navigateToNext,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8F4),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 7,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(36),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF3C5948),
                              AppColors.primary,
                              Color(0xFF23362B),
                            ],
                            stops: [0, 0.58, 1],
                          ),
                        ),
                      ),
                      Positioned(
                        top: -108,
                        right: -90,
                        child: _ambientDisc(270, 0.055),
                      ),
                      Positioned(
                        bottom: -140,
                        left: -118,
                        child: _ambientDisc(300, 0.045),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                        child: FadeTransition(
                          opacity: _contentOpacity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              ScaleTransition(
                                scale: _markScale,
                                child: Container(
                                  width: 166,
                                  height: 166,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF7FAF5),
                                    borderRadius: BorderRadius.circular(42),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.18,
                                        ),
                                        blurRadius: 28,
                                        offset: const Offset(0, 14),
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    'assets/images/app_mark.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Mono LMS',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 34,
                                  height: 1.1,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.7,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'A little learning.\nA world of possibilities.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFFE1EBDD),
                                  fontSize: 15,
                                  height: 1.5,
                                  letterSpacing: 0.1,
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 24, 28, 18),
                  child: FadeTransition(
                    opacity: _contentOpacity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _progressController,
                          builder: (context, child) => ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: _progressController.value,
                              minHeight: 4,
                              backgroundColor: const Color(0xFFDDE5DA),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'YOUR NEXT CHAPTER STARTS HERE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.sageInk,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.7,
                          ),
                        ),
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

  Widget _ambientDisc(double size, double opacity) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: Colors.white.withValues(alpha: opacity),
        width: 1,
      ),
    ),
  );
}
