import 'package:json_annotation/json_annotation.dart';

part 'module_lessons_request_body.g.dart';

@JsonSerializable()
class ModuleLessonsRequestBody {
  final int courseId;

  ModuleLessonsRequestBody({required this.courseId});
  Map<String, dynamic> toJson() => _$ModuleLessonsRequestBodyToJson(this);
}
