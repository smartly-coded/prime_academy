// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonDetailsResponse _$LessonDetailsResponseFromJson(
  Map<String, dynamic> json,
) => LessonDetailsResponse(
  id: (json['id'] as num).toInt(),
  itemId: (json['item_id'] as num).toInt(),
  title: json['title'] as String,
  theme: json['theme'] as String,
  accessWithoutEnrollment: json['access_without_enrollment'] as bool,
  videoId: (json['video_id'] as num?)?.toInt(),
  thumbnailId: (json['thumbnail_id'] as num?)?.toInt(),
  videoLength: (json['video_length'] as num).toInt(),
  externalUrl: json['external_url'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  thumbnail: json['thumbnail'] as String?,
  videoSource: json['video_source'] as String?,
  groupedQuestions: json['groupedQuestions'] as Map<String, dynamic>,
  chatId: (json['chatId'] as num).toInt(),
  isEnrolled: json['isEnrolled'] as bool,
  ranges: Ranges.fromJson(json['ranges'] as Map<String, dynamic>),
  watched: json['watched'] as bool,
  hasTestimonial: json['hasTestimonial'] as bool,
);

Map<String, dynamic> _$LessonDetailsResponseToJson(
  LessonDetailsResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'item_id': instance.itemId,
  'title': instance.title,
  'theme': instance.theme,
  'access_without_enrollment': instance.accessWithoutEnrollment,
  'video_id': instance.videoId,
  'thumbnail_id': instance.thumbnailId,
  'video_length': instance.videoLength,
  'external_url': instance.externalUrl,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'thumbnail': instance.thumbnail,
  'video_source': instance.videoSource,
  'groupedQuestions': instance.groupedQuestions,
  'chatId': instance.chatId,
  'isEnrolled': instance.isEnrolled,
  'ranges': instance.ranges,
  'watched': instance.watched,
  'hasTestimonial': instance.hasTestimonial,
};

Ranges _$RangesFromJson(Map<String, dynamic> json) =>
    Ranges(watchedRanges: json['watched_ranges'] as List<dynamic>);

Map<String, dynamic> _$RangesToJson(Ranges instance) => <String, dynamic>{
  'watched_ranges': instance.watchedRanges,
};

LessonQuestion _$LessonQuestionFromJson(Map<String, dynamic> json) =>
    LessonQuestion(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      lessonId: (json['lesson_id'] as num).toInt(),
      timestamp: (json['timestamp'] as num).toInt(),
      type: $enumDecode(_$QuestionTypeEnumMap, json['type']),
      allowMultipleAnswers: json['allow_multiple_answers'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      answers:
          (json['answers'] as List<dynamic>?)
              ?.map((e) => Answer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      correctAnswers:
          (json['correct_answers'] as List<dynamic>?)
              ?.map((e) => CorrectAnswer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      sortDirection: $enumDecodeNullable(
        _$SortDirectionEnumMap,
        json['sortDirection'],
      ),
      prompts:
          (json['prompts'] as List<dynamic>?)
              ?.map((e) => Prompt.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$LessonQuestionToJson(
  LessonQuestion instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'lesson_id': instance.lessonId,
  'timestamp': instance.timestamp,
  'type': _$QuestionTypeEnumMap[instance.type]!,
  'allow_multiple_answers': instance.allowMultipleAnswers,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'answers': instance.answers.map((e) => e.toJson()).toList(),
  'correct_answers': instance.correctAnswers.map((e) => e.toJson()).toList(),
  'sortDirection': _$SortDirectionEnumMap[instance.sortDirection],
  'prompts': instance.prompts.map((e) => e.toJson()).toList(),
};

const _$QuestionTypeEnumMap = {
  QuestionType.mcq: 'mcq',
  QuestionType.essay: 'essay',
  QuestionType.fillBlank: 'fill-blank',
  QuestionType.match: 'match',
  QuestionType.reOrder: 're-order',
};

const _$SortDirectionEnumMap = {
  SortDirection.asc: 'asc',
  SortDirection.desc: 'desc',
};

AnswerImage _$AnswerImageFromJson(Map<String, dynamic> json) => AnswerImage(
  id: (json['id'] as num?)?.toInt(),
  filename: json['filename'] as String?,
  url: json['url'] as String?,
  mimeType: json['mime_type'] as String?,
  size: (json['size'] as num?)?.toInt(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$AnswerImageToJson(AnswerImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'filename': instance.filename,
      'url': instance.url,
      'mime_type': instance.mimeType,
      'size': instance.size,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

Answer _$AnswerFromJson(Map<String, dynamic> json) => Answer(
  id: (json['id'] as num).toInt(),
  questionId: (json['question_id'] as num).toInt(),
  title: json['title'] as String,
  image: json['image'] == null
      ? null
      : AnswerImage.fromJson(json['image'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$AnswerToJson(Answer instance) => <String, dynamic>{
  'id': instance.id,
  'question_id': instance.questionId,
  'title': instance.title,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'image': instance.image,
};

CorrectAnswer _$CorrectAnswerFromJson(Map<String, dynamic> json) =>
    CorrectAnswer(
      id: (json['id'] as num).toInt(),
      questionId: (json['question_id'] as num).toInt(),
      answerId: (json['answer_id'] as num?)?.toInt(),
      title: json['title'] as String?,
      order: (json['order'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$CorrectAnswerToJson(CorrectAnswer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question_id': instance.questionId,
      'answer_id': instance.answerId,
      'title': instance.title,
      'order': instance.order,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

Prompt _$PromptFromJson(Map<String, dynamic> json) => Prompt(
  id: (json['id'] as num).toInt(),
  questionId: (json['question_id'] as num).toInt(),
  title: json['title'] as String,
  imageId: (json['image_id'] as num?)?.toInt(),
  image: json['image'] == null
      ? null
      : ImageModel.fromJson(json['image'] as Map<String, dynamic>),
  response: json['response'] == null
      ? null
      : ResponseModel.fromJson(json['response'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$PromptToJson(Prompt instance) => <String, dynamic>{
  'id': instance.id,
  'question_id': instance.questionId,
  'title': instance.title,
  'image_id': instance.imageId,
  'image': instance.image?.toJson(),
  'response': instance.response?.toJson(),
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

ResponseModel _$ResponseModelFromJson(Map<String, dynamic> json) =>
    ResponseModel(
      id: (json['id'] as num).toInt(),
      questionId: (json['question_id'] as num).toInt(),
      promptId: (json['prompt_id'] as num).toInt(),
      title: json['title'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ResponseModelToJson(ResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question_id': instance.questionId,
      'prompt_id': instance.promptId,
      'title': instance.title,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

ImageModel _$ImageModelFromJson(Map<String, dynamic> json) => ImageModel(
  id: (json['id'] as num).toInt(),
  filename: json['filename'] as String,
  url: json['url'] as String,
  mimeType: json['mime_type'] as String,
  size: (json['size'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ImageModelToJson(ImageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'filename': instance.filename,
      'url': instance.url,
      'mime_type': instance.mimeType,
      'size': instance.size,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
