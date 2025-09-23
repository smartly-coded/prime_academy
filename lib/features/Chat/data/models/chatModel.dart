

class MessageModel {
  final int? id;
  final int? senderId;
  final String senderRole;
  final String message;
  final String? mediaUrl;
  final String? mediaType; 
  final String? filename;
  final String? mediaKey; 
  final DateTime? createdAt;

  MessageModel({
    this.id,
    this.senderId,
    required this.senderRole,
    required this.message,
    this.mediaUrl,
    this.mediaType,
    this.filename,
    this.mediaKey, 
    this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final media = json['media'];
    return MessageModel(
      id: json['id'] as int?,
      senderId: json['sender_id'] as int?,
      senderRole: (json['sender_role']?.toString() == "1")
          ? 'student'
          : 'teacher',
      message: json['message'] ?? '',
      mediaUrl: media?['url'],
      mediaType: media?['mime_type'],
      filename: media?['filename'],
      mediaKey: media?['key'], 
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }
}
