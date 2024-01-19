import 'package:attendme_app/data/models/attended_user_data_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'attended_user_response.g.dart';

@JsonSerializable()
class AttendedUser {
  final int id;
  final String created_at;
  final UserData user;
  AttendedUser(this.id, this.created_at, this.user);

  factory AttendedUser.fromJson(Map<String, dynamic> json) =>
      _$AttendedUserFromJson(json);

  Map<String, dynamic> toJson() => _$AttendedUserToJson(this);
}
