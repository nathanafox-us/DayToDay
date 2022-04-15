import 'package:flutter/material.dart';
import 'Events.dart';
import 'dart:collection';

class ExamsWidget extends StatefulWidget {
  final projectsList = Queue<Events>();

  ExamsWidget({Key? key}) : super(key: key);

  @override
  State<ExamsWidget> createState() => ExamsState();
}

class ExamsState extends State<ExamsWidget> {
  List<String> exams = ["Exam 1", "Exam 2"];
  int count = 2;
  List<bool?> checked = [false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Exams List")),
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
                      exams.removeAt(index);
                      checked.removeAt(index);
                      count--;
                    });
                  },
                  title: Text(
                    exams[index],
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
            String returnStr = "Exam " + count.toString();
            exams.add(returnStr);
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
