// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'student_profile_response.g.dart';

@JsonSerializable()
class StudentProfileResponse {
  int? id;
  String? firstname;
  String? lastname;
  @JsonKey(name: "updated_at")
  DateTime? updatedAt;
  @JsonKey(name: "created_at")
  DateTime? createdAt;
  @JsonKey(name: "user_id")
  int? userId;
  @JsonKey(name: "image_id")
  int? imageId;
  @JsonKey(name: "login_attempts")
  int? loginAttempts;
  UserImage? image;
  List<Courses>? courses;
  List<Trophy>? trophies; // إضافة قائمة الجوائز

  StudentProfileResponse({
    this.id,
    this.firstname,
    this.lastname,
    this.updatedAt,
    this.createdAt,
    this.userId,
    this.imageId,
    this.loginAttempts,
    this.image,
    this.courses,
    this.trophies,
  });

  factory StudentProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$StudentProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StudentProfileResponseToJson(this);
}

@JsonSerializable()
class UserImage {
  int? id;
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
    this.id,
    this.url,
    this.filename,
    this.mimeType,
    this.size,
    this.createdAt,
    this.updatedAt,
  });

  factory UserImage.fromJson(Map<String, dynamic> json) =>
      _$UserImageFromJson(json);

  Map<String, dynamic> toJson() => _$UserImageToJson(this);
}

@JsonSerializable()
class Courses {
  int? id;
  String? title;
  @JsonKey(name: "created_at")
  DateTime? createdAt;
  @JsonKey(name: "updated_at")
  DateTime? updatedAt;
  @JsonKey(name: "featured_image")
  FeaturedImage? featuredImage;

  Courses({
    this.id,
    this.title,
    this.createdAt,
    this.updatedAt,
    this.featuredImage,
  });

  factory Courses.fromJson(Map<String, dynamic> json) =>
      _$CoursesFromJson(json);

  Map<String, dynamic> toJson() => _$CoursesToJson(this);
}

@JsonSerializable()
class FeaturedImage {
  int? id;
  String? filename;
  String? url;
  @JsonKey(name: "mime_type")
  String? mimeType;
  int? size;
  @JsonKey(name: "created_at")
  DateTime? createdAt;
  @JsonKey(name: "updated_at")
  DateTime? updatedAt;

  FeaturedImage({
    this.id,
    this.filename,
    this.url,
    this.mimeType,
    this.size,
    this.createdAt,
    this.updatedAt,
  });

  factory FeaturedImage.fromJson(Map<String, dynamic> json) =>
      _$FeaturedImageFromJson(json);

  Map<String, dynamic> toJson() => _$FeaturedImageToJson(this);
}

// إضافة Trophy model
@JsonSerializable()
class Trophy {
  int? id;
  String? name;
  @JsonKey(name: "user_id")
  int? userId;
  @JsonKey(name: "image_id")
  int? imageId;
  @JsonKey(name: "created_at")
  DateTime? createdAt;
  @JsonKey(name: "updated_at")
  DateTime? updatedAt;
  TrophyImage? image;

  Trophy({
    this.id,
    this.name,
    this.userId,
    this.imageId,
    this.createdAt,
    this.updatedAt,
    this.image,
  });

  factory Trophy.fromJson(Map<String, dynamic> json) => _$TrophyFromJson(json);

  Map<String, dynamic> toJson() => _$TrophyToJson(this);
}

@JsonSerializable()
class TrophyImage {
  int? id;
  String? filename;
  String? url;
  @JsonKey(name: "mime_type")
  String? mimeType;
  int? size;
  @JsonKey(name: "created_at")
  DateTime? createdAt;
  @JsonKey(name: "updated_at")
  DateTime? updatedAt;

  TrophyImage({
    this.id,
    this.filename,
    this.url,
    this.mimeType,
    this.size,
    this.createdAt,
    this.updatedAt,
  });

  factory TrophyImage.fromJson(Map<String, dynamic> json) =>
      _$TrophyImageFromJson(json);

  Map<String, dynamic> toJson() => _$TrophyImageToJson(this);
}
