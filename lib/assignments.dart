import 'package:flutter/material.dart';
import 'event_form.dart';
import 'globals.dart' as globals;
import 'events.dart';

class AssignmentsWidget extends StatefulWidget {
  List<Events> hw = [];
  AssignmentsWidget({Key? key, required this.stream}) : super(key: key);
  final Stream<bool> stream;

  @override
  State<AssignmentsWidget> createState() => AssignmentsState();
}

class AssignmentsState extends State<AssignmentsWidget> {
  int count = 2;

  @override
  void initState() {

    widget.stream.listen((event) {
      setState(() {

      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.hw = [];
    globals.eventsList.forEach((key, value) {
      for (int i = 0; i < value.length; i++) {
        if (value[i].type.contains("assign")) {
          widget.hw.add(value[i]);
        }
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Assignments List")),
        backgroundColor: const Color.fromARGB(255, 255, 82, 82),
      ),
      body: ListView.builder(
        itemCount: widget.hw.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: CheckboxListTile(
                  dense: true,
                  activeColor: Colors.red[400],
                  controlAffinity: ListTileControlAffinity.leading,
                  value: false,
                  onChanged: (value) {
                    setState(() {
                      widget.hw.removeAt(index);
                    });
                  },
                  title: Text(
                    widget.hw[index].title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color.fromARGB(255, 12, 12, 12)),
                  )));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return EventForm();
            }));
          });
          setState(() {});
        },
        child: const Icon(
          Icons.add,
          size: 45,
          color: Colors.white,
        ),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}
