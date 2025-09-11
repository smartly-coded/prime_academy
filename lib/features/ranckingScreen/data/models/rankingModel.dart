class RankingModel {
  final int id;
  final String firstname;
  final String lastname;
  final int points;
  final int rank;
  final ImageModel? image;

  RankingModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.points,
    required this.rank,
    this.image,
  });

  factory RankingModel.fromJson(Map<String, dynamic> json) {
    return RankingModel(
      id: json['id'] ?? 0,
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      points: json['points'] ?? 0,
      rank: json['rank'] ?? 0,
      image: json['image'] != null ? ImageModel.fromJson(json['image']) : null,
    );
  }
}

class ImageModel {
  final int id;
  final String filename;
  final String url;
  final String? mimeType;
  final int? size;

  ImageModel({
    required this.id,
    required this.filename,
    required this.url,
    this.mimeType,
    this.size,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'] ?? 0,
      filename: json['filename'] ?? '',
      url: json['url'] ?? '',
      mimeType: json['mime_type'],
      size: json['size'],
    );
  }
}
