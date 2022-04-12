import 'package:flutter/material.dart';

class Events {
  DateTime from;
  DateTime to;
  int page;
  String title = "";
  Color color;
  bool allDay;

Events(this.title, this.color,
     this.allDay, this.page, this.from, this.to);

}