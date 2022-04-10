import 'package:day_to_day/inherited.dart';
import 'package:day_to_day/months.dart';
import 'package:day_to_day/main.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class EventForm extends StatefulWidget {
  const EventForm({Key? key}) : super(key: key);

  @override
  EventFormState createState() => EventFormState();
}
enum SingingCharacter {daily,weekly, monthly, yearly, none}

class EventFormState extends State<EventForm> {
  var events = {};
  bool isSwitched = false;
  TextEditingController titleController = TextEditingController();
  var weekdays = {
    1: "Mon",
    2: "Tue",
    3: "Wed",
    4: "Thu",
    5: "Fri",
    6: "Sat",
    7: "Sun"
  };
  SingingCharacter? repeatingChoose = SingingCharacter.none;

  String? from;
  String? to;
  Months n = Months();
  DateTime selectedTime = DateTime(2020);
  DateTime? selectedTimeTo;
  bool chosenFrom = false;
  bool chosenTFrom = false;
  String timeFrom = "";
  String? selectedHour;
  String finalTimeFrom = "";
  bool chosenTo = false;
  bool chosenTTo = false;
  String timeTo= "";
  String? selectedHourTo;
  String finalTimeTo = "";
  String repeatD = "Don't repeat";
  Color colorChosenBubble = Colors.red[200]!;
  String colorChosenText = "Default";
  TimeOfDay fromObj = TimeOfDay.now();
  TimeOfDay toObj = TimeOfDay.now();
  int hourF = 0;
  int minuteF = 0;
  int minuteT = 0;
  int hourT = 0;

  @override
  Widget build(BuildContext context) {
    String to;
    String title = "Default Event";
    int dayF = (StateWidget.of(context)?.clicked)!;
    int weekDayN;
    int hour = n.now.hour;
    int minute = n.now.minute;
    String? weekD;
    bool pastSixty = false;
    if (dayF == -2 && !chosenFrom) {
      selectedTime = n.now;
    } else if (!chosenFrom) {
      selectedTime = DateTime(
          (StateWidget.of(context)?.yearFrom)!,
          (StateWidget.of(context)?.monthFrom)!,
          (StateWidget.of(context)?.clicked)!);
    }
    if (minute % 10 != 0) {
      if (10 - (minute % 10) <= 5) {
        minute += 10 - (minute % 10) + 5;
      } else {
        minute += 10 - (minute % 10);
      }
    }
    if (minute >= 60) {
      hour += 1;
      if (hour == 24) {
        hour == 0;
      }
      else if (hour == 25) {
        hour = 1;
      }
      pastSixty = true;
      minute = 0;
    }

    if (!chosenTFrom && !isSwitched) {
      String minuteStr = minute.toString();
      if (minute == 0) {
        minuteStr = minuteStr.toString() + "0";
      }

      if (hour > 12) {
        hour %= 12;
        timeFrom = hour.toString() + ":" + minuteStr + " PM";
      } else if (hour == 12) {
        timeFrom = hour.toString() + ":" + minuteStr + " PM";
      } else {
        if (hour == 0) {
          hour = 12;
        }
        timeFrom = hour.toString() + ":" + minuteStr + " AM";
      }
      finalTimeFrom = timeFrom;
      hourF = hour;
      minuteF = minute;
    }
    if (!chosenTTo && !isSwitched) {
      hour = n.now.hour;
      hour += 1;
      if (pastSixty) {
        hour += 1;
      }
      String minuteStr = minute.toString();
      if (minute == 0) {
        minuteStr = minuteStr.toString() + "0";
      }
      if (hour > 12) {
        hour %= 12;
        timeTo = hour.toString() + ":" + minuteStr + " PM";
      } else if (hour == 12) {
        timeTo = hour.toString() + ":" + minuteStr + " PM";
      } else {
        if (hour == 0) {
          hour = 12;
        }
        timeTo = hour.toString() + ":" + minuteStr + " AM";
      }
      finalTimeTo = timeTo;
      hourT = hour;
      minuteT = minute;
    }

    weekDayN = selectedTime.weekday;
    weekD = weekdays[weekDayN];
    from = weekD! +
        ", " +
        n.monthShort[selectedTime.month]! +
        " " +
        (selectedTime.day.toString()) +
        ", " +
        (selectedTime.year.toString());
    if (chosenTo) {
      to = weekdays[selectedTimeTo?.weekday]! +
          ", " +
          n.monthShort[selectedTimeTo?.month]! +
          " " +
          (selectedTimeTo?.day.toString())! +
          ", " +
          (selectedTimeTo?.year.toString())!;
    }
    else {
      to = weekD+
          ", " +
          n.monthShort[selectedTime.month]! +
          " " +
          (selectedTime.day.toString()) +
          ", " +
          (selectedTime.year.toString());
    }


    return InheritedState(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  top: 50, bottom: 12, left: 15, right: 20),
              child: TextFormField(
                autofocus: true,
                controller: titleController,
                maxLength: 50,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Add Event Title',
                ),
                onChanged: (value) {
                  title = value;
                },
              ),
            ),
            const Divider(color: Colors.grey,),
            InkWell(
              child: Row(
                children: [
                  const Padding(padding: EdgeInsets.only(left: 20)),
                  const ImageIcon(
                    AssetImage("assets/icons/clock.png"),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 26),
                    child: Text(
                      "All Day",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const Spacer(),
                  Switch(value: isSwitched, onChanged: onToggled),
                ],
              ),
              onTap: () => onToggled(true),
            ),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 70),
                  child: InkWell(
                    child: Text(
                      from!,
                      style: const TextStyle(fontSize: 20),
                    ),
                    onTap: () => chooseFromDay(context, selectedTime, true),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: InkWell(
                    child: Text(
                      finalTimeFrom,
                      style: const TextStyle(fontSize: 20),
                    ),
                    onTap: () => chooseFromTime(context, true),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 70),
                    child: InkWell(
                      child: Text(
                        to,
                        style: const TextStyle(fontSize: 20),
                      ),
                      onTap: () => chooseFromDay(context, selectedTime, false),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: InkWell(
                      child: Text(
                        finalTimeTo,
                        style: const TextStyle(fontSize: 20),
                      ),
                      onTap: () => chooseFromTime(context, false),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  [
                  const Padding(padding: EdgeInsets.only(left: 20)),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 17),
                    child: ImageIcon(
                      AssetImage("assets/icons/repeat.png"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: SizedBox(
                      child: Text(
                        repeatD,
                        style: const TextStyle(fontSize: 20),
                      ),
                      height: 45,
                    ),
                  ),
                ],
              ),
              onTap: () {
                onRepeat();
              },
            ),
            const Divider(color: Colors.grey,),
            InkWell(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  [
                  const Padding(padding: EdgeInsets.only(left: 20)),
                  Container(
                    decoration: BoxDecoration(
                      color: colorChosenBubble,
                      shape: BoxShape.circle,
                    ),
                    height: 45.0,
                    width: 25.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Text(
                      colorChosenText,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              onTap: () {
                onColor();
              },
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Align(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(fontSize: 25, color: Colors.red[200]),
                    ),
                  ),
                  alignment: Alignment.bottomCenter,
                ),
                TextButton(
                  onPressed: () {
                    //print(title);
                    if (selectedTimeTo != null) {
                      StateWidget.of(context)?.addEvent(selectedTime.day, selectedTime.year, selectedTime.month, title,
                          finalTimeFrom, finalTimeTo, (selectedTimeTo?.day)!, (selectedTimeTo?.month)!, (selectedTimeTo?.year)!, colorChosenBubble, toObj, fromObj, isSwitched, repeatD,
                          (selectedTime.year - 1980) * 12 + selectedTime.month - 1, hourF, hourT, minuteF, minuteT);
                    }
                    else {
                      StateWidget.of(context)?.addEvent(selectedTime.day, selectedTime.year, selectedTime.month, title,
                          finalTimeFrom, finalTimeTo, selectedTime.day, selectedTime.month,
                          selectedTime.year, colorChosenBubble, toObj, fromObj, isSwitched, repeatD, (selectedTime.year - 1980) * 12 + selectedTime.month - 1, hourF, hourT, minuteF, minuteT);
                    }
                    streamController.add(true);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: 25, color: Colors.red[200]),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void onToggled(bool state) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        finalTimeFrom = "";
        finalTimeTo = "";
      });
    } else if (isSwitched == true) {
      setState(() {
        finalTimeFrom = timeFrom;
        finalTimeTo = timeTo;
        isSwitched = false;
      });
    }
  }

  Future<void> chooseFromDay(
      BuildContext context, DateTime current, bool fromChoose) async {
    DateTime? userChosenFrom = (await showDatePicker(
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(
            primary: Colors.red[200]!,
            onPrimary: Colors.white,
            onSurface: Colors.white,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              primary: Colors.red[200],
            ),
          ),
        ), child: child!,
        )},
        context: context,
        initialDate: current,
        firstDate: DateTime(1980, 1),
        lastDate: DateTime(2222)))!;
    if (fromChoose) {
      if (userChosenFrom != current) {
        chosenFrom = true;
        setState(() {
          selectedTime = userChosenFrom;

        });
      }
    } else {
      chosenTo = true;
      setState(() {
        selectedTimeTo = userChosenFrom;
      });

    }

  }

  Future<void> chooseFromTime(BuildContext context, bool fromChoose) async {
    if (fromChoose) {
      TimeOfDay? userChosenTimeFrom = (await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      ));
      if (userChosenTimeFrom != null) {
        chosenTFrom = true;
        fromObj = userChosenTimeFrom;
        hourF = userChosenTimeFrom.hour;
        minuteF = userChosenTimeFrom.minute;

        setState(() {
          timeFrom = userChosenTimeFrom.format(context);
          finalTimeFrom = userChosenTimeFrom.format(context);
        });
      }
    } else {
      TimeOfDay? userChosenTimeTo = (await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
            hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute),
      ));
      if (userChosenTimeTo != null) {
        chosenTTo = true;
        toObj = userChosenTimeTo;
        minuteT = userChosenTimeTo.minute;
        hourT = userChosenTimeTo.hour;
        setState(() {
          timeTo = userChosenTimeTo.format(context);
          finalTimeTo = userChosenTimeTo.format(context);
        });
      }
    }
  }

  void onRepeat() {

      showDialog(context: context, builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              elevation: 20,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              child: SizedBox(
                height: 300,
                child:  Column(
                  children: [
                    RadioListTile(
                        title: const Text("Don't Repeat"),
                        value: SingingCharacter.none,
                        groupValue: repeatingChoose,
                        onChanged: (SingingCharacter? value) {
                          Navigator.pop(context, true);
                          setState(() {
                            repeatD = "Don't Repeat";
                            repeatingChoose = value;
                          });
                        }
                    ),
                    RadioListTile(
                        title: const Text("Everyday"),
                        value: SingingCharacter.daily,
                        groupValue: repeatingChoose,
                        onChanged: (SingingCharacter? value) {
                          Navigator.pop(context, true);
                          setState(() {
                            repeatD = "Everyday";
                            repeatingChoose = value;
                          });
                        }
                    ),
                    RadioListTile(
                        title: const Text("Every week"),
                        value: SingingCharacter.weekly,
                        groupValue: repeatingChoose,
                        onChanged: (SingingCharacter? value) {
                          Navigator.pop(context, true);
                          setState(() {
                            repeatD = "Every week";
                            repeatingChoose = value;
                          });
                        }
                    ),
                    RadioListTile(
                        title: const Text("Every month"),
                        value: SingingCharacter.monthly,
                        groupValue: repeatingChoose,
                        onChanged: (SingingCharacter? value) {
                          Navigator.pop(context,true);
                          setState(() {
                            repeatD = "Every month";
                            repeatingChoose = value;
                          });
                        }
                    ),
                    RadioListTile(
                        title: const Text("Every year"),
                        value: SingingCharacter.yearly,
                        groupValue: repeatingChoose,
                        onChanged: (SingingCharacter? value) {
                          Navigator.pop(context, true);

                          setState(() {
                            repeatD = "Every year";
                            repeatingChoose = value;
                          });
                        }
                    ),

                  ],
                ),
              )
            );
          });

      }).then((value) {
        setState(() {

        });
      });
  }

  void onColor() {
    showDialog(context: context, builder: (context) {
      return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
                elevation: 20,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                child: SizedBox(
                  height: 300,
                  child:  Column(
                    children: [
                      chooseColor(Colors.red, "Red"),
                      chooseColor(Colors.green, "Green"),
                      chooseColor(Colors.blue, "Blue"),
                      chooseColor(Colors.yellow, "Yellow"),
                      chooseColor(Colors.orange, "Orange"),
                      chooseColor(Colors.red[200]!, "Default"),

                    ],
                  ),
                )
            );
          });

    }).then((value) {
      setState(() {

      });
    });
  }
  Widget chooseColor(Color color, String text) {
    return
      Padding(
        padding: const EdgeInsets.only(left: 20),
        child: InkWell(
          onTap: () {
            Navigator.pop(context, true);
            setState(() {
              colorChosenBubble = color;
              colorChosenText = text;
            });
          },
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                height: 45.0,
                width: 25.0,
                padding: const EdgeInsets.only(right: 50),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(text,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
