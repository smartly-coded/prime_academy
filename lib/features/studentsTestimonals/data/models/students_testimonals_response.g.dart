// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'students_testimonals_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentTestimonalsResponse _$StudentTestimonalsResponseFromJson(
  Map<String, dynamic> json,
) => StudentTestimonalsResponse(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  content: json['content'] as String,
  viewable: json['viewable'] as bool,
  image: json['image'] == null
      ? null
      : UserImage.fromJson(json['image'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$StudentTestimonalsResponseToJson(
  StudentTestimonalsResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'content': instance.content,
  'viewable': instance.viewable,
  'image': instance.image,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

UserImage _$UserImageFromJson(Map<String, dynamic> json) => UserImage(
  id: (json['id'] as num?)?.toInt(),
  url: json['url'] as String?,
  mimeType: json['mime_type'] as String?,
  filename: json['filename'] as String?,
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
  'mime_type': instance.mimeType,
  'filename': instance.filename,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
