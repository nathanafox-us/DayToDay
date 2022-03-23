import 'package:day_to_day/Months.dart';
import 'package:day_to_day/ToDoList.dart';
import 'package:day_to_day/ToDoListDirectory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

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
    var systemColor = MediaQuery.of(context).platformBrightness;
    bool darkMode = systemColor == Brightness.dark;
    Color labelColorChange;
    final PageController controller = PageController(initialPage: n.now.month);

    if (darkMode) {
      labelColorChange = Colors.red[400]!;
    } else {
      labelColorChange = Colors.red[400]!;
    }
    String monthIAmIn = n.currentMonth;
    return Scaffold(
      appBar: AppBar(
        title: const Text('DayToDay'),
        //backgroundColor: Colors.black,
        bottom: TabBar(
          indicatorColor: Colors.red[400]!,
          labelColor: labelColorChange,
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
          PageView.builder(
            controller: controller,
            itemBuilder: (BuildContext context, int index) {
              int temporaryM = index;
              while (temporaryM >= 12) {
                temporaryM -= 11;
              }
              monthIAmIn = n.month[temporaryM].toString();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        monthIAmIn,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                    ),
                  ),
                  calendarWidget(index),
                ],
              );
            },
          ),
          ToDoListDirectory(),
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

  Widget calendarWidget(int userMonth) {
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

    Months monthView;
    if (n.now.month == userMonth) {
      monthView = n;
    } else {
      monthView = Months.otherYears(userMonth, n.now.year);
    }

    return Expanded(
      child: GridView.builder(
          itemCount: monthView.daysInMonth + monthView.monthStart,
          scrollDirection: Axis.vertical,
          physics: const ScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
          ),
          itemBuilder: (BuildContext context, int index) {
            var day = index + 1 - monthView.monthStart;
            Color textColor;
            Widget textStyleToday = Text(day.toString());

            if (day == monthView.now.day &&
                monthView.now.month == n.now.month) {
              textColor = Colors.white;
              textStyleToday = CircleAvatar(
                backgroundColor: Colors.red[400]!,
                child: Text(
                  day.toString(),
                  style: TextStyle(color: textColor),
                ),
                maxRadius: 12,
              );
            }

            if (index < monthView.monthStart) {
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
              while (index >= 7) {
                index = index - 7;
              }
              return Card(
                child: InkWell(
                  splashColor: Colors.deepOrangeAccent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      textStyleToday,
                      Text(
                        days[index].toString(),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  onTap: () => _tapDate(day),
                ),
              );
            }
          }),
    );
  }

  void _tapDate(int i) {
    DatabaseReference _day = FirebaseDatabase.instance.ref().child("test");
    _day.set("Day tapped: ${i}");
    print(i);
  }
}
