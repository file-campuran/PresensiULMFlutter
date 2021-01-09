import 'package:intl/intl.dart';

String unixTimeStampToDateTime(int millisecond) {
  var format = DateFormat('EEEE, dd MMMM yyyy HH:mm', 'id');
  var dateTimeString =
      format.format(DateTime.fromMillisecondsSinceEpoch(millisecond));

  return dateTimeString;
}

String unixTimeStampToTime(int millisecond) {
  var format = DateFormat('HH:mm', 'id');
  var dateTimeString =
      format.format(DateTime.fromMillisecondsSinceEpoch(millisecond));

  return dateTimeString;
}

String unixTimeStampToDateTimeWithoutDay(int millisecond) {
  var format = DateFormat('dd MMMM yyyy HH:mm', 'id');
  var dateTimeString =
      format.format(DateTime.fromMillisecondsSinceEpoch(millisecond * 1000));
  return dateTimeString;
}

String unixTimeStampToDate(int millisecond) {
  var format = DateFormat.yMMMMEEEEd('id');
  var dateString =
      format.format(DateTime.fromMillisecondsSinceEpoch(millisecond * 1000));
  return dateString;
}

String unixTimeStampToDateWithoutDay(int millisecond) {
  var format = DateFormat.yMMMMd('id');
  var dateString =
      format.format(DateTime.fromMillisecondsSinceEpoch(millisecond * 1000));
  return dateString;
}

String unixTimeStampToDateDocs(int millisecond) {
  var format = DateFormat('EEEE, dd MMMM yyyy', 'id');
  var dateTimeString =
      format.format(DateTime.fromMillisecondsSinceEpoch(millisecond));

  return dateTimeString;
}

String unixTimeStampToDateWithoutMultiplication(int millisecond) {
  var format = DateFormat.yMMMMEEEEd('id');
  var dateString =
      format.format(DateTime.fromMillisecondsSinceEpoch(millisecond));
  return dateString;
}

String unixTimeStampToTimeAgo(int millisecond) {
  Duration diff = DateTime.now()
      .difference(DateTime.fromMillisecondsSinceEpoch(millisecond));

  if (diff.inDays > 0) {
    return "${diff.inDays} hari yang lalu";
  } else if (diff.inHours > 0) {
    return "${diff.inHours} jam yang lalu";
  } else if (diff.inMinutes > 0) {
    return "${diff.inMinutes} menit yang lalu";
  } else {
    return "Baru saja";
  }
}

String sisaWaktu(String start, String end) {
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(now);
  var dateString = (DateTime.parse(formatted + ' ' + end));
  Duration diff = dateString.difference(now);

  if (diff.inDays > 0) {
    return "${diff.inDays} hari lagi";
  } else if (diff.inHours > 0) {
    return "${diff.inHours} jam ${diff.inMinutes - (diff.inHours * 60)} menit lagi";
  } else if (diff.inMinutes > 0) {
    return "${diff.inMinutes} menit lagi";
  } else {
    return null;
  }
}

String readTimestamp(String timestamp) {
  var now = new DateTime.now();
  var format = new DateFormat('HH:mm a');
  var date = new DateTime.fromMicrosecondsSinceEpoch(1609512055);
  var diff = date.difference(now);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else {
    if (diff.inDays == 1) {
      time = diff.inDays.toString() + 'DAY AGO';
    } else {
      time = diff.inDays.toString() + 'DAYS AGO';
    }
  }

  return time;
}
