import 'package:json_annotation/json_annotation.dart';
import 'package:prime_academy/features/CoursesModules/data/models/lesson_type.dart';
part 'module_lessons_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ModuleLessonsResponse {
  final int id;
  final String title;
  @JsonKey(name: 'course_id')
  final int courseId;
  final bool special;
  final String? description;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final List<Item>? items;
  final List<MaterialData>? materials;
  final Teacher teacher;
  @JsonKey(name: 'isEnrolled')
  final bool isEnrolled;

  ModuleLessonsResponse({
    required this.id,
    required this.title,
    required this.courseId,
    required this.special,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.items,
    this.materials,
    required this.teacher,
    required this.isEnrolled,
  });

  factory ModuleLessonsResponse.fromJson(Map<String, dynamic> json) =>
      _$ModuleLessonsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ModuleLessonsResponseToJson(this);
}

@JsonSerializable()
class Item {
  final int id;
  @JsonKey(name: 'module_id')
  final int moduleId;
  @JsonKey(name: 'item_type')
  final LessonType itemType;
  @JsonKey(name: 'lesson_id')
  final int? lessonId;
  @JsonKey(name: 'external_source_id')
  final int? externalSourceId;
  final int order;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'external_source')
  final ExternalSource? externalSource;
  final Lesson? lesson;

  Item({
    required this.id,
    required this.moduleId,
    required this.itemType,
    this.lessonId,
    this.externalSourceId,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
    this.externalSource,
    this.lesson,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);
}

@JsonSerializable()
class Lesson {
  final int id;
  @JsonKey(name: 'item_id')
  final int itemId;
  final String title;
  @JsonKey(name: 'video_length')
  final int videoLength;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'access_without_enrollment')
  final bool accessWithoutEnrollment;
  @JsonKey(name: 'external_url')
  final String? externalUrl;
  final bool watched;
  final String? thumbnail;

  Lesson({
    required this.id,
    required this.itemId,
    required this.title,
    required this.videoLength,
    required this.createdAt,
    required this.updatedAt,
    required this.accessWithoutEnrollment,
    this.externalUrl,
    required this.watched,
    this.thumbnail,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
  Map<String, dynamic> toJson() => _$LessonToJson(this);
}

@JsonSerializable()
class ExternalSource {
  final int id;
  final String title;
  @JsonKey(name: 'item_id')
  final int itemId;
  final String url;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  ExternalSource({
    required this.id,
    required this.title,
    required this.itemId,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExternalSource.fromJson(Map<String, dynamic> json) =>
      _$ExternalSourceFromJson(json);
  Map<String, dynamic> toJson() => _$ExternalSourceToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MaterialData {
  final int id;
  @JsonKey(name: 'module_id')
  final int moduleId;
  @JsonKey(name: 'access_without_enrollment')
  final bool accessWithoutEnrollment;
  @JsonKey(name: 'fileData')
  final FileData fileData;

  MaterialData({
    required this.id,
    required this.moduleId,
    required this.accessWithoutEnrollment,
    required this.fileData,
  });

  factory MaterialData.fromJson(Map<String, dynamic> json) =>
      _$MaterialDataFromJson(json);
  Map<String, dynamic> toJson() => _$MaterialDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class FileData {
  final int id;
  final String filename;
  final String url;
  @JsonKey(name: 'mime_type')
  final String mimeType;
  final int size;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  FileData({
    required this.id,
    required this.filename,
    required this.url,
    required this.mimeType,
    required this.size,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FileData.fromJson(Map<String, dynamic> json) =>
      _$FileDataFromJson(json);
  Map<String, dynamic> toJson() => _$FileDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Teacher {
  final int id;
  final String firstname;
  final String lastname;
  final int role;
  final TeacherImage image;

  Teacher({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.role,
    required this.image,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) =>
      _$TeacherFromJson(json);
  Map<String, dynamic> toJson() => _$TeacherToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TeacherImage {
  final int id;
  final String filename;
  final String url;
  @JsonKey(name: 'mime_type')
  final String mimeType;
  final int size;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  TeacherImage({
    required this.id,
    required this.filename,
    required this.url,
    required this.mimeType,
    required this.size,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TeacherImage.fromJson(Map<String, dynamic> json) =>
      _$TeacherImageFromJson(json);
  Map<String, dynamic> toJson() => _$TeacherImageToJson(this);
}
