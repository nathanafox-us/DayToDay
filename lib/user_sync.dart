import 'package:day_to_day/to_do_list.dart';
import 'package:day_to_day/events.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:day_to_day/globals.dart' as globals;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

//NOTE: potentially not very efficient. Tends to clear events that are
//  being sync'ed and re-writing them. Potential upgrade would be to hash
//  the entire event and use that as the title, then check local hashes against
//  the database before deciding to write, but at this scale it should be ok.
class Sync {
  static String uID = (FirebaseAuth.instance.currentUser?.uid ?? 'null');
  static DatabaseReference user =
      FirebaseDatabase.instance.ref('Users').child(uID);

  //concats the from DateTime hash, the to DateTime hash, and the title
  static String hashEvent(Events event) {
    String input = event.from.hashCode.toString() +
        event.to.hashCode.toString() +
        event.title;
    return input;
  }

  static sendEvents(DatabaseReference ref, List<Events> events) async {
    await ref.remove();
    for (Events event in events) {
      String hash = hashEvent(event);
      DatabaseReference eventRef = ref.child(hash);
      eventRef.child('from').set(event.from.toString());
      eventRef.child('to').set(event.to.toString());
      eventRef.child('page').set(event.page);
      eventRef.child('title').set(event.title);
      eventRef.child('allDay').set(event.allDay);
      eventRef.child('eventType').set(event.type);
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

  static void sendDaily(List<Events> events) {
    DatabaseReference ref = user.child('everyDay');
    sendEvents(ref, events);
  }

  static void sendWeekly(List<Events> events) {
    DatabaseReference ref = user.child('everyWeek');
    sendEvents(ref, events);
  }

  static void sendMonthly(List<Events> events) {
    DatabaseReference ref = user.child('everyMonth');
    sendEvents(ref, events);
  }

  static void sendYearly(List<Events> events) {
    DatabaseReference ref = user.child('everyYear');
    sendEvents(ref, events);
  }

  static void sendAssignments(List<Events> events) {
    DatabaseReference ref = user.child('assignments');
    sendEvents(ref, events);
  }

  static void sendExams(List<Events> events) {
    DatabaseReference ref = user.child('exams');
    sendEvents(ref, events);
  }

  static void sendProjects(List<Events> events) {
    DatabaseReference ref = user.child('projects');
    sendEvents(ref, events);
  }

  static void sendCompletedAssignments(List<Events> events) {
    DatabaseReference ref = user.child('completedAssignments');
    sendEvents(ref, events);
  }

  static void sendCompletedExams(List<Events> events) {
    DatabaseReference ref = user.child('completedExams');
    sendEvents(ref, events);
  }

  static void sendCompletedProjects(List<Events> events) {
    DatabaseReference ref = user.child('completedProjects');
    sendEvents(ref, events);
  }

  static void sendToDoList(String date, List<ToDoList> todos) {
    DatabaseReference ref = user.child('toDoList').child(date);
    sendToDo(ref, todos);
  }

  static Future<List<Events>> getEvents(DatabaseReference ref) async {
    List<Events> events = [];
    DataSnapshot snap = await ref.get();
    for (var dbEvent in snap.children) {
      DateTime from = DateTime.parse(dbEvent.child('from').value! as String);
      //print('from: ' + from.toString());
      DateTime to = DateTime.parse(dbEvent.child('to').value! as String);
      //print('to: ' + to.toString());
      int page = dbEvent.child('page').value! as int;
      //print('page: ' + page.toString());
      String title = dbEvent.child('title').value! as String;
      //print('title: ' + title);
      bool allDay = dbEvent.child('allDay').value! as bool;
      //print('allDay: ' + allDay.toString());
      String eventType = dbEvent.child('eventType').value! as String;
      //print('eventType: ' + eventType);

      int a = dbEvent.child('color/a').value! as int;
      int r = dbEvent.child('color/r').value! as int;
      int g = dbEvent.child('color/g').value! as int;
      int b = dbEvent.child('color/b').value! as int;
      Color color = Color.fromARGB(a, r, g, b);
      //print(color.toString());

      Events event = Events(title, color, allDay, page, from, to, eventType);
      events.add(event);
    }
    return events;
  }

  static Future<List<ToDoList>> getToDos(DatabaseReference ref) async {
    List<ToDoList> todos = [];
    DataSnapshot snap = await ref.get();
    for (var dbList in snap.children) {
      String title = dbList.child('title').value! as String;
      List<String> items = dbList.child('title').value! as List<String>;
      List<bool?> checked = dbList.child('checked').value! as List<bool?>;
      ToDoList todo = ToDoList.hasAll(title, items, checked);
      todos.add(todo);
    }
    return todos;
  }

  static Future<void> getEventsList() async {
    DatabaseReference ref = user.child('eventsList');
    DataSnapshot snap = await ref.get();
    for (var child in snap.children) {
      List<Events> events = await getEvents(child.ref);
      globals.eventsList[child.key!] = events;
    }
  }

  static Future<List<Events>> getDaily() async {
    DatabaseReference ref = user.child('everyDay');
    return await getEvents(ref);
  }

  static Future<List<Events>> getWeekly() async {
    DatabaseReference ref = user.child('everyWeek');
    return await getEvents(ref);
  }

  static Future<List<Events>> getMonthly() async {
    DatabaseReference ref = user.child('everyMonth');
    return await getEvents(ref);
  }

  static Future<List<Events>> getYearly() async {
    DatabaseReference ref = user.child('everyYear');
    return await getEvents(ref);
  }

  static Future<List<Events>> getAssignments() async {
    DatabaseReference ref = user.child('assignments');
    return await getEvents(ref);
  }

  static Future<List<Events>> getExams() async {
    DatabaseReference ref = user.child('exams');
    return await getEvents(ref);
  }

  static Future<List<Events>> getProjects() async {
    DatabaseReference ref = user.child('projects');
    return await getEvents(ref);
  }

  static Future<List<Events>> getCompletedAssignments() async {
    DatabaseReference ref = user.child('completedAssignments');
    return await getEvents(ref);
  }

  static Future<List<Events>> getCompletedExams() async {
    DatabaseReference ref = user.child('completedExams');
    return await getEvents(ref);
  }

  static Future<List<Events>> getCompletedProjects() async {
    DatabaseReference ref = user.child('completedProjects');
    return await getEvents(ref);
  }

  static Future<void> getToDoList() async {
    DatabaseReference ref = user.child('toDoList');
    DataSnapshot snap = await ref.get();
    for (var child in snap.children) {
      List<ToDoList> todos = await getToDos(child.ref);
      globals.toDoList[child.key!] = todos;
    }
  }

  static sync([DateTime? ts]) async {
    //print('Global timestamp: ' + globals.timestamp.toString());
    if (ts != null) {
      globals.timestamp = ts;
    }
    DateTime timestamp = DateTime.fromMicrosecondsSinceEpoch(0);
    var snap = await user.get();
    if (snap.child('timestamp').exists) {
      timestamp = DateTime.parse(snap.child('timestamp').value as String);
    } else {
      user.child('timestamp').set(timestamp.toString());
    }

    print('Syncing...');
    //print('Global timestamp: ' + globals.timestamp.toString());

    //check timestamp and decide which way to sync
    //Whichever data is more recent takes priority
    if (timestamp.isBefore(globals.timestamp)) {
      print('setting...');
      //syncing Firebase FROM disc
      //updating database timestamp
      timestamp = globals.timestamp;
      print(globals.timestamp.toString());
      user.child('timestamp').set(timestamp.toString());
      globals.eventsList
          .forEach((date, events) => sendEventsList(date, events));
      sendDaily(globals.everyDay);
      sendWeekly(globals.everyWeek);
      sendMonthly(globals.everyMonth);
      sendYearly(globals.everyYear);
      sendAssignments(globals.assignments);
      sendExams(globals.exams);
      sendProjects(globals.projects);
      sendCompletedAssignments(globals.completedAssignments);
      sendCompletedExams(globals.completedExams);
      sendCompletedProjects(globals.completedProjects);
      globals.toDoList.forEach((date, todos) => sendToDoList(date, todos));
    } else {
      print('getting...');
      //syncing disc FROM firebase
      //updating local timestamp
      globals.timestamp = timestamp;
      print(globals.timestamp.toString());
      await getEventsList();
      if (snap.child('everyDay').exists) {
        globals.everyDay = await getDaily();
      } else {
        globals.everyDay.clear();
      }
      if (snap.child('everyWeek').exists) {
        globals.everyWeek = await getWeekly();
      } else {
        globals.everyWeek.clear();
      }
      if (snap.child('everyMonth').exists) {
        globals.everyMonth = await getMonthly();
      } else {
        globals.everyMonth.clear();
      }
      if (snap.child('everyYear').exists) {
        globals.everyYear = await getYearly();
      } else {
        globals.everyMonth.clear();
      }
      if (snap.child('assignments').exists) {
        globals.assignments = await getAssignments();
      } else {
        globals.assignments.clear();
      }
      if (snap.child('exams').exists) {
        globals.exams = await getExams();
      } else {
        globals.exams.clear();
      }
      if (snap.child('projects').exists) {
        globals.projects = await getProjects();
      } else {
        globals.projects.clear();
      }
      if (snap.child('completedAssignments').exists) {
        globals.completedAssignments = await getCompletedAssignments();
      } else {
        globals.completedAssignments.clear();
      }
      if (snap.child('completedExams').exists) {
        globals.completedExams = await getCompletedExams();
      } else {
        globals.completedExams.clear();
      }
      if (snap.child('completedProjects').exists) {
        globals.completedProjects = await getCompletedProjects();
      } else {
        globals.completedProjects.clear();
      }
      await getToDoList();
    }
  }
}
