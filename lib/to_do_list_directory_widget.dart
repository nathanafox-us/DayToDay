import 'package:flutter/material.dart';
import 'package:day_to_day/to_do_list_widget.dart';
import 'package:day_to_day/to_do_list.dart';

// test of ToDoList class to use to make the directory and individual lists
List<ToDoList> initializeTest(int size) {
  DateTime todaysDate =
      DateTime.now(); // temporary holder before backend implementation
  List<ToDoList> lists = [];

  for (int i = 0; i < size; i++) {
    String title = todaysDate.month.toString() +
        "/" +
        (todaysDate.day - i).toString() +
        "/" +
        todaysDate.year.toString() +
        " To Do List";

    var list = ToDoList(title);
    lists.add(list);
  }

  return lists;
}

class ToDoListDirectoryWidget extends StatelessWidget {
  const ToDoListDirectoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ToDoList> lists = initializeTest(20);
    // makes the list
    return ListView.builder(
      itemCount: lists.length, //change for when backedn is running

      // for loop to make each card of teh list
      itemBuilder: (context, int index) {
        return Card(
            child: ListTile(
          // change the text when backend is running
          title: Text(
            lists[index].title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          // might have to use the normal routing style
          // tap functionality
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ToDoListWidget(lists[index]);
            }));
          }, //will need to fix so it goes to the right note page
        ));
      },
    );
  }
}
