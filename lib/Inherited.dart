import 'package:flutter/material.dart';
import 'Events.dart';

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

  int yearFrom = 0;
  int monthFrom = 0;
  Map<String, Events> events = {};

  void updateClicked(int position, int yearC, int monthC) {

    clicked = position;
    yearFrom = yearC;
    monthFrom = monthC;
  }

  void addEvent(int dayFrom, int yearFrom, int monthFrom, String title) {
    events[dayFrom.toString() + monthFrom.toString() + yearFrom.toString()] = Events(monthFrom, yearFrom, dayFrom, title);
  }

  @override
  Widget build(BuildContext context) => StateWidget(
      child: widget.child,
      clicked: clicked,
      monthFrom: monthFrom,
      yearFrom: yearFrom,
      events: events,
      state: this,
  );
}




class StateWidget extends InheritedWidget {
  final int clicked;
  final _InheritedStateState state;
  final int yearFrom;
  final int monthFrom;
  final Map<String, Events> events;

  const StateWidget({
    Key? key,
    required Widget child,
    required this.clicked,
    required this.state,
    required this.monthFrom,
    required this.yearFrom,
    required this.events,
  }) : super(key: key, child: child);

  static _InheritedStateState? of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<StateWidget>()
          ?.state;

  @override
  bool updateShouldNotify(StateWidget oldWidget) {
    return oldWidget.clicked != clicked ||
        oldWidget.monthFrom != monthFrom ||
        oldWidget.yearFrom != yearFrom ||
        oldWidget.events != events ||
        oldWidget.state != state;
  }

}
