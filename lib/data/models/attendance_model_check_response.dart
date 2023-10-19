import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class AttendanceCheckResponse {
  final String status;
  final String? createdAt;
  AttendanceCheckResponse({required this.status, this.createdAt});
}
