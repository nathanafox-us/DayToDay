import 'package:day_to_day/to_do_list.dart';
import 'package:day_to_day/events.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:day_to_day/globals.dart' as globals;
import 'package:firebase_database/firebase_database.dart';

class Sync {
  static FirebaseDatabase db = FirebaseDatabase.instance;
  static String uID = (FirebaseAuth.instance.currentUser?.uid ?? 'null');
  static bool loggedIn = (FirebaseAuth.instance.currentUser != null);
  static DatabaseReference user = db.ref('Users').child(uID);

  //concats the from DateTime hash, the to DateTime hash, and the title
  static String hashEvent(Events event) {
    String input = event.from.hashCode.toString() +
        event.to.hashCode.toString() +
        event.title;
    return input;
  }

  static sendEvents(DatabaseReference ref, List<Events> events) {
    for (Events event in events) {
      String hash = hashEvent(event);
      DatabaseReference eventRef = ref.child(hash);
      eventRef.child('from').set(event.from.toString());
      eventRef.child('to').set(event.to.toString());
      eventRef.child('page').set(event.page.toString());
      eventRef.child('title').set(event.title);
      eventRef.child('allDay').set(event.allDay);
      eventRef.child('type').set(event.eventType);
      DatabaseReference color = eventRef.child('color');
      color.child('a').set(event.color.alpha);
      color.child('r').set(event.color.red);
      color.child('g').set(event.color.green);
      color.child('b').set(event.color.blue);
      //can retrieve with:
      //  Color c = Color.fromARGB(color.a, color.r, color.g, color.b)
      //or something similar
    }
  }

  static sendToDo(DatabaseReference ref, List<ToDoList> todos) {
    for (ToDoList todo in todos) {
      DatabaseReference todoRef = ref.child(todo.title);
      todoRef.child('items').set(todo.items);
      todoRef.child('checked').set(todo.checked);
    }
  }

  static sendEventsList(String date, List<Events> events) {
    DatabaseReference ref = user.child('eventsList').child(date);
    sendEvents(ref, events);
  }

  static sendDaily(List<Events> events) {
    DatabaseReference ref = user.child('everyDay');
    sendEvents(ref, events);
  }

  static sendWeekly(List<Events> events) {
    DatabaseReference ref = user.child('everyWeek');
    sendEvents(ref, events);
  }

  static sendMonthly(List<Events> events) {
    DatabaseReference ref = user.child('everyMonth');
    sendEvents(ref, events);
  }

  static sendYearly(List<Events> events) {
    DatabaseReference ref = user.child('everyYear');
    sendEvents(ref, events);
  }

  static sendAssignments(List<Events> events) {
    DatabaseReference ref = user.child('assignments');
    sendEvents(ref, events);
  }

  static sendHomework(List<Events> events) {
    DatabaseReference ref = user.child('homework');
    sendEvents(ref, events);
  }

  static sendToDoList(String date, List<ToDoList> todos) {
    DatabaseReference ref = user.child('toDoList').child(date);
    sendToDo(ref, todos);
  }

  static sync() {
    print('Setting timestamp');
    db.ref('timestamp').set(DateTime.now().toString());
    print('Syncing...');
    /* uID = setUID(); //possibly redundant, unsure but better safe than sorry */
    //check timestamp and decide which way to sync
    print('Setting events');

    //syncing Firebase FROM disc
    globals.eventsList.forEach((date, events) => sendEventsList(date, events));
    sendDaily(globals.everyDay);
    sendWeekly(globals.everyWeek);
    sendMonthly(globals.everyMonth);
    sendYearly(globals.everyYear);
    sendAssignments(globals.assignments);
    sendHomework(globals.homework);
    globals.toDoList.forEach((date, todos) => sendToDoList(date, todos));
  }
}
