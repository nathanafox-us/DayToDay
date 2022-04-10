import 'package:day_to_day/to_do_list.dart';
import 'package:day_to_day/Events.dart';

class User {
  String uID = "TEST";
  int fbTest = 0;
  List<ToDoList>? lists;
  //String is a date, will
  Map<String, List<Events>> events = {};
  List<Events> everyDay = [];
  List<Events> everyMonth = [];
  List<Events> everyWeek = [];
  List<Events> everyYear = [];

  User() {
    uID = "testconst";
    fbTest = 321;
  }
}
