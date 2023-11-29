import 'dart:convert';

import 'package:attendme_app/domain/entities/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_model_response.g.dart';

@JsonSerializable()
class LoginData {
  final int id;
  final String surname;
  final String last_name;
  final String role;
  final String job_desk;
  final String image_url;
  final String email;
  final int companyId;
  LoginData(this.id, this.surname, this.last_name, this.role, this.job_desk,
      this.image_url, this.email, this.companyId);

  User toEntity() {
    return User(
        userId: id,
        companyId: companyId,
        jobDesk: job_desk,
        role: role,
        surName: surname,
        lastName: last_name,
        imageUrl: image_url);
  }

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);

  String toJson() => jsonEncode(_$LoginDataToJson(this));
}
