// This file is used for testing your application's widgets.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

// IMPORTANT: Make sure this package name matches the 'name:' field
// in your pubspec.yaml file. Based on your path, it is likely 'gitraj'.
import 'package:gitraj/main.dart';

void main() {
  // This is a new, updated test for your Flutter Connect app.
  // It simply checks that the app builds and that the SplashScreen
  // shows the correct title, which is a great starting point.
  testWidgets('App starts and shows SplashScreen elements', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FlutterConnectApp());

    // Verify that the MaterialApp widget is present.
    expect(find.byType(MaterialApp), findsOneWidget);

    // Verify that the title "Flutter Connect" from the SplashScreen is visible.
    expect(find.text('Flutter Connect'), findsOneWidget);

    // Verify that the Icon from the SplashScreen is visible.
    expect(find.byIcon(Icons.hub), findsOneWidget);
  });

  /*
  // THE OLD COUNTER APP TEST IS COMMENTED OUT BELOW FOR YOUR REFERENCE.
  // This test was failing because it was looking for widgets that no longer exist.

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
  */
}
