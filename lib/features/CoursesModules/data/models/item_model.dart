import 'package:prime_academy/features/CoursesModules/data/models/lesson_type.dart';

class ItemModel {
  final int id;
  final LessonType type; // Enum
  final String title;
  final String? time;

  ItemModel({
    required this.id,
    required this.type,
    required this.title,
    this.time,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    final itemType = json['item_type'] == 'lesson'
        ? LessonType.video
        : LessonType.link;

    String extractedTitle = '';
    String? extractedTime;

    if (json['lesson'] != null) {
      extractedTitle = json['lesson']['title'] ?? '';
      if (json['lesson']['video_length'] != null) {
        final secs = json['lesson']['video_length'] as int;
        extractedTime = "${(secs ~/ 60)} min";
      }
    } else if (json['external_source'] != null) {
      extractedTitle = json['external_source']['title'] ?? '';
    }

    return ItemModel(
      id: json['id'],
      type: itemType, // Enum هنا
      title: extractedTitle,
      time: extractedTime,
    );
  }
}
