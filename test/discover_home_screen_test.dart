import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:learning_app/screens/discover_home_screen.dart';

void main() {
  // The home is a long scroll: these tests pump fixed frames (the orbit has
  // its own loop) and scroll each control into view before tapping it.
  Future<void> pumpHome(WidgetTester tester) async {
    tester.view.physicalSize = const Size(500, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: DiscoverHomeScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));
  }

  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(finder);
    await tester.pump(const Duration(milliseconds: 700));
  }

  testWidgets('lays out cleanly on a 360dp phone', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: DiscoverHomeScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));

    expect(
      tester.takeException(),
      isNull,
      reason: 'no overflow or layout exceptions at 360dp',
    );
    expect(find.text('Master the skills to drive your career'), findsOneWidget);
  });

  testWidgets('renders the web home sections in order', (
    WidgetTester tester,
  ) async {
    await pumpHome(tester);

    for (final heading in [
      'Master the skills to drive your career',
      'Choose Favourite Course From top Category',
      'Featured Courses',
      'Transform Access To Education',
      'Achieve Your Goals with Mono LMS',
      'Accelerate Cloud Success',
      'Most Trending Courses',
      'Courses Taught by Real Instructors',
      'Become An Instructor',
      'Trusted By Many',
      'Questions, answered',
    ]) {
      expect(find.text(heading), findsOneWidget, reason: 'missing $heading');
    }
    expect(find.text('The Leader in Online Learning'), findsOneWidget);
    expect(find.text('What do you want to learn?'), findsOneWidget);
    expect(tester.getSize(find.byKey(const Key('category-rail'))).height, 164);
  });

  testWidgets('featured filter narrows the course rail', (
    WidgetTester tester,
  ) async {
    await pumpHome(tester);

    const pythonOnly = 'The Complete Web Developer Python Course';
    const htmlCourse = 'Build Responsive Websites with HTML';
    final rail = find.byKey(const Key('featured-rail'));
    final slider = find.byKey(const Key('hero-slider'));

    // The rail shows all six featured courses; the hero slider carries the
    // first three of them.
    expect(
      find.descendant(of: rail, matching: find.text(htmlCourse)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: rail, matching: find.text(pythonOnly)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: slider, matching: find.text(htmlCourse)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: slider, matching: find.text(pythonOnly)),
      findsOneWidget,
    );

    await tapVisible(tester, find.byKey(const Key('featured-tab-2')));
    expect(
      find.descendant(of: rail, matching: find.text(htmlCourse)),
      findsNothing,
    );
    expect(
      find.descendant(of: rail, matching: find.text(pythonOnly)),
      findsOneWidget,
    );

    // Scrolling the chip row back, then clearing the filter.
    await tester.dragUntilVisible(
      find.byKey(const Key('featured-tab-0')),
      find.byKey(const Key('featured-tabs-row')),
      const Offset(200, 0),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.byKey(const Key('featured-tab-0')));
    await tester.pump(const Duration(milliseconds: 700));
    expect(
      find.descendant(of: rail, matching: find.text(htmlCourse)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: rail, matching: find.text(pythonOnly)),
      findsOneWidget,
    );
  });

  testWidgets('hero slider pages through the featured courses', (
    WidgetTester tester,
  ) async {
    await pumpHome(tester);

    final slider = find.byKey(const Key('hero-slider'));
    // Two swipes land on the third slide (the Angular course).
    await tester.fling(slider, const Offset(-300, 0), 800);
    await tester.pump(const Duration(milliseconds: 650));
    await tester.fling(slider, const Offset(-300, 0), 800);
    await tester.pump(const Duration(milliseconds: 650));
    expect(
      find.descendant(
        of: slider,
        matching: find.text('Build Responsive Websites with Angular'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('faq opens the tapped question only', (
    WidgetTester tester,
  ) async {
    await pumpHome(tester);

    const answer =
        'Yes. Courses come with lifetime access, so you can learn at your own pace, anytime, anywhere.';
    expect(find.text(answer), findsNothing);

    await tapVisible(tester, find.text('Can I learn on my own schedule?'));
    expect(find.text(answer), findsOneWidget);

    await tapVisible(tester, find.text('Will I receive a certificate?'));
    expect(find.text(answer), findsNothing);
  });

  testWidgets('course card saves to the wishlist', (WidgetTester tester) async {
    await pumpHome(tester);

    expect(find.byIcon(Icons.favorite_rounded), findsNothing);
    await tapVisible(tester, find.byIcon(Icons.favorite_border_rounded).first);
    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
  });

  testWidgets('hero category picker opens with the live catalog', (
    WidgetTester tester,
  ) async {
    await pumpHome(tester);

    await tapVisible(tester, find.text('Select category'));
    expect(find.text('Browse by category'), findsOneWidget);
    // The eight categories the web home lists today.
    expect(find.byType(ListTile), findsNWidgets(8));
    for (final name in [
      'Web Design',
      'Python Development',
      'Angular Development',
      'NodeJS Development',
      'PHP Development',
      'Laravel Development',
      'Business Management',
      'Creative Arts & Media',
    ]) {
      expect(find.text(name), findsWidgets, reason: 'missing $name');
    }
  });
}
