import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:prime_academy/core/networking/api_constants.dart';
import 'package:prime_academy/core/networking/dio_factory.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final Dio _dio = DioFactory.getDio();

  Future<List<NotificationModel>> getNotifications() async {
    final response = await _dio.get('${ApiConstants.apiBaseUrl}notifications');
    final data = response.data as List<dynamic>;
    return data.map((e) => NotificationModel.fromJson(e)).toList();
  }

  Future<void> markAsRead(List<int> ids) async {
    await _dio.patch(
      '${ApiConstants.apiBaseUrl}notifications',
      data: {"ids": ids},
    );
  }

  Stream<NotificationModel> connectSSE() async* {
    final response = await _dio.get<ResponseBody>(
      '${ApiConstants.apiBaseUrl}sse',
      options: Options(responseType: ResponseType.stream),
    );

    if (response.statusCode == 200) {
      final stream = response.data!.stream;

      await for (final data in stream.cast<List<int>>().transform(
        utf8.decoder,
      )) {
        for (final line in data.split("\n")) {
          final trimmed = line.trim();

          
          if (trimmed.isEmpty || trimmed.startsWith(":")) continue;

          if (trimmed.startsWith("data:")) {
            try {
              final jsonData = jsonDecode(trimmed.substring(5).trim());

             
              if (jsonData["title"] == null && jsonData["message"] == null) {
                continue;
              }

              yield NotificationModel.fromJson(jsonData);
            } catch (e) {
             
              continue;
            }
          }
        }
      }
    } else {
      throw Exception('SSE connection failed');
    }
  }
}
