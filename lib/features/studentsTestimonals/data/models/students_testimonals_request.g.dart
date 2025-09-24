// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'students_testimonals_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentsTestimonalsRequest _$StudentsTestimonalsRequestFromJson(
  Map<String, dynamic> json,
) => StudentsTestimonalsRequest(
  courseId: (json['courseId'] as num).toInt(),
  content: json['content'] as String,
);

Map<String, dynamic> _$StudentsTestimonalsRequestToJson(
  StudentsTestimonalsRequest instance,
) => <String, dynamic>{
  'courseId': instance.courseId,
  'content': instance.content,
};
