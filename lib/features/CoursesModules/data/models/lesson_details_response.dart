// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'lesson_details_response.g.dart';

@JsonSerializable()
class LessonDetailsResponse {
  final int id;

  @JsonKey(name: 'item_id')
  final int itemId;

  final String title;
  final String theme;

  @JsonKey(name: 'access_without_enrollment')
  final bool accessWithoutEnrollment;

  @JsonKey(name: 'video_id')
  final int? videoId;

  @JsonKey(name: 'thumbnail_id')
  final int? thumbnailId;

  @JsonKey(name: 'video_length')
  final int videoLength;

  @JsonKey(name: 'external_url')
  final String? externalUrl;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  final String? thumbnail;

  @JsonKey(name: 'video_source')
  final String? videoSource;

  final Map<String, dynamic> groupedQuestions;

  final int chatId;

  final bool isEnrolled;

  final Ranges ranges;

  final bool watched;

  final bool hasTestimonial;

  LessonDetailsResponse({
    required this.id,
    required this.itemId,
    required this.title,
    required this.theme,
    required this.accessWithoutEnrollment,
    this.videoId,
    this.thumbnailId,
    required this.videoLength,
    this.externalUrl,
    required this.createdAt,
    required this.updatedAt,
    this.thumbnail,
    this.videoSource,
    required this.groupedQuestions,
    required this.chatId,
    required this.isEnrolled,
    required this.ranges,
    required this.watched,
    required this.hasTestimonial,
  });

  factory LessonDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$LessonDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LessonDetailsResponseToJson(this);
}

@JsonSerializable()
class Ranges {
  @JsonKey(name: 'watched_ranges')
  final List<dynamic> watchedRanges;

  Ranges({required this.watchedRanges});

  factory Ranges.fromJson(Map<String, dynamic> json) => _$RangesFromJson(json);

  Map<String, dynamic> toJson() => _$RangesToJson(this);
}

enum QuestionType {
  @JsonValue('mcq')
  mcq,
  @JsonValue('essay')
  essay,
  @JsonValue('fill-blank')
  fillBlank,
  @JsonValue('match')
  match,
  @JsonValue('re-order')
  reOrder,
}

@JsonSerializable(explicitToJson: true)
class LessonQuestion {
  final int id;
  final String title;
  @JsonKey(name: 'lesson_id')
  final int lessonId;
  final int timestamp;
  final QuestionType type;
  @JsonKey(name: 'allow_multiple_answers', defaultValue: false)
  final bool allowMultipleAnswers;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'answers', defaultValue: [])
  final List<Answer> answers;

  @JsonKey(name: 'correct_answers', defaultValue: [])
  final List<CorrectAnswer> correctAnswers;
  @JsonKey(name: 'sortDirection')
  final SortDirection? sortDirection;
  @JsonKey(name: 'prompts', defaultValue: [])
  final List<Prompt> prompts;

  LessonQuestion({
    required this.id,
    required this.title,
    required this.lessonId,
    required this.timestamp,
    required this.type,
    required this.allowMultipleAnswers,
    required this.createdAt,
    required this.updatedAt,
    required this.answers,
    required this.correctAnswers,
    this.sortDirection,
    required this.prompts,
  });

  factory LessonQuestion.fromJson(Map<String, dynamic> json) =>
      _$LessonQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$LessonQuestionToJson(this);
}

@JsonSerializable()
class Answer {
  final int id;
  @JsonKey(name: 'question_id')
  final int questionId;
  final String title;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final String? image;

  Answer({
    required this.id,
    required this.questionId,
    required this.title,
    this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerToJson(this);
}

@JsonSerializable()
class CorrectAnswer {
  final int id;
  @JsonKey(name: 'question_id')
  final int questionId;
  @JsonKey(name: 'answer_id')
  final int? answerId;

  // Essay هيكون عنده title
  final String? title;
  final int? order;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  CorrectAnswer({
    required this.id,
    required this.questionId,
    this.answerId,
    this.title,
    this.order,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CorrectAnswer.fromJson(Map<String, dynamic> json) =>
      _$CorrectAnswerFromJson(json);

  Map<String, dynamic> toJson() => _$CorrectAnswerToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Prompt {
  final int id;

  @JsonKey(name: 'question_id')
  final int questionId;

  final String title;

  @JsonKey(name: 'image_id')
  final int? imageId;

  final ImageModel? image;
  final ResponseModel? response;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Prompt({
    required this.id,
    required this.questionId,
    required this.title,
    this.imageId,
    this.image,
    this.response,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Prompt.fromJson(Map<String, dynamic> json) => _$PromptFromJson(json);

  Map<String, dynamic> toJson() => _$PromptToJson(this);
}

@JsonSerializable()
class ResponseModel {
  final int id;

  @JsonKey(name: 'question_id')
  final int questionId;

  @JsonKey(name: 'prompt_id')
  final int promptId;

  final String title;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  ResponseModel({
    required this.id,
    required this.questionId,
    required this.promptId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseModelToJson(this);
}

enum SortDirection {
  @JsonValue('asc')
  asc,

  @JsonValue('desc')
  desc,
}

@JsonSerializable()
class ImageModel {
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

  ImageModel({
    required this.id,
    required this.filename,
    required this.url,
    required this.mimeType,
    required this.size,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) =>
      _$ImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImageModelToJson(this);
}
