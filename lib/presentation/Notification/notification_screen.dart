import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/Notigication/logic/notification_cubit.dart';
import 'package:prime_academy/features/Notigication/data/models/notification_model.dart';

enum DeviceType { mobile, tablet }

DeviceType getDeviceType(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < 600) {
    return DeviceType.mobile;
  } else {
    return DeviceType.tablet;
  }
}

void showNotificationsDialog(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final deviceType = getDeviceType(context);

  final dialogWidth = deviceType == DeviceType.mobile
      ? size.width * 0.9
      : size.width * 0.6;

  final dialogHeight = deviceType == DeviceType.mobile
      ? size.height * 0.7
      : size.height * 0.6;

  final itemHeight = deviceType == DeviceType.mobile
      ? size.height * 0.09
      : size.height * 0.12;

  final titleFontSize = deviceType == DeviceType.mobile ? 18.0 : 22.0;
  final iconSize = deviceType == DeviceType.mobile
      ? size.width * 0.05
      : size.width * 0.03;

  showDialog(
    context: context,
    builder: (_) {
      return Align(
        alignment: Alignment.topLeft,
        child: Dialog(
          backgroundColor: Mycolors.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(2),
            width: dialogWidth,
            height: dialogHeight,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff4f2349), Color(0xffa76433)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Mycolors.backgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(16),
              child: BlocBuilder<NotificationCubit, NotificationState>(
                builder: (context, state) {
                  if (state is NotificationLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is NotificationLoaded) {
                    final notifications = state.notifications;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "الإشعارات",
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Divider(color: Colors.white54, thickness: 1),
                        Expanded(
                          child: ListView.builder(
                            itemCount: notifications.length,
                            itemBuilder: (context, index) {
                              final NotificationModel noti =
                                  notifications[index];

                              final isChat = noti.type?.toLowerCase() == 'chat';
                              final icon = isChat
                                  ? Icons.chat_bubble_outline
                                  : Icons.notifications;

                              return GestureDetector(
                                onTap: () {
                                  context
                                      .read<NotificationCubit>()
                                      .markNotificationAsRead(noti.id!);
                                },
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8.0,
                                      ),
                                      child: Container(
                                        height: itemHeight,
                                        decoration: BoxDecoration(
                                          color: noti.isRead
                                              ? Mycolors.grey
                                              : Colors.orange,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: itemHeight,
                                      margin: const EdgeInsets.only(right: 10),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Mycolors.cardColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              noti.data?['title'] ??
                                                  noti.data?['message'] ??
                                                  "No title",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: noti.isRead
                                                    ? FontWeight.normal
                                                    : FontWeight.bold,
                                                fontSize:
                                                    deviceType ==
                                                        DeviceType.mobile
                                                    ? 14
                                                    : 16,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Icon(
                                            icon,
                                            size: iconSize,
                                            color: noti.isRead
                                                ? Colors.grey
                                                : Colors.orange,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else if (state is NotificationError) {
                    return Center(
                      child: Text(
                        "Error: ${state.message}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  return const Center(
                    child: Text(
                      "No notifications",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    },
  );
}
