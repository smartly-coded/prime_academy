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
