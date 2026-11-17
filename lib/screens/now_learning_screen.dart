import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../core/widgets/figma_icon.dart';

class NowLearningScreen extends StatefulWidget {
  const NowLearningScreen({super.key});

  @override
  State<NowLearningScreen> createState() => _NowLearningScreenState();
}

class _NowLearningScreenState extends State<NowLearningScreen> {
  int _activeTabIndex = 0;

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
                    _buildVideoPlayer(),
                    _buildLessonInfo(),
                    _buildTabs(),
                    _buildLessons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildCompleteBar(),
    );
  }

  Widget _buildCompleteBar() {
    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 13, 24, 0),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'Mark as complete',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
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
              'Now learning',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const FigmaIcon('more_icon', size: 22),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 221,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/course_uiux.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 55,
            color: const Color(0xFF171027).withValues(alpha: 0.86),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const FigmaIcon('pause_icon', size: 22),
                const SizedBox(width: 12),
                const Text(
                  '02:18 / 08:45',
                  style: TextStyle(fontSize: 11, color: Colors.white),
                ),
                const Spacer(),
                const FigmaIcon('expand_icon', size: 22),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 3,
          left: 0,
          right: 0,
          child: Stack(
            children: [
              Container(height: 3, color: const Color(0xFF8776AC)),
              FractionallySizedBox(
                widthFactor: 0.262,
                child: Container(height: 3, color: const Color(0xFFFF4668)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLessonInfo() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 25),
          Text(
            'LESSON 8 OF 12',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'How to solve the\nprocess exercise',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          SizedBox(height: 30),
          Text(
            'Information About UI/UX Design Degree',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    final tabs = ['Lessons', 'Resources', 'Notes'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        children: [
          Row(
            children: List.generate(tabs.length, (index) {
              final isSelected = _activeTabIndex == index;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _activeTabIndex = index),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Center(
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          Stack(
            children: [
              Container(
                height: 1,
                width: double.infinity,
                color: AppColors.border,
              ),
              Row(
                children: List.generate(tabs.length, (index) {
                  return Expanded(
                    child: Center(
                      child: Container(
                        height: 3,
                        width: 62,
                        decoration: BoxDecoration(
                          color: _activeTabIndex == index
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLessons() {
    final lessons = [
      _LessonData(
        number: '07',
        title: 'How to show the process exercise',
        duration: '05:20',
        state: _LessonState.completed,
      ),
      _LessonData(
        number: '08',
        title: 'How to solve the process exercise',
        duration: '08:45',
        state: _LessonState.playing,
      ),
      _LessonData(
        number: '09',
        title: 'How to use text effectively',
        duration: '06:10',
        state: _LessonState.pending,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Getting Started',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const FigmaIcon('down_icon', size: 18),
            ],
          ),
          const SizedBox(height: 18),
          ...lessons.map(
            (lesson) => Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: _buildLessonItem(lesson),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonItem(_LessonData lesson) {
    final isPlaying = lesson.state == _LessonState.playing;
    final isCompleted = lesson.state == _LessonState.completed;

    Color stateBg;
    Widget stateChild;

    if (isCompleted) {
      stateBg = const Color(0xFFE2F4EA);
      stateChild = const FigmaIcon('check_icon', size: 16);
    } else if (isPlaying) {
      stateBg = AppColors.primary;
      stateChild = const FigmaIcon('play_lesson', size: 16);
    } else {
      stateBg = const Color(0xFFF0EFF3);
      stateChild = Text(
        lesson.number,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      );
    }

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isPlaying ? AppColors.benefitBg : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: stateBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: stateChild),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  lesson.title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isPlaying ? FontWeight.w600 : FontWeight.normal,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  lesson.duration,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (isPlaying)
            const Text(
              'Playing',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }
}

enum _LessonState { completed, playing, pending }

class _LessonData {
  final String number;
  final String title;
  final String duration;
  final _LessonState state;

  const _LessonData({
    required this.number,
    required this.title,
    required this.duration,
    required this.state,
  });
}
