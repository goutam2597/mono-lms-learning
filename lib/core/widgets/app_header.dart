import 'package:flutter/material.dart';
import 'figma_icon.dart';
import '../theme/app_theme.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final bool showBack;
  final Widget? action;

  const AppHeader({
    super.key,
    required this.title,
    this.showBack = true,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          if (showBack)
            GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: const FigmaIcon('back_icon', size: 22),
            ),
          if (showBack) const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          ?action,
        ],
      ),
    );
  }
}
