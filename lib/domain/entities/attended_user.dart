import 'package:attendme_app/data/models/attended_user_response.dart';

class UserAttended {
  final int userCount;
  final List<AttendedUser> userList;
  UserAttended({
    required this.userCount,
    required this.userList,
  });
}
