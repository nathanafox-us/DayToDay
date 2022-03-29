
import 'package:day_to_day/Calendar.dart';
import 'package:day_to_day/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Testing that correct month displayed at app startup', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(const MaterialApp(home: Material(child: CalendarWidget())));

    final displayText = find.text("March ");

    expect(displayText, findsOneWidget);

  });
  testWidgets('Test if modal bottom sheet pops up for quick navigation', (WidgetTester tester) async {
    // Enter text and add the item...
    await tester.pumpWidget(const MaterialApp(home: Material(child: CalendarWidget())));
    //final Size windowSize = MediaQueryData.fromWindow(window).size;
    // Swipe the item to dismiss it.
    await tester.tap(find.text('March '));
    //await tester.pump();
    // Build the widget until the dismiss animation ends.
    await tester.pumpAndSettle();

    // Ensure that the item is no longer on screen.
    expect(find.text('2022'), findsOneWidget);
  });
  testWidgets('Test if add event button brings up new page', (WidgetTester tester) async {
    // Enter text and add the item...
    await tester.pumpWidget(MaterialApp(home: Material(child: AppWidget())));
    //final Size windowSize = MediaQueryData.fromWindow(window).size;
    // Swipe the item to dismiss it.
    await tester.tap(find.byType(FloatingActionButton));
    //await tester.pump();
    // Build the widget until the dismiss animation ends.
    await tester.pumpAndSettle();

    // Ensure that the item is no longer on screen.
    expect(find.text('All Day'), findsOneWidget);
  });
}