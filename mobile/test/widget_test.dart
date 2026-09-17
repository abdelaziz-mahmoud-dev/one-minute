// Basic smoke test for the One Minute app.
//
// Verifies that the app builds successfully with all its providers
// and renders without throwing any errors.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/main.dart';

void main() {
  testWidgets('OneMinuteApp builds without errors', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const OneMinuteApp());

    // Let any async initial work (like the splash screen) settle.
    await tester.pump();

    // Verify the app rendered a MaterialApp successfully.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}