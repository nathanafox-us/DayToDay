import 'package:flutter/material.dart';
import 'dart:convert';
import 'events.dart';
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
    DateTime from = DateTime.now();
    DateTime to = DateTime.now();
    int dayT = 0;
    int monthT = 0;
    int yearT = 0;
    int dayF = 0;
    int monthF = 0;
    int yearF = 0;
    int page = 0;
    String type = "";
    String title = "";
    Color color;
    bool allDay;

    if (contents.isEmpty) {
      return [];
    }

    var data = contents.split(":");
    for (int i = 0; i < data.length / 11; i++) {
      type = data[i * 11];
      monthF = int.parse(data[i * 11 + 1]);
      monthT = int.parse(data[i * 11 + 2]);
      yearF = int.parse(data[i * 11 + 3]);
      page = int.parse(data[i * 11 + 4]);
      yearT = int.parse(data[i * 11 + 5]);
      dayT = int.parse(data[i * 11 + 6]);
      dayF = int.parse(data[i * 11 + 7]);
      title = data[i * 11 + 8];
      color = data[i * 11 + 9] as Color;
      if (data[i * 11 + 10].contains("rue")) {
        allDay = true;
      } else {
        allDay = false;
      }

      from = DateTime(yearF, monthF, dayF, 0, 0, 0, 0, 0);
      to = DateTime(yearT, monthT, dayT, 0, 0, 0, 0, 0);

      events.add(Events(title, color, allDay, page, from, to, type));
    }

    return events;
  }

  Future<File> writeEvents(List<Events> events) async {
    //This is the file
    final file = await _localFile;

    //Set globals.timestamp = date.now() every time you write

    /*Every event has
                      DateTime from;
                      DateTime to;
                      int page = 0;
                      String type = "";
                      String title = "";
                      Color color;
                      bool allDay;*/

    for (int i = 0; i < events.length; i++) {
      file.writeAsString(events[i].from.toIso8601String());
      file.writeAsString(events[i].to.toIso8601String());
      file.writeAsString(events[i].page.toString());
      file.writeAsString(events[i].type);
      file.writeAsString(events[i].title);
      file.writeAsString(events[i].color.toString());
      if (events[i].allDay) {
        file.writeAsString("True");
      } else {
        file.writeAsString("False");
      }
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
