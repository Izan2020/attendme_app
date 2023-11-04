// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model_check_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceCheckResponse _$AttendanceCheckResponseFromJson(
        Map<String, dynamic> json) =>
    AttendanceCheckResponse(
      status: json['status'] as String?,
      createdAt: json['createdAt'] as String?,
      reason: json['reason'] as String?,
      attendanceId: json['attendanceId'] as int?,
      createdTime: json['created_time'] as String?,
    );

Map<String, dynamic> _$AttendanceCheckResponseToJson(
        AttendanceCheckResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'reason': instance.reason,
      'createdAt': instance.createdAt,
      'createdTime': instance.createdTime,
      'attendanceId': instance.attendanceId,
    };
