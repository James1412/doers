Map<int, String> weekdays = {
  1: "Mon",
  2: "Tue",
  3: "Wed",
  4: "Thu",
  5: "Fri",
  6: "Sat",
  7: "Sun",
};
Map<int, String> months = {
  1: "Jan",
  2: "Feb",
  3: "Mar",
  4: "Apr",
  5: "May",
  6: "June",
  7: "Jul",
  8: "Aug",
  9: "Sep",
  10: "Oct",
  11: "Nov",
  12: "Dec",
};
int currentYear = DateTime.now().year;
String getDate(DateTime dateTime) {
  if (isDateToday(dateTime)) {
    return "${months[dateTime.month]} ${dateTime.day} (${weekdays[dateTime.weekday]}) • Today";
  }
  return "${months[dateTime.month]} ${dateTime.day} (${weekdays[dateTime.weekday]})";
}

DateTime currentDay =
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

bool isDateToday(DateTime dateTime) {
  if (DateTime(dateTime.year, dateTime.month, dateTime.day) ==
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)) {
    return true;
  } else {
    return false;
  }
}
