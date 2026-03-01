import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prime_academy/core/di/dependency_injection.dart';
import 'package:prime_academy/features/Chat/data/repos/chat_repo.dart';
import 'package:prime_academy/features/Chat/logic/chat_cubit.dart';
import 'package:prime_academy/features/CoursesModules/data/repo/modules_lessons_repo.dart';
import 'package:prime_academy/features/CoursesModules/logic/module_lessons_cubit.dart';
import 'package:prime_academy/features/Notification/data/models/notification_model.dart';
import 'package:prime_academy/features/Notification/logic/notification_cubit.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/presentation/Chat/ChatPage1.dart';
import 'package:prime_academy/presentation/Home/veiw/home_screen.dart';
import 'package:prime_academy/presentation/Modules/veiw/view_lesson.dart';
import 'package:url_launcher/url_launcher_string.dart';

enum DeviceType { mobile, tablet }

DeviceType getDeviceType(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < 600) {
    return DeviceType.mobile;
  } else {
    return DeviceType.tablet;
  }
}

void showNotificationsDialog(BuildContext context, LoginResponse user) {
  final size = MediaQuery.of(context).size;
  final deviceType = getDeviceType(context);

  final dialogWidth = deviceType == DeviceType.mobile
      ? size.width * 0.9
      : size.width * 0.6;

  final dialogHeight = deviceType == DeviceType.mobile
      ? size.height * 0.7
      : size.height * 0.7;

  final borderRadiusSize = deviceType == DeviceType.mobile ? 12.0 : 16.0;

  showDialog(
    context: context,
    builder: (dialogContext) {
      return BlocProvider.value(
        value: context.read<NotificationCubit>(),
        child: Align(
          alignment: Alignment.topLeft,
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadiusSize),
            ),
            child: Container(
              padding: const EdgeInsets.all(2),
              width: dialogWidth,
              height: dialogHeight,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF9933), Color(0xFF450486)],
                ),
                borderRadius: BorderRadius.circular(borderRadiusSize),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0d1117),
                  borderRadius: BorderRadius.circular(borderRadiusSize),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "الإشعارات",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 8),

                          Container(
                            height: 1,
                            color: Colors.grey.withOpacity(0.4),
                          ),

                          const SizedBox(height: 12),

                          BlocBuilder<NotificationCubit, NotificationState>(
                            builder: (context, state) {
                              if (state is NotificationLoaded) {
                                final unreadIds = state.notifications
                                    .where((n) => !n.isRead)
                                    .map((n) => n.id!)
                                    .toList();

                                if (unreadIds.isEmpty) {
                                  return const SizedBox.shrink();
                                }

                                return Center(
                                  child: TextButton(
                                    onPressed: () {
                                      context
                                          .read<NotificationCubit>()
                                          .markAllAsRead(unreadIds);
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      minimumSize: const Size(0, 0),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      backgroundColor: Colors.transparent,
                                    ),
                                    child: const Text(
                                      "تحديد الكل كمقروء",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFFD1D5DB),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: BlocBuilder<NotificationCubit, NotificationState>(
                        builder: (context, state) {
                          if (state is NotificationLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFFF9933),
                              ),
                            );
                          } else if (state is NotificationLoaded) {
                            final notifications = state.notifications;

                            if (notifications.isEmpty) {
                              return const Center(
                                child: Text(
                                  "لا توجد إشعارات",
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }

                            final unreadNotifications = notifications
                                .where((noti) => !noti.isRead)
                                .toList();

                            if (unreadNotifications.isEmpty) {
                              return const Center(
                                child: Text(
                                  "لا توجد إشعارات جديدة",
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }

                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              itemCount: unreadNotifications.length,
                              itemBuilder: (context, index) {
                                final noti = unreadNotifications[index];
                                return _NotificationItem(
                                  notification: noti,
                                  user: user,
                                );
                              },
                            );
                          } else if (state is NotificationError) {
                            return Center(
                              child: Text(
                                "خطأ: ${state.message}",
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          }
                          return const Center(
                            child: Text(
                              "لا توجد إشعارات",
                              style: TextStyle(color: Colors.white54),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final LoginResponse user;

  const _NotificationItem({required this.notification, required this.user});

  @override
  Widget build(BuildContext context) {
    final isChat = notification.type.toLowerCase() == 'chat';
    final isUnread = !notification.isRead;
    final isTrophy =
        notification.type == 'NEW_QUESTION_POINT' ||
        notification.type == 'NEW_LESSON_TROPHY';

    return GestureDetector(
      onTap: () => _handleNotificationTap(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border(
            right: BorderSide(
              color: isUnread
                  ? const Color(0xFFFF9933)
                  : Colors.grey.withOpacity(0.5),
              width: 4,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _getNotificationMessage(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,

                      height: 1.6,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),

                  if (isUnread) ...[
                    const SizedBox(height: 4),

                    Text(
                      _getUnreadCount(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFFF9933),
                      ),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 12),

            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 20,
              height: 20,
              child: isTrophy
                  ? const Icon(
                      Icons.emoji_events,
                      color: Color(0xFFFF9933),
                      size: 20,
                    )
                  : SvgPicture.asset(
                      isChat
                          ? 'assets/icons/message.svg'
                          : 'assets/icons/youtube.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFFF9933),
                        BlendMode.srcIn,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _getNotificationMessage() {
    final data = notification.data;
    if (data == null) return "إشعار جديد";

    final message = data['message'];
    final title = data['title'];

    if (message is String && message.isNotEmpty) {
      return message;
    }

    if (title is String && title.isNotEmpty) {
      return title;
    }

    return "إشعار جديد";
  }

  String _getUnreadCount() {
    return "غير مقروء";
  }

  void _handleNotificationTap(BuildContext context) {
    context.read<NotificationCubit>().markNotificationAsRead(notification.id!);

    final type = notification.type;
    final data = notification.data;

    final String? link = data?['link'] != null && data!['link'] is String
        ? data['link'] as String
        : null;

    if (type.toLowerCase() == "chat") {
      final chatId = data?['chatId'];
      if (chatId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => ChatCubit(
                chatRepo: getIt<ChatRepo>(),
                modulesLessonsRepo: getIt<ModulesLessonsRepo>(),
                chatId: chatId,
                user: user,
              )..loadChat(),
              child: ChatScreen(chatId: chatId, user: user),
            ),
          ),
        );
      }
      return;
    }

    if (type == "NEW_LESSON" && link != null) {
      try {
        final uri = Uri.parse(link);
        final segments = uri.pathSegments;
        final courseId = int.tryParse(segments[1]);
        final moduleId = int.tryParse(segments[3]);
        final lessonId = int.tryParse(uri.queryParameters['lessonId'] ?? "");

        if (courseId != null && moduleId != null && lessonId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (context) =>
                    ModuleLessonsCubit(context.read<ModulesLessonsRepo>())
                      ..emitModuleLessonsStates(moduleId, courseId),
                child: ViewModule(
                  moduleId: moduleId,
                  courseId: courseId,
                  itemId: lessonId,
                  user: user,
                ),
              ),
            ),
          );
        }
      } catch (e) {
        print("Error parsing NEW_LESSON link: $e");
      }
      return;
    }

    if (type == "NEW_QUESTION_POINT" || type == "NEW_LESSON_TROPHY") {
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(user: user, initialTab: 2)),
      );
      return;
    }

    if (type == "EXTERNAL_SOURCE" && link != null) {
      launchUrlString(link);
      return;
    }
  }
}
