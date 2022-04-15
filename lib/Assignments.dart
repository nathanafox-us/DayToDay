import 'package:flutter/material.dart';
import 'Events.dart';
import 'dart:collection';

class AssignmentsWidget extends StatefulWidget {
  final assignmentsList = Queue<Events>();

  AssignmentsWidget({Key? key}) : super(key: key);

  @override
  State<AssignmentsWidget> createState() => AssignmentsState();
}

class AssignmentsState extends State<AssignmentsWidget> {
  List<String> assignments = ["HW 1", "HW 2"];
  List<bool?> checked = [false, false];
  int count = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Assignments List")),
      ),
      body: ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: CheckboxListTile(
                  dense: true,
                  activeColor: Colors.red[400],
                  controlAffinity: ListTileControlAffinity.leading,
                  value: checked[index],
                  onChanged: (value) {
                    setState(() {
                      assignments.removeAt(index);
                      checked.removeAt(index);
                      count--;
                    });
                  },
                  title: Text(
                    assignments[index],
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
            count++;
            String returnStr = "HW " + count.toString();
            assignments.add(returnStr);
            checked.add(false);
          });
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
