import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:learning_app/screens/auth/splash_screen.dart';

void main() {
  testWidgets('splash shows the brand artwork and transitions to login', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 720);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: SplashScreen()));
    await tester.pump();

    expect(find.text('Mono LMS'), findsOneWidget);
    expect(
      find.text('A little learning.\nA world of possibilities.'),
      findsOneWidget,
    );
    expect(find.byType(Image), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
