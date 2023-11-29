import 'package:attendme_app/data/models/attended_user_response.dart';
import 'package:attendme_app/domain/entities/attended_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'attended_user_list_response.g.dart';

@JsonSerializable()
class AttendedUserList {
  final List<AttendedUser> data;
  AttendedUserList(this.data);

  factory AttendedUserList.fromJson(Map<String, dynamic> json) =>
      _$AttendedUserListFromJson(json);

  Map<String, dynamic> toJson() => _$AttendedUserListToJson(this);

  UserAttended toEntity() => UserAttended(
        userCount: data.length,
        userList: data,
      );
}
