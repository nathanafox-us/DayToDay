import 'dart:async';
import 'package:day_to_day/globals.dart';
import 'event_list_storage.dart';
import 'event_form.dart';
import 'package:flutter/material.dart';
import 'events.dart';
import 'globals.dart' as globals;
//import 'package:firebase_database/firebase_database.dart';
StreamController<bool> streamController = StreamController<bool>.broadcast();

class ProjectsWidget extends StatefulWidget {

  const ProjectsWidget({Key? key, required this.stream}) : super(key: key);
  final Stream<bool> stream;

  @override
  State<ProjectsWidget> createState() => ProjectsState();
}

class ProjectsState extends State<ProjectsWidget> {

  @override
  void initState() {

    widget.stream.listen((event) {
      setState(() {

      });
    });

    super.initState();
  }
  bool isPlaying = true;

  bool visibleList = false;
  bool visibleButton = false;

  @override
  Widget build(BuildContext context) {

    if (globals.completedProjects.isNotEmpty) {
      visibleButton = true;
    }
    Color textColor = Colors.black;
    var systemColor = MediaQuery.of(context).platformBrightness;
    bool darkMode = systemColor == Brightness.dark;
    if (darkMode) {
      textColor = Colors.white;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Projects List")),
        backgroundColor: const Color.fromARGB(255, 255, 82, 82),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
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
                            completedProjects.add(globals.projects[index]);
                            projects.removeAt(index);
                            if (globals.completedProjects.isNotEmpty) {
                              visibleButton = true;
                            }
                          });
                        },
                        title: Text(projects[index].title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: textColor,
                            ))));
              },
            ),
          ),
          Visibility(
            visible: visibleButton,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  isPlaying = !isPlaying;
                  visibleList = !visibleList;
                });
              },
              icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => RotationTransition(
                    turns: child.key == const ValueKey('firstIcon') ? Tween<double>(begin: 0, end: 1).animate(animation) : Tween<double>(begin: 0, end: 1).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                  child: isPlaying ? const Icon(Icons.arrow_right_outlined, key: ValueKey('secondIcon')) : const Icon(Icons.arrow_drop_down_sharp, key: ValueKey('firstIcon'),)),
              label: const Text(
                "Completed",
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
          Expanded(
            child: Visibility(
              visible: visibleList,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: ListView.builder(
                itemCount: completedProjects.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: CheckboxListTile(
                          dense: true,
                          activeColor: Colors.red[400],
                          controlAffinity: ListTileControlAffinity.leading,
                          value: true,
                          onChanged: (value) {
                            setState(() {
                              projects.add(completedProjects[index]);
                              completedProjects.removeAt(index);
                              if (globals.completedProjects.isEmpty) {
                                visibleButton = false;
                              }
                            });
                          },
                          title: Text(completedProjects[index].title,
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.grey,
                              ))));
                },
              ),
            ),
          ),
        ],
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
