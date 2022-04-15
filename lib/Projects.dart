import 'dart:async';
import 'dart:collection';
import 'package:day_to_day/Inherited.dart';
import 'package:day_to_day/Months.dart';
import 'package:flutter/material.dart';
import 'Events.dart';
import 'globals.dart' as globals;
import 'package:firebase_database/firebase_database.dart';

class ProjectsWidget extends StatefulWidget {
  ProjectsWidget({Key? key}) : super(key: key);

  @override
  State<ProjectsWidget> createState() => ProjectsState();
}

class ProjectsState extends State<ProjectsWidget> {
  List<String> projectsList = ["P1", "P2"];
  int count = 2;
  List<bool?> checked = [false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Projects List")),
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
                      projectsList.removeAt(index);
                      checked.removeAt(index);
                      count--;
                    });
                  },
                  title: Text(
                    projectsList[index],
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
            String returnStr = "P" + count.toString();
            projectsList.add(returnStr);
            checked.add(false);
            print(count);
            print(projectsList);
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
