import 'package:intl/intl.dart';

String formatForecastDate(String date) {
  if (date.isEmpty || date == "Loading...") {
    return "Loading...";
  }

  final forecastDate = DateTime.parse(date);

  final now = DateTime.now();

  final today = DateTime(
    now.year,
    now.month,
    now.day,
  );

  final difference = forecastDate.difference(today).inDays;

  if (difference == 0) {
    return "Today";
  }

  if (difference == 1) {
    return "Tomorrow";
  }

  return DateFormat("EEE").format(forecastDate).substring(0, 3);
}
