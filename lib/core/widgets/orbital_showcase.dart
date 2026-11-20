import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// One platform stat: shown as a pill under the orbit.
class OrbitalPod {
  final IconData icon;
  final String value;
  final String label;

  const OrbitalPod({
    required this.icon,
    required this.value,
    required this.label,
  });
}

/// The web hero's orbital centrepiece, re-cut for a phone: the photo medallion
/// keeps its conic sage rim, dashed ring and beads, and the five stats the web
/// floats around it become a thumb-readable rail instead of 8px text in circles.
class OrbitalShowcase extends StatelessWidget {
  final List<OrbitalPod> pods;
  final String photoAsset;
  final double maxSize;

  const OrbitalShowcase({
    super.key,
    required this.pods,
    required this.photoAsset,
    this.maxSize = 260,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final side = math.min(constraints.maxWidth, maxSize);
        return Column(
          children: [
            Semantics(
              label: pods.map((p) => '${p.value} ${p.label}').join(', '),
              child: SizedBox(
                width: side,
                height: side,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    ..._glows(side),
                    Positioned.fill(
                      child: CustomPaint(painter: _OrbitPainter()),
                    ),
                    _medallion(side * 0.62),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 56,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                itemCount: pods.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, i) => _statPill(pods[i]),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _glows(double side) {
    final spots = [
      (Offset(side * 0.82, side * 0.14), side * 0.5, AppColors.sageMint, 0.35),
      (Offset(side * 0.16, side * 0.86), side * 0.55, AppColors.sage, 0.25),
      (Offset(side * 0.5, side * 0.5), side * 0.72, AppColors.sageEvergreen, 0.12),
    ];
    return spots
        .map(
          (s) => Positioned(
            left: s.$1.dx - s.$2 / 2,
            top: s.$1.dy - s.$2 / 2,
            width: s.$2,
            height: s.$2,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      s.$3.withValues(alpha: s.$4),
                      s.$3.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  Widget _medallion(double d) {
    final photo = d - d * 0.12;
    return SizedBox(
      width: d,
      height: d,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const SweepGradient(
                  colors: [
                    AppColors.sageEvergreen,
                    AppColors.sageMoss,
                    AppColors.sage,
                    AppColors.sageMint,
                    AppColors.sageEvergreen,
                  ],
                  stops: [0, 0.3, 0.6, 0.82, 1],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.sageEvergreen.withValues(alpha: 0.22),
                    blurRadius: 26,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(d * 0.03),
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Center(
            child: ClipOval(
              child: SizedBox(
                width: photo,
                height: photo,
                child: Image.asset(
                  photoAsset,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (_, _, _) => const ColoredBox(
                    color: AppColors.sageHint,
                    child: Center(
                      child: Icon(Icons.school_outlined,
                          color: AppColors.sageEvergreen),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statPill(OrbitalPod pod) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.hairline),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.sageHint,
              border: Border.all(color: AppColors.sageMint),
            ),
            child: Icon(pod.icon, size: 13, color: AppColors.sageEvergreen),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pod.value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1.1,
                ),
              ),
              Text(
                pod.label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.sageInk,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    dashedCircle(
      canvas,
      center,
      size.width * 0.485,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = AppColors.sage.withValues(alpha: 0.45),
      dash: 3,
      gap: 7,
    );

    final r = size.width * 0.425;
    final rect = Rect.fromCircle(center: center, radius: r);
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7
        ..color = AppColors.sageMoss.withValues(alpha: 0.13),
    );
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..shader = const SweepGradient(
          colors: [
            AppColors.sageEvergreen,
            AppColors.sageMoss,
            AppColors.sage,
            AppColors.sageMint,
            AppColors.sageHint,
            AppColors.sageEvergreen,
          ],
          stops: [0, .2, .4, .6, .8, 1],
        ).createShader(rect),
    );

    // Beads sitting on the track
    final evergreen = Paint()..color = AppColors.sageEvergreen;
    final moss = Paint()..color = AppColors.sageMoss;
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.white;
    for (var i = 0; i < 10; i++) {
      final a = (i * 36 + 18) * math.pi / 180;
      final p = center + Offset(math.cos(a), math.sin(a)) * r;
      canvas.drawCircle(p, 4, ring);
      canvas.drawCircle(p, 3.2, i.isEven ? evergreen : moss);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// dart:ui exposes no PathEffect, so dashes are drawn as short arcs.
void dashedCircle(Canvas canvas, Offset center, double radius, Paint paint,
    {double dash = 3, double gap = 7}) {
  final circumference = 2 * math.pi * radius;
  final count = (circumference / (dash + gap)).floor();
  if (count < 1) return;
  final step = 2 * math.pi / count;
  final sweep = step * (dash / (dash + gap));
  final rect = Rect.fromCircle(center: center, radius: radius);
  for (var i = 0; i < count; i++) {
    canvas.drawArc(rect, i * step, sweep, false, paint);
  }
}
