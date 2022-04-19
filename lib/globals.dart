import 'to_do_list.dart';
import 'events.dart';

DateTime timestamp = DateTime.fromMicrosecondsSinceEpoch(0);
Map<String, List<Events>> eventsList = {};
List<Events> everyDay = [];
List<Events> everyMonth = [];
List<Events> everyWeek = [];
List<Events> everyYear = [];
List<Events> assignments = [];
List<Events> exams = [];
List<Events> projects = [];
List<Events> completedAssignments = [];
List<Events> completedExams = [];
List<Events> completedProjects = [];
Map<String, List<ToDoList>> toDoList = {};
