

import 'dart:async';
import 'dart:convert';
import 'package:eventsource/eventsource.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:prime_academy/core/networking/api_constants.dart';
import 'package:prime_academy/features/Chat/data/models/chatModel.dart';
import 'package:prime_academy/features/Chat/logic/chat_cubit.dart';

class SSEService {
  EventSource? _eventSource;
  StreamSubscription? _subscription;

  Future<void> connect(ChatCubit cubit) async {
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
  (event) async {
    if (event.data != null && event.data!.isNotEmpty) {
      try {
        final decoded = jsonDecode(event.data!);

        if (decoded is Map<String, dynamic>) {
          // 🎯 لو جالي رسالة مباشرة
          if (decoded.containsKey("sender_id") && decoded.containsKey("message")) {
            final newMessage = MessageModel.fromJson(decoded);
            cubit.addMessage(newMessage);
          }
          // 🎯 لو جالي Notification
          else if (decoded["type"] == "CHAT" && decoded.containsKey("data")) {
            final data = decoded["data"];

            // لو مع الإشعار فيه الرسالة نفسها
            if (data is Map<String, dynamic> && data.containsKey("message") && data.containsKey("senderId")) {
              final newMessage = MessageModel.fromJson({
                "id": data["itemId"] ?? data["messageId"],
                "sender_id": data["senderId"],
                "sender_role": "teacher", // السيرفر ممكن يحددها أو نخمن حسب الحالة
                "message": data["message"],
                "media": data["media"],
                "created_at": DateTime.now().toIso8601String(),
              });
              cubit.addMessage(newMessage);
            } 
            // لو بس chatId + messageId => نجيب الرسالة من الـ GET
            else if (data is Map<String, dynamic> && data.containsKey("chatId")) {
              try {
                final latestMessages = await cubit.chatRepo.getMessages(data["chatId"], page: 1);
                if (latestMessages.isNotEmpty) {
                  cubit.addMessage(latestMessages.first); // آخر رسالة
                }
              } catch (e) {
                print("❌ Failed to fetch latest chat message: $e");
              }
            }
          } 
          // 🎯 أي حاجة تانية
          else {
            print('⚠️ Ignored SSE event: ${event.data}');
          }
        } else {
          print('⚠️ Unexpected SSE format: ${event.data}');
        }
      } catch (e) {
        print('❌ Error parsing SSE data: $e');
      }
    } else {
      print('⚠️ SSE event with no data');
    }
  },
  onError: (error, stackTrace) {
    print('❌ SSE stream error: $error');
  },
  onDone: () {
    print('⚠️ SSE closed');
  },
  cancelOnError: true,
);


      print('🎉 SSE connected successfully.');
    } catch (e, stackTrace) {
      print('❌ SSE connection failed: $e');
      print('Stack trace: $stackTrace');
    }
  }

  void disconnect() {
    _subscription?.cancel();
    _eventSource?.client.close();
  }
}



// import 'dart:async';
// import 'dart:convert';
// import 'package:eventsource/eventsource.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:prime_academy/core/networking/api_constants.dart';
// import 'package:prime_academy/features/Chat/data/models/chatModel.dart';
// import 'package:prime_academy/features/Chat/logic/chat_cubit.dart';

// class SSEService {
//   EventSource? _eventSource;
//   StreamSubscription? _subscription;
//   bool _isDisconnecting = false;
//   bool _isConnected = false;

//   Future<void> connect(ChatCubit cubit) async {
//     if (_isConnected || _isDisconnecting) {
//       print('⚠️ SSE already connected or disconnecting');
//       return;
//     }

//     try {
//       final storage = const FlutterSecureStorage();
//       final token = await storage.read(key: 'accessToken') ?? '';
//       final refreshToken = await storage.read(key: 'refreshToken') ?? '';

//       final headers = <String, String>{};
//       if (token.isNotEmpty) headers['Authorization'] = 'Bearer $token';
//       if (token.isNotEmpty && refreshToken.isNotEmpty) {
//         headers['Cookie'] = 'accessToken=$token; refreshToken=$refreshToken';
//       }
//       headers['Accept'] = 'text/event-stream';

//       _eventSource = await EventSource.connect(
//         '${ApiConstants.apiBaseUrl}sse',
//         headers: headers,
//       );

//       _isConnected = true;

//       _subscription = _eventSource!.listen(
//         (event) async {
//           if (_isDisconnecting) return;

//           if (event.data != null && event.data!.isNotEmpty) {
//             try {
//               final decoded = jsonDecode(event.data!);

//               if (decoded is Map<String, dynamic>) {
//                 if (decoded.containsKey("sender_id") && decoded.containsKey("message")) {
//                   if (!_isDisconnecting) {
//                     final newMessage = MessageModel.fromJson(decoded);
//                     cubit.addMessage(newMessage);
//                   }
//                 }
//                 else if (decoded["type"] == "CHAT" && decoded.containsKey("data")) {
//                   if (_isDisconnecting) return;

//                   final data = decoded["data"];

//                   if (data is Map<String, dynamic> && data.containsKey("message") && data.containsKey("senderId")) {
//                     final newMessage = MessageModel.fromJson({
//                       "id": data["itemId"] ?? data["messageId"],
//                       "sender_id": data["senderId"],
//                       "sender_role": "teacher",
//                       "message": data["message"],
//                       "media": data["media"],
//                       "created_at": DateTime.now().toIso8601String(),
//                     });
//                     if (!_isDisconnecting) {
//                       cubit.addMessage(newMessage);
//                     }
//                   } 
//                   else if (data is Map<String, dynamic> && data.containsKey("chatId")) {
//                     if (_isDisconnecting) return;
                    
//                     try {
//                       final latestMessages = await cubit.chatRepo.getMessages(data["chatId"], page: 1);
//                       if (latestMessages.isNotEmpty && !_isDisconnecting) {
//                         cubit.addMessage(latestMessages.first);
//                       }
//                     } catch (e) {
//                       if (!_isDisconnecting) {
//                         print("❌ Failed to fetch latest chat message: $e");
//                       }
//                     }
//                   }
//                 } 
//                 else {
//                   if (!_isDisconnecting) {
//                     print('⚠️ Ignored SSE event: ${event.data}');
//                   }
//                 }
//               } else {
//                 if (!_isDisconnecting) {
//                   print('⚠️ Unexpected SSE format: ${event.data}');
//                 }
//               }
//             } catch (e) {
//               if (!_isDisconnecting) {
//                 print('❌ Error parsing SSE data: $e');
//               }
//             }
//           }
//         },
//         onError: (error, stackTrace) {
//           if (!_isDisconnecting) {
//             print('❌ SSE stream error: $error');
//           }
//         },
//         onDone: () {
//           if (!_isDisconnecting) {
//             print('⚠️ SSE closed');
//           }
//           _isConnected = false;
//         },
//         cancelOnError: false,
//       );

//       print('🎉 SSE connected successfully.');
//     } catch (e, stackTrace) {
//       _isConnected = false;
//       if (!_isDisconnecting) {
//         print('❌ SSE connection failed: $e');
//         print('Stack trace: $stackTrace');
//       }
//     }
//   }

//   void disconnect() {
//     if (_isDisconnecting) return;
    
//     _isDisconnecting = true;
//     _isConnected = false;

//     // ⭐ استخدم Future.microtask عشان الـ exceptions ماتظهرش
//     Future.microtask(() async {
//       try {
//         await _subscription?.cancel().timeout(
//           const Duration(milliseconds: 100),
//           onTimeout: () {},
//         );
//       } catch (_) {}
      
//       _subscription = null;
      
//       try {
//         _eventSource?.client.close();
//       } catch (_) {}
      
//       _eventSource = null;
//       _isDisconnecting = false;
      
//       print('✅ SSE disconnected safely');
//     });
//   }
// }