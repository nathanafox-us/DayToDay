import 'package:flutter/material.dart';

void main() {
  runApp(const DayToDay());
}

class DayToDay extends StatelessWidget {
  const DayToDay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "DayToDay",
      theme: ThemeData(
        brightness: Brightness.light,
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
      home: const MyStatefulWidget(),
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
    with TickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @mustCallSuper
  @override
  Widget build(BuildContext context) {
    var systemColor = MediaQuery.of(context).platformBrightness;
    bool darkMode = systemColor == Brightness.dark;
    Color labelColorChange;

    if (darkMode) {
      labelColorChange = Colors.blueAccent;
    }
    else {
      labelColorChange = Colors.deepOrangeAccent;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('DayToDay'),
        //backgroundColor: Colors.black,
        bottom: TabBar(
          indicatorColor: Colors.blue,
          labelColor: labelColorChange,
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: <Widget>[
            Tab(
              text: "Calendar",

              icon: Image.asset('icons/icons8-calendar-48.png', scale: 2,),

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
          Center(
            child: calendarWidget(),

          ),
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

  //Keeps state of each tab, in other words doesnt reset tab once you change tabs, i think

  Column calendarWidget() {
    DateTime f = DateTime.now();
    var months = {
      1:"January",
      2:"February",
      3:"March",
      4:"April",
      5:"May",
      6:"June",
      7:"July",
      8:"August",
      9:"September",
      10:"October",
      11:"November",
      12:"December"};
    var days = {
      1:"Sun",
      2:"Mon",
      3:"Tues",
      4:"Wed",
      5:"Thu",
      6:"Fri",
      7:"Sat"
    };
    List<Widget> ex = [];

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Feb"),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text("h"),
                padding: EdgeInsets.all(5),
              ),
              Container(
                child: Text("attemp"),
                padding: EdgeInsets.all(5),
              )
            ],
          ),
          padding: EdgeInsets.only(top: 30),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text("attemp"),
                padding: EdgeInsets.all(5),
              )
            ],
          ),
        ),
      ],
    );
  }
}
