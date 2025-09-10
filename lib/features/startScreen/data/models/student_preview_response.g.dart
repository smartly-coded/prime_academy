// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_preview_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentPreviewResponse _$StudentPreviewResponseFromJson(
  Map<String, dynamic> json,
) => StudentPreviewResponse(
  id: (json['id'] as num).toInt(),
  firstname: json['firstname'] as String,
  lastname: json['lastname'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  userId: (json['user_id'] as num).toInt(),
  imageId: (json['image_id'] as num?)?.toInt(),
  loginAttempts: (json['login_attempts'] as num).toInt(),
  image: json['image'] == null
      ? null
      : UserImage.fromJson(json['image'] as Map<String, dynamic>),
  trophies: (json['trophies'] as List<dynamic>?)
      ?.map((e) => Trophy.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StudentPreviewResponseToJson(
  StudentPreviewResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'firstname': instance.firstname,
  'lastname': instance.lastname,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'user_id': instance.userId,
  'image_id': instance.imageId,
  'login_attempts': instance.loginAttempts,
  'image': instance.image,
  'trophies': instance.trophies,
};

UserImage _$UserImageFromJson(Map<String, dynamic> json) => UserImage(
  id: (json['id'] as num).toInt(),
  filename: json['filename'] as String,
  url: json['url'] as String,
  mimeType: json['mime_type'] as String,
  size: (json['size'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserImageToJson(UserImage instance) => <String, dynamic>{
  'id': instance.id,
  'filename': instance.filename,
  'url': instance.url,
  'mime_type': instance.mimeType,
  'size': instance.size,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

FeaturedImage _$FeaturedImageFromJson(Map<String, dynamic> json) =>
    FeaturedImage(
      id: (json['id'] as num).toInt(),
      filename: json['filename'] as String,
      url: json['url'] as String,
      mimeType: json['mime_type'] as String,
      size: (json['size'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$FeaturedImageToJson(FeaturedImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'filename': instance.filename,
      'url': instance.url,
      'mime_type': instance.mimeType,
      'size': instance.size,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

Trophy _$TrophyFromJson(Map<String, dynamic> json) => Trophy(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  userId: (json['user_id'] as num).toInt(),
  imageId: (json['image_id'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  image: TrophyImage.fromJson(json['image'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TrophyToJson(Trophy instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'user_id': instance.userId,
  'image_id': instance.imageId,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'image': instance.image,
};

TrophyImage _$TrophyImageFromJson(Map<String, dynamic> json) => TrophyImage(
  id: (json['id'] as num).toInt(),
  filename: json['filename'] as String,
  url: json['url'] as String,
  mimeType: json['mime_type'] as String,
  size: (json['size'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$TrophyImageToJson(TrophyImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'filename': instance.filename,
      'url': instance.url,
      'mime_type': instance.mimeType,
      'size': instance.size,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
