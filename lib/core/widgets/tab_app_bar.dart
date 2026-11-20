import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Shared app bar for the main-shell tab screens (explore, learning,
/// wishlist, profile). Home keeps its own branded header instead.
///
/// One height, one type style, one padding: the screens read as a set.
class TabAppBar extends StatelessWidget {
  final String title;
  final List<Widget> actions;

  const TabAppBar({super.key, required this.title, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.4,
                ),
              ),
            ),
            ...actions,
          ],
        ),
      ),
    );
  }
}
