// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Media _$MediaFromJson(Map<String, dynamic> json) => Media(
  id: (json['id'] as num).toInt(),
  filename: json['filename'] as String,
  url: json['url'] as String,
  mimeType: json['mime_type'] as String?,
  size: (json['size'] as num?)?.toInt(),
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$MediaToJson(Media instance) => <String, dynamic>{
  'id': instance.id,
  'filename': instance.filename,
  'url': instance.url,
  'mime_type': instance.mimeType,
  'size': instance.size,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
