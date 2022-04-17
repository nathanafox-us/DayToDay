import 'package:day_to_day/to_do_list.dart';
import 'package:day_to_day/events.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:day_to_day/globals.dart' as globals;
import 'package:firebase_database/firebase_database.dart';

class Sync {
  static String setUID() {
    if (FirebaseAuth.instance.currentUser != null) {
      var _uID = FirebaseAuth.instance.currentUser?.uid;
      return (_uID ?? 'null uID');
    } else {
      return 'null currentUser';
    }
  }

  static sendEvents(String date, List<Events> events) {
    print(date);
  }

  static sync() {
    String uID = "TEST";
    bool loggedIn = (FirebaseAuth.instance.currentUser != null);
    int fbTest = 0;

    print('Syncing...');

    //check timestamp and decide which way to sync

    //syncing Firebase FROM disc
    if (loggedIn) {
      print('Logged in');
      uID = setUID();
      print('uID is: ' + uID);
      FirebaseDatabase db = FirebaseDatabase.instance;
      DatabaseReference ref = db.ref('Users').child(uID);
      print('Database created!');
      DatabaseReference eventsRef = ref.child('Events');
      print('Setting events');
      globals.eventsList.forEach((date, events) => sendEvents(date, events));
    } else {
      print('Not logged in :(');
      return;
    }
  }
}
