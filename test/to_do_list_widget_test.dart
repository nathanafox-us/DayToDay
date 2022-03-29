import 'package:day_to_day/to_do_list_widget.dart';
import 'package:day_to_day/to_do_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('The title is in the checklist and is the title of list',
      (tester) async {
    //make widget
    final String title = "Testing title";
    ToDoList list = ToDoList(title);

    await tester
        .pumpWidget(MaterialApp(home: Material(child: ToDoListWidget(list))));

    // check if there are two widgets containing the title
    final titleFinder = find.textContaining(title);
    expect(titleFinder, findsNWidgets(2));
  });

  testWidgets('There is a CheckboxListTile for each item', (tester) async {
    //make widget
    final String title = "Testing title";
    ToDoList list = ToDoList(title);

    await tester
        .pumpWidget(MaterialApp(home: Material(child: ToDoListWidget(list))));

    // go through each list item and find the widget with its text
    for (int i = 0; i < list.items.length; i++) {
      var textFinder = find.widgetWithText(CheckboxListTile, list.items[i]);
      var scrollFinder = find.byType(Scrollable);

      // scroll if the widget is not on screen
      await tester.scrollUntilVisible(
        textFinder,
        500.0,
        scrollable: scrollFinder,
      );

      // checks to see if the widget is there
      expect(textFinder, findsOneWidget);
    }
  });

  testWidgets('Each item can be checked and unchecked', (tester) async {
    // make widget
    final String title = "Testing title";
    ToDoList list = ToDoList(title);

    await tester
        .pumpWidget(MaterialApp(home: Material(child: ToDoListWidget(list))));

    // go through each list item to check and uncheck each one
    for (int i = 0; i < list.items.length; i++) {
      // finds the widget associated with list[i]
      var textFinder = find.widgetWithText(CheckboxListTile, list.items[i]);
      var scrollFinder = find.byType(Scrollable);

      // scrolls if the widget to be found is not on screen
      await tester.scrollUntilVisible(
        textFinder,
        500.0,
        scrollable: scrollFinder,
      );

      // expect the checkbox to initially be false
      expect(list.checked[i], false);

      // tap the checkbox and expect it to be true
      await tester.tap(textFinder);
      await tester.pumpAndSettle();
      expect(list.checked[i], true);

      // tap the checkbox again and expect it to be false
      await tester.tap(textFinder);
      await tester.pumpAndSettle();
      expect(list.checked[i], false);
    }
  });
}
