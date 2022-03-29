import 'package:flutter/material.dart';
import 'package:day_to_day/Events.dart';
class EventForm extends StatefulWidget {
  const EventForm({Key? key}) : super(key: key);

  @override
  EventFormState createState() => EventFormState();
}

class EventFormState extends State<EventForm> {
  var events = {};
  bool isSwitched = false;
  TextEditingController titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String from;
    String to;
    String title;


    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top:50, bottom: 12),
            child: TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Add Event Title',
              ),
            ),
          ),
          InkWell(
            child: Row(
              children: [
                const ImageIcon(AssetImage("assets/icons/clock.png"),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Text("All Day", style: TextStyle(fontSize: 20),),
                ),
                const Spacer(),
                Switch(value: isSwitched, onChanged: onToggled),
              ],
            ),
            onTap: () => onToggled(true),
          ),

        ],
      ),
    );
  }

  void onToggled(bool state) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
      });
    }
    else if (isSwitched == true) {
      setState(() {
        isSwitched = false;
      });
    }
  }
}