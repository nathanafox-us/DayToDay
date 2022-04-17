
import 'dart:async';

import 'package:day_to_day/calendar.dart';
import 'package:day_to_day/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

StreamController<bool> streamController = StreamController<bool>.broadcast();

void main() {
  testWidgets('Testing that correct month displayed at app startup', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: Material(child: CalendarWidget(stream: streamController.stream,))));

    final displayText = find.text("March ");

    expect(displayText, findsOneWidget);

  });
  testWidgets('Test if modal bottom sheet pops up for quick navigation', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Material(child: CalendarWidget(stream: streamController.stream,))));
    await tester.tap(find.text('March '));
    await tester.pumpAndSettle();

    // Ensure that the item is no longer on screen.
    expect(find.text('2022'), findsOneWidget);
  });
  testWidgets('Test if add event button brings up new page', (WidgetTester tester) async {
    //await tester.pumpWidget(const MaterialApp(home: Material(child: AppWidget())));
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Ensure that the item is no longer on screen.
    expect(find.text('All Day'), findsOneWidget);
  });
  testWidgets('Test if cancel button on event add page goes back to calendar', (WidgetTester tester) async {
    //await tester.pumpWidget(const MaterialApp(home: Material(child: AppWidget())));
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(TextButton).first);
    await tester.pumpAndSettle();

    // Ensure that the item is no longer on screen.
    expect(find.text('March '), findsOneWidget);
  });
}