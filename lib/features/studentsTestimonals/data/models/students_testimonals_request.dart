// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'students_testimonals_request.g.dart';

@JsonSerializable()
class StudentsTestimonalsRequest {
  final int courseId;
  final String content;
  StudentsTestimonalsRequest({required this.courseId, required this.content});

  Map<String, dynamic> toJson() => _$StudentsTestimonalsRequestToJson(this);
}
