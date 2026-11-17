import 'package:flutter/material.dart';
import 'figma_icon.dart';
import '../theme/app_theme.dart';

enum BottomNavTab { home, explore, learning, wishlist, profile }

class BottomNavBar extends StatelessWidget {
  final BottomNavTab selected;
  final ValueChanged<BottomNavTab>? onTap;

  const BottomNavBar({super.key, required this.selected, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 66,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTab(BottomNavTab.home, 'home_nav', 'Home'),
              _buildTab(BottomNavTab.explore, 'search_nav', 'Explore'),
              _buildTab(BottomNavTab.learning, 'book_nav', 'Learning'),
              _buildTab(BottomNavTab.wishlist, 'heart_nav', 'Wishlist'),
              _buildTab(BottomNavTab.profile, 'user_nav_selected', 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(BottomNavTab tab, String iconAsset, String label) {
    final isSelected = selected == tab;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap == null ? null : () => onTap!(tab),
      child: _tabContent(isSelected, iconAsset, label),
    );
  }

  Widget _tabContent(bool isSelected, String iconAsset, String label) {
    return SizedBox(
      width: 73,
      height: 66,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 30,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.selectedTab : null,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: FigmaIcon(
                iconAsset,
                size: 19,
                color: isSelected ? AppColors.primary : const Color(0xFF85818E),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
