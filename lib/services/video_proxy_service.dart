import 'dart:convert';
import 'package:http/http.dart' as http;

class VideoProxyService {
  final String baseUrl;

  VideoProxyService({required this.baseUrl});

  Future<bool> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      print('Health check failed: $e');
      return false;
    }
  }

  Future<VideoInfo?> getVideoInfo(String videoId) async {
    try {
      print('Fetching video info for: $videoId');
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/video/info/$videoId'),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return VideoInfo.fromJson(data);
      } else {
        print('Failed to get video info: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error getting video info: $e');
      return null;
    }
  }

  /// Get stream URL - Video streams through proxy server
  String getStreamUrl(String videoId, {String quality = '720'}) {
    return '$baseUrl/api/video/stream/$videoId?quality=$quality';
  }
}

class VideoInfo {
  final String id;
  final String title;
  final int duration;
  final String thumbnail;
  final String? description;

  VideoInfo({
    required this.id,
    required this.title,
    required this.duration,
    required this.thumbnail,
    this.description,
  });

  factory VideoInfo.fromJson(Map<String, dynamic> json) {
    return VideoInfo(
      id: json['id'] as String,
      title: json['title'] as String,
      duration: json['duration'] as int,
      thumbnail: json['thumbnail'] as String,
      description: json['description'] as String?,
    );
  }
}