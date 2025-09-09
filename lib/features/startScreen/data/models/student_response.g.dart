// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentsResponse _$StudentsResponseFromJson(Map<String, dynamic> json) =>
    StudentsResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => Student.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StudentsResponseToJson(StudentsResponse instance) =>
    <String, dynamic>{'data': instance.data, 'meta': instance.meta};

Student _$StudentFromJson(Map<String, dynamic> json) => Student(
  id: (json['id'] as num).toInt(),
  firstname: json['firstname'] as String,
  lastname: json['lastname'] as String,
  email: json['email'] as String,
  username: json['username'] as String,
  points: (json['points'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  image: UserImage.fromJson(json['image'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
  'id': instance.id,
  'firstname': instance.firstname,
  'lastname': instance.lastname,
  'email': instance.email,
  'username': instance.username,
  'points': instance.points,
  'created_at': instance.createdAt.toIso8601String(),
  'image': instance.image,
};

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
  currentPage: (json['current_page'] as num).toInt(),
  lastPage: (json['last_page'] as num).toInt(),
  total: (json['total'] as num).toInt(),
);

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
  'current_page': instance.currentPage,
  'last_page': instance.lastPage,
  'total': instance.total,
};

UserImage _$UserImageFromJson(Map<String, dynamic> json) => UserImage(
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
  'url': instance.url,
  'filename': instance.filename,
  'mime_type': instance.mimeType,
  'size': instance.size,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
