import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../../models/course_model.dart';
import 'person_avatar.dart';

/// The web's course card, ported: full-bleed cover with the mint/white wave
/// transition, save button, category pill, instructor + rating, meta row and
/// a gradient Enroll pill.
class WebCourseCard extends StatefulWidget {
  final CourseModel course;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onSavedChanged;
  final bool initiallySaved;

  const WebCourseCard({
    super.key,
    required this.course,
    this.onTap,
    this.onSavedChanged,
    this.initiallySaved = false,
  });

  @override
  State<WebCourseCard> createState() => _WebCourseCardState();
}

class _WebCourseCardState extends State<WebCourseCard> {
  late bool _saved = widget.initiallySaved;
  bool _pressed = false;

  void _toggleSave() {
    setState(() => _saved = !_saved);
    widget.onSavedChanged?.call(_saved);
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.course;
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _pressed ? 0.985 : 1,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFF1F1F1)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 22,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _cover(c),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _instructorRow(c),
                      const SizedBox(height: 10),
                      Text(
                        c.title.replaceAll('\n', ' '),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _metaRow(c),
                      const SizedBox(height: 12),
                      const Divider(height: 1, thickness: 1, color: Color(0xFFF1F1F1)),
                      const SizedBox(height: 12),
                      _footer(c),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cover(CourseModel c) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          child: AspectRatio(
            aspectRatio: 16 / 10,
            child: Image.asset(
              c.coverImage,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const ColoredBox(
                color: AppColors.sageHint,
                child: Center(
                  child: Icon(Icons.image_outlined, color: AppColors.sageMoss),
                ),
              ),
            ),
          ),
        ),
        // Save
        Positioned(
          top: 10,
          left: 10,
          child: Semantics(
            button: true,
            toggled: _saved,
            label: _saved ? 'Remove from wishlist' : 'Save course',
            child: GestureDetector(
              onTap: _toggleSave,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: _saved ? 1 : 0.94),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: Icon(
                    _saved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    key: ValueKey(_saved),
                    size: 17,
                    color: _saved ? const Color(0xFFE11D48) : const Color(0xFF475569),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Category pill
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.categoryGreen,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.14),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.laptop_mac_outlined, size: 12, color: Colors.white),
                const SizedBox(width: 5),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 120),
                  child: Text(
                    c.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Wave transition from photo into the card body
        Positioned(
          left: 0,
          right: 0,
          bottom: -1,
          height: 24,
          child: IgnorePointer(
            child: CustomPaint(painter: _CardWavePainter()),
          ),
        ),
      ],
    );
  }

  Widget _instructorRow(CourseModel c) {
    return Row(
      children: [
        PersonAvatar(
          name: c.instructor,
          size: 30,
          imageUrl: c.instructorAvatar,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                c.instructor,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Instructor',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF94A3B8),
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.ratingBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, size: 12, color: AppColors.starGold),
              const SizedBox(width: 4),
              Text(
                c.rating,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.1,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                '(${c.reviews})',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.categoryGreen,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _metaRow(CourseModel c) {
    final row = Row(
      children: [
        _meta(Icons.signal_cellular_alt_outlined, c.level),
        _sep(),
        _meta(Icons.schedule, c.duration),
        _sep(),
        _meta(Icons.play_circle_outline, c.lessons),
      ],
    );
    // Long lesson labels must never push the row out of the card.
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: row,
    );
  }

  Widget _sep() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Container(width: 1, height: 12, color: const Color(0xFFE2E8F0)),
      );

  Widget _meta(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.slateBody),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: AppColors.slateBody,
              height: 1.1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _footer(CourseModel c) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                c.price,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.categoryGreen,
                  height: 1.1,
                  letterSpacing: -0.2,
                ),
              ),
              if (c.oldPrice != null) ...[
                const SizedBox(height: 2),
                Text(
                  c.oldPrice!,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF94A3B8),
                    height: 1.1,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 10),
        _EnrollPill(label: c.isFree ? 'Enroll now' : 'Enroll now'),
      ],
    );
  }
}

class _EnrollPill extends StatelessWidget {
  final String label;

  const _EnrollPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [AppColors.enrollFrom, AppColors.enrollTo],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.enrollFrom.withValues(alpha: 0.28),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          const SizedBox(width: 5),
          const Icon(Icons.arrow_forward_rounded, size: 13, color: Colors.white),
        ],
      ),
    );
  }
}

/// Two stacked waves (mint, then white) cutting the photo off into the body,
/// exactly as the web card does.
class _CardWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final mint = Path()
      ..moveTo(0, h * 0.83)
      ..cubicTo(w * 0.36, h * 0.83, w * 0.62, h * 0.2, w, h * 0.33)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(mint, Paint()..color = AppColors.waveMint.withValues(alpha: 0.65));

    final white = Path()
      ..moveTo(0, h * 0.5)
      ..cubicTo(w * 0.24, h * 0.87, w * 0.56, h * 0.3, w, h * 0.63)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(white, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
