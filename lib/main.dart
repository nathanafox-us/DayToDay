import 'package:day_to_day/Months.dart';
import 'package:day_to_day/to_do_list_directory_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:day_to_day/Calendar.dart';
import 'package:day_to_day/EventForm.dart';
import 'package:day_to_day/user.dart';

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
            return const AppWidget();
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

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);
  @override
  State<AppWidget> createState() => _MyStatefulWidgetState();
}

/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _MyStatefulWidgetState extends State<AppWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var systemColor = MediaQuery.of(context).platformBrightness;
    bool darkMode = systemColor == Brightness.dark;
    Color labelColorChange;

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
      floatingActionButton: FloatingActionButton(
        onPressed: () => onAddEventButtonPressed(),
        child: const Icon(
          Icons.add,
          size: 45,
          color: Colors.white,
        ),
        backgroundColor: Colors.blueGrey,
      ),
      appBar: AppBar(
        title: const Text('DayToDay'),
        actions: [
          IconButton(
            onPressed: () => onSearchButtonPressed(),
            icon: Image.asset(
              "assets/icons/search-icon.png",
            ),
            splashRadius: 20,
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
          CalendarWidget(),
          ToDoListDirectoryWidget(),
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

  void onSearchButtonPressed() {}
  void onAddEventButtonPressed() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      print(CalendarState().getClicked());
      return const EventForm();
    }));
  }
}
