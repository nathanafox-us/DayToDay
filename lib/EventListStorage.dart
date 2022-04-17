import 'package:flutter/material.dart';
import 'dart:convert';
import 'Events.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// This class is used to read and write files in the application
class EventListStorage {
  var typeName = "";
  EventListStorage(this.typeName);

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    File file = File('$path/$typeName.txt');
    if (!await file.exists()) {
      file.writeAsString("");
    }
    return file;
  }

  Future<List<Events>> readEvents() async {
    final file = await _localFile;

    // Read the file
    final contents = await file.readAsString();

    List<Events> events = [];
    String type = "";
    int monthFrom = 0;
    int monthTo = 0;
    int yearFrom = 0;
    int page = 0;
    int yearTo = 0;
    int dayTo = 0;
    int dayFrom = 0;
    String title = "";
    String timeF = "";
    String timeT = "";
    Color color;
    TimeOfDay fromT;
    TimeOfDay toT;
    bool allDay;
    String repeat;
    int weekDay = 0;

    if (contents.isEmpty) {
      return [];
    }

    var data = contents.split(":");
    for (int i = 0; i < data.length / 17; i++) {
      type = data[i * 17];
      monthFrom = int.parse(data[i * 17 + 1]);
      monthTo = int.parse(data[i * 17 + 2]);
      yearFrom = int.parse(data[i * 17 + 3]);
      page = int.parse(data[i * 17 + 4]);
      yearTo = int.parse(data[i * 17 + 5]);
      dayTo = int.parse(data[i * 17 + 6]);
      dayFrom = int.parse(data[i * 17 + 7]);
      title = data[i * 17 + 8];
      timeF = data[i * 17 + 9];
      timeT = data[i * 17 + 10];
      color = data[i * 17 + 11] as Color;
      fromT = data[i * 17 + 12] as TimeOfDay;
      toT = data[i * 17 + 13] as TimeOfDay;
      if (data[i * 17 + 14].contains("rue")) {
        allDay = true;
      } else {
        allDay = false;
      }
      repeat = data[i * 17 + 15];
      weekDay = int.parse(data[i * 17 + 16]);

      events.add(Events(
          monthFrom,
          yearFrom,
          dayFrom,
          title,
          timeF,
          timeT,
          dayTo,
          monthTo,
          yearTo,
          color,
          fromT,
          toT,
          allDay,
          repeat,
          page,
          weekDay,
          type));
    }

    return events;
  }

  Future<File> writeEvents(List<Events> events) async {
    //This is the file
    final file = await _localFile;

    /*Every event has String type = "";
                      int monthFrom = 0;
                      int monthTo = 0;
                      int yearFrom = 0;
                      int page = 0;
                      int yearTo = 0;
                      int dayTo = 0;
                      int dayFrom = 0;
                      String title = "";
                      String timeF = "";
                      String timeT = "";
                      Color color;
                      TimeOfDay fromT;
                      TimeOfDay toT;
                      bool allDay;
                      String repeat;
                      int weekDay = 0;*/
    for (int i = 0; i < events.length; i++) {
      file.writeAsString(events[i].type + ":");
      file.writeAsString(events[i].monthFrom.toString() + ":");
      file.writeAsString(events[i].monthTo.toString() + ":");
      file.writeAsString(events[i].yearFrom.toString() + ":");
      file.writeAsString(events[i].yearTo.toString() + ":");
      file.writeAsString(events[i].page.toString() + ":");
      file.writeAsString(events[i].dayFrom.toString() + ":");
      file.writeAsString(events[i].dayTo.toString() + ":");
      file.writeAsString(events[i].title + ":");
      file.writeAsString(events[i].timeF + ":");
      file.writeAsString(events[i].timeT + ":");
      file.writeAsString(events[i].color.toString() + ":");
      file.writeAsString(events[i].fromT.toString() + ":");
      file.writeAsString(events[i].toT.toString() + ":");
      file.writeAsString(events[i].allDay.toString() + ":");
      file.writeAsString(events[i].repeat + ":");
      file.writeAsString(events[i].weekDay.toString() + ":");
    }

    return file;
  }

  Future<File> writeEvent(Events event) async {
    final file = await _localFile;
    List<Events> oldList = await readEvents();
    oldList.add(event);
    return writeEvents(oldList);
  }
}
