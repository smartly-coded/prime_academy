import 'dart:async';
import 'dart:convert';
import 'package:eventsource/eventsource.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:prime_academy/core/networking/api_constants.dart';
import 'package:prime_academy/features/Notigication/data/models/notification_model.dart';
import 'package:prime_academy/features/Notigication/logic/notification_cubit.dart';

class NotificationSSEService {
  EventSource? _eventSource;
  StreamSubscription? _subscription;

  Future<void> connect(NotificationCubit cubit) async {
    try {
      final storage = const FlutterSecureStorage();
      final token = await storage.read(key: 'accessToken') ?? '';
      final refreshToken = await storage.read(key: 'refreshToken') ?? '';

      final headers = <String, String>{};
      if (token.isNotEmpty) headers['Authorization'] = 'Bearer $token';
      if (token.isNotEmpty && refreshToken.isNotEmpty) {
        headers['Cookie'] = 'accessToken=$token; refreshToken=$refreshToken';
      }
      headers['Accept'] = 'text/event-stream';

      _eventSource = await EventSource.connect(
        '${ApiConstants.apiBaseUrl}sse',
        headers: headers,
      );

      _subscription = _eventSource!.listen(
        (event) {
          if (event.data != null && event.data!.isNotEmpty) {
            try {
              final decoded = jsonDecode(event.data!);

              if (decoded is Map<String, dynamic>) {
             
                if (decoded.containsKey("type") && decoded.containsKey("data")) {
                  final model = NotificationModel.fromJson(decoded);
                  final hasContent = (model.data?['title']?.toString().trim().isNotEmpty ?? false) ||
                      (model.data?['message']?.toString().trim().isNotEmpty ?? false);

                  if (hasContent) {
                    cubit.addNotification(model);
                    print("📩 New Notification: $decoded");
                  } else {
                    print("⏳ Ignored heartbeat");
                  }
                } else {
                  print("⚠️ Ignored unknown event: $decoded");
                }
              }
            } catch (e) {
              print("❌ Error parsing notification SSE: $e");
            }
          }
        },
        onError: (error) {
          print("❌ Notification SSE error: $error");
        },
        onDone: () {
          print("⚠️ Notification SSE closed");
          
          reconnect(cubit);
        },
        cancelOnError: true,
      );

      print("🎉 Notification SSE connected.");
    } catch (e, st) {
      print("❌ Notification SSE connection failed: $e");
      print(st);
    }
  }

  void reconnect(NotificationCubit cubit) {
    disconnect();
    Future.delayed(const Duration(seconds: 3), () {
      connect(cubit);
    });
  }

  void disconnect() {
    _subscription?.cancel();
    _eventSource?.client.close();
  }
}
