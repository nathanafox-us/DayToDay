import 'package:flutter/material.dart';

class events {
  DateTime from;
  DateTime to;
  int page;
  String title = "";
  String timeF = "";
  String timeT = "";
  Color color;
  TimeOfDay fromT;
  TimeOfDay toT;
  bool allDay;
  int weekDay = 0;

events(this.title, this.timeF, this.timeT, this.color,
    this.fromT, this.toT, this.allDay, this.page, this.weekDay, this.from, this.to);


}