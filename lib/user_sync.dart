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

  static String hashEvent(Events event) {
    String input = event.from.hashCode.toString() +
        event.to.hashCode.toString() +
        event.title;
    return input;
  }

  static sendEvents(DatabaseReference ref, String date, List<Events> events) {
    print(date);
    DatabaseReference day = ref.child(date);
    for (Events event in events) {
      String hash = hashEvent(event);
      DatabaseReference eventRef = day.child(hash);
      eventRef.child('from').set(event.from.toString());
      eventRef.child('to').set(event.to.toString());
      eventRef.child('page').set(event.page.toString());
      eventRef.child('title').set(event.title);
      eventRef.child('allDay').set(event.allDay);
      eventRef.child('type').set(event.eventType);
      DatabaseReference color = eventRef.child('color');
      color.child('a').set(event.color.alpha);
      color.child('r').set(event.color.red);
      color.child('g').set(event.color.green);
      color.child('b').set(event.color.blue);
    }
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
      globals.eventsList
          .forEach((date, events) => sendEvents(eventsRef, date, events));
    } else {
      print('Not logged in :(');
      return;
    }
  }
}
