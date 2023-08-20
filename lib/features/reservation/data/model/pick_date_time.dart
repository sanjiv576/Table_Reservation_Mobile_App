import 'package:flutter/material.dart';

class PickDateTime {
  static String convertDate({required DateTime date}) {
    String year = date.year.toString();
    String month = _getMonthName(value: date.month);
    String day = date.day.toString();
    return '$month $day, $year';
  }

  static String _getMonthName({required int value}) {
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return months[value - 1];
  }

  static String convertTime({required TimeOfDay time}) {
    // it gives 1-24 hours so 16 == 4PM, 12 == 12AM,  3 == 3AM
    int hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    String dayNight = time.hour <= 12 ? 'AM' : 'PM';
    String minute = time.minute.toString();
    return '$hour : $minute $dayNight';
  }
}
