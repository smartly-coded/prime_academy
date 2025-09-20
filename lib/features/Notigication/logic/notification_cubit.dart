// notification_cubit.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/services/notification_eventsource.dart';
import 'package:prime_academy/features/Notigication/data/repos/notification_repo.dart';
import '../data/models/notification_model.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository repository;
  final NotificationSSEService sseService;
  StreamSubscription<NotificationModel>? _sseSubscription;

  NotificationCubit(this.repository, this.sseService) : super(NotificationInitial()) {
    // ✅ أول ما الكيوبت يتبني، يجيب الإشعارات ويفتح قناة SSE
    fetchNotifications();
   sseService.connect(this);
  }

  Future<void> fetchNotifications() async {
    emit(NotificationLoading());
    try {
      final notis = await repository.getNotifications();
      emit(NotificationLoaded(notis));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

//   void _listenSSE() {
//   _sseSubscription = repository.connectSSE().listen((newNoti) {
//     print("📩 SSE Received: ${newNoti.toJson()}"); // ✅ هتطبع أي حاجة جاية

//     // نتأكد إن فيه محتوى
//     final hasContent = (newNoti.data?['title']?.toString().trim().isNotEmpty ?? false) ||
//         (newNoti.data?['message']?.toString().trim().isNotEmpty ?? false);

//     if (!hasContent) {
//       print("⏳ Ignored heartbeat (no title/message)");
//       return; // نخرج
//     }

//     if (state is NotificationLoaded) {
//       final current = List<NotificationModel>.from(
//         (state as NotificationLoaded).notifications,
//       );
//       current.insert(0, newNoti);
//       emit(NotificationLoaded(current));
//       print("✅ Added new notification");
//     } else {
//       emit(NotificationLoaded([newNoti]));
//       print("✅ First notification added");
//     }
//   }, onError: (e) {
//     print("❌ SSE Error: $e");
//   });
// }


  Future<void> markNotificationAsRead(int id) async {
    if (state is NotificationLoaded) {
      final current = (state as NotificationLoaded).notifications.map((n) {
        if (n.id == id) {
          return NotificationModel(
            id: n.id,
            userId: n.userId,
            type: n.type,
            data: n.data,
            isRead: true,
            createdAt: n.createdAt,
            updatedAt: n.updatedAt,
          );
        }
        return n;
      }).toList();

      emit(NotificationLoaded(current));
    }

    try {
      await repository.markAsRead([id]);
    } catch (_) {
      // ممكن تعمل rollback لو عايزة
    }
  }

  Future<void> markAllAsRead(List<int> ids) async {
    await repository.markAsRead(ids);
    if (state is NotificationLoaded) {
      final current = (state as NotificationLoaded).notifications.map((n) {
        if (ids.contains(n.id)) {
          return NotificationModel(
            id: n.id,
            userId: n.userId,
            type: n.type,
            data: n.data,
            isRead: true,
            createdAt: n.createdAt,
            updatedAt: n.updatedAt,
          );
        }
        return n;
      }).toList();
      emit(NotificationLoaded(current));
    }
  }
  void addNotification(NotificationModel newNoti) {
  if (state is NotificationLoaded) {
    final current = List<NotificationModel>.from(
      (state as NotificationLoaded).notifications,
    );
    current.insert(0, newNoti);
    emit(NotificationLoaded(current));
  } else {
    emit(NotificationLoaded([newNoti]));
  }
}


  @override
  Future<void> close() {
    _sseSubscription?.cancel();
    return super.close();
  }
}
