import 'package:intl/intl.dart';

Future<String> dateTimeToString(DateTime? value) async {
  return DateFormat('''yyyy-MM-dd'T'HH:mm:ss.SSSSSS+00:00''').format(value!);
}
