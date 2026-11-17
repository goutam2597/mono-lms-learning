import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/category_card.dart';
import '../core/widgets/course_card.dart';
import '../core/widgets/figma_icon.dart';
import '../core/widgets/person_avatar.dart';
import '../core/widgets/section_header.dart';
import '../models/course_model.dart';
import 'auth/create_account_screen.dart';
import 'course_details_screen.dart';
import 'explore_screen.dart';
import 'shopping_cart_screen.dart';
import 'wishlist_screen.dart';

/// Home tab — the mobile counterpart of the web home page.
class DiscoverHomeScreen extends StatefulWidget {
  const DiscoverHomeScreen({super.key});

  @override
  State<DiscoverHomeScreen> createState() => _DiscoverHomeScreenState();
}

class _DiscoverHomeScreenState extends State<DiscoverHomeScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scroll = ScrollController();
  final TextEditingController _query = TextEditingController();
  final TextEditingController _email = TextEditingController();
  late final AnimationController _intro;
  late final PageController _slides;
  Timer? _autoSlide;
  int _slide = 0;
  bool _userDrivingSlides = false;

  bool _headerSolid = false;
  bool _statsSeen = false;
  int _filterIndex = 0;
  int _expandedFaq = 0;
  String _category = AppStrings.selectCategory;

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 760),
    )..forward();
    _scroll.addListener(_onScroll);
    _slides = PageController(viewportFraction: 0.92);
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoSlide());
  }

  @override
  void dispose() {
    _scroll.dispose();
    _query.dispose();
    _email.dispose();
    _intro.dispose();
    _autoSlide?.cancel();
    _slides.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    if (_autoSlide != null || !mounted) return;
    _autoSlide = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_reduceMotion || _userDrivingSlides) return;
      final next = (_slide + 1) % _HomeData.featured.take(3).length;
      if (_slides.hasClients) {
        _slides.animateToPage(
          next,
          duration: const Duration(milliseconds: 560),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _onScroll() {
    final offset = _scroll.hasClients ? _scroll.offset : 0.0;
    final solid = offset > 14;
    final seen = offset > 380;
    if (solid != _headerSolid || seen != _statsSeen) {
      setState(() {
        _headerSolid = solid;
        _statsSeen = seen;
      });
    }
  }

  bool get _reduceMotion => MediaQuery.disableAnimationsOf(context);

  // ---------------------------------------------------------------- routes

  void _openExplore() => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const ExploreScreen()),
  );

  void _openCourse(CourseModel course) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => CourseDetailsScreen(course: course)),
  );

  void _openRegister() => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const CreateAccountScreen()),
  );

  void _toast(String message) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));

  // ------------------------------------------------------------------ shell

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _header(context),
            Expanded(
              child: SingleChildScrollView(
                controller: _scroll,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _hero(),
                    _statsRibbon(),
                    _masterSkills(),
                    _categories(),
                    _featured(),
                    _transformBanner(),
                    _goals(),
                    _accelerate(),
                    _trending(),
                    _instructors(),
                    _becomeInstructor(),
                    _testimonials(),
                    _faq(),
                    _footer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: _headerSolid ? Colors.white : AppColors.heroTop,
        border: Border(
          bottom: BorderSide(
            color: _headerSolid ? AppColors.hairline : Colors.transparent,
            width: 1,
          ),
        ),
        boxShadow: _headerSolid
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.035),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 28,
            fit: BoxFit.contain,
          ),
          const Spacer(),
          Semantics(
            button: true,
            label: 'Wishlist',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WishlistScreen()),
              ),
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: FigmaIcon('heart_header', size: 22),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Semantics(
            button: true,
            label: 'Cart, 2 items',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ShoppingCartScreen()),
              ),
              child: Padding(
                padding: EdgeInsets.all(6),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    FigmaIcon('cart_header', size: 22),
                    Positioned(
                      right: -8,
                      top: -7,
                      child: Container(
                        width: 17,
                        height: 17,
                        decoration: const BoxDecoration(
                          color: AppColors.cartBadge,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            '2',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Staggered hero entrance — one authored moment, off when the user asks
  /// for reduced motion.
  Widget _stage({required int index, required Widget child}) {
    if (_reduceMotion) return child;
    final start = math.min(0.05 + index * 0.09, 0.62);
    final curve = CurvedAnimation(
      parent: _intro,
      curve: Interval(start, start + 0.38, curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: curve,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.05),
          end: Offset.zero,
        ).animate(curve),
        child: child,
      ),
    );
  }

  // ------------------------------------------------------------------ hero

  Widget _hero() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.heroTop, AppColors.heroMid, Colors.white],
          stops: [0, 0.55, 1],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Ambient blobs, like the web's blurred circles
          Positioned(
            right: -70,
            top: -90,
            child: _blob(240, AppColors.sageEvergreen, 0.07),
          ),
          Positioned(
            left: -90,
            top: 120,
            child: _blob(200, AppColors.sageMoss, 0.09),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _stage(index: 0, child: _badge()),
                const SizedBox(height: 14),
                _stage(index: 1, child: _heroTitle()),
                const SizedBox(height: 8),
                _stage(index: 2, child: _heroSubtitle()),
                const SizedBox(height: 16),
                _stage(index: 3, child: _searchCard()),
                const SizedBox(height: 18),
                _stage(index: 4, child: _courseSlider()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _blob(double size, Color color, double alpha) => IgnorePointer(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: alpha),
            color.withValues(alpha: 0),
          ],
        ),
      ),
    ),
  );

  Widget _badge() => Align(
    alignment: Alignment.centerLeft,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.sageEvergreen,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: AppColors.sageEvergreen.withValues(alpha: 0.22),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Text(
        AppStrings.heroBadge,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: AppColors.sageHint,
        ),
      ),
    ),
  );

  Widget _heroTitle() => Text.rich(
    TextSpan(
      children: [
        const TextSpan(text: '${AppStrings.heroTitle} '),
        TextSpan(
          text: '${AppStrings.heroAmpersand} ',
          style: const TextStyle(color: AppColors.sageMoss),
        ),
        TextSpan(text: AppStrings.heroTitleHighlight),
      ],
      style: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        height: 1.18,
        letterSpacing: -0.5,
      ),
    ),
  );

  Widget _heroSubtitle() => Text(
    AppStrings.heroSubtitle,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style: const TextStyle(
      fontSize: 13,
      height: 1.45,
      color: AppColors.textSecondary,
    ),
  );

  Widget _searchCard() => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.hairline),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.07),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    padding: const EdgeInsets.all(6),
    child: Row(
      children: [
        _categoryChip(),
        const SizedBox(width: 6),
        const Padding(
          padding: EdgeInsets.only(right: 4),
          child: Icon(Icons.school_outlined, size: 18, color: AppColors.sage),
        ),
        Expanded(
          child: TextField(
            controller: _query,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _openExplore(),
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: AppStrings.searchPlaceholder,
              hintStyle: const TextStyle(
                fontSize: 12.5,
                color: Color(0xFF8A8A8A),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Semantics(
          button: true,
          label: AppStrings.searchHint,
          child: GestureDetector(
            onTap: _openExplore,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.sageEvergreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _categoryChip() => Semantics(
    button: true,
    label: 'Choose a category to search in',
    child: GestureDetector(
      onTap: _pickCategory,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 128),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.sageHint.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                _category,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 2),
            const Icon(Icons.expand_more, size: 16, color: AppColors.sageInk),
          ],
        ),
      ),
    ),
  );

  Future<void> _pickCategory() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 10),
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 6),
              child: Text(
                'Browse by category',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
            for (final c in _HomeData.categories)
              ListTile(
                dense: true,
                leading: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: c.color.tint(0.12),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(c.icon, size: 16, color: c.color.deep),
                ),
                title: Text(c.name, style: const TextStyle(fontSize: 14)),
                subtitle: Text(
                  '${c.count} courses',
                  style: const TextStyle(fontSize: 11.5),
                ),
                onTap: () => Navigator.pop(sheetContext, c.name),
              ),
          ],
        ),
      ),
    );
    if (picked != null) setState(() => _category = picked);
  }

  /// Featured courses as an auto-advancing card slider. Manual swiping pauses
  /// the loop; reduced-motion users get a static first slide.
  Widget _courseSlider() {
    final slides = _HomeData.featured.take(3).toList();
    return Column(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollStartNotification &&
                notification.dragDetails != null) {
              _userDrivingSlides = true;
              _autoSlide?.cancel();
              _autoSlide = null;
            } else if (notification is ScrollEndNotification &&
                _userDrivingSlides) {
              _userDrivingSlides = false;
              _startAutoSlide();
            }
            return false;
          },
          child: SizedBox(
            height: 168,
            child: PageView.builder(
              key: const Key('hero-slider'),
              controller: _slides,
              itemCount: slides.length,
              onPageChanged: (index) => setState(() => _slide = index),
              itemBuilder: (context, index) => _slideCard(slides[index]),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _slideDots(slides.length),
      ],
    );
  }

  Widget _slideCard(CourseModel course) {
    return Semantics(
      button: true,
      label: 'Open course: ${course.title}',
      child: GestureDetector(
        onTap: () => _openCourse(course),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(course.coverImage, fit: BoxFit.cover),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.78),
                        Colors.black.withValues(alpha: 0.06),
                        Colors.transparent,
                      ],
                      stops: const [0, 0.55, 1],
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      course.category,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 13,
                            color: AppColors.starGold,
                          ),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              '${course.rating} · ${course.instructor}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.sageEvergreen,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              course.price,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.sageHint,
                              ),
                            ),
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

  Widget _slideDots(int count) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      for (var i = 0; i < count; i++)
        AnimatedContainer(
          key: Key('hero-dot-$i'),
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 3.5),
          width: i == _slide ? 18 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: i == _slide ? AppColors.sageEvergreen : AppColors.sageMint,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
    ],
  );

  // ---------------------------------------------------------- stats ribbon

  Widget _statsRibbon() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
      child: Column(
        children: [
          _statRow(_HomeData.stats.take(2).toList()),
          const SizedBox(height: 12),
          _statRow(_HomeData.stats.skip(2).toList()),
        ],
      ),
    );
  }

  Widget _statRow(List<_Stat> row) => Row(
    children: [
      for (var i = 0; i < row.length; i++) ...[
        if (i > 0) const SizedBox(width: 12),
        Expanded(child: _statCard(row[i])),
      ],
    ],
  );

  Widget _statCard(_Stat stat) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.hairline),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.045),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: stat.color.tint(0.12),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(stat.icon, size: 22, color: stat.ink),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _counter(stat),
              const SizedBox(height: 3),
              Text(
                stat.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
  );

  Widget _counter(_Stat stat) {
    final style = TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.w800,
      color: stat.ink,
    );
    if (stat.fixed != null) return Text(stat.fixed!, style: style);
    if (!_statsSeen) {
      return Text('0${stat.suffix ?? ''}', style: style);
    }
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: stat.value),
      duration: const Duration(milliseconds: 1100),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => Text('$v${stat.suffix ?? ''}', style: style),
    );
  }

  // --------------------------------------------------------- master skills

  Widget _masterSkills() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeader(
            title: AppStrings.masterHeading,
            subtitle: AppStrings.masterSubtitle,
          ),
          const SizedBox(height: 24),
          Center(child: _layeredPhotos()),
          const SizedBox(height: 26),
          _featuresList(),
        ],
      ),
    );
  }

  Widget _layeredPhotos() => SizedBox(
    width: 250,
    height: 272,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          right: -14,
          top: -14,
          child: CustomPaint(
            size: const Size(96, 96),
            painter: _DashedRingPainter(
              color: AppColors.accentCyan.withValues(alpha: 0.45),
              stroke: 3,
            ),
          ),
        ),
        Positioned(
          left: -10,
          bottom: 6,
          child: Opacity(
            opacity: 0.22,
            child: Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(22)),
                gradient: LinearGradient(
                  colors: [AppColors.accentPurple, AppColors.accentCyan],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          width: 182,
          height: 182,
          child: _photoFrame('assets/images/cat_design.jpg', 24),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          width: 162,
          height: 162,
          child: _photoFrame('assets/images/cat_development.jpg', 28),
        ),
      ],
    ),
  );

  Widget _photoFrame(String asset, double radius) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: Colors.white, width: 4),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.14),
          blurRadius: 22,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    clipBehavior: Clip.antiAlias,
    child: Image.asset(
      asset,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const ColoredBox(color: AppColors.sageHint),
    ),
  );

  /// One column of full-width rows: the web's 2x2 grid reads as two narrow
  /// newspaper columns on a phone.
  Widget _featuresList() {
    final items = _HomeData.features;
    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: 14),
          _featureRow(items[i]),
        ],
      ],
    );
  }

  Widget _featureRow(_Feature f) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEDEDED)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(f.icon, size: 21, color: f.ink),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          f.text,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            height: 1.35,
          ),
        ),
      ),
    ],
  );

  // ------------------------------------------------------------ categories

  Widget _categories() {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionHeader(
              title: AppStrings.categoriesHeading,
              onViewAll: _openExplore,
              viewAllLabel: AppStrings.viewAll,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            key: const Key('category-rail'),
            height: 164,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: _HomeData.categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final c = _HomeData.categories[i];
                return SizedBox(
                  width: 220,
                  child: WebCategoryCard(
                    name: c.name,
                    color: c.color,
                    icon: c.icon,
                    courseCount: c.count,
                    imageAsset: c.imageAsset,
                    onTap: _openExplore,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------- featured

  List<CourseModel> get _visibleFeatured {
    if (_filterIndex == 0) return _HomeData.featured;
    final tag = _HomeData.filterTags[_filterIndex];
    return _HomeData.featured.where((c) => c.category == tag).toList();
  }

  Widget _featured() {
    final courses = _visibleFeatured;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionHeader(
              title: AppStrings.featuredHeading,
              onViewAll: _openExplore,
              viewAllLabel: AppStrings.viewAll,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 38,
            child: ListView.separated(
              key: const Key('featured-tabs-row'),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: _HomeData.filterTags.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final selected = i == _filterIndex;
                return GestureDetector(
                  key: Key('featured-tab-$i'),
                  onTap: () => setState(() => _filterIndex = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.sageHint.withValues(alpha: 0.55)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: selected
                            ? AppColors.sageEvergreen
                            : Colors.transparent,
                      ),
                    ),
                    child: Text(
                      _HomeData.filterTags[i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: selected
                            ? AppColors.sageEvergreen
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 378,
            child: ListView.separated(
              key: const Key('featured-rail'),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: courses.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, i) => SizedBox(
                width: 282,
                child: WebCourseCard(
                  course: courses[i],
                  onTap: () => _openCourse(courses[i]),
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _primaryButton(
              label: AppStrings.viewAll,
              onTap: _openExplore,
            ),
          ),
        ],
      ),
    );
  }

  Widget _primaryButton({
    required String label,
    required VoidCallback onTap,
    Color? color,
    bool white = false,
  }) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: white ? Colors.white : (color ?? AppColors.sageEvergreen),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: white ? AppColors.textPrimary : Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_rounded,
              size: 17,
              color: white ? AppColors.textPrimary : Colors.white,
            ),
          ],
        ),
      ),
    ),
  );

  // ------------------------------------------------------- transform banner

  Widget _transformBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.bannerDark,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.bannerDark.withValues(alpha: 0.28),
              blurRadius: 26,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              right: -60,
              bottom: -70,
              child: _blob(180, Colors.white, 0.06),
            ),
            Positioned(
              left: -60,
              top: -70,
              child: _blob(170, AppColors.sageMoss, 0.18),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  AppStrings.transformHeading,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.25,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  AppStrings.transformBody,
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.5,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 18),
                _primaryButton(
                  label: AppStrings.transformCta,
                  onTap: _openExplore,
                  white: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------ goals

  Widget _goals() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeader(title: AppStrings.goalsHeading),
          const SizedBox(height: 20),
          for (final g in _HomeData.goals)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 2,
                    height: 44,
                    color: g.color.tint(0.35),
                    margin: const EdgeInsets.only(right: 12),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              g.value,
                              style: const TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 11,
                              height: 11,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: g.color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          g.label,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------- accelerate

  Widget _accelerate() {
    return Container(
      color: AppColors.navy,
      padding: const EdgeInsets.fromLTRB(0, 32, 0, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SectionHeader(
              title: AppStrings.accelerateHeading,
              subtitle: AppStrings.accelerateSubtitle,
              onDark: true,
            ),
          ),
          const SizedBox(height: 20),
          for (var i = 0; i < _HomeData.showcases.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _showcaseCard(_HomeData.showcases[i]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _showcaseCard(_Showcase s) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.045),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: s.color.tint(0.16),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(s.icon, size: 22, color: s.color),
        ),
        const SizedBox(height: 14),
        Text(
          s.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: s.color,
            height: 1.25,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          s.body,
          style: const TextStyle(
            fontSize: 12,
            height: 1.5,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 14),
        for (final point in s.points) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.check_circle_rounded, size: 16, color: s.color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  point,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
        ],
      ],
    ),
  );

  // --------------------------------------------------------------- trending

  Widget _trending() {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(
            title: AppStrings.trendingHeading,
            onViewAll: _openExplore,
            viewAllLabel: AppStrings.viewAll,
          ),
          const SizedBox(height: 18),
          for (var i = 0; i < _HomeData.trending.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            _trendRow(_HomeData.trending[i]),
          ],
        ],
      ),
    );
  }

  Widget _trendRow(CourseModel c) {
    return GestureDetector(
      onTap: () => _openCourse(c),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.hairline),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 16,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                c.coverImage,
                width: 104,
                height: 104,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const ColoredBox(
                  color: AppColors.sageHint,
                  child: SizedBox(width: 104, height: 104),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.category.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.sageMoss,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    c.title.replaceAll('\n', ' '),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 13,
                        color: AppColors.starGold,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${c.rating} (${c.reviews})',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.slateBody,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        c.duration,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        c.price,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.categoryGreen,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: AppColors.sageMoss,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------- instructors

  Widget _instructors() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionHeader(
              title: AppStrings.instructorsHeading,
              onViewAll: _openExplore,
              viewAllLabel: AppStrings.viewAll,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 186,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                for (final t in _HomeData.teachers)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _teacherTile(t),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: _teacherFeature(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _teacherTile(_Teacher t) => GestureDetector(
    onTap: _openExplore,
    child: SizedBox(
      width: 124,
      child: Column(
        children: [
          Container(
            width: 124,
            height: 124,
            decoration: BoxDecoration(
              color: t.tint,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: PersonAvatar(name: t.name, size: 62, imageUrl: t.avatar),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            t.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            t.role,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _teacherFeature() => Container(
    width: 168,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.sageEvergreen, AppColors.sageMoss],
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.sageEvergreen.withValues(alpha: 0.3),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.18),
          ),
          child: const Icon(
            Icons.favorite_border_rounded,
            size: 17,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        const Text(
          'Hendriques',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 3),
        const Text(
          'Python Developer',
          style: TextStyle(fontSize: 11, color: Colors.white70),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                '4 courses',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                size: 15,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  // -------------------------------------------------------- instructor CTA

  Widget _becomeInstructor() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.sageEvergreen,
              Color(0xFF2D4235),
              AppColors.sageMoss,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.sageEvergreen.withValues(alpha: 0.3),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              AppStrings.instructorHeading,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              AppStrings.instructorBody,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.5,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 18),
            _primaryButton(
              label: AppStrings.instructorCta,
              onTap: _openRegister,
              white: true,
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------- testimonials

  Widget _testimonials() {
    return Container(
      color: AppColors.navy,
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeader(
            title: AppStrings.testimonialsHeading,
            subtitle: AppStrings.testimonialsSubtitle,
            onDark: true,
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 30,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.format_quote_rounded,
                  size: 34,
                  color: AppColors.inkPurple,
                ),
                const SizedBox(height: 12),
                const Text(
                  AppStrings.testimonialQuote,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.6,
                    color: Color(0xFF4B5563),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    for (var i = 0; i < 5; i++)
                      Icon(
                        Icons.star_rounded,
                        size: 17,
                        color: AppColors.starGold.withValues(
                          alpha: i < 4 ? 1 : 0.45,
                        ),
                      ),
                    const SizedBox(width: 8),
                    const Text(
                      AppStrings.testimonialRating,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slateBody,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Divider(height: 1, color: Color(0xFFF1F1F1)),
                ),
                Row(
                  children: [
                    const PersonAvatar(name: 'Martin Harn', size: 40),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            AppStrings.testimonialAuthor,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            AppStrings.testimonialRole,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _primaryButton(
            label: AppStrings.instructorCta,
            onTap: _openRegister,
            white: true,
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------- faq

  Widget _faq() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeader(title: AppStrings.faqHeading),
          const SizedBox(height: 18),
          for (var i = 0; i < _HomeData.faqs.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            _faqTile(i, _HomeData.faqs[i]),
          ],
        ],
      ),
    );
  }

  Widget _faqTile(int index, _Faq faq) {
    final open = _expandedFaq == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _expandedFaq = open ? -1 : index),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: open ? AppColors.sageMint : AppColors.hairline,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    faq.q,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: open ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.expand_more,
                    size: 22,
                    color: AppColors.sageEvergreen,
                  ),
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: open
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        faq.a,
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.55,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------ footer

  Widget _footer() {
    return Container(
      color: AppColors.footerBackground,
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/images/logo_white.png',
            height: 30,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 12),
          const Text(
            AppStrings.footerTagline,
            style: TextStyle(fontSize: 12.5, color: AppColors.sageHint),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              for (final link in const [
                'Explore courses',
                'About us',
                'Help center',
              ])
                Expanded(
                  child: GestureDetector(
                    onTap: _openExplore,
                    child: Text(
                      link,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            AppStrings.footerNewsletter,
            style: TextStyle(fontSize: 12, color: AppColors.sageHint),
          ),
          const SizedBox(height: 12),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    onSubmitted: (_) => _toast(AppStrings.notWired),
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      hintText: AppStrings.footerEmail,
                      hintStyle: TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF8A8A8A),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _toast(AppStrings.notWired),
                  child: Container(
                    height: 38,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.sageEvergreen,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'Join',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            AppStrings.footerCopyright,
            style: TextStyle(fontSize: 10.5, color: AppColors.sageMint),
          ),
        ],
      ),
    );
  }
}

/// A thin dashed circle, used as the web's dotted ornament.
class _DashedRingPainter extends CustomPainter {
  final Color color;
  final double stroke;

  const _DashedRingPainter({required this.color, this.stroke = 3});

  @override
  void paint(Canvas canvas, Size size) {
    _dashedCircle(
      canvas,
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = color,
      dash: 2,
      gap: 8,
    );
  }

  @override
  bool shouldRepaint(_DashedRingPainter old) =>
      old.color != color || old.stroke != stroke;
}

/// dart:ui exposes no PathEffect, so dashes are drawn as short arcs.
void _dashedCircle(
  Canvas canvas,
  Offset center,
  double radius,
  Paint paint, {
  double dash = 3,
  double gap = 7,
}) {
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

// ------------------------------------------------------------------- model

class _Cat {
  final String name;
  final Color color;
  final IconData icon;
  final int count;
  final String? imageAsset;
  const _Cat(this.name, this.color, this.icon, this.count, {this.imageAsset});
}

class _Stat {
  final IconData icon;
  final Color color;
  final Color ink;
  final int value;
  final String? suffix;
  final String? fixed; // non-counting value, e.g. "4.8/5"
  final String label;
  const _Stat({
    required this.icon,
    required this.color,
    required this.ink,
    this.value = 0,
    required this.label,
    this.suffix,
    this.fixed,
  });
}

class _Feature {
  final IconData icon;
  final Color ink;
  final String text;
  const _Feature(this.icon, this.ink, this.text);
}

class _Goal {
  final String value;
  final String label;
  final Color color;
  const _Goal(this.value, this.label, this.color);
}

class _Showcase {
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final List<String> points;
  const _Showcase(this.icon, this.color, this.title, this.body, this.points);
}

class _Teacher {
  final String name;
  final String role;
  final Color tint;
  final String? avatar;
  const _Teacher(this.name, this.role, this.tint, [this.avatar]);
}

class _Faq {
  final String q;
  final String a;
  const _Faq(this.q, this.a);
}

/// Static mirror of what the web home renders today. Swap for API data when
/// the app is wired to the backend.
class _HomeData {
  static const categories = <_Cat>[
    _Cat(
      'Web Design',
      Color(0xFF0DCAF0),
      Icons.brush_outlined,
      2,
      imageAsset: 'assets/images/cat_design.jpg',
    ),
    _Cat(
      'Python Development',
      Color(0xFF3776AB),
      Icons.data_object,
      1,
      imageAsset: 'assets/images/cat_development.jpg',
    ),
    _Cat(
      'Angular Development',
      Color(0xFFDD0031),
      Icons.layers_outlined,
      1,
      imageAsset: 'assets/images/cat_development.jpg',
    ),
    _Cat(
      'NodeJS Development',
      Color(0xFF339933),
      Icons.dns_outlined,
      1,
      imageAsset: 'assets/images/cat_development.jpg',
    ),
    _Cat(
      'PHP Development',
      Color(0xFF777BB4),
      Icons.terminal_outlined,
      0,
      imageAsset: 'assets/images/cat_development.jpg',
    ),
    _Cat(
      'Laravel Development',
      Color(0xFFFF2D20),
      Icons.bolt_outlined,
      0,
      imageAsset: 'assets/images/cat_development.jpg',
    ),
    _Cat(
      'Business Management',
      Color(0xFFFFC107),
      Icons.business_center_outlined,
      3,
      imageAsset: 'assets/images/cat_business.jpg',
    ),
    _Cat(
      'Creative Arts & Media',
      Color(0xFFFF4667),
      Icons.movie_filter_outlined,
      1,
      imageAsset: 'assets/images/cat_photography.jpg',
    ),
  ];

  static const featured = <CourseModel>[
    CourseModel(
      id: 'html',
      title: 'Build Responsive Websites with HTML',
      category: 'Web Design',
      coverImage: 'assets/images/course_webdev_preview.jpg',
      instructor: 'Rolands Granger',
      rating: '5.0',
      reviews: '1',
      lessons: '24 lessons',
      duration: '6h 30m',
      level: 'Beginner',
      price: '\$650.00',
      oldPrice: '\$900.00',
      aboutText: 'Build responsive, standards-compliant websites from scratch with semantic HTML and modern CSS.',
    ),
    CourseModel(
      id: 'python',
      title: 'The Complete Web Developer Python Course',
      category: 'Python Development',
      coverImage: 'assets/images/course_reactjs.jpg',
      instructor: 'Hinata Hyuga',
      rating: '4.0',
      reviews: '1',
      lessons: '18 lessons',
      duration: '5h 10m',
      level: 'Intermediate',
      price: '\$300.00',
      aboutText: 'Go from fundamentals to working web applications with Python, covering syntax, tooling and deployment.',
    ),
    CourseModel(
      id: 'angular',
      title: 'Build Responsive Websites with Angular',
      category: 'Angular Development',
      coverImage: 'assets/images/course_uiux.jpg',
      instructor: 'Rolands Granger',
      rating: '5.0',
      reviews: '0',
      lessons: '21 lessons',
      duration: '7h 45m',
      level: 'Intermediate',
      price: '\$550.00',
      aboutText: 'Component-driven front-end development with Angular: routing, forms, services and responsive layouts.',
    ),
    CourseModel(
      id: 'nodejs',
      title: 'NodeJS Fundamentals: Storage in Server',
      category: 'NodeJS Development',
      coverImage: 'assets/images/course_wordpress.jpg',
      instructor: 'Rolands Granger',
      rating: '5.0',
      reviews: '0',
      lessons: '15 lessons',
      duration: '4h 20m',
      level: 'Advanced',
      price: '\$999.00',
      aboutText: 'Server-side storage patterns in Node.js: file systems, databases, caching and safe uploads.',
    ),
    CourseModel(
      id: 'uiux',
      title: 'Information About UI/UX Design Degree & Professional Career',
      category: 'Web Design',
      coverImage: 'assets/images/course_sketch.jpg',
      instructor: 'David Benitez',
      rating: '5.0',
      reviews: '0',
      lessons: '32 lessons',
      duration: '9h 05m',
      level: 'Beginner',
      price: '\$120.00',
      aboutText: 'A guided path through UI and UX practice, from research and wireframes to polished, testable interfaces.',
    ),
    CourseModel(
      id: 'business',
      title: 'The Complete Business Management Course',
      category: 'Business Management',
      coverImage: 'assets/images/course_business.jpg',
      instructor: 'Rolands Granger',
      rating: '4.8',
      reviews: '2',
      lessons: '26 lessons',
      duration: '8h 15m',
      level: 'Beginner',
      price: '\$200.00',
      aboutText: 'Planning, operations, people and finance — the working toolkit for a first management role.',
    ),
  ];

  static List<CourseModel> get trending => [
    featured[0],
    featured[4],
    featured[5],
  ];

  static List<String> get filterTags => [
    'All',
    ...featured.map((c) => c.category).toSet(),
  ];

  static const stats = <_Stat>[
    _Stat(
      icon: Icons.groups_outlined,
      color: AppColors.accentGreen,
      ink: AppColors.inkGreen,
      value: 23,
      label: 'Enrolled Students',
    ),
    _Stat(
      icon: Icons.menu_book_rounded,
      color: AppColors.accentPurple,
      ink: AppColors.inkPurple,
      value: 11,
      label: 'Active Courses',
    ),
    _Stat(
      icon: Icons.school_outlined,
      color: AppColors.accentAmber,
      ink: AppColors.inkAmber,
      value: 8,
      suffix: '+',
      label: 'Expert Instructors',
    ),
    _Stat(
      icon: Icons.workspace_premium_outlined,
      color: AppColors.accentCyan,
      ink: AppColors.inkCyan,
      fixed: '4.8/5',
      label: 'Average Rating',
    ),
  ];

  static const features = <_Feature>[
    _Feature(
      Icons.description_outlined,
      AppColors.inkPurple,
      'Get certified with hands-on certification courses',
    ),
    _Feature(
      Icons.bolt_outlined,
      AppColors.inkAmber,
      'Build skills your way, from labs to courses',
    ),
    _Feature(
      Icons.groups_outlined,
      AppColors.inkCyan,
      'Stay motivated with engaging instructors',
    ),
    _Feature(
      Icons.cloud_outlined,
      AppColors.inkGreen,
      'Keep up with the latest in cloud technology',
    ),
  ];

  static const goals = <_Goal>[
    _Goal(
      '23',
      'Students enrolled across the platform',
      AppColors.accentPurple,
    ),
    _Goal('11', 'Courses published on the platform', AppColors.accentCyan),
    _Goal('8', 'Verified expert instructors', AppColors.accentGreen),
  ];

  static const showcases = <_Showcase>[
    _Showcase(
      Icons.emoji_events_outlined,
      AppColors.accentAmber,
      'Award Winning Course Management',
      'Recognised for quality, innovation and effectiveness — for instructors and students both.',
      [
        'Interactive tools for engagement',
        'Customizable course creation',
        'Robust analytics and reporting',
        'Collaborative, peer-to-peer learning',
        'World-class instructors',
      ],
    ),
    _Showcase(
      Icons.schedule_outlined,
      AppColors.accentCyan,
      'Learn anything, anywhere, anytime',
      'Everything is available on every device, so a lesson fits between what you already do.',
      [
        'Access to a world of knowledge',
        'Diverse learning formats',
        'Learn at your own pace',
        'Affordable and flexible pricing',
        'Continue on any device',
      ],
    ),
    _Showcase(
      Icons.workspace_premium_outlined,
      AppColors.accentGreen,
      'Certification for your career',
      'Certificates issued on completion, shareable, and tied to the skills you practised.',
      [
        'Demonstrates expertise',
        'Boosts your credibility',
        'Improves job security',
        'Facilitates career advancement',
        'Fosters personal growth',
      ],
    ),
  ];

  static const teachers = <_Teacher>[
    _Teacher('Rolands Granger', 'Web Design', Color(0xFFDCE7DA)),
    _Teacher('Hinata Hyuga', 'Python Development', Color(0xFFE3E0F5)),
    _Teacher('David Benitez', 'NodeJS Development', Color(0xFFDDEEF4)),
    _Teacher(
      'Nicole Brown',
      'Web Development',
      Color(0xFFE0F0E6),
      'assets/images/instructor_nicole.jpg',
    ),
  ];

  static const faqs = <_Faq>[
    _Faq(
      'Will I receive a certificate?',
      'Many paid courses include a Certificate of Completion. Check the course details for eligibility.',
    ),
    _Faq(
      'Can I learn on my own schedule?',
      'Yes. Courses come with lifetime access, so you can learn at your own pace, anytime, anywhere.',
    ),
    _Faq(
      'How do I choose the right course?',
      'Browse by category, read student reviews, or preview the introductory lessons before deciding.',
    ),
  ];
}
