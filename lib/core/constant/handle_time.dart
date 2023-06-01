import 'package:intl/intl.dart';

String convertTime(int value) {
  return '${value >= 12 ? value - 12 : value}:00 ${value >= 12 ? 'PM' : 'AM'}';
}

int getMinBetweenDates(DateTime start, DateTime end) {
  int result = end.difference(start).inMinutes;
  return result;
}

int checkDateBetween(DateTime start, DateTime end) {
  DateTime now = DateTime.now();
  if (now.isBefore(start)) {
    return 0;
  } else if (now.isAfter(end)) {
    return 2;
  }
  return 1;
}

String getYmdFormat(DateTime dateTime) {
  return DateFormat().add_yMd().format(dateTime);
}

String getYmdHmFormat(DateTime dateTime) {
  return DateFormat().add_yMd().add_Hm().format(dateTime);
}

String getjmFormat(DateTime dateTime) {
  return DateFormat().add_jm().format(dateTime);
}

String getRangeDateFormat(DateTime startDate, DateTime endDate) =>
    '${DateFormat().add_yMEd().format(startDate)} - ${DateFormat().add_yMEd().format(endDate)}';

int hoursBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return to.difference(from).inHours;
}

int minutesBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return to.difference(from).inMinutes;
}

String displayHoursMinutesBetween(DateTime from, DateTime to) {
  var hours = hoursBetween(from, to);
  var minutes = minutesBetween(from, to);
  return '$hours h $minutes m';
}

String getMMMMEEEd(DateTime time) =>
    DateFormat().add_MMMMEEEEd().add_Hm().format(time);
