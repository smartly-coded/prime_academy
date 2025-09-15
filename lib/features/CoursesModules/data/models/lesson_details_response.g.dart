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
