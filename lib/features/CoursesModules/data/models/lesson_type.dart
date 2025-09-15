import 'package:json_annotation/json_annotation.dart';

enum LessonType {
  @JsonValue('lesson')
  video,

  @JsonValue('external_source')
  link,
}
