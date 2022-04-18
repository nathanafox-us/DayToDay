import 'dart:async';
import 'package:day_to_day/globals.dart';
import 'event_list_storage.dart';
import 'event_form.dart';
import 'package:flutter/material.dart';
import 'events.dart';
import 'globals.dart' as globals;
import 'user_sync.dart';

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
      setState(() {});
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
                    child: GestureDetector(
                  onLongPress: () => delete(projects[index]),
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
                          ))),
                ));
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
                        turns: child.key == const ValueKey('firstIcon')
                            ? Tween<double>(begin: 0, end: 1).animate(animation)
                            : Tween<double>(begin: 0, end: 1)
                                .animate(animation),
                        child: FadeTransition(opacity: animation, child: child),
                      ),
                  child: isPlaying
                      ? const Icon(Icons.arrow_right_outlined,
                          key: ValueKey('secondIcon'))
                      : const Icon(
                          Icons.arrow_drop_down_sharp,
                          key: ValueKey('firstIcon'),
                        )),
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
                      child: GestureDetector(
                    onLongPress: () => delete(completedProjects[index]),
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
                            ))),
                  ));
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

  delete(Events item) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Delete event?'),
              content: const Text('Can\'t be undone'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    String d = item.from.day.toString();
                    String m = item.from.month.toString();
                    String y = item.from.year.toString();

                    if (item.to.difference(item.from).inDays != 0) {
                      for (int j = 0;
                          j <= item.to.difference(item.from).inDays;
                          j++) {
                        d = (item.from.day + j).toString();

                        if (int.parse(d) <= 9) {
                          d = "0" + d;
                        }
                        if (int.parse(m) <= 9) {
                          m = "0" + m;
                        }
                        for (int i = 0;
                            i < (globals.eventsList[d + m + y]?.length)!;
                            i++) {
                          if (globals.eventsList[d + m + y]?.elementAt(i).to.day ==
                                  item.to.day &&
                              globals.eventsList[d + m + y]?.elementAt(i).to.month ==
                                  item.to.month &&
                              globals.eventsList[d + m + y]?.elementAt(i).to.year ==
                                  item.to.year &&
                              globals.eventsList[d + m + y]?.elementAt(i).to.hour ==
                                  item.to.hour &&
                              globals.eventsList[d + m + y]?.elementAt(i).to.minute ==
                                  item.to.minute &&
                              globals.eventsList[d + m + y]?.elementAt(i).from.day ==
                                  item.from.day &&
                              globals.eventsList[d + m + y]?.elementAt(i).from.minute ==
                                  item.from.minute &&
                              globals.eventsList[d + m + y]?.elementAt(i).from.year ==
                                  item.from.year &&
                              globals.eventsList[d + m + y]?.elementAt(i).from.month ==
                                  item.from.month &&
                              globals.eventsList[d + m + y]?.elementAt(i).from.hour ==
                                  item.from.hour &&
                              globals.eventsList[d + m + y]?.elementAt(i).type ==
                                  item.type &&
                              globals.eventsList[d + m + y]?.elementAt(i).allDay ==
                                  item.allDay &&
                              globals.eventsList[d + m + y]?.elementAt(i).page ==
                                  item.page &&
                              globals.eventsList[d + m + y]?.elementAt(i).title ==
                                  item.title) {
                            globals.eventsList[d + m + y]?.removeAt(i);
                            print("hm");
                          }
                        }
                      }
                    } else {
                      if (int.parse(d) <= 9) {
                        d = "0" + d;
                      }
                      if (int.parse(m) <= 9) {
                        m = "0" + m;
                      }
                      for (int i = 0;
                          i < (globals.eventsList[d + m + y]?.length)!;
                          i++) {
                        if (globals.eventsList[d + m + y]?.elementAt(i).to.day ==
                                item.to.day &&
                            globals.eventsList[d + m + y]?.elementAt(i).to.month ==
                                item.to.month &&
                            globals.eventsList[d + m + y]?.elementAt(i).to.year ==
                                item.to.year &&
                            globals.eventsList[d + m + y]?.elementAt(i).to.hour ==
                                item.to.hour &&
                            globals.eventsList[d + m + y]?.elementAt(i).to.minute ==
                                item.to.minute &&
                            globals.eventsList[d + m + y]?.elementAt(i).from.day ==
                                item.from.day &&
                            globals.eventsList[d + m + y]
                                    ?.elementAt(i)
                                    .from
                                    .minute ==
                                item.from.minute &&
                            globals.eventsList[d + m + y]?.elementAt(i).from.year ==
                                item.from.year &&
                            globals.eventsList[d + m + y]?.elementAt(i).from.month ==
                                item.from.month &&
                            globals.eventsList[d + m + y]?.elementAt(i).from.hour ==
                                item.from.hour &&
                            globals.eventsList[d + m + y]?.elementAt(i).type ==
                                item.type &&
                            globals.eventsList[d + m + y]?.elementAt(i).allDay ==
                                item.allDay &&
                            globals.eventsList[d + m + y]?.elementAt(i).page ==
                                item.page &&
                            globals.eventsList[d + m + y]?.elementAt(i).title ==
                                item.title) {
                          globals.eventsList[d + m + y]?.removeAt(i);
                        }
                      }
                      if (globals.projects.isNotEmpty) {
                        for (int i = 0; i < globals.projects.length; i++) {
                          if (globals.projects.elementAt(i).to.day ==
                                  item.to.day &&
                              globals.projects.elementAt(i).to.month ==
                                  item.to.month &&
                              globals.projects.elementAt(i).to.year ==
                                  item.to.year &&
                              globals.projects.elementAt(i).to.hour ==
                                  item.to.hour &&
                              globals.projects.elementAt(i).to.minute ==
                                  item.to.minute &&
                              globals.projects.elementAt(i).from.day ==
                                  item.from.day &&
                              globals.projects.elementAt(i).from.minute ==
                                  item.from.minute &&
                              globals.projects.elementAt(i).from.year ==
                                  item.from.year &&
                              globals.projects.elementAt(i).from.month ==
                                  item.from.month &&
                              globals.projects.elementAt(i).from.hour ==
                                  item.from.hour &&
                              globals.projects.elementAt(i).type == item.type &&
                              globals.projects.elementAt(i).allDay ==
                                  item.allDay &&
                              globals.projects.elementAt(i).page == item.page &&
                              globals.projects.elementAt(i).title ==
                                  item.title) {
                            globals.projects.removeAt(i);
                          }
                        }
                      }
                      if (globals.completedProjects.isNotEmpty) {
                        for (int i = 0;
                            i < globals.completedProjects.length;
                            i++) {
                          if (globals.completedProjects.elementAt(i).to.day ==
                                  item.to.day &&
                              globals.completedProjects.elementAt(i).to.month ==
                                  item.to.month &&
                              globals.completedProjects.elementAt(i).to.year ==
                                  item.to.year &&
                              globals.completedProjects.elementAt(i).to.hour ==
                                  item.to.hour &&
                              globals.completedProjects
                                      .elementAt(i)
                                      .to
                                      .minute ==
                                  item.to.minute &&
                              globals.completedProjects.elementAt(i).from.day ==
                                  item.from.day &&
                              globals.completedProjects
                                      .elementAt(i)
                                      .from
                                      .minute ==
                                  item.from.minute &&
                              globals.completedProjects
                                      .elementAt(i)
                                      .from
                                      .year ==
                                  item.from.year &&
                              globals.completedProjects
                                      .elementAt(i)
                                      .from
                                      .month ==
                                  item.from.month &&
                              globals.completedProjects
                                      .elementAt(i)
                                      .from
                                      .hour ==
                                  item.from.hour &&
                              globals.completedProjects.elementAt(i).type ==
                                  item.type &&
                              globals.completedProjects.elementAt(i).allDay ==
                                  item.allDay &&
                              globals.completedProjects.elementAt(i).page ==
                                  item.page &&
                              globals.completedProjects.elementAt(i).title ==
                                  item.title) {
                            globals.completedProjects.removeAt(i);
                          }
                        }
                      }
                    }

                    Navigator.pop(context);
                  },
                  child: const Text('Delete'),
                ),
              ],
            )).then((value) => setState(() {
          visibleButton = false;
        }));
    print('hey pauly watch me delete this project');
    Sync.sync(DateTime.now());
  }
}
