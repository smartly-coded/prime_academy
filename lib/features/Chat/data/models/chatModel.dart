class MessageModel {
  final int id;
  final int senderId;
  final String senderRole; // teacher or student
  final String message;
  final String? mediaUrl;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.senderRole,
    required this.message,
    this.mediaUrl,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      senderId: json['sender_id'],
      senderRole: json['sender_role'] == 1 ? 'teacher' : 'student',
      message: json['message'] ?? '',
      mediaUrl: json['media']?['url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
