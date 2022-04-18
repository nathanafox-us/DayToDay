import 'package:flutter/material.dart';
import 'event_form.dart';
import 'globals.dart' as globals;
import 'events.dart';
import 'globals.dart';

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
                    child: CheckboxListTile(
                        dense: true,
                        activeColor: Colors.red[400],
                        controlAffinity: ListTileControlAffinity.leading,
                        value: false,
                        onChanged: (value) {
                          setState(() {
                            globals.completedExams.add(globals.exams[index]);
                            exams.removeAt(index);
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
                itemCount: globals.completedExams.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: CheckboxListTile(
                          dense: true,
                          activeColor: Colors.red[400],
                          controlAffinity: ListTileControlAffinity.leading,
                          value: true,
                          onChanged: (value) {
                            setState(() {
                              exams.add(globals.completedExams[index]);
                              globals.completedExams.removeAt(index);
                              if (globals.completedExams.isEmpty) {
                                visibleButton = false;
                              }
                            });
                          },
                          title: Text(globals.completedExams[index].title + "          " + globals.completedExams[index].to.day.toString() + "/" + globals.completedExams[index].to.month.toString() + "/" + globals.completedExams[index].to.year.toString(),
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
