// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  String? id;
  String? firstname;
  String? lastname;
  String? username;
  String? email;
  String? role;
  @JsonKey(name: "updated_at")
  DateTime? updatedAt;
  @JsonKey(name: "created_at")
  DateTime? createdAt;
  UserImage? image;
  LoginResponse({
    this.id,
    this.firstname,
    this.lastname,
    this.username,
    this.email,
    this.role,
    this.updatedAt,
    this.createdAt,
    this.image,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@JsonSerializable()
class UserImage {
  String? url;
  String? filename;
  @JsonKey(name: "mime_type")
  String? mimeType;
  int? size;
  @JsonKey(name: "created_at")
  DateTime? createdAt;
  @JsonKey(name: "updated_at")
  DateTime? updatedAt;
  UserImage({
    this.url,
    this.filename,
    this.mimeType,
    this.size,
    this.createdAt,
    this.updatedAt,
  });

  factory UserImage.fromJson(Map<String, dynamic> json) =>
      _$UserImageFromJson(json);
}
