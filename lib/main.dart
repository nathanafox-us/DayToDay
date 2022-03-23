import 'package:day_to_day/Months.dart';
import 'package:day_to_day/to_do_list_directory_widget.dart';
import 'package:day_to_day/to_do_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/painting.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DayToDay());
}

class DayToDay extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  DayToDay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "DayToDay",
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,

        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
        scaffoldBackgroundColor: Colors.black,
      ),
      themeMode: ThemeMode.system,
      /* ThemeMode.system to follow system theme,
         ThemeMode.light for light theme,
         ThemeMode.dark for dark theme
      */
      //home: const MyStatefulWidget(),
      home: FutureBuilder(
        future: _fbApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('You have an error! ${snapshot.error.toString()}');
            return Text('Something went wrong!');
          } else if (snapshot.hasData) {
            return const MyStatefulWidget();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  Months n = Months();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var systemColor = MediaQuery
        .of(context)
        .platformBrightness;
    bool darkMode = systemColor == Brightness.dark;
    Color labelColorChange;
    PageController pageController = PageController(
      initialPage: ((n.now.year - 1980) * 12 + n.now.month) - 1,
    );
    var equation = ((n.now.year - 1980) * 12 + n.now.month) - 1;

    if (darkMode) {
      labelColorChange = Colors.red[400]!;
    } else {
      labelColorChange = Colors.red[400]!;
    }

    return Scaffold(
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Ex1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Ex2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        //backgroundColor: Colors.red[400]!,
        title: const Text('DayToDay'),
        //backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () => onSearchButtonPressed(),
            icon: Image.asset(
              "assets/icons/search-icon.png",
            ),
            splashRadius: 20,
          ),

          InkWell(
            onTap: () => onFindMyDayPressed(equation, pageController),
            splashColor: Colors.red[400]!,
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(200),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.red[400]!),
                shape: BoxShape.circle,
              ),
              height: 10.0,
              width: 25.0,
              child: Center(
                child: Text(n.now.day.toString()),
              ),
            ),
          ),
          /*IconButton(
            onPressed: () => onFindMyDayPressed(equation, pageController),
            icon: Image.asset(
              "assets/icons/find-the-day.png",
            ),
            splashRadius: 20,
          ),*/
        ],
        bottom: TabBar(
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: <Widget>[
            Tab(
              text: "Calendar",

              icon: Image.asset(
                'assets/icons/icons8-calendar-48.png',
                scale: 2,
              ),

              //icon: ImageIcon(
              //  AssetImage("assets/icons/icons8-calendar-48.png"),
              //  size: 24,
              //),
            ),
            const Tab(
              text: "To-do",
            ),
            const Tab(
              text: "Projects",
            ),
            const Tab(
              text: "Homework",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          calendarWidget(pageController),
          ToDoListDirectoryWidget(),
          Center(
            child: Text("To do"),
          ),
          Center(
            child: Text("Projects"),
          ),
          Center(
            child: Text("HW"),
          )
        ],
      ),
    );
  }

  Widget calendarWidget(PageController pageController) {
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
                        onTap: onYearPressed,
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

  void _tapDate(int i) {
    DatabaseReference _day = FirebaseDatabase.instance.ref().child("test");
    _day.set("Day tapped: ${i}");
    print(i);
  }

  void onFindMyDayPressed(int i, PageController controller) {
    controller.animateToPage(i,
        duration: const Duration(seconds: 2), curve: Curves.ease);
  }

  void onSearchButtonPressed() {}

  void onYearPressed() {
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
}