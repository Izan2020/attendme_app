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
