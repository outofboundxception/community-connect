// test/widget_test.dart
import 'package:flutter_test/flutter_test.dart'; // Correct
import 'package:flutter/material.dart';

// Make sure this package name matches your pubspec.yaml
import 'package:community_connect/main.dart';

void main() {
  testWidgets('App starts and shows SplashScreen elements', (
    WidgetTester tester,
  ) async {
    // FIX 1: Use the correct widget name, MyApp, from your main.dart file.
    await tester.pumpWidget(const MyApp());

    // Verify that the MaterialApp widget is present.
    expect(find.byType(MaterialApp), findsOneWidget);

    // FIX 2: Verify the correct title "Community Connect" is visible.
    expect(find.text('Community Connect'), findsOneWidget);

    // Verify that the Icon from the SplashScreen is visible.
    expect(find.byIcon(Icons.hub), findsOneWidget);
  });
}