// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginData _$LoginDataFromJson(Map<String, dynamic> json) => LoginData(
      json['id'] as int,
      json['surname'] as String,
      json['lastName'] as String,
      json['role'] as String,
      json['jobDesk'] as String,
      json['imageUrl'] as String,
      json['email'] as String,
      json['companyId'] as int,
    );

Map<String, dynamic> _$LoginDataToJson(LoginData instance) => <String, dynamic>{
      'id': instance.id,
      'surname': instance.surname,
      'lastName': instance.lastName,
      'role': instance.role,
      'jobDesk': instance.jobDesk,
      'imageUrl': instance.imageUrl,
      'email': instance.email,
      'companyId': instance.companyId,
    };
