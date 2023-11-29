import 'package:json_annotation/json_annotation.dart';
part 'attended_user_data_response.g.dart';

@JsonSerializable()
class UserData {
  final int id;
  final String last_name;
  final String surname;
  final String image_url;
  UserData(
      {required this.id,
      required this.last_name,
      required this.surname,
      required this.image_url});

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
