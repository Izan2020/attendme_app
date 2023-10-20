// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model_check_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceCheckResponse _$AttendanceCheckResponseFromJson(
        Map<String, dynamic> json) =>
    AttendanceCheckResponse(
      status: json['status'] as String,
      createdAt: json['created_at'] as String?,
      reason: json['reason'] as String?,
      attendanceId: json['id'] as int?,
    );

Map<String, dynamic> _$AttendanceCheckResponseToJson(
        AttendanceCheckResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'createdAt': instance.createdAt,
      'reason': instance.reason,
      'id': instance.attendanceId,
    };
