import 'package:json_annotation/json_annotation.dart';

part 'media.g.dart';

@JsonSerializable()
class Media {
  final int id;
  final String filename;
  final String url;

  @JsonKey(name: 'mime_type')
  final String? mimeType;

  final int? size;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  Media({
    required this.id,
    required this.filename,
    required this.url,
    this.mimeType,
    this.size,
    this.createdAt,
    this.updatedAt,
  });

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);
  Map<String, dynamic> toJson() => _$MediaToJson(this);
}
