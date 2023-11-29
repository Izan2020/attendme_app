// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attended_user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendedUser _$AttendedUserFromJson(Map<String, dynamic> json) => AttendedUser(
      json['id'] as int,
      json['created_at'] as String,
      UserData.fromJson(json['userData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AttendedUserToJson(AttendedUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.created_at,
      'userData': instance.userData,
    };
