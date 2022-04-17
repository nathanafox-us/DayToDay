class Months {
  DateTime now = DateTime.now();
  DateTime monthStartConstruct = DateTime.now();
  String currentMonth = "";
  int monthStart = 0;
  int daysInMonth = 0;

  var month = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December"
  };

  var monthShort = {
    1: "Jan",
    2: "Feb",
    3: "Mar",
    4: "Apr",
    5: "May",
    6: "Jun",
    7: "Jul",
    8: "Aug",
    9: "Sep",
    10: "Oct",
    11: "Nov",
    12: "Dec"
  };

  Months() {
    monthStartConstruct = DateTime(now.year, now.month, 1);
    currentMonth = month[now.month].toString();
    monthStart = monthStartConstruct.weekday;
    daysInMonth = DateTime(now.year, now.month + 1, 0).day;
  }

  Months.otherMonths(int monthPosition) {
    now = DateTime(now.year, monthPosition);
    monthStartConstruct = DateTime(now.year, monthPosition, 1);
    currentMonth = month[monthPosition].toString();
    monthStart = monthStartConstruct.weekday;
    daysInMonth = DateTime(now.year, monthPosition + 1, 0).day;
  }
  Months.otherYears(int monthPosition, int yearPosition) {
    now = DateTime(yearPosition, monthPosition);
    monthStartConstruct = DateTime(now.year, monthPosition, 1);
    currentMonth = month[monthPosition].toString();
    monthStart = monthStartConstruct.weekday;
    daysInMonth = DateTime(now.year, monthPosition + 1, 0).day;
  }

  String? getMonthShort(int index) {
    return monthShort[index];
  }
}
