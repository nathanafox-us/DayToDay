// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:day_to_day/main.dart';

void main() {
  testWidgets('All tabs are in the app', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Material(child: AppWidget())));

    // Verify that our counter starts at 0.
    var tabFinder = find.byType(TabBar);

    var textFinder = find.text('Calendar');
    await tester.dragUntilVisible(textFinder, tabFinder, Offset(50.0, 0.0));
    expect(textFinder, findsOneWidget);

    textFinder = find.text('To-do');
    await tester.dragUntilVisible(textFinder, tabFinder, Offset(50.0, 0.0));
    expect(textFinder, findsOneWidget);

    textFinder = find.text('Projects');
    await tester.dragUntilVisible(textFinder, tabFinder, Offset(50.0, 0.0));
    expect(textFinder, findsOneWidget);

    textFinder = find.text('Homework');
    await tester.dragUntilVisible(textFinder, tabFinder, Offset(50.0, 0.0));
    expect(textFinder, findsOneWidget);
  });
}