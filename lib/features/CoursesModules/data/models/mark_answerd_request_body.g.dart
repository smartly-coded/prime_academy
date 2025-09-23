// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_answerd_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkAnsweredRequestBody _$MarkAnsweredRequestBodyFromJson(
  Map<String, dynamic> json,
) => MarkAnsweredRequestBody(
  lessonId: (json['lessonId'] as num).toInt(),
  questionType: json['type'] as String,
  answers: json['answers'],
);

Map<String, dynamic> _$MarkAnsweredRequestBodyToJson(
  MarkAnsweredRequestBody instance,
) => <String, dynamic>{
  'lessonId': instance.lessonId,
  'type': instance.questionType,
  'answers': instance.answers,
};
