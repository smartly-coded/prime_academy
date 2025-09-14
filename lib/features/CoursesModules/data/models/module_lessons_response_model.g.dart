// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_lessons_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModuleLessonsResponse _$ModuleLessonsResponseFromJson(
  Map<String, dynamic> json,
) => ModuleLessonsResponse(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  courseId: (json['course_id'] as num).toInt(),
  special: json['special'] as bool,
  description: json['description'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
      .toList(),
  materials: (json['materials'] as List<dynamic>?)
      ?.map((e) => MaterialData.fromJson(e as Map<String, dynamic>))
      .toList(),
  teacher: Teacher.fromJson(json['teacher'] as Map<String, dynamic>),
  isEnrolled: json['isEnrolled'] as bool,
);

Map<String, dynamic> _$ModuleLessonsResponseToJson(
  ModuleLessonsResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'course_id': instance.courseId,
  'special': instance.special,
  'description': instance.description,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'items': instance.items?.map((e) => e.toJson()).toList(),
  'materials': instance.materials?.map((e) => e.toJson()).toList(),
  'teacher': instance.teacher.toJson(),
  'isEnrolled': instance.isEnrolled,
};

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
  id: (json['id'] as num).toInt(),
  moduleId: (json['module_id'] as num).toInt(),
  itemType: json['item_type'] as String,
  lessonId: (json['lesson_id'] as num?)?.toInt(),
  externalSourceId: (json['external_source_id'] as num?)?.toInt(),
  order: (json['order'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  externalSource: json['external_source'] == null
      ? null
      : ExternalSource.fromJson(
          json['external_source'] as Map<String, dynamic>,
        ),
  lesson: json['lesson'] == null
      ? null
      : Lesson.fromJson(json['lesson'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
  'id': instance.id,
  'module_id': instance.moduleId,
  'item_type': instance.itemType,
  'lesson_id': instance.lessonId,
  'external_source_id': instance.externalSourceId,
  'order': instance.order,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'external_source': instance.externalSource,
  'lesson': instance.lesson,
};

Lesson _$LessonFromJson(Map<String, dynamic> json) => Lesson(
  id: (json['id'] as num).toInt(),
  itemId: (json['item_id'] as num).toInt(),
  title: json['title'] as String,
  videoLength: (json['video_length'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  accessWithoutEnrollment: json['access_without_enrollment'] as bool,
  externalUrl: json['external_url'] as String?,
  watched: json['watched'] as bool,
);

Map<String, dynamic> _$LessonToJson(Lesson instance) => <String, dynamic>{
  'id': instance.id,
  'item_id': instance.itemId,
  'title': instance.title,
  'video_length': instance.videoLength,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'access_without_enrollment': instance.accessWithoutEnrollment,
  'external_url': instance.externalUrl,
  'watched': instance.watched,
};

ExternalSource _$ExternalSourceFromJson(Map<String, dynamic> json) =>
    ExternalSource(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      itemId: (json['item_id'] as num).toInt(),
      url: json['url'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ExternalSourceToJson(ExternalSource instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'item_id': instance.itemId,
      'url': instance.url,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

MaterialData _$MaterialDataFromJson(Map<String, dynamic> json) => MaterialData(
  id: (json['id'] as num).toInt(),
  moduleId: (json['module_id'] as num).toInt(),
  accessWithoutEnrollment: json['access_without_enrollment'] as bool,
  fileData: FileData.fromJson(json['fileData'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MaterialDataToJson(MaterialData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'module_id': instance.moduleId,
      'access_without_enrollment': instance.accessWithoutEnrollment,
      'fileData': instance.fileData.toJson(),
    };

FileData _$FileDataFromJson(Map<String, dynamic> json) => FileData(
  id: (json['id'] as num).toInt(),
  filename: json['filename'] as String,
  url: json['url'] as String,
  mimeType: json['mime_type'] as String,
  size: (json['size'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$FileDataToJson(FileData instance) => <String, dynamic>{
  'id': instance.id,
  'filename': instance.filename,
  'url': instance.url,
  'mime_type': instance.mimeType,
  'size': instance.size,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

Teacher _$TeacherFromJson(Map<String, dynamic> json) => Teacher(
  id: (json['id'] as num).toInt(),
  firstname: json['firstname'] as String,
  lastname: json['lastname'] as String,
  role: (json['role'] as num).toInt(),
  image: TeacherImage.fromJson(json['image'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TeacherToJson(Teacher instance) => <String, dynamic>{
  'id': instance.id,
  'firstname': instance.firstname,
  'lastname': instance.lastname,
  'role': instance.role,
  'image': instance.image.toJson(),
};

TeacherImage _$TeacherImageFromJson(Map<String, dynamic> json) => TeacherImage(
  id: (json['id'] as num).toInt(),
  filename: json['filename'] as String,
  url: json['url'] as String,
  mimeType: json['mime_type'] as String,
  size: (json['size'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$TeacherImageToJson(TeacherImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'filename': instance.filename,
      'url': instance.url,
      'mime_type': instance.mimeType,
      'size': instance.size,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
