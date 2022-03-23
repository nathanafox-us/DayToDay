import 'package:flutter/material.dart';
import 'package:day_to_day/ToDoList.dart';

class ToDoListDirectory extends StatefulWidget {
  _ToDoListDirectoryState createState() => _ToDoListDirectoryState();
}

class _ToDoListDirectoryState extends State<ToDoListDirectory> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20, //change for when backedn is running
      itemBuilder: (context, int index) {
        DateTime todaysDate =
            DateTime.now(); // temporary holder before backend implementation

        return Card(
            child: ListTile(
          // change the text when backend is running
          title: Text(
            todaysDate.month.toString() +
                "/" +
                (todaysDate.day - index).toString() +
                "/" +
                todaysDate.year.toString() +
                " To Do List",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ToDoList();
            }));
          }, //will need to fix so it goes to the right note page
        ));
      },
    );
  }
}
