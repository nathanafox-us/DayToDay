import 'package:flutter/material.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({Key? key}) : super(key: key);

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  @override
  Widget build(BuildContext context) {
    return Text("Opened Note.");
    /* NEED TO FIX
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, int index) {
          
          bool val = false;
          return CheckboxListTile(
            title: Text("Index is $index."),
            value: val,
            onChanged: (bool _val) {
              setState(() {
                val = _val;
              });
              
            return Center(
              child: Text(
                "Index is $index."
              )
            );
            },
          );
        }
        );*/
  }
}
