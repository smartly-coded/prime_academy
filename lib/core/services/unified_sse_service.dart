import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:eventsource/eventsource.dart' show EventSource, Event;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:prime_academy/core/networking/api_constants.dart';
import 'package:prime_academy/features/Chat/data/models/chatModel.dart';
import 'package:prime_academy/features/Chat/logic/chat_cubit.dart';
import 'package:prime_academy/features/Notification/data/models/notification_model.dart';
import 'package:prime_academy/features/Notification/logic/notification_cubit.dart';

/// 🎯 Unified SSE Service - handles both Chat and Notification events
class UnifiedSSEService {
  static final UnifiedSSEService _instance = UnifiedSSEService._internal();
  factory UnifiedSSEService() => _instance;
  UnifiedSSEService._internal();

  EventSource? _eventSource;
  StreamSubscription? _subscription;

  NotificationCubit? _notificationCubit;
  ChatCubit? _activeChatCubit;

  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isConnected = false;
  bool _isConnecting = false;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
static final AudioPlayer _audioPlayer = AudioPlayer();
  // 🔔 Stream to notify UI about new notifications
  final _notificationStreamController = StreamController<bool>.broadcast();
  Stream<bool> get notificationStream => _notificationStreamController.stream;

  /// Register the notification cubit (called once at app startup)
  void registerNotificationCubit(NotificationCubit cubit) {
    _notificationCubit = cubit;
    if (!_isConnected && !_isConnecting) {
      connect();
    }
  }

  /// Register the active chat cubit (called when user opens a chat)
  void registerChatCubit(ChatCubit cubit) {
    _activeChatCubit = cubit;
  }

  /// Unregister chat cubit (called when user leaves chat screen)
  void unregisterChatCubit() {
    _activeChatCubit = null;
  }

  Future<void> connect() async {
    if (_isConnected) {
      print('✅ SSE already connected');
      return;
    }

    if (_isConnecting) {
      print('⏳ SSE connection already in progress');
      return;
    }

    _isConnecting = true;

    try {
      print('🔄 Attempting SSE connection...');

      final storage = const FlutterSecureStorage();
      final token = await storage.read(key: 'accessToken') ?? '';
      final refreshToken = await storage.read(key: 'refreshToken') ?? '';
      final deviceIdentifier = await storage.read(key: 'device_fingerprint') ?? '';
      final deviceToken = await storage.read(key: 'deviceToken') ?? '';

      if (token.isEmpty) {
        print('⚠️ No access token found - skipping SSE connection');
        _isConnecting = false;
        return;
      }

      print('🔑 Access Token found: ${token.substring(0, 10)}...');

      final headers = <String, String>{};
      
      // 1. Authorization Token
      headers['Authorization'] = 'Bearer $token';
      
      // 2. Device Identifier (fingerprint)
      // if (deviceIdentifier.isNotEmpty) {
      //   headers['X-Device-Identifier'] = deviceIdentifier;
      //   print('📱 Device Identifier: ${deviceIdentifier.substring(0, 10)}...');
      // }
      
      // 3. Device Token (from login response)
      if (deviceToken.isNotEmpty) {
        headers['X-Device-Identifier'] = deviceToken;
        print('🔐 Device Token added');
      }

      // 4. Cookies (access + refresh tokens)
      if (refreshToken.isNotEmpty) {
        headers['Cookie'] = 'accessToken=$token; refreshToken=$refreshToken';
        print('🍪 Cookies added');
      }

      // 5. SSE-specific headers
      headers['Accept'] = 'text/event-stream';
      headers['Cache-Control'] = 'no-cache';
      headers['Connection'] = 'keep-alive';

      final url = '${ApiConstants.apiBaseUrl}sse';
      print('🌐 Connecting to: $url');
      print('📋 Headers: ${headers.keys.join(", ")}');

      _eventSource = await EventSource.connect(url, headers: headers);

      _subscription = _eventSource!.listen(
        (event) => _handleSSEEvent(event),
        onError: (error, stackTrace) {
          print('❌ SSE stream error: $error');
        },
        onDone: () {
          print('⚠️ SSE connection closed');
          _isConnected = false;
          _isConnecting = false;
          _reconnect();
        },
        cancelOnError: false,
      );

      _isConnected = true;
      _isConnecting = false;
      _reconnectAttempts = 0;
      print('🎉 Unified SSE connected successfully');
    } catch (e, st) {
      print('❌ SSE connection failed: $e');
      print('Stack trace: $st');
      _isConnected = false;
      _isConnecting = false;

      if (e.toString().contains('401') ||
          e.toString().contains('Unauthorized')) {
        print('🔐 Authentication error - token may be invalid');
        return;
      }

      if (e.toString().contains('403') || e.toString().contains('Forbidden')) {
        print('🚫 Access forbidden - check server permissions');
        return;
      }

      if (e.toString().contains('404') || e.toString().contains('Not Found')) {
        print('🔍 SSE endpoint not found - check API URL');
        return;
      }

      _reconnect();
    }
  }

  void _handleSSEEvent(Event event) async {
    // ✅ Handle empty events (heartbeats from server)
    if (event.data == null || event.data!.isEmpty || event.data == '{}') {
      // This is a heartbeat/keep-alive - just ignore silently
      return;
    }

    try {
      final decoded = jsonDecode(event.data!);

      if (decoded is! Map<String, dynamic>) {
        print('⚠️ Unexpected SSE format: ${event.data}');
        return;
      }

      // ✅ Handle empty object (another form of heartbeat)
      if (decoded.isEmpty) {
        // Empty object heartbeat - ignore silently
        return;
      }

      // 🎯 Route 1: Direct Chat Message (has sender_id + message)
      if (decoded.containsKey("sender_id") && decoded.containsKey("message")) {
        _handleDirectChatMessage(decoded);
        return;
      }

      // 🎯 Route 2: Typed Notification/Event (has type + data)
      if (decoded.containsKey("type") && decoded.containsKey("data")) {
        final type = decoded["type"];
        final data = decoded["data"];

        // ✅ Ignore heartbeat type
        if (type == "heartbeat" || type == "ping" || type == "keep-alive") {
          return;
        }

        // ✅ Check if data is empty
        if (data == null || (data is Map && data.isEmpty)) {
          return;
        }

        if (type == "CHAT") {
          await _handleChatNotification(decoded);
        } else {
          _handleGeneralNotification(decoded);
        }
        return;
      }
// أضيفي الـ case ده قبل الـ "Ignored unknown" print
if (decoded.containsKey("chatId") && decoded.containsKey("messageId")) {
  await _handleChatNotification({
    "type": "CHAT",
    "data": {
      "chatId": decoded["chatId"],
      "messageId": decoded["messageId"],
      "itemId": decoded["itemId"],
    }
  });
  return;
}
      // Only log if it's not empty and not a known heartbeat pattern
      if (decoded.isNotEmpty &&
          decoded["type"] != "heartbeat" &&
          decoded["type"] != "ping") {

        print('⚠️ Ignored unknown SSE event: $decoded');
      }
    } catch (e) {
      // Only log parsing errors for non-empty data
      if (event.data != null && event.data != '{}' && event.data!.isNotEmpty) {
        print('❌ Error parsing SSE data: $e');
        print('Raw data: ${event.data}');
      }
    }
  }

  /// Handle direct chat message (real-time message in active chat)
  void _handleDirectChatMessage(Map<String, dynamic> data) {
    if (_activeChatCubit != null) {
      try {
        final message = MessageModel.fromJson(data);
        _activeChatCubit!.addMessage(message);
        print('💬 Direct chat message added');
      } catch (e) {
        print('❌ Error parsing chat message: $e');
      }
    }
  }

  /// Handle CHAT type notification
  Future<void> _handleChatNotification(Map<String, dynamic> decoded) async {
    final data = decoded["data"];

    if (data is! Map<String, dynamic>) return;

    // If user is in the chat, add message directly
    if (_activeChatCubit != null &&
        data.containsKey("chatId") &&
        data["chatId"] == _activeChatCubit!.chatId) {
      // Option A: Message is embedded in notification
      if (data.containsKey("message") && data.containsKey("senderId")) {
        try {
          final newMessage = MessageModel.fromJson({
            "id": data["itemId"] ?? data["messageId"],
            "sender_id": data["senderId"],
            "sender_role": "teacher",
            "message": data["message"],
            "media": data["media"],
            "created_at": DateTime.now().toIso8601String(),
          });
          _activeChatCubit!.addMessage(newMessage);
          print('💬 Chat message added from notification');
        } catch (e) {
          print('❌ Error creating message from notification: $e');
        }
      }
      // Option B: Fetch latest message from API
      else if (data.containsKey("chatId")) {
        try {
          final latestMessages = await _activeChatCubit!.chatRepo.getMessages(
            data["chatId"],
            page: 1,
          );
          if (latestMessages.isNotEmpty) {
            _activeChatCubit!.addMessage(latestMessages.first);
            print('💬 Latest chat message fetched and added');
          }
        } catch (e) {
          print('❌ Failed to fetch latest chat message: $e');
        }
      }
    }

    // Always add to notification list (unless user is in that specific chat)
    if (_notificationCubit != null) {
      try {
        final model = NotificationModel.fromJson(decoded);
        _notificationCubit!.addNotification(model);

        // Show notification if user is not in this chat
        if (_activeChatCubit == null ||
            data["chatId"] != _activeChatCubit!.chatId) {
          final title = data['title']?.toString().trim() ?? 'رسالة جديدة';
          final message =
              data['message']?.toString().trim() ?? 'لديك رسالة جديدة';
          await _showHeadsUpNotification(title, message);
          _notificationStreamController.add(true); // 🔔 Trigger bell animation
          print('📩 Chat notification added and shown');
        }
      } catch (e) {
        print('❌ Error handling chat notification: $e');
      }
    }
  }

  /// Handle general (non-chat) notifications
  void _handleGeneralNotification(Map<String, dynamic> decoded) {
    if (_notificationCubit == null) return;

    try {
      final model = NotificationModel.fromJson(decoded);
      final title = model.data?['title']?.toString().trim() ?? '';
      final message = model.data?['message']?.toString().trim() ?? '';

      final hasContent = title.isNotEmpty || message.isNotEmpty;

      if (hasContent) {
        _notificationCubit!.addNotification(model);
        _showHeadsUpNotification(title, message);
        _notificationStreamController.add(true); // 🔔 Trigger bell animation
        print('📩 General notification added: $title');
      }
    } catch (e) {
      print('❌ Error handling general notification: $e');
    }
  }
 
static Future<void> initializeNotifications() async {
  const InitializationSettings initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    iOS: DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    ),
  );
  
  await _localNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (details) {
      print('✅ iOS Notification tapped: ${details.payload}');
    },
  );
  
  // ✅ تحققي من الـ permission
  final plugin = _localNotificationsPlugin
      .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
  
  if (plugin != null) {
    final granted = await plugin.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    print('🔔 iOS notification permission granted: $granted');
  } else {
    print('⚠️ iOS plugin is null');
  }
  
  print('✅ SSE Notifications initialized');
}
Future<void> _showHeadsUpNotification(String title, String body) async {
  try {
       await _audioPlayer.play(AssetSource('sounds/notification.mp3'));

    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        ticker: 'ticker',
        icon: '@mipmap/ic_launcher',
        fullScreenIntent: true,
      ),
      // ✅ أضيفي الـ iOS settings
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _localNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title.isEmpty ? 'إشعار جديد' : title,
      body.isEmpty ? 'لديك إشعار جديد' : body,
      notificationDetails,
    );

    print('🔔 Notification shown: $title');
  } catch (e) {
    print('❌ Error showing notification: $e');
  }
}
 

  void _reconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      print('❌ Max reconnection attempts reached.');
      return;
    }

    _reconnectAttempts++;
    final delaySeconds = _reconnectAttempts * 3;

    print(
      '🔄 Reconnecting in $delaySeconds seconds (attempt $_reconnectAttempts/$_maxReconnectAttempts)',
    );

    disconnect();

    Future.delayed(Duration(seconds: delaySeconds), () {
      if (!_isConnected && !_isConnecting) {
        connect();
      }
    });
  }

  void disconnect() {
    _subscription?.cancel();
    _subscription = null;

    _eventSource?.client.close();
    _eventSource = null;

    _isConnected = false;
    _isConnecting = false;

    print('🔌 SSE disconnected');
  }

  /// Reset reconnection attempts (call after successful login)
  void resetReconnectionAttempts() {
    _reconnectAttempts = 0;
  }
}
