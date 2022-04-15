import 'package:flutter/material.dart';
import 'Events.dart';
import 'globals.dart' as globals;

class InheritedState extends StatefulWidget {
  final Widget child;

  const InheritedState({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _InheritedStateState createState() => _InheritedStateState();
}

class _InheritedStateState extends State<InheritedState> {
  int clicked = -2;
  int eventAdded = 0;

  int yearFrom = 0;
  int monthFrom = 0;

  void updateClicked(int position, int yearC, int monthC) {
    clicked = position;
    yearFrom = yearC;
    monthFrom = monthC;
  }

  void addEvent(
      int dayFrom,
      int yearFrom,
      int monthFrom,
      String title,
      String timeF,
      String timeT,
      int dayTo,
      int monthTo,
      int yearTo,
      Color color,
      TimeOfDay toT,
      TimeOfDay fromT,
      bool allDay,
      String repeat,
      int page) {
    int weekDay = DateTime(yearFrom, monthFrom, dayFrom).weekday;
    if (repeat == "Everyday") {
      globals.everyDay.add(Events(
          monthFrom,
          yearFrom,
          dayFrom,
          title,
          timeF,
          timeT,
          dayTo,
          monthTo,
          yearTo,
          color,
          fromT,
          toT,
          allDay,
          repeat,
          page,
          weekDay,
          'calendar'));
    } else if (repeat == "Every week") {
      globals.everyWeek.add(Events(
          monthFrom,
          yearFrom,
          dayFrom,
          title,
          timeF,
          timeT,
          dayTo,
          monthTo,
          yearTo,
          color,
          fromT,
          toT,
          allDay,
          repeat,
          page,
          weekDay,
          'calendar'));
    } else if (repeat == "Every month") {
      globals.everyMonth.add(Events(
          monthFrom,
          yearFrom,
          dayFrom,
          title,
          timeF,
          timeT,
          dayTo,
          monthTo,
          yearTo,
          color,
          fromT,
          toT,
          allDay,
          repeat,
          page,
          weekDay,
          'calendar'));
    } else if (repeat == "Every year") {
      globals.everyYear.add(Events(
          monthFrom,
          yearFrom,
          dayFrom,
          title,
          timeF,
          timeT,
          dayTo,
          monthTo,
          yearTo,
          color,
          fromT,
          toT,
          allDay,
          repeat,
          page,
          weekDay,
          'calendar'));
    } else {
      if (globals.events[dayFrom.toString() +
              monthFrom.toString() +
              yearFrom.toString()] !=
          null) {
        globals.events[
                dayFrom.toString() + monthFrom.toString() + yearFrom.toString()]
            ?.add(Events(
                monthFrom,
                yearFrom,
                dayFrom,
                title,
                timeF,
                timeT,
                dayTo,
                monthTo,
                yearTo,
                color,
                fromT,
                toT,
                allDay,
                repeat,
                page,
                weekDay,
                'calendar'));
      } else {
        List<Events> temp = [
          Events(
              monthFrom,
              yearFrom,
              dayFrom,
              title,
              timeF,
              timeT,
              dayTo,
              monthTo,
              yearTo,
              color,
              fromT,
              toT,
              allDay,
              repeat,
              page,
              weekDay,
              'calendar')
        ];
        globals.events[dayFrom.toString() +
            monthFrom.toString() +
            yearFrom.toString()] = temp;
      }
    }

    globals
        .events[dayFrom.toString() + monthFrom.toString() + yearFrom.toString()]
        ?.sort((a, b) {
      if (a.fromT.hour == b.fromT.hour) {
        return a.fromT.minute.compareTo(b.fromT.minute);
      } else {
        return a.fromT.hour.compareTo(b.fromT.hour);
      }
    });
  }

  @override
  Widget build(BuildContext context) => StateWidget(
        child: widget.child,
        clicked: clicked,
        monthFrom: monthFrom,
        yearFrom: yearFrom,
        eventAdded: eventAdded,
        state: this,
      );
}

class StateWidget extends InheritedWidget {
  final int clicked;
  final _InheritedStateState state;
  final int yearFrom;
  final int eventAdded;
  final int monthFrom;

  const StateWidget({
    Key? key,
    required Widget child,
    required this.clicked,
    required this.state,
    required this.monthFrom,
    required this.yearFrom,
    required this.eventAdded,
  }) : super(key: key, child: child);

  static _InheritedStateState? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<StateWidget>()?.state;

  @override
  bool updateShouldNotify(StateWidget oldWidget) {
    return oldWidget.clicked != clicked ||
        oldWidget.monthFrom != monthFrom ||
        oldWidget.yearFrom != yearFrom ||
        oldWidget.eventAdded != eventAdded ||
        oldWidget.state != state;
  }
}
