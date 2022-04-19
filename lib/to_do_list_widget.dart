import 'package:flutter/material.dart';
import 'package:day_to_day/to_do_list.dart';
import 'package:day_to_day/user_sync.dart';

class ToDoListWidget extends StatefulWidget {
  final ToDoList list;

  // probably change this to the normal constructor in the future
  const ToDoListWidget(this.list);

  @override
  _ToDoListWidgetState createState() => _ToDoListWidgetState();
}

class _ToDoListWidgetState extends State<ToDoListWidget> {
  final textController = TextEditingController();

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
            var systemColor = MediaQuery.of(context).platformBrightness;
            bool darkMode = systemColor == Brightness.dark;
            // do we want to keep the cards or make it so there is a bar underneath each list item?
            if (darkMode) {
              return Card(
                  //color: Colors.red[400], if we want the cards to be colored
                  child: GestureDetector(
                      onLongPress: () {
                        setState(() {
                          widget.list.removeItem(index);
                        });
                        //Sync.sync(DateTime.now());
                      },
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
                          ))));
            } else {
              return Card(
                  //color: Colors.red[400], if we want the cards to be colored
                  child: GestureDetector(
                      onLongPress: () {
                        setState(() {
                          widget.list.removeItem(index);
                        });
                        //Sync.sync(DateTime.now());
                      },
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
                                color: Color.fromARGB(255, 12, 12, 12)),
                          ))));
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: displayAddTask,
        child: const Icon(
          Icons.add,
          size: 45,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> displayAddTask() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text('Add task'),
            actions: <Widget>[
              TextButton(child: const Text('Add'), onPressed: addItem),
              TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
            content: TextField(
              controller: textController,
              textInputAction: TextInputAction.next,
            ));
      },
    );
  }

  void addItem() {
    setState(() {
      widget.list.addItem(textController.text.trim());
    });

    //Sync.sync(DateTime.now());
    textController.clear();
    Navigator.of(context).pop();
  }
}
