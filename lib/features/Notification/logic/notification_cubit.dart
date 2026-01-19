import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/features/Notification/data/repos/notification_repo.dart';
import '../data/models/notification_model.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository repository;

  NotificationCubit(this.repository) : super(NotificationInitial()) {
    fetchNotifications();
    // ⚠️ SSE connection is now handled by UnifiedSSEService in main.dart
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
      // Rollback if needed
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

  /// Called by UnifiedSSEService when new notification arrives
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
    // ⚠️ No need to close SSE here - it's managed globally
    return super.close();
  }
}