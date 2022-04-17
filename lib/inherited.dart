import 'package:day_to_day/user_sync.dart';
import 'package:flutter/material.dart';
import 'events.dart';
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
      int page,
      int hourF,
      int hourT,
      int minuteF,
      int minuteT,
      String eventType) {
    DateTime from = DateTime(yearFrom, monthFrom, dayFrom, hourF, minuteF);
    DateTime to = DateTime(yearTo, monthTo, dayTo, hourT, minuteT);

    String dfStr = dayFrom.toString();
    if (dayFrom < 10) {
      dfStr = '0' + dfStr;
    }
    String mfStr = monthFrom.toString();
    if (monthFrom < 10) {
      mfStr = '0' + mfStr;
    }

    if (repeat == "Everyday") {
      globals.everyDay
          .add(Events(title, color, allDay, page, from, to, eventType));
    } else if (repeat == "Every week") {
      globals.everyWeek
          .add(Events(title, color, allDay, page, from, to, eventType));
    } else if (repeat == "Every month") {
      globals.everyMonth
          .add(Events(title, color, allDay, page, from, to, eventType));
    } else if (repeat == "Every year") {
      globals.everyYear
          .add(Events(title, color, allDay, page, from, to, eventType));
    } else {
      if (globals.eventsList[dfStr + mfStr + yearFrom.toString()] != null) {
        if (to.difference(from).inDays != 0) {
          for (int i = 0; i <= to.difference(from).inDays; i++) {
            globals.eventsList[dfStr + mfStr + yearFrom.toString()]
                ?.add(Events(title, color, allDay, page, from, to, eventType));
            dayFrom += 1;
            if (dayFrom > DateTime(from.year, from.month + 1, 0).day) {
              dayFrom = 1;
              monthFrom += 1;
            }
          }
        } else {
          globals.eventsList[dfStr + mfStr + yearFrom.toString()]
              ?.add(Events(title, color, allDay, page, from, to, eventType));
        }
      } else {
        if (to.difference(from).inDays != 0) {
          for (int i = 0; i <= to.difference(from).inDays; i++) {
            List<Events> temp = [
              Events(title, color, allDay, page, from, to, eventType)
            ];
            globals.eventsList[dfStr + mfStr + yearFrom.toString()] = temp;
            dayFrom += 1;
            if (dayFrom > DateTime(from.year, from.month + 1, 0).day) {
              dayFrom = 1;
              monthFrom += 1;
            }
          }
        } else {
          List<Events> temp = [
            Events(title, color, allDay, page, from, to, eventType)
          ];
          globals.eventsList[dfStr + mfStr + yearFrom.toString()] = temp;
        }
      }
    }
    //Sync.sync(DateTime.now());

    globals.eventsList[dfStr + mfStr + yearFrom.toString()]?.sort((a, b) {
      if (a.from.hour == b.from.hour) {
        return a.from.minute.compareTo(b.from.minute);
      } else {
        return a.from.hour.compareTo(b.from.hour);
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
