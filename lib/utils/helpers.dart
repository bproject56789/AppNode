import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ylc/utils/api_result.dart';
import 'package:ylc/values/strings.dart';

int timestamp() {
  return DateTime.now().millisecondsSinceEpoch;
}

Duration getRemainingTime(int time) {
  var endTime = DateTime.fromMillisecondsSinceEpoch(time);
  var timeRemaining = endTime.difference(DateTime.now());
  return timeRemaining;
}

Future<void> showSnackBar(
  BuildContext context, {
  @required ApiResult result,
  @required String message,
  String error,
  VoidCallback onSuccess,
  VoidCallback onError,
}) async {
  if (result.isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
    await Future.delayed(Duration(seconds: 1));
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    onSuccess?.call();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error ?? Strings.generalError),
    ));
    onError?.call();
  }
}

extension Format on DateTime {
  String get time => DateFormat('jm').format(this);
  String get date => DateFormat('yMMMMEEEEd').format(this);
}

Future<DateTime> showDateTimePicker(BuildContext context,
    {int initialDate}) async {
  var now = DateTime.now();
  var selectedDate = initialDate != null
      ? DateTime.fromMillisecondsSinceEpoch(initialDate)
      : now;
  var date = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: now,
    lastDate: now.add(
      Duration(hours: 2160),
    ), //allows 3 months time in future
  );

  if (date == null) {
    return null;
  }

  var time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(selectedDate),
  );
  if (time == null) {
    return null;
  }

  var startTime =
      DateTime(date.year, date.month, date.day, time.hour, time.minute);

  if (startTime.isBefore(DateTime.now())) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Looks like you selected a date in past.'),
      ),
    );
    return null;
  } else {
    return startTime;
  }
}
