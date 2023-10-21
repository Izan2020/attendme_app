import 'package:intl/intl.dart';

Future<String> dateTimeToString(DateTime? value) async {
  return DateFormat('''yyyy-MM-dd'T'HH:mm:ss.SSSSSS''').format(value!);
}

String simpleDateString(DateTime value) {
  final simpleDateFormat = DateFormat('dd, MMMM yyyy');
  return simpleDateFormat.format(value);
}
