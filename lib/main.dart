import 'package:day_to_day/inherited.dart';
import 'package:day_to_day/login_widget.dart';
import 'package:day_to_day/events.dart';
import 'package:day_to_day/projects_widget.dart';
import 'package:day_to_day/assignments.dart';
import 'package:day_to_day/exams.dart';
import 'package:day_to_day/to_do_list_directory_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:day_to_day/calendar.dart';
import 'package:day_to_day/event_form.dart';
import 'package:day_to_day/user_sync.dart';
import 'dart:async';
import 'event_list_storage.dart';

StreamController<bool> streamController = StreamController<bool>.broadcast();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(DayToDay());
}

class DayToDay extends StatelessWidget {
  DayToDay({Key? key}) : super(key: key);
  bool wic = true;

  @override
  Widget build(BuildContext context) => InheritedState(
        child: MaterialApp(
          title: "DayToDay",
          theme: ThemeData(
            timePickerTheme: TimePickerThemeData(
              //backgroundColor: Colors.red[200],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              hourMinuteShape: const CircleBorder(),
            ),
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,

            /* light theme settings */
          ),
          darkTheme: ThemeData(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.grey[900],
              dayPeriodTextColor: Colors.white,
              entryModeIconColor: Colors.white,
              dialTextColor: Colors.white,
              hourMinuteTextColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              hourMinuteShape: const CircleBorder(),
            ),
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Colors.red[200],
              secondary: Colors.redAccent[200],
              brightness: Brightness.dark,
            ),
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.black,
          ),
          themeMode: ThemeMode.system,
          /* ThemeMode.system to follow system theme,
         ThemeMode.light for light theme,
         ThemeMode.dark for dark theme
      */
          //home: const MyStatefulWidget(),
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return AppWidget();
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Error'),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return const LoginWidget();
              }
            },
          ),
          debugShowCheckedModeBanner: false,
        ),
      );
}

class AppWidget extends StatefulWidget {
  AppWidget({Key? key}) : super(key: key);
  List<Events> eventList = [];

  @override
  State<AppWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<AppWidget>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    Sync.sync();
    Timer syncTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      Sync.sync();
    });
    super.initState();
    tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var pass = EventListStorage("Project").readEvents().then((value) {
      widget.eventList = value;
    });

    var systemColor = MediaQuery.of(context).platformBrightness;
    bool darkMode = systemColor == Brightness.dark;
    Color labelColorChange;

    if (darkMode) {
      labelColorChange = Colors.red[400]!;
    } else {
      labelColorChange = Colors.red[400]!;
    }
    Color? appBarC;
    Color? appBarT;
    if (darkMode) {
      appBarC = Colors.grey[800];
      appBarT = Colors.white;
    } else {
      appBarC = Colors.white10;
      appBarT = Colors.black;
    }

    return Scaffold(
      drawer: Drawer(
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
              title: const Text('Sign Out'),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          'DayToDay',
          style: TextStyle(color: appBarT),
        ),
        backgroundColor: appBarC,
        actions: const [
          //IconButton(
          //onPressed: () => onSearchButtonPressed(),
          //icon: Image.asset(
          //"assets/icons/search-icon.png",
          //),
          //splashRadius: 20,
          //),
          /*IconButton(
            onPressed: () => onFindMyDayPressed(equation, pageController),
            icon: Image.asset(
              "assets/icons/find-the-day.png",
            ),
            splashRadius: 20,
          ),*/
        ],
        bottom: TabBar(
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          controller: tabController,
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
              text: "To-Do",
            ),
            const Tab(
              text: "Assignments",
            ),
            const Tab(
              text: "Projects",
            ),
            const Tab(
              text: "Exams",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          CalendarWidget(
            stream: streamController.stream,
          ),
          const ToDoListDirectoryWidget(),
          AssignmentsWidget(
            stream: streamController.stream,
          ),
          ProjectsWidget(
            stream: streamController.stream,
          ),
          ExamsWidget(
            stream: streamController.stream,
          ),
        ],
      ),
    );
  }

  void onSearchButtonPressed() {}
}
