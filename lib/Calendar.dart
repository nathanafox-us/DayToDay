import 'package:day_to_day/Months.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';



class Calendar {
  
  Months n = Months();

  Widget calendarWidget(PageController pageController, BuildContext context) {
    var systemColor = MediaQuery
        .of(context)
        .platformBrightness;
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

    Months monthView;

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: pageController,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              int temporaryM = index;

              int yearsPassed = 1;
              if (index > 12) {
                //print(index.toString() + " test");
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

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding:
                        const EdgeInsets.only(bottom: 16, right: 12, top: 10),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            monthIAmIn,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                        ),
                      ),
                      InkWell(
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 16, top: 10),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              (yearEarly + yearsPassed).toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                          ),
                        ),
                        onTap: () => onYearPressed(context),
                        borderRadius: BorderRadius.circular(200),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  Expanded(
                    child: GridView.builder(
                        itemCount: monthView.daysInMonth + mdw + 7,
                        scrollDirection: Axis.vertical,
                        physics: const ScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(

                            crossAxisCount: 7,
                            childAspectRatio: 2/2,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          if (index < 7) {
                            Color colorB;
                            if (darkMode) {
                              colorB = Colors.black;
                            }
                            else {
                              colorB = Colors.white;
                            }
                            return SizedBox(
                              height: 27,
                              child: Card(
                                elevation: 0,
                                color: colorB,
                                child: Text(days[index].toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),),
                              ),
                            );
                          }
                          else if (index >= 7) {
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
                                style: TextStyle(color: textColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              maxRadius: 12,
                            );
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
                                  child: InkWell(
                                    splashColor: Colors.deepOrangeAccent,
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Column(children: [
                                        textStyleToday,
                                      ],),
                                    ),
                                    onTap: () => _tapDate(day),
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
  void onYearPressed(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.blueGrey,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('Modal BottomSheet'),
                  ElevatedButton(
                    child: const Text('Close BottomSheet'),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
  void _tapDate(int i) {
    DatabaseReference _day = FirebaseDatabase.instance.ref().child("test");
    _day.set("Day tapped: ${i}");
    print(i);
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
}