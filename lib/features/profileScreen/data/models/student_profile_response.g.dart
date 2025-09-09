// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentProfileResponse _$StudentProfileResponseFromJson(
  Map<String, dynamic> json,
) => StudentProfileResponse(
  id: (json['id'] as num?)?.toInt(),
  firstname: json['firstname'] as String?,
  lastname: json['lastname'] as String?,
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  userId: (json['user_id'] as num?)?.toInt(),
  imageId: (json['image_id'] as num?)?.toInt(),
  loginAttempts: (json['login_attempts'] as num?)?.toInt(),
  image: json['image'] == null
      ? null
      : UserImage.fromJson(json['image'] as Map<String, dynamic>),
  courses: (json['courses'] as List<dynamic>?)
      ?.map((e) => Courses.fromJson(e as Map<String, dynamic>))
      .toList(),
  trophies: (json['trophies'] as List<dynamic>?)
      ?.map((e) => Trophy.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StudentProfileResponseToJson(
  StudentProfileResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'firstname': instance.firstname,
  'lastname': instance.lastname,
  'updated_at': instance.updatedAt?.toIso8601String(),
  'created_at': instance.createdAt?.toIso8601String(),
  'user_id': instance.userId,
  'image_id': instance.imageId,
  'login_attempts': instance.loginAttempts,
  'image': instance.image,
  'courses': instance.courses,
  'trophies': instance.trophies,
};

UserImage _$UserImageFromJson(Map<String, dynamic> json) => UserImage(
  id: (json['id'] as num?)?.toInt(),
  url: json['url'] as String?,
  filename: json['filename'] as String?,
  mimeType: json['mime_type'] as String?,
  size: (json['size'] as num?)?.toInt(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserImageToJson(UserImage instance) => <String, dynamic>{
  'id': instance.id,
  'url': instance.url,
  'filename': instance.filename,
  'mime_type': instance.mimeType,
  'size': instance.size,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

Courses _$CoursesFromJson(Map<String, dynamic> json) => Courses(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  featuredImage: json['featured_image'] == null
      ? null
      : FeaturedImage.fromJson(json['featured_image'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CoursesToJson(Courses instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'featured_image': instance.featuredImage,
};

FeaturedImage _$FeaturedImageFromJson(Map<String, dynamic> json) =>
    FeaturedImage(
      id: (json['id'] as num?)?.toInt(),
      filename: json['filename'] as String?,
      url: json['url'] as String?,
      mimeType: json['mime_type'] as String?,
      size: (json['size'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$FeaturedImageToJson(FeaturedImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'filename': instance.filename,
      'url': instance.url,
      'mime_type': instance.mimeType,
      'size': instance.size,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

Trophy _$TrophyFromJson(Map<String, dynamic> json) => Trophy(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  userId: (json['user_id'] as num?)?.toInt(),
  imageId: (json['image_id'] as num?)?.toInt(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  image: json['image'] == null
      ? null
      : TrophyImage.fromJson(json['image'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TrophyToJson(Trophy instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'user_id': instance.userId,
  'image_id': instance.imageId,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'image': instance.image,
};

TrophyImage _$TrophyImageFromJson(Map<String, dynamic> json) => TrophyImage(
  id: (json['id'] as num?)?.toInt(),
  filename: json['filename'] as String?,
  url: json['url'] as String?,
  mimeType: json['mime_type'] as String?,
  size: (json['size'] as num?)?.toInt(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$TrophyImageToJson(TrophyImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'filename': instance.filename,
      'url': instance.url,
      'mime_type': instance.mimeType,
      'size': instance.size,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
