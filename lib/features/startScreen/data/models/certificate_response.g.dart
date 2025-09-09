// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificate_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CertificateResponse _$CertificateResponseFromJson(Map<String, dynamic> json) =>
    CertificateResponse(
      id: (json['id'] as num).toInt(),
      description: json['description'] as String?,
      imageId: (json['image_id'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      image: ImageData.fromJson(json['image'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CertificateResponseToJson(
  CertificateResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'description': instance.description,
  'image_id': instance.imageId,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'image': instance.image,
};

ImageData _$ImageDataFromJson(Map<String, dynamic> json) => ImageData(
  id: (json['id'] as num).toInt(),
  filename: json['filename'] as String,
  url: json['url'] as String,
  mimeType: json['mime_type'] as String,
  size: (json['size'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ImageDataToJson(ImageData instance) => <String, dynamic>{
  'id': instance.id,
  'filename': instance.filename,
  'url': instance.url,
  'mime_type': instance.mimeType,
  'size': instance.size,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
