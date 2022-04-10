import 'package:flutter_test/flutter_test.dart';
import 'package:day_to_day/to_do_list_directory_widget.dart';
import 'package:day_to_day/to_do_list_widget.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('The current day is in the directory', (tester) async {
    //make widget
    await tester.pumpWidget(
        MaterialApp(home: Material(child: ToDoListDirectoryWidget())));

    // check if there are two widgets containing the title
    DateTime todaysDate = DateTime.now();
    String title = todaysDate.month.toString() +
        "/" +
        (todaysDate.day).toString() +
        "/" +
        todaysDate.year.toString() +
        " To Do List";

    final titleFinder = find.textContaining(title);
    expect(titleFinder, findsOneWidget);
  });

  testWidgets('Each list is tapable and the back buttons go to the directory',
      (tester) async {
    //make widget
    DateTime todaysDate = DateTime.now();
    await tester.pumpWidget(
        MaterialApp(home: Material(child: ToDoListDirectoryWidget())));

    // go through each list item and find the widget with its text
    for (int i = 0; i < 20; i++) {
      String title = todaysDate.month.toString() +
          "/" +
          (todaysDate.day - i).toString() +
          "/" +
          todaysDate.year.toString() +
          " To Do List";
      var textFinder = find.widgetWithText(Card, title);
      var scrollFinder = find.byType(Scrollable);

      // scroll if the widget is not on screen
      await tester.scrollUntilVisible(
        textFinder,
        500.0,
        scrollable: scrollFinder,
      );

      // checks to see if the widget is there
      expect(textFinder, findsOneWidget);

      // taps on the list
      await tester.tap(textFinder);
      await tester.pumpAndSettle();

      // in ToDoListWidget
      var toDoListFinder = find.byType(Scaffold);
      expect(toDoListFinder, findsOneWidget);

      // taps on the backbutton and goes back to directory
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(textFinder, findsOneWidget);
    }
  });

  testWidgets('List has same title in directory and in to do list',
      (tester) async {
        //make widget
        DateTime todaysDate = DateTime.now();
        await tester.pumpWidget(
            const MaterialApp(
                home: Material(child: ToDoListDirectoryWidget())));

        // go through each list item and find the widget with its text
        for (int i = 0; i < 20; i++) {
          String title = todaysDate.month.toString() +
              "/" +
              (todaysDate.day - i).toString() +
              "/" +
              todaysDate.year.toString() +
              " To Do List";
          var textFinder = find.widgetWithText(Card, title);
          var scrollFinder = find.byType(Scrollable);

          // scroll if the widget is not on screen
          await tester.scrollUntilVisible(
            textFinder,
            500.0,
            scrollable: scrollFinder,
          );

          // checks to see if the widget is there
          expect(textFinder, findsOneWidget);

          // taps on the list
          await tester.tap(textFinder);
          await tester.pumpAndSettle();

          // in ToDoListWidget
          var toDoListFinder = find.widgetWithText(AppBar, title);
          expect(toDoListFinder, findsOneWidget);
        }
      });

    testWidgets('Each list has items in', (tester) async {
      //make widget
      DateTime todaysDate = DateTime.now();
      await tester.pumpWidget(
          MaterialApp(home: Material(child: ToDoListDirectoryWidget())));

      // go through each list item and find the widget with its text
      for (int i = 0; i < 20; i++) {
        String title = todaysDate.month.toString() +
            "/" +
            (todaysDate.day - i).toString() +
            "/" +
            todaysDate.year.toString() +
            " To Do List";
        var textFinder = find.widgetWithText(Card, title);
        var scrollFinder = find.byType(Scrollable);

        // scroll if the widget is not on screen
        await tester.scrollUntilVisible(
          textFinder,
          500.0,
          scrollable: scrollFinder,
        );

        // checks to see if the widget is there
        expect(textFinder, findsOneWidget);

        // taps on the list
        await tester.tap(textFinder);
        await tester.pumpAndSettle();

        // in ToDoListWidget
        var toDoListFinder = find.byType(Scaffold);
        expect(toDoListFinder, findsOneWidget);

        // taps on the backbutton and goes back to directory
        await tester.tap(find.byTooltip('Back'));
        await tester.pumpAndSettle();
        expect(textFinder, findsOneWidget);
      }
    });
}
