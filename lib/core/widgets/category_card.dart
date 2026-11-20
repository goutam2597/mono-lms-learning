import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Web category card: tinted icon tile, name, accent rule, course count and a
/// circular arrow button in the category's own colour.
class WebCategoryCard extends StatefulWidget {
  final String name;
  final Color color;
  final IconData icon;
  final int courseCount;
  final String? imageAsset;
  final VoidCallback? onTap;

  const WebCategoryCard({
    super.key,
    required this.name,
    required this.color,
    required this.icon,
    required this.courseCount,
    this.imageAsset,
    this.onTap,
  });

  @override
  State<WebCategoryCard> createState() => _WebCategoryCardState();
}

class _WebCategoryCardState extends State<WebCategoryCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.color;
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 140),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (widget.imageAsset != null)
                  Image.asset(
                    widget.imageAsset!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        ColoredBox(color: accent.deep),
                  )
                else
                  ColoredBox(color: accent.deep),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.08),
                        Colors.black.withValues(alpha: 0.12),
                        Colors.black.withValues(alpha: 0.76),
                      ],
                      stops: const [0, 0.42, 1],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.94),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              widget.icon,
                              size: 18,
                              color: accent.deep,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.94),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${widget.courseCount} ${widget.courseCount == 1 ? 'course' : 'courses'}',
                              style: const TextStyle(
                                fontSize: 10,
                                height: 1,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        widget.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          Text(
                            'Explore',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.92),
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 13,
                            color: Colors.white,
                          ),
                        ],
                      ),
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
}
