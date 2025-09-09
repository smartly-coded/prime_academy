import 'package:json_annotation/json_annotation.dart';

part 'certificate_response.g.dart';

@JsonSerializable()
class CertificateResponse {
  final int id;
  final String? description;
  @JsonKey(name: "image_id")
  final int imageId;
  @JsonKey(name: "created_at")
  final DateTime createdAt;
  @JsonKey(name: "updated_at")
  final DateTime updatedAt;
  final ImageData image;

  CertificateResponse({
    required this.id,
    this.description,
    required this.imageId,
    required this.createdAt,
    required this.updatedAt,
    required this.image,
  });

  factory CertificateResponse.fromJson(Map<String, dynamic> json) =>
      _$CertificateResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CertificateResponseToJson(this);
}

@JsonSerializable()
class ImageData {
  final int id;
  final String filename;
  final String url;
  @JsonKey(name: "mime_type")
  final String mimeType;
  final int size;
  @JsonKey(name: "created_at")
  final DateTime createdAt;
  @JsonKey(name: "updated_at")
  final DateTime updatedAt;

  ImageData({
    required this.id,
    required this.filename,
    required this.url,
    required this.mimeType,
    required this.size,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) =>
      _$ImageDataFromJson(json);
}
