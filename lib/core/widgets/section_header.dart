import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// The short sage gradient rule the web sits under every section title.
class SageGradientBar extends StatelessWidget {
  final double width;
  final double height;

  const SageGradientBar({super.key, this.width = 56, this.height = 5});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        gradient: const LinearGradient(
          colors: [
            AppColors.sageEvergreen,
            AppColors.sageMoss,
            AppColors.sageMint,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}

/// "View All →" in the web's moss green, sized for a thumb.
class ViewAllLink extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool onDark;

  const ViewAllLink({
    super.key,
    this.label = 'View all',
    this.onTap,
    this.onDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = onDark ? Colors.white : AppColors.sageMoss;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Semantics(
        button: true,
        label: label,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.arrow_forward_rounded, size: 15, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

/// Section title + gradient rule, with an optional trailing action —
/// the same header the web uses for Featured / Trending / Categories.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onViewAll;
  final String viewAllLabel;
  final bool onDark;
  final double titleSize;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onViewAll,
    this.viewAllLabel = 'View all',
    this.onDark = false,
    this.titleSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    final ink = onDark ? Colors.white : AppColors.textPrimary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w700,
                  color: ink,
                  height: 1.2,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            if (onViewAll != null) ViewAllLink(label: viewAllLabel, onTap: onViewAll, onDark: onDark),
          ],
        ),
        const SizedBox(height: 10),
        const SageGradientBar(),
        if (subtitle != null) ...[
          const SizedBox(height: 12),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: onDark ? Colors.white.withValues(alpha: 0.82) : AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
