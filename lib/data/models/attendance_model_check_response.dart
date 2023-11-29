import 'dart:convert';

import 'package:attendme_app/domain/entities/attendance_status.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'attendance_model_check_response.g.dart';

@JsonSerializable()
class AttendanceCheckResponse extends Equatable {
  final String? status;
  final String? reason;
  final String? created_at;
  final String? created_time;
  final int? attendance_id;
  const AttendanceCheckResponse(
      {this.status,
      this.created_at,
      this.reason,
      this.attendance_id,
      this.created_time});

  AttendanceStatus toEntity() {
    return AttendanceStatus(
        status, created_at, attendance_id, reason, created_time);
  }

  factory AttendanceCheckResponse.fromJson(Map<String, dynamic> json) =>
      _$AttendanceCheckResponseFromJson(json);

  String toJson() => jsonEncode(_$AttendanceCheckResponseToJson(this));

  @override
  List<Object?> get props => [
        status,
        created_at,
        reason,
        attendance_id,
      ];
}
