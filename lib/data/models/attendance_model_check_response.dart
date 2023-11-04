import 'dart:convert';

import 'package:attendme_app/domain/entities/attendance_status.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'attendance_model_check_response.g.dart';

@JsonSerializable()
class AttendanceCheckResponse extends Equatable {
  final String? status;
  final String? reason;
  final String? createdAt;
  final String? createdTime;
  final int? attendanceId;
  const AttendanceCheckResponse(
      {this.status,
      this.createdAt,
      this.reason,
      this.attendanceId,
      this.createdTime});

  AttendanceStatus toEntity() {
    return AttendanceStatus(
        status, createdAt, attendanceId, reason, createdTime);
  }

  factory AttendanceCheckResponse.fromJson(Map<String, dynamic> json) =>
      _$AttendanceCheckResponseFromJson(json);

  String toJson() => jsonEncode(_$AttendanceCheckResponseToJson(this));

  @override
  List<Object?> get props => [
        status,
        createdAt,
        reason,
        attendanceId,
      ];
}
