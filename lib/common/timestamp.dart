import 'package:intl/intl.dart';

Future<String> dateTimeToString(DateTime? value) async {
  return DateFormat('''yyyy-MM-dd'T'HH:mm:ss.SSSSSS''').format(value!);
}

String simpleDateTime({
  required DateTime value,
  required String format,
}) {
  final simpleDateFormat = DateFormat(format);
  return simpleDateFormat.format(value);
}

String currentDateTime() {
  DateTime now = DateTime.now();
  DateFormat customFormat = DateFormat('yyyy-MM-dd 00:00:00.000');
  return customFormat.format(now);
}
