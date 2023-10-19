// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginData _$LoginDataFromJson(Map<String, dynamic> json) => LoginData(
      json['id'] as int,
      json['surname'] as String,
      json['last_name'] as String,
      json['role'] as String,
      json['job_desk'] as String,
      json['image_url'] as String,
      json['email'] as String,
      json['company_id'] as int,
    );

Map<String, dynamic> _$LoginDataToJson(LoginData instance) => <String, dynamic>{
      'id': instance.id,
      'surname': instance.surname,
      'last_name': instance.lastName,
      'role': instance.role,
      'job_desk': instance.jobDesk,
      'image_url': instance.imageUrl,
      'email': instance.email,
      'company_id': instance.companyId,
    };
