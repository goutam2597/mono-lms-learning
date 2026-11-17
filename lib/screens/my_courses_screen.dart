import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/figma_icon.dart';
import 'now_learning_screen.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['All courses', 'In progress', 'Completed'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTabs(),
                    _buildTitle(),
                    _buildCoursesList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          const FigmaIcon('back_icon', size: 22),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'My courses',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const FigmaIcon('search_nav', size: 22),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 9, 24, 0),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = index == _selectedTab;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = index),
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              margin: const EdgeInsets.only(right: 9),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: isSelected
                    ? null
                    : Border.all(color: AppColors.border),
              ),
              child: Center(
                child: Text(
                  _tabs[index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your next skill starts here.',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 13),
          Text(
            'Keep learning, one lesson at a time.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesList() {
    final allCourses = [
      const _MyCourseData(
        image: 'assets/images/course_uiux.jpg',
        title: 'Information About UI/UX Design Degree',
        instructor: 'David Benitez',
        progress: '7 of 12 lessons completed',
        percent: 60,
      ),
      const _MyCourseData(
        image: 'assets/images/course_wordpress.jpg',
        title: 'Wordpress for Beginners - Master Wordpress Quickly',
        instructor: 'Ana Reyes',
        progress: '3 of 12 lessons completed',
        percent: 25,
      ),
      const _MyCourseData(
        image: 'assets/images/course_sketch.jpg',
        title: 'Sketch from A to Z (2024): Become an app designer',
        instructor: 'Andrew Pirtle',
        progress: 'Course completed',
        percent: 100,
      ),
    ];

    final filteredCourses = _selectedTab == 0
        ? allCourses
        : _selectedTab == 1
            ? allCourses.where((c) => c.percent < 100).toList()
            : allCourses.where((c) => c.percent == 100).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 27, 24, 40),
      child: Column(
        children: filteredCourses
            .map((course) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _buildCourseCard(course),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildCourseCard(_MyCourseData course) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NowLearningScreen()),
      ),
      child: Container(
        width: double.infinity,
        height: 150,
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 102,
                  height: 88,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(course.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        course.instructor,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    course.progress,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Text(
                  '${course.percent}%',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 11),
            Stack(
              children: [
                Container(
                  height: 4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.benefitBg,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: course.percent / 100,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MyCourseData {
  final String image;
  final String title;
  final String instructor;
  final String progress;
  final int percent;

  const _MyCourseData({
    required this.image,
    required this.title,
    required this.instructor,
    required this.progress,
    required this.percent,
  });
}
