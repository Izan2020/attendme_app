import 'dart:convert';

import 'package:attendme_app/domain/entities/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_model_response.g.dart';

@JsonSerializable()
class LoginData {
  final int id;
  final String surname;
  final String lastName;
  final String role;
  final String jobDesk;
  final String imageUrl;
  final String email;
  final int companyId;
  LoginData(this.id, this.surname, this.lastName, this.role, this.jobDesk,
      this.imageUrl, this.email, this.companyId);

  User toEntity() {
    return User(
        userId: id,
        companyId: companyId,
        jobDesk: jobDesk,
        role: role,
        surName: surname,
        lastName: lastName,
        imageUrl: imageUrl);
  }

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);

  String toJson() => jsonEncode(_$LoginDataToJson(this));
}
