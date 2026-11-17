import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/core/widgets/bottom_nav_bar.dart';

void main() {
  for (final width in [320.0, 337.5, 360.0, 393.0]) {
    testWidgets('bottom navigation fits and stays tappable at ${width}dp', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = Size(width, 720);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      var selectedTab = BottomNavTab.home;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const SizedBox.expand(),
            bottomNavigationBar: BottomNavBar(
              selected: selectedTab,
              onTap: (tab) => selectedTab = tab,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final tabs = BottomNavTab.values
          .map((tab) => find.byKey(Key('bottom-nav-${tab.name}')))
          .toList();
      expect(tabs.length, 5);

      final rects = tabs.map(tester.getRect).toList();
      for (var i = 0; i < rects.length; i++) {
        expect(rects[i].left, greaterThanOrEqualTo(0));
        expect(rects[i].right, lessThanOrEqualTo(width));
        if (i > 0) {
          expect(rects[i].left, greaterThanOrEqualTo(rects[i - 1].right));
        }
      }

      await tester.tapAt(rects[BottomNavTab.wishlist.index].center);
      expect(selectedTab, BottomNavTab.wishlist);
      expect(tester.takeException(), isNull);
    });
  }
}
