import 'package:flutter/material.dart';

class events {
  DateTime from;
  DateTime to;
  int page;
  String title = "";
  Color color;
  bool allDay;

events(this.title, this.color,
     this.allDay, this.page, this.from, this.to);

}