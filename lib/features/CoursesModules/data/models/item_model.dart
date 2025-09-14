enum LessonType { video, link }

class ItemModel {
  final int id;
  final LessonType type;
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
      // جاي من كائن lesson
      extractedTitle = json['lesson']['title'] ?? '';
      if (json['lesson']['video_length'] != null) {
        final secs = json['lesson']['video_length'] as int;
        extractedTime = "${(secs ~/ 60)} min"; // مثلا بالدقايق
      }
    } else if (json['external_source'] != null) {
      // جاي من external_source
      extractedTitle = json['external_source']['title'] ?? '';
    }

    return ItemModel(
      id: json['id'],
      type: itemType,
      title: extractedTitle,
      time: extractedTime,
    );
  }
}
