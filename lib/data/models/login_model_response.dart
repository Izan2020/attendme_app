class LoginData {
  final int id;
  final String surname;
  final String lastName;
  final String role;
  final String jobDesk;
  final String imageUrl;
  final String createdAt;
  String? updatedAt = 'none';
  final String email;
  final String password;
  final int companyId;

  LoginData({
    required this.id,
    required this.surname,
    required this.lastName,
    required this.role,
    required this.jobDesk,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.email,
    required this.password,
    required this.companyId,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      id: json['id'] as int,
      surname: json['surname'] as String,
      lastName: json['last_name'] as String,
      role: json['role'] as String,
      jobDesk: json['job_desk'] as String,
      imageUrl: json['image_url'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
      email: json['email'] as String,
      password: json['password'] as String,
      companyId: json['company_id'] as int,
    );
  }
}
