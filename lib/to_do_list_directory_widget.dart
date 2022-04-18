import 'package:flutter/material.dart';
import 'package:day_to_day/to_do_list_widget.dart';
import 'package:day_to_day/to_do_list.dart';
import 'dart:async';
import 'package:day_to_day/globals.dart';
import 'event_list_storage.dart';
import 'event_form.dart';
import 'package:flutter/material.dart';
import 'package:day_to_day/user_sync.dart';
import 'events.dart';
import 'globals.dart' as globals;

// test of ToDoList class to use to make the directory and individual lists
void newList() {
  List<ToDoList> list = [];

  DateTime todaysDate = DateTime.now();

  String key = todaysDate.month.toString() +
      todaysDate.day.toString() +
      todaysDate.year.toString();

  if (!globals.toDoList.containsKey(key)) {
    list.add(ToDoList(key + " To Do List"));
    globals.toDoList[key] = list;
  }

  Sync.sync(DateTime.now());
}

class ToDoListDirectoryWidget extends StatelessWidget {
  const ToDoListDirectoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // makes the list
    newList();

    return ListView.builder(
      itemCount: globals.toDoList.length, //change for when backedn is running

      // for loop to make each card of the list
      itemBuilder: (context, int index) {
        // getting around nulls
        String key = globals.toDoList.keys.elementAt(index);
        String? tempTitle = "";
        String title = "";
        ToDoList? tempToDo;
        ToDoList toDo = ToDoList("");

        if (globals.toDoList.containsKey(key)) {
          tempTitle = globals.toDoList[key]?.first.title;
          tempToDo = globals.toDoList[key]?.first;
        }

        if (tempTitle != null && tempToDo != null) {
          title = tempTitle;
          toDo = tempToDo;
        }

        return Card(
            child: ListTile(
          // change the text when backend is running
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          // might have to use the normal routing style
          // tap functionality
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ToDoListWidget(toDo);
            }));
          }, //will need to fix so it goes to the right note page
        ));
      },
    );
  }
}
