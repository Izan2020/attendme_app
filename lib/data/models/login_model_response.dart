// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:attendme_app/domain/entities/user.dart';

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
    this.updatedAt,
    required this.email,
    required this.password,
    required this.companyId,
  });

  LoginData copyWith({
    int? id,
    String? surname,
    String? lastName,
    String? role,
    String? jobDesk,
    String? imageUrl,
    String? createdAt,
    String? updatedAt,
    String? email,
    String? password,
    int? companyId,
  }) {
    return LoginData(
      id: id ?? this.id,
      surname: surname ?? this.surname,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      jobDesk: jobDesk ?? this.jobDesk,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      email: email ?? this.email,
      password: password ?? this.password,
      companyId: companyId ?? this.companyId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'surname': surname,
      'lastName': lastName,
      'role': role,
      'jobDesk': jobDesk,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'email': email,
      'password': password,
      'companyId': companyId,
    };
  }

  factory LoginData.fromMap(Map<String, dynamic> map) {
    return LoginData(
      id: map['id'] as int,
      surname: map['surname'] as String,
      lastName: map['lastName'] as String,
      role: map['role'] as String,
      jobDesk: map['jobDesk'] as String,
      imageUrl: map['imageUrl'] as String,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      email: map['email'] as String,
      password: map['password'] as String,
      companyId: map['companyId'] as int,
    );
  }

  User toEntity() {
    return User(
      userId: id,
      companyId: companyId,
      jobDesk: jobDesk,
      role: role,
      surName: surname,
      lastName: lastName,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginData.fromJson(String source) =>
      LoginData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LoginData(id: $id, surname: $surname, lastName: $lastName, role: $role, jobDesk: $jobDesk, imageUrl: $imageUrl, createdAt: $createdAt, updatedAt: $updatedAt, email: $email, password: $password, companyId: $companyId)';
  }

  @override
  bool operator ==(covariant LoginData other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.surname == surname &&
        other.lastName == lastName &&
        other.role == role &&
        other.jobDesk == jobDesk &&
        other.imageUrl == imageUrl &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.email == email &&
        other.password == password &&
        other.companyId == companyId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        surname.hashCode ^
        lastName.hashCode ^
        role.hashCode ^
        jobDesk.hashCode ^
        imageUrl.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        email.hashCode ^
        password.hashCode ^
        companyId.hashCode;
  }
}
