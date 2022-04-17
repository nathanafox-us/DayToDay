import 'package:day_to_day/globals.dart';
import 'event_form.dart';
import 'event_list_storage.dart';
import 'package:flutter/material.dart';
import 'events.dart';
import 'globals.dart' as globals;
//import 'package:firebase_database/firebase_database.dart';

class ProjectsWidget extends StatefulWidget {
  List<Events> projects = [];
  ProjectsWidget({Key? key}) : super(key: key);

  @override
  State<ProjectsWidget> createState() => ProjectsState();
}

class ProjectsState extends State<ProjectsWidget> {
  @override
  Widget build(BuildContext context) {
    projects = [];
    globals.eventsList.forEach((key, value) {
      for (int i = 0; i < value.length; i++) {
        if (value[i].type.contains("project")) {
          projects.add(value[i]);
        }
      }
    });
    print("\n\n\nProjects: " + projects.length.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Projects List")),
        backgroundColor: const Color.fromARGB(255, 255, 82, 82),
      ),
      body: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: CheckboxListTile(
                  dense: true,
                  activeColor: Colors.red[400],
                  controlAffinity: ListTileControlAffinity.leading,
                  value: false,
                  onChanged: (value) {
                    setState(() {
                      projects.removeAt(index);
                    });
                  },
                  title: Text(
                    projects[index].title,
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
