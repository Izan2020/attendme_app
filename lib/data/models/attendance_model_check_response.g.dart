// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model_check_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceCheckResponse _$AttendanceCheckResponseFromJson(
        Map<String, dynamic> json) =>
    AttendanceCheckResponse(
      status: json['status'] as String?,
      created_at: json['created_at'] as String?,
      reason: json['reason'] as String?,
      attendance_id: json['attendance_id'] as int?,
      created_time: json['created_time'] as String?,
    );

Map<String, dynamic> _$AttendanceCheckResponseToJson(
        AttendanceCheckResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'reason': instance.reason,
      'created_at': instance.created_at,
      'created_time': instance.created_time,
      'attendance_id': instance.attendance_id,
    };
