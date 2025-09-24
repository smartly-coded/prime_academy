// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'students_testimonals_response.g.dart';

@JsonSerializable()
class StudentTestimonalsResponse {
  final int id;
  final String name;
  String content;
  final bool viewable;
  UserImage? image;
  @JsonKey(name: "created_at")
  final DateTime createdAt;
  @JsonKey(name: "updated_at")
  final DateTime updatedAt;

  StudentTestimonalsResponse({
    required this.id,
    required this.name,
    required this.content,
    required this.viewable,
    this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudentTestimonalsResponse.fromJson(Map<String, dynamic> json) =>
      _$StudentTestimonalsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StudentTestimonalsResponseToJson(this);
}

@JsonSerializable()
class UserImage {
  int? id;
  String? url;

  @JsonKey(name: "mime_type")
  String? mimeType;
  String? filename;
  @JsonKey(name: "created_at")
  DateTime? createdAt;
  @JsonKey(name: "updated_at")
  DateTime? updatedAt;

  UserImage({
    this.id,
    this.url,
    this.mimeType,
    this.filename,
    this.createdAt,
    this.updatedAt,
  });

  factory UserImage.fromJson(Map<String, dynamic> json) =>
      _$UserImageFromJson(json);

  Map<String, dynamic> toJson() => _$UserImageToJson(this);
}
