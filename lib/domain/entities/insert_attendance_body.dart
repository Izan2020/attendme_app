// ignore_for_file: public_member_api_docs, sort_constructors_first
class AttendanceBody {
  int userId;
  int companyId;
  String imageUrl;
  String longitude;
  String latitude;
  String? status = 'attended';
  String? reason = 'none';
  String? message = 'none';
  AttendanceBody({
    required this.userId,
    required this.companyId,
    required this.imageUrl,
    required this.longitude,
    required this.latitude,
    this.status,
    this.reason,
    this.message,
  });
}
