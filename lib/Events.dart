import 'package:flutter/material.dart';

class Events {

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

Events(this.monthFrom, this.yearFrom, this.dayFrom, this.title, this.timeF, this.timeT, this.dayTo, this.monthTo, this.yearTo, this.color,
    this.fromT, this.toT, this.allDay, this.repeat, this.page, this.weekDay);


}