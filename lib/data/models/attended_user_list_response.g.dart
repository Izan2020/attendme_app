// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attended_user_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendedUserList _$AttendedUserListFromJson(Map<String, dynamic> json) =>
    AttendedUserList(
      (json['data'] as List<dynamic>)
          .map((e) => AttendedUser.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AttendedUserListToJson(AttendedUserList instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
