class MessageModel {
  final int? id;
  final int? chatId;
  final int? senderId;
  final int? senderRole;
  final String message;
  final int? mediaId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final MediaModel? media;

  MessageModel({
    this.id,
    this.chatId,
    this.senderId,
    this.senderRole,
    required this.message,
    this.mediaId,
    this.createdAt,
    this.updatedAt,
    this.media,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as int?,
      chatId: json['chat_id'] as int?,
      senderId: json['sender_id'] as int?,
      senderRole: json['sender_role'] as int?,
      message: json['message'] ?? '',
      mediaId: json['media_id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      media: json['media'] != null ? MediaModel.fromJson(json['media']) : null,
    );
  }

  // Helper getters for backward compatibility
  String get senderRoleString => senderRole == 1 ? 'student' : 'teacher';
  String? get mediaUrl => media?.url;
  String? get mediaType => _getMediaTypeFromMimeType(media?.mimeType);
  String? get name => media?.filename;

  // Helper method to determine media type from mime type
  String? _getMediaTypeFromMimeType(String? mimeType) {
    if (mimeType == null) return null;

    if (mimeType.startsWith('image/')) return 'image';
    if (mimeType.startsWith('audio/')) return 'audio';
    if (mimeType.startsWith('video/')) return 'video';
    if (mimeType == 'application/pdf') return 'file';
    return 'file'; // default to file for other types
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'sender_id': senderId,
      'sender_role': senderRole,
      'message': message,
      'media_id': mediaId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'media': media?.toJson(),
    };
  }
}

class MediaModel {
  final int? id;
  final String? filename;
  final String? url;
  final String? mimeType;
  final int? size;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MediaModel({
    this.id,
    this.filename,
    this.url,
    this.mimeType,
    this.size,
    this.createdAt,
    this.updatedAt,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json['id'] as int?,
      filename: json['filename'] as String?,
      url: json['url'] as String?,
      mimeType: json['mime_type'] as String?,
      size: json['size'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filename': filename,
      'url': url,
      'mime_type': mimeType,
      'size': size,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
