import 'package:flutter/material.dart';
import '../core/widgets/bottom_nav_bar.dart';
import 'discover_home_screen.dart';
import 'explore_screen.dart';
import 'my_courses_screen.dart';
import 'wishlist_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DiscoverHomeScreen(),
    ExploreScreen(),
    MyCoursesScreen(),
    WishlistScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        selected: BottomNavTab.values[_currentIndex],
        onTap: (tab) => setState(() => _currentIndex = tab.index),
      ),
    );
  }
}
