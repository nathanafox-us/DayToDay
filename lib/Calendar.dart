import 'package:day_to_day/Months.dart';
import 'package:day_to_day/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  State<CalendarWidget> createState() => CalendarState();
}

class CalendarState extends State<CalendarWidget> {
  //Creating month object to get data about what day it is
  Months n = Months();
  PageController pageController = PageController();
  String display = "";
  int clickedPosition = -1;

  @override
  void initState() {
    var equation = ((getCurrentYear() - 1980) * 12 + getCurrentMonth()) - 1;
    pageController = PageController(initialPage: equation);

    super.initState();
  }
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Months monthView;
    var systemColor = MediaQuery.of(context).platformBrightness;
    bool darkMode = systemColor == Brightness.dark;
    var days = {
      0: "Sun",
      1: "Mon",
      2: "Tues",
      3: "Wed",
      4: "Thu",
      5: "Fri",
      6: "Sat"
    };

    return Column(
      children: [
        Expanded(
          //Builds separate page for each month of every year since 1980
          child: PageView.builder(
            controller: pageController,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              int temporaryM = index;

              int yearsPassed = 1;
              if (index > 12) {
                temporaryM = (temporaryM % 12) + 1;
              }
              int userMonth = temporaryM;

              var yearEarly = 1980;
              yearsPassed = (index / 12).floor();
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
              monthIAmIn = n.month[temporaryM].toString();

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
                            padding: const EdgeInsets.only(bottom: 16, top: 10),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                monthIAmIn + ' ' + year,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
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
                                child: Text(CalendarState().getCurrentDay().toString()),
                              ),
                            ),
                          ),
                        padding: const EdgeInsets.only(left: 120, right: 15),
                      ),
                    ],
                    //mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),

                  Expanded(
                    //Builds grid of days based on number of days in month
                    child: GridView.builder(
                        itemCount: monthView.daysInMonth + mdw + 7,
                        scrollDirection: Axis.vertical,
                        physics: const ScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          childAspectRatio: 2 / 2,
                        ),
                        itemBuilder: (BuildContext context, int index) {

                          if (index < 7) {
                            Color colorB;
                            if (darkMode) {
                              colorB = Colors.black;
                            } else {
                              colorB = Colors.white;
                            }
                            return SizedBox(
                              height: 27,
                              child: Card(
                                elevation: 0,
                                color: colorB,
                                child: Text(
                                  days[index].toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                              ),
                            );
                          } else if (index >= 7) {
                            index -= 7;
                          }
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
                                    color: textColor, fontWeight: FontWeight.bold),
                              ),
                              maxRadius: 12,
                            );
                          }
                          if (clickedPosition - 2 == index -2) {
                            clickedColor = Colors.red[200]!;
                          }
                          else {
                            clickedColor =   Colors.white70;
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

                            return Align(
                              child: SizedBox(
                                height: 200,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: clickedColor, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(50),
                                    splashColor: Colors.deepOrangeAccent,
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Column(
                                        children: [
                                          textStyleToday,
                                        ],
                                      ),
                                    ),
                                    onTap: () => _tapDate(index),
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                  ),
                ],
              );
            },
          ),
        ),

      ],
    );
  }

  void _tapDate(int i) {
    setState(() {
      clickedPosition = i;
    });
    DatabaseReference _day = FirebaseDatabase.instance.ref().child("test");
    _day.set("Day tapped: ${i}");
    print(i);
  }

  void navigationPress(int month, int year, BuildContext context) {
    Navigator.pop(context);
    pageController.animateToPage(year * 12 + month,
        duration: Duration(seconds: 1), curve: Curves.easeIn);
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
      backgroundColor: Colors.blueGrey,
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
      pageController.animateToPage(((getCurrentYear() - 1980) * 12 + getCurrentMonth()) - 1,
          duration: const Duration(seconds: 2), curve: Curves.easeIn);
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
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  var firstYearRange = 1980 + ((year / 12).floor() * 12);
                  setState(() {
                    display = (firstYearRange.toString() + "-" +
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
                  if (month + 1 == getCurrentMonth() && year == getCurrentYear() - 1980) {
                    monthName = Colors.red[200]!;
                  }
                  else {
                    monthName = Colors.blueGrey;
                  }
                  return Container(
                    padding: EdgeInsets.all(5),
                    child: ElevatedButton(
                      child: Text(
                        n.getMonthShort(month + 1).toString(),
                        style: const TextStyle(fontSize: 13),
                      ),
                      onPressed: () =>
                          navigationPress(month, year, context),
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
