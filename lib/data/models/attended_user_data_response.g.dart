// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attended_user_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      id: json['id'] as int,
      last_name: json['last_name'] as String,
      surname: json['surname'] as String,
      image_url: json['image_url'] as String,
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'last_name': instance.last_name,
      'surname': instance.surname,
      'image_url': instance.image_url,
    };
