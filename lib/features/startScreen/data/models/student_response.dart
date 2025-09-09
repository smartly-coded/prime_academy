// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'student_response.g.dart';

@JsonSerializable()
class StudentsResponse {
  List<Student> data;
  Meta meta;

  StudentsResponse({required this.data, required this.meta});

  factory StudentsResponse.fromJson(Map<String, dynamic> json) =>
      _$StudentsResponseFromJson(json);
}

@JsonSerializable()
class Student {
  int id;
  String firstname;
  String lastname;
  String email;
  String username;
  int points;
  @JsonKey(name: "created_at")
  DateTime createdAt;
  UserImage image;

  Student({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.username,
    required this.points,
    required this.createdAt,
    required this.image,
  });

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
}

@JsonSerializable()
class Meta {
  @JsonKey(name: "current_page")
  int currentPage;
  @JsonKey(name: "last_page")
  int lastPage;
  int total;

  Meta({
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
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
