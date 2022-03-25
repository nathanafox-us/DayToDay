import 'package:day_to_day/Months.dart';
import 'package:day_to_day/to_do_list_directory_widget.dart';
import 'package:day_to_day/to_do_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:day_to_day/Calendar.dart';

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

  Calendar myCalendar = Calendar();

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
    var equation = ((myCalendar.getCurrentYear() - 1980) * 12 + myCalendar.getCurrentMonth()) - 1;
    PageController pageController = PageController(
      initialPage: equation,
    );

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
                child: Text(myCalendar.getCurrentDay().toString()),
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
          myCalendar.calendarWidget(pageController, context),
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


  void onFindMyDayPressed(int i, PageController controller) {
    controller.animateToPage(i,
        duration: const Duration(seconds: 2), curve: Curves.ease);
  }

  void onSearchButtonPressed() {}


}