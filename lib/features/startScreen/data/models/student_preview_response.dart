import 'package:json_annotation/json_annotation.dart';

part 'student_preview_response.g.dart';

@JsonSerializable()
class StudentPreviewResponse {
  int id;
  String firstname;
  String lastname;
  @JsonKey(name: "created_at")
  DateTime createdAt;
  @JsonKey(name: "updated_at")
  DateTime updatedAt;
  @JsonKey(name: "user_id")
  int userId;
  @JsonKey(name: "image_id")
  int? imageId;
  @JsonKey(name: "login_attempts")
  int loginAttempts;
  UserImage? image;
  List<Trophy>? trophies;

  StudentPreviewResponse({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    this.imageId,
    required this.loginAttempts,
    this.image,

    this.trophies,
  });

  factory StudentPreviewResponse.fromJson(Map<String, dynamic> json) =>
      _$StudentPreviewResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StudentPreviewResponseToJson(this);
}

@JsonSerializable()
class UserImage {
  int id;
  String filename;
  String url;

  @JsonKey(name: "mime_type")
  String mimeType;

  int size;

  @JsonKey(name: "created_at")
  DateTime createdAt;

  @JsonKey(name: "updated_at")
  DateTime updatedAt;

  UserImage({
    required this.id,
    required this.filename,
    required this.url,
    required this.mimeType,
    required this.size,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserImage.fromJson(Map<String, dynamic> json) =>
      _$UserImageFromJson(json);

  Map<String, dynamic> toJson() => _$UserImageToJson(this);
}

@JsonSerializable()
class FeaturedImage {
  int id;
  String filename;
  String url;

  @JsonKey(name: "mime_type")
  String mimeType;

  int size;

  @JsonKey(name: "created_at")
  DateTime createdAt;

  @JsonKey(name: "updated_at")
  DateTime updatedAt;

  FeaturedImage({
    required this.id,
    required this.filename,
    required this.url,
    required this.mimeType,
    required this.size,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FeaturedImage.fromJson(Map<String, dynamic> json) =>
      _$FeaturedImageFromJson(json);

  Map<String, dynamic> toJson() => _$FeaturedImageToJson(this);
}

@JsonSerializable()
class Trophy {
  int id;
  String name;

  @JsonKey(name: "user_id")
  int userId;

  @JsonKey(name: "image_id")
  int imageId;

  @JsonKey(name: "created_at")
  DateTime createdAt;

  @JsonKey(name: "updated_at")
  DateTime updatedAt;

  TrophyImage image;

  Trophy({
    required this.id,
    required this.name,
    required this.userId,
    required this.imageId,
    required this.createdAt,
    required this.updatedAt,
    required this.image,
  });

  factory Trophy.fromJson(Map<String, dynamic> json) => _$TrophyFromJson(json);

  Map<String, dynamic> toJson() => _$TrophyToJson(this);
}

@JsonSerializable()
class TrophyImage {
  int id;
  String filename;
  String url;

  @JsonKey(name: "mime_type")
  String mimeType;

  int size;

  @JsonKey(name: "created_at")
  DateTime createdAt;

  @JsonKey(name: "updated_at")
  DateTime updatedAt;

  TrophyImage({
    required this.id,
    required this.filename,
    required this.url,
    required this.mimeType,
    required this.size,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TrophyImage.fromJson(Map<String, dynamic> json) =>
      _$TrophyImageFromJson(json);

  Map<String, dynamic> toJson() => _$TrophyImageToJson(this);
}
