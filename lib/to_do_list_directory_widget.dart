import 'package:flutter/material.dart';
import 'package:day_to_day/to_do_list.dart';

class ToDoListWidget extends StatefulWidget {
  final ToDoList list;

  // probably change this to the normal constructor in the future
  const ToDoListWidget(this.list);

  @override
  _ToDoListWidgetState createState() => _ToDoListWidgetState();
}

class _ToDoListWidgetState extends State<ToDoListWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.list.title),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
          itemCount: widget.list.items.length,
          itemBuilder: (context, int index) {
            // do we want to keep the cards or make it so there is a bar underneath each list item?
            return Card(
                //color: Colors.red[400], if we want the cards to be colored
                child: CheckboxListTile(
                    dense: true,
                    activeColor: Colors.red[400],
                    controlAffinity: ListTileControlAffinity.leading,
                    value: widget.list.checked[index],
                    onChanged: (value) {
                      setState(() {
                        widget.list.checked[index] = value;
                      });
                    },
                    title: Text(
                      widget.list.items[index],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    )));
          }),
    );
  }
}
