import 'dart:async';
import 'package:flutter/material.dart';
import 'event_form.dart';
import 'globals.dart' as globals;
import 'events.dart';
import 'globals.dart';
import 'user_sync.dart';

class ExamsWidget extends StatefulWidget {
  ExamsWidget({Key? key, required this.stream}) : super(key: key);
  final Stream<bool> stream;

  @override
  State<ExamsWidget> createState() => ExamsState();
}

class ExamsState extends State<ExamsWidget> {
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
    if (globals.completedExams.isNotEmpty) {
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
        title: const Center(child: Text("Exams List")),
        backgroundColor: const Color.fromARGB(255, 255, 82, 82),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: exams.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    child: GestureDetector(
                  onLongPress: () => delete(exams[index]),
                  child: CheckboxListTile(
                      dense: true,
                      activeColor: Colors.red[400],
                      controlAffinity: ListTileControlAffinity.leading,
                      value: false,
                      onChanged: (value) {
                        setState(() {
                          globals.completedExams.add(globals.exams[index]);
                          exams.removeAt(index);
                          globals.timestamp = DateTime.now();
                          if (globals.completedExams.isNotEmpty) {
                            visibleButton = true;
                          }
                        });
                      },
                      title: Text(exams[index].title,
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
                itemCount: globals.completedExams.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: GestureDetector(
                    onLongPress: () => delete(globals.completedExams[index]),
                    child: CheckboxListTile(
                        dense: true,
                        activeColor: Colors.red[400],
                        controlAffinity: ListTileControlAffinity.leading,
                        value: true,
                        onChanged: (value) {
                          setState(() {
                            exams.add(globals.completedExams[index]);
                            globals.completedExams.removeAt(index);
                            globals.timestamp = DateTime.now();
                            if (globals.completedExams.isEmpty) {
                              visibleButton = false;
                            }
                          });
                        },
                        title: Text(
                            globals.completedExams[index].title +
                                "          " +
                                globals.completedExams[index].to.day
                                    .toString() +
                                "/" +
                                globals.completedExams[index].to.month
                                    .toString() +
                                "/" +
                                globals.completedExams[index].to.year
                                    .toString(),
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
                      if (globals.exams.isNotEmpty) {
                        for (int i = 0; i < globals.exams.length; i++) {
                          if (globals.exams.elementAt(i).to.day ==
                                  item.to.day &&
                              globals.exams.elementAt(i).to.month ==
                                  item.to.month &&
                              globals.exams.elementAt(i).to.year ==
                                  item.to.year &&
                              globals.exams.elementAt(i).to.hour ==
                                  item.to.hour &&
                              globals.exams.elementAt(i).to.minute ==
                                  item.to.minute &&
                              globals.exams.elementAt(i).from.day ==
                                  item.from.day &&
                              globals.exams.elementAt(i).from.minute ==
                                  item.from.minute &&
                              globals.exams.elementAt(i).from.year ==
                                  item.from.year &&
                              globals.exams.elementAt(i).from.month ==
                                  item.from.month &&
                              globals.exams.elementAt(i).from.hour ==
                                  item.from.hour &&
                              globals.exams.elementAt(i).type == item.type &&
                              globals.exams.elementAt(i).allDay ==
                                  item.allDay &&
                              globals.exams.elementAt(i).page == item.page &&
                              globals.exams.elementAt(i).title == item.title) {
                            globals.exams.removeAt(i);
                          }
                        }
                      }
                      if (globals.completedExams.isNotEmpty) {
                        for (int i = 0;
                            i < globals.completedExams.length;
                            i++) {
                          if (globals.completedExams.elementAt(i).to.day ==
                                  item.to.day &&
                              globals.completedExams.elementAt(i).to.month ==
                                  item.to.month &&
                              globals.completedExams.elementAt(i).to.year ==
                                  item.to.year &&
                              globals.completedExams.elementAt(i).to.hour ==
                                  item.to.hour &&
                              globals.completedExams.elementAt(i).to.minute ==
                                  item.to.minute &&
                              globals.completedExams.elementAt(i).from.day ==
                                  item.from.day &&
                              globals.completedExams.elementAt(i).from.minute ==
                                  item.from.minute &&
                              globals.completedExams.elementAt(i).from.year ==
                                  item.from.year &&
                              globals.completedExams.elementAt(i).from.month ==
                                  item.from.month &&
                              globals.completedExams.elementAt(i).from.hour ==
                                  item.from.hour &&
                              globals.completedExams.elementAt(i).type ==
                                  item.type &&
                              globals.completedExams.elementAt(i).allDay ==
                                  item.allDay &&
                              globals.completedExams.elementAt(i).page ==
                                  item.page &&
                              globals.completedExams.elementAt(i).title ==
                                  item.title) {
                            globals.completedExams.removeAt(i);
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
    print('ayyyy im syncin exams hea');
    Sync.sync(DateTime.now());
  }
}
