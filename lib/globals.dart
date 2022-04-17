import 'package:day_to_day/to_do_list.dart';

import 'events.dart';

DateTime timestamp = DateTime.fromMicrosecondsSinceEpoch(0);
Map<String, List<Events>> eventsList = {};
List<Events> everyDay = [];
List<Events> everyMonth = [];
List<Events> everyWeek = [];
List<Events> everyYear = [];
List<Events> assignments = [];
List<Events> homework = [];
Map<String, List<ToDoList>> toDoList = {};
