import 'dart:async';
import 'package:day_to_day/Inherited.dart';
import 'package:day_to_day/Months.dart';
import 'package:flutter/material.dart';
import 'Events.dart';
import 'globals.dart' as globals;
import 'package:firebase_database/firebase_database.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key, required this.stream}) : super(key: key);
  final Stream<bool> stream;

  @override
  State<CalendarWidget> createState() => CalendarState();
}

class CalendarState extends State<CalendarWidget> {
  //Creating month object to get data about what day it is
  Months n = Months();
  PageController pageController = PageController();
  String display = "";
  int clickedPosition = -1;
  List<Widget> dayClicked = [];

  @override
  void initState() {
    var equation = ((getCurrentYear() - 1980) * 12 + getCurrentMonth()) - 1;
    pageController = PageController(initialPage: equation);
    widget.stream.listen((event) {
      mySetStateAdd();
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void mySetStateAdd() {
    setState(() {
      clickedPosition = -1;
      dayClicked.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    Months monthView;
    var systemColor = MediaQuery.of(context).platformBrightness;
    bool darkMode = systemColor == Brightness.dark;

    return InheritedState(
      child: Column(
        children: [
          Expanded(
            //Builds separate page for each month of every year since 1980
            child: PageView.builder(
              controller: pageController,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int pages) {
                int temporaryM = pages;

                if (clickedPosition == -1) {
                  clickedPosition = getCurrentDay();
                  if (globals.events[getCurrentDay().toString() +
                          getCurrentMonth().toString() +
                          getCurrentYear().toString()] !=
                      null) {
                    globals.events[getCurrentDay().toString() +
                            getCurrentMonth().toString() +
                            getCurrentYear().toString()]
                        ?.forEach((element) {
                      dayClicked.add(Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: element.color),
                            height: 15,
                            width: 2,
                          ),
                          Padding(padding: EdgeInsets.only(right: 10)),
                          Text(
                            element.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ));
                      if (element.dayFrom == element.dayTo &&
                          element.monthFrom == element.monthTo &&
                          element.yearFrom == element.yearTo) {
                        dayClicked.add(Center(
                          child: Text(element.timeF + " - " + element.timeT),
                        ));
                      } else if (element.yearFrom == element.yearTo) {
                        dayClicked.add(Center(
                          child: Text(
                              Months().getMonthShort(element.monthFrom)! +
                                  " " +
                                  element.dayFrom.toString() +
                                  ", " +
                                  element.timeF +
                                  " - " +
                                  Months().getMonthShort(element.monthTo)! +
                                  " " +
                                  element.dayTo.toString() +
                                  ", " +
                                  element.timeT),
                        ));
                      } else {
                        dayClicked.add(Center(
                          child: Text(
                              Months().getMonthShort(element.monthFrom)! +
                                  " " +
                                  element.dayFrom.toString() +
                                  ", " +
                                  element.yearFrom.toString() +
                                  ", " +
                                  element.timeF +
                                  " - " +
                                  Months().getMonthShort(element.monthTo)! +
                                  " " +
                                  element.dayTo.toString() +
                                  ", " +
                                  element.yearTo.toString() +
                                  ", " +
                                  element.timeT),
                        ));
                      }
                    });
                  } else {
                    dayClicked.add(const Text("No events today"));
                  }
                }

                int yearsPassed = 1;
                if (pages > 12) {
                  temporaryM = (temporaryM % 12) + 1;
                }
                int userMonth = temporaryM;
                temporaryM = pages;

                var yearEarly = 1980;
                yearsPassed = (pages / 12).floor();
                int earlyYear = yearEarly + yearsPassed;
                String monthIAmIn = n.currentMonth;
                if (n.now.month == userMonth && n.now.year == earlyYear) {
                  monthView = n;
                } else {
                  monthView = Months.otherYears(userMonth, earlyYear);
                }
                int mdw = monthView.monthStart;
                if (monthView.monthStart == 7) {
                  mdw = 0;
                }
                monthIAmIn = n.month[userMonth].toString();

                String year = (yearEarly + yearsPassed).toString();

                if (getCurrentYear().toString() == year) {
                  year = "";
                }
                Color clickedColor = Colors.white70;
                pageController.addListener(() {
                  clickedPosition = -2;
                });
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Center(
                          child: InkWell(
                            child: Container(
                              padding:
                                  const EdgeInsets.only(bottom: 16, top: 10),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  monthIAmIn + ' ' + year,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                              ),
                            ),
                            onTap: () {
                              onYearPressed(context, pageController);
                            },
                            borderRadius: BorderRadius.circular(200),
                          ),
                        ),
                        Padding(
                          child: InkWell(
                            onTap: () => onFindMyDayPressed(),
                            splashColor: Colors.red[400]!,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Colors.red[400]!),
                                shape: BoxShape.circle,
                              ),
                              height: 25.0,
                              width: 25.0,
                              child: Center(
                                child: Text(
                                    CalendarState().getCurrentDay().toString()),
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.only(left: 120, right: 15),
                        ),
                      ],
                      //mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text(
                            "Sun",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text("Mon",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text("Tues",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text("Wed",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text("Thur",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text("Fri",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text("Sat",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      //Builds grid of days based on number of days in month
                      child: GridView.builder(
                          itemCount: monthView.daysInMonth + mdw,
                          scrollDirection: Axis.vertical,
                          physics: const ScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            childAspectRatio: 1 / 1.1,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            index += 1;
                            int day;
                            bool skip = false;
                            if (mdw != 0) {
                              day = index - monthView.monthStart;
                            } else {
                              day = index;
                              skip = true;
                            }
                            Color textColor;
                            Widget textStyleToday = Text((day).toString());

                            if ((day) == monthView.now.day &&
                                monthView.now.month == n.now.month &&
                                monthView.now.year == n.now.year) {
                              textColor = Colors.white;
                              textStyleToday = CircleAvatar(
                                backgroundColor: Colors.red[400]!,
                                child: Text(
                                  day.toString(),
                                  style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                maxRadius: 12,
                              );
                            }
                            if (clickedPosition == day) {
                              clickedColor = Colors.red[200]!;
                            } else {
                              clickedColor = Colors.white70;
                            }

                            int dayLetters = index - 1;

                            if (index <= monthView.monthStart && !skip) {
                              Color colorCard;
                              if (darkMode) {
                                colorCard = Colors.black;
                              } else {
                                colorCard = Colors.white;
                              }

                              return Card(
                                color: colorCard,
                                elevation: 0,
                              );
                            } else {
                              if (dayLetters >= 7) {
                                dayLetters = (dayLetters % 7);
                              }
                              var todayE = globals.events[day.toString() +
                                  userMonth.toString() +
                                  (yearEarly + yearsPassed).toString()];
                              List<Widget> dayInfo = [];
                              dayInfo.add(textStyleToday);
                              if (todayE != null) {
                                for (var element in todayE) {
                                  dayInfo.add(Container(
                                    padding: const EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: element.color),
                                    height: 2,
                                    width: 40,
                                  ));
                                }
                              }
                              if (globals.everyDay.isNotEmpty) {
                                for (var element in globals.everyDay) {
                                  if (temporaryM >= element.page) {
                                    if (element.yearFrom == (yearsPassed + yearEarly) && element.monthFrom == userMonth) {
                                      if (day >= element.dayFrom) {
                                        dayInfo.add(Container(
                                          padding: const EdgeInsets.only(top: 10),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: element.color),
                                          height: 2,
                                          width: 40,
                                        ));
                                      }
                                    }
                                    else {
                                      dayInfo.add(Container(
                                        padding: const EdgeInsets.only(top: 10),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: element.color),
                                        height: 2,
                                        width: 40,
                                      ));
                                    }
                                  }
                                }
                              }
                              if (globals.everyWeek.isNotEmpty) {

                                for (var element in globals.everyWeek) {
                                  if (temporaryM >= element.page) {
                                    DateTime wee = DateTime(yearEarly + yearsPassed, userMonth, day);
                                    if (wee.weekday == (element.weekDay)) {
                                      if (element.yearFrom == (yearsPassed + yearEarly) && element.monthFrom == userMonth) {
                                        if (day >= element.dayFrom) {
                                          dayInfo.add(Container(
                                            padding: const EdgeInsets.only(top: 10),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                color: element.color),
                                            height: 2,
                                            width: 40,
                                          ));
                                        }
                                      }
                                      else {
                                        dayInfo.add(Container(
                                          padding: const EdgeInsets.only(top: 10),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: element.color),
                                          height: 2,
                                          width: 40,
                                        ));
                                      }
                                    }
                                  }
                                }
                              }

                              if (globals.everyMonth.isNotEmpty) {

                                for (var element in globals.everyMonth) {
                                  if (day == element.dayFrom) {
                                    if (temporaryM >= element.page) {
                                          dayInfo.add(Container(
                                            padding: const EdgeInsets.only(top: 10),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                color: element.color),
                                            height: 2,
                                            width: 40,
                                          ));
                                    }

                                  }
                                }
                              }
                              if (globals.everyYear.isNotEmpty) {
                                for (var element in globals.everyYear) {
                                  if (day == element.dayFrom &&
                                      userMonth == element.monthFrom) {
                                    if (temporaryM >= element.page) {
                                          dayInfo.add(Container(
                                            padding: const EdgeInsets.only(top: 10),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                color: element.color),
                                            height: 2,
                                            width: 40,
                                          ));

                                    }
                                  }
                                }
                              }

                              return SizedBox(
                                height: 200,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: clickedColor, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(50),
                                    splashColor: Colors.deepOrangeAccent,
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: dayInfo,
                                      ),
                                    ),
                                    onTap: () => _tapDate(day,
                                        yearEarly + yearsPassed, userMonth, temporaryM),
                                  ),
                                ),
                              );
                            }
                          }),
                    ),
                    Expanded(
                        flex: 1,
                        child: ListView(
                          children: [
                            Column(
                              children: dayClicked,
                            ),
                          ],
                        )),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _tapDate(int day, int year, int month, int page) {
    dayClicked.clear();

    setState(() {
      clickedPosition = day;
    });
    List<Events> temp;
    if (globals.events[day.toString() + month.toString() + year.toString()] != null) {
      temp = (globals.events[day.toString() + month.toString() + year.toString()])!;
    }
    else {
      temp = [];
    }

    if (globals.everyDay.isNotEmpty) {
      for (var element in globals.everyDay) {
        if (page >= element.page) {
          if (element.yearFrom == year && element.monthFrom == month) {
            if (day >= element.dayFrom) {
              temp.add(element);
            }
          }
          else {
            temp.add(element);
          }
        }
      }
    }
    if (globals.everyWeek.isNotEmpty) {
      for (var element in globals.everyWeek) {
        DateTime wee = DateTime(year, month, day);
        if (wee.weekday == (element.weekDay)) {
          if (page >= element.page) {
            if (element.yearFrom == year && element.monthFrom == month) {
              if (day >= element.dayFrom) {
                temp.add(element);
              }
            }
            else {
              temp.add(element);
            }
          }
        }
      }
    }
    if (globals.everyMonth.isNotEmpty) {
      for (var element in globals.everyMonth) {
        if (day == element.dayFrom) {

          if (page >= element.page) {
            if (element.yearFrom == year && element.monthFrom == month) {
              if (day >= element.dayFrom) {
                temp.add(element);
              }
            }
            else {
              temp.add(element);
            }
          }
        }
      }
    }
    if (globals.everyYear.isNotEmpty) {
      for (var element in globals.everyYear) {
        if (day == element.dayFrom && month == element.monthFrom) {
          if (page >= element.page) {
            if (element.yearFrom == year && element.monthFrom == month) {
              if (day >= element.dayFrom) {
                temp.add(element);
              }
            }
            else {
              temp.add(element);
            }
          }

        }
      }
    }
    if (temp.isNotEmpty) {
      temp.forEach((element) {
        dayClicked.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: element.color),
              height: 15,
              width: 2,
            ),
            const Padding(padding: EdgeInsets.only(right: 10)),
            Text(
              element.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ));
        if (element.dayFrom == element.dayTo &&
            element.monthFrom == element.monthTo &&
            element.yearFrom == element.yearTo) {
          if (element.allDay) {
            dayClicked.add(const Center(
              child: Text("All day"),
            ));
          } else {
            dayClicked.add(Center(
              child: Text(element.timeF + " - " + element.timeT),
            ));
          }
        } else if (element.yearFrom == element.yearTo) {
          if (element.allDay) {
            dayClicked.add(Center(
              child: Text(Months().getMonthShort(element.monthFrom)! +
                  " " +
                  element.dayFrom.toString() +
                  " - " +
                  Months().getMonthShort(element.monthTo)! +
                  " " +
                  element.dayTo.toString()),
            ));
          } else {
            dayClicked.add(Center(
              child: Text(Months().getMonthShort(element.monthFrom)! +
                  " " +
                  element.dayFrom.toString() +
                  ", " +
                  element.timeF +
                  " - " +
                  Months().getMonthShort(element.monthTo)! +
                  " " +
                  element.dayTo.toString() +
                  ", " +
                  element.timeT),
            ));
          }
        } else {
          if (element.allDay) {
            dayClicked.add(Center(
              child: Text(Months().getMonthShort(element.monthFrom)! +
                  " " +
                  element.dayFrom.toString() +
                  ", " +
                  element.yearFrom.toString() +
                  " - " +
                  Months().getMonthShort(element.monthTo)! +
                  " " +
                  element.dayTo.toString() +
                  ", " +
                  element.yearTo.toString()),
            ));
          } else {
            dayClicked.add(Center(
              child: Text(Months().getMonthShort(element.monthFrom)! +
                  " " +
                  element.dayFrom.toString() +
                  ", " +
                  element.yearFrom.toString() +
                  ", " +
                  element.timeF +
                  " - " +
                  Months().getMonthShort(element.monthTo)! +
                  " " +
                  element.dayTo.toString() +
                  ", " +
                  element.yearTo.toString() +
                  ", " +
                  element.timeT),
            ));
          }
        }
      });
    } else {
      dayClicked.add(const Text("No events today"));
    }
    final access = StateWidget.of(context);
    access?.updateClicked(day, year, month);
    DatabaseReference _day = FirebaseDatabase.instance.ref().child("test");
    _day.set("Day tapped: ${day}");
    print(day);
  }

  void navigationPress(int month, int year, BuildContext context) {
    Navigator.pop(context);
    pageController.animateToPage(year * 12 + month,
        duration: const Duration(seconds: 1), curve: Curves.easeIn);
  }

  int getCurrentMonth() {
    return n.now.month;
  }

  int getCurrentDay() {
    return n.now.day;
  }

  int getCurrentYear() {
    return n.now.year;
  }

  int getClicked() {
    return clickedPosition;
  }

  void onYearPressed(BuildContext context, PageController pageController) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.black,
      builder: (BuildContext context) {
        return SizedBox(
          child: selectMonth(context, pageController),
          height: 200,
          width: 200,
        );
      },
    );
  }

  void onFindMyDayPressed() {
    if (pageController.hasClients) {
      pageController.animateToPage(
          ((getCurrentYear() - 1980) * 12 + getCurrentMonth()) - 1,
          duration: const Duration(seconds: 2),
          curve: Curves.easeIn);
    }
  }

  Widget selectMonth(BuildContext context, PageController pageController) {
    int equation = getCurrentYear() - 1980;

    PageController selectionController = PageController(
      initialPage: equation,
    );
    return PageView.builder(
        scrollDirection: Axis.horizontal,
        controller: selectionController,
        itemBuilder: (BuildContext context, int year) {
          var displayYear = (1980 + year).toString();
          display = displayYear;
          return Column(
            children: [
              InkWell(
                child: Text(
                  display,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  var firstYearRange = 1980 + ((year / 12).floor() * 12);
                  setState(() {
                    display = (firstYearRange.toString() +
                        "-" +
                        (firstYearRange + 12).toString());
                    print(display);
                  });
                },
              ),
              Expanded(
                  child: GridView.builder(
                itemCount: 12,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                ),
                itemBuilder: (BuildContext context, int month) {
                  Color monthName;
                  if (month + 1 == getCurrentMonth() &&
                      year == getCurrentYear() - 1980) {
                    monthName = Colors.red[200]!;
                  } else {
                    monthName = Colors.grey[800]!;
                  }
                  return Container(
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      child: Text(
                        n.getMonthShort(month + 1).toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                      onPressed: () => navigationPress(month, year, context),
                      style: ElevatedButton.styleFrom(
                        primary: monthName,
                        side: const BorderSide(width: 1.0, color: Colors.red),
                        shape: const CircleBorder(),
                      ),
                    ),
                  );
                },
              )),
            ],
          );
        });
  }
}
