// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
// // import 'package:prime_academy/features/Chat/data/repos/chat_repo.dart';
// // import 'package:prime_academy/features/Chat/logic/chat_cubit.dart';
// // import 'package:prime_academy/features/Notification/data/models/notification_model.dart';
// // import 'package:prime_academy/features/Notification/logic/notification_cubit.dart';
// // import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
// // import 'package:prime_academy/presentation/Chat/chatPage.dart';

// // enum DeviceType { mobile, tablet }

// // DeviceType getDeviceType(BuildContext context) {
// //   final width = MediaQuery.of(context).size.width;
// //   if (width < 600) {
// //     return DeviceType.mobile;
// //   } else {
// //     return DeviceType.tablet;
// //   }
// // }

// // void showNotificationsDialog(BuildContext context, LoginResponse user) {
// //   final size = MediaQuery.of(context).size;
// //   final deviceType = getDeviceType(context);

// //   final dialogWidth = deviceType == DeviceType.mobile
// //       ? size.width * 0.9
// //       : size.width * 0.6;

// //   final dialogHeight = deviceType == DeviceType.mobile
// //       ? size.height * 0.7
// //       : size.height * 0.6;

// //   final itemHeight = deviceType == DeviceType.mobile
// //       ? size.height * 0.09
// //       : size.height * 0.12;

// //   final titleFontSize = deviceType == DeviceType.mobile ? 18.0 : 22.0;
// //   final iconSize = deviceType == DeviceType.mobile
// //       ? size.width * 0.05
// //       : size.width * 0.03;

// //   showDialog(
// //     context: context,
// //     builder: (_) {
// //       return Align(
// //         alignment: Alignment.topLeft,
// //         child: Dialog(
// //           backgroundColor: Mycolors.backgroundColor,
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(12),
// //           ),
// //           child: Container(
// //             padding: const EdgeInsets.all(2),
// //             width: dialogWidth,
// //             height: dialogHeight,
// //             decoration: BoxDecoration(
// //               gradient: const LinearGradient(
// //                 colors: [Color(0xff4f2349), Color(0xffa76433)],
// //               ),
// //               borderRadius: BorderRadius.circular(20),
// //             ),
// //             child: Container(
// //               decoration: BoxDecoration(
// //                 color: Mycolors.backgroundColor,
// //                 borderRadius: BorderRadius.circular(20),
// //               ),
// //               padding: const EdgeInsets.all(16),
// //               child: BlocBuilder<NotificationCubit, NotificationState>(
// //                 builder: (context, state) {
// //                   if (state is NotificationLoading) {
// //                     return const Center(child: CircularProgressIndicator());
// //                   } else if (state is NotificationLoaded) {
// //                     final notifications = state.notifications;
// //                     return Column(
// //                       crossAxisAlignment: CrossAxisAlignment.end,
// //                       children: [
// //                         Text(
// //                           "الإشعارات",
// //                           style: TextStyle(
// //                             fontSize: titleFontSize,
// //                             fontWeight: FontWeight.bold,
// //                             color: Colors.white,
// //                           ),
// //                         ),
// //                         const Divider(color: Colors.white54, thickness: 1),
// //                         Expanded(
// //                           child: ListView.builder(
// //                             itemCount: notifications.length,
// //                             itemBuilder: (context, index) {
// //                               final NotificationModel noti =
// //                                   notifications[index];

// //                               final isChat = noti.type.toLowerCase() == 'chat';
// //                               final icon = isChat
// //                                   ? Icons.chat_bubble_outline
// //                                   : Icons.notifications;

// //                               return GestureDetector(
// //                                 // onTap: () {
// //                                 //   context
// //                                 //       .read<NotificationCubit>()
// //                                 //       .markNotificationAsRead(noti.id!);
// //                                 // },
// //                                 onTap: () {
// //                                   context
// //                                       .read<NotificationCubit>()
// //                                       .markNotificationAsRead(noti.id!);

// //                                   if (noti.type.toLowerCase() == 'chat') {
// //                                     final chatId = noti.data?['chatId'];
// //                                     if (chatId != null) {
// //                                       Navigator.push(
// //                                         context,
// //                                         MaterialPageRoute(
// //                                           builder: (_) => BlocProvider(
// //                                             create: (context) => ChatCubit(
// //                                               context
// //                                                   .read<ChatRepo>(), // ✅ repo
// //                                               chatId,
// //                                               user,
// //                                             )..loadChat(),
// //                                             child: ChatScreen(
// //                                               chatId: chatId,
// //                                               user: user,
// //                                             ),
// //                                           ),
// //                                         ),
// //                                       );
// //                                     }
// //                                   }
// //                                 },

// //                                 child: Stack(
// //                                   children: [
// //                                     Padding(
// //                                       padding: const EdgeInsets.only(
// //                                         bottom: 8.0,
// //                                       ),
// //                                       child: Container(
// //                                         height: itemHeight,
// //                                         decoration: BoxDecoration(
// //                                           color: noti.isRead
// //                                               ? Mycolors.grey
// //                                               : Colors.orange,
// //                                           borderRadius: BorderRadius.circular(
// //                                             12,
// //                                           ),
// //                                         ),
// //                                       ),
// //                                     ),
// //                                     Container(
// //                                       height: itemHeight,
// //                                       margin: const EdgeInsets.only(right: 10),
// //                                       padding: const EdgeInsets.symmetric(
// //                                         horizontal: 12,
// //                                         vertical: 8,
// //                                       ),
// //                                       decoration: BoxDecoration(
// //                                         color: Mycolors.cardColor,
// //                                         borderRadius: BorderRadius.circular(12),
// //                                       ),
// //                                       child: Row(
// //                                         children: [
// //                                           Expanded(
// //                                             child: Text(
// //                                               noti.data?['title'] ??
// //                                                   noti.data?['message'] ??
// //                                                   "No title",
// //                                               style: TextStyle(
// //                                                 color: Colors.white,
// //                                                 fontWeight: noti.isRead
// //                                                     ? FontWeight.normal
// //                                                     : FontWeight.bold,
// //                                                 fontSize:
// //                                                     deviceType ==
// //                                                         DeviceType.mobile
// //                                                     ? 14
// //                                                     : 16,
// //                                               ),
// //                                               overflow: TextOverflow.ellipsis,
// //                                             ),
// //                                           ),
// //                                           Icon(
// //                                             icon,
// //                                             size: iconSize,
// //                                             color: noti.isRead
// //                                                 ? Colors.grey
// //                                                 : Colors.orange,
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               );
// //                             },
// //                           ),
// //                         ),
// //                       ],
// //                     );
// //                   } else if (state is NotificationError) {
// //                     return Center(
// //                       child: Text(
// //                         "Error: ${state.message}",
// //                         style: const TextStyle(color: Colors.white),
// //                       ),
// //                     );
// //                   }
// //                   return const Center(
// //                     child: Text(
// //                       "No notifications",
// //                       style: TextStyle(color: Colors.white),
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //           ),
// //         ),
// //       );
// //     },
// //   );
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
// import 'package:prime_academy/features/Chat/data/repos/chat_repo.dart';
// import 'package:prime_academy/features/Chat/logic/chat_cubit.dart';
// import 'package:prime_academy/features/CoursesModules/data/repo/modules_lessons_repo.dart';
// import 'package:prime_academy/features/CoursesModules/logic/module_lessons_cubit.dart';
// import 'package:prime_academy/features/Notification/data/models/notification_model.dart';
// import 'package:prime_academy/features/Notification/logic/notification_cubit.dart';
// import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
// import 'package:prime_academy/presentation/Chat/ChatPage1.dart';
// import 'package:prime_academy/presentation/Chat/chatPage.dart';
// import 'package:prime_academy/presentation/Modules/veiw/view_lesson.dart';
// import 'package:url_launcher/url_launcher_string.dart';

// enum DeviceType { mobile, tablet }

// DeviceType getDeviceType(BuildContext context) {
//   final width = MediaQuery.of(context).size.width;
//   if (width < 600) {
//     return DeviceType.mobile;
//   } else {
//     return DeviceType.tablet;
//   }
// }

// void showNotificationsDialog(BuildContext context, LoginResponse user) {
//   final size = MediaQuery.of(context).size;
//   final deviceType = getDeviceType(context);

//   // Responsive dimensions
//   final dialogWidth = deviceType == DeviceType.mobile
//       ? size.width * 0.9
//       : size.width * 0.6;

//   final dialogHeight = deviceType == DeviceType.mobile
//       ? size.height * 0.7
//       : size.height * 0.6;

//   final itemHeight = deviceType == DeviceType.mobile
//       ? size.height * 0.09
//       : size.height * 0.12;

//   final titleFontSize = deviceType == DeviceType.mobile ? 18.0 : 22.0;
//   final iconSize = deviceType == DeviceType.mobile
//       ? size.width * 0.05
//       : size.width * 0.03;

//   final paddingSize = deviceType == DeviceType.mobile ? 16.0 : 20.0;
//   final marginSize = deviceType == DeviceType.mobile ? 5.0 : 10.0;
//   final borderRadiusSize = deviceType == DeviceType.mobile ? 12.0 : 16.0;

//   showDialog(
//     context: context,
//     builder: (_) {
//       return Align(
//         alignment: Alignment.topLeft,
//         child: Dialog(
//           backgroundColor: Mycolors.backgroundColor,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(borderRadiusSize),
//           ),
//           child: Container(
//             padding: const EdgeInsets.all(2),
//             width: dialogWidth,
//             height: dialogHeight,
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xff4f2349), Color(0xffa76433)],
//               ),
//               borderRadius: BorderRadius.circular(borderRadiusSize),
//             ),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Mycolors.backgroundColor,
//                 borderRadius: BorderRadius.circular(borderRadiusSize),
//               ),
//               padding: EdgeInsets.all(paddingSize),
//               child: BlocBuilder<NotificationCubit, NotificationState>(
//                 builder: (context, state) {
//                   if (state is NotificationLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (state is NotificationLoaded) {
//                     final notifications = state.notifications;
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           "الإشعارات",
//                           style: TextStyle(
//                             fontSize: titleFontSize,
//                             // fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const Divider(color: Colors.white54, thickness: 1),
//                         Expanded(
//                           child: ListView.builder(
//                             itemCount: notifications.length,
//                             itemBuilder: (context, index) {
//                               final NotificationModel noti =
//                                   notifications[index];

//                               final isChat = noti.type.toLowerCase() == 'chat';
//                               final icon = isChat
//                                   ? Icons.chat_bubble_outline
//                                   : Icons.notifications;

//                               return GestureDetector(
//                                 // onTap: () {
//                                 //   context
//                                 //       .read<NotificationCubit>()
//                                 //       .markNotificationAsRead(noti.id!);

//                                 //   if (noti.type.toLowerCase() == 'chat') {
//                                 //     final chatId = noti.data?['chatId'];
//                                 //     if (chatId != null) {
//                                 //       Navigator.push(
//                                 //         context,
//                                 //         MaterialPageRoute(
//                                 //           builder: (_) => BlocProvider(
//                                 //             create: (context) => ChatCubit(
//                                 //               context.read<ChatRepo>(),
//                                 //               chatId,
//                                 //               user,
//                                 //             )..loadChat(),
//                                 //             child: ChatScreen(
//                                 //               chatId: chatId,
//                                 //               user: user,
//                                 //             ),
//                                 //           ),
//                                 //         ),
//                                 //       );
//                                 //     }
//                                 //   }
//                                 // },
//                                 onTap: () {
//                                   context
//                                       .read<NotificationCubit>()
//                                       .markNotificationAsRead(noti.id!);

//                                   final type = noti.type;
//                                   final data = noti.data;
//                                   final link = data?["link"];

//                                   // ===========================================================
//                                   // 1) فتح الشات Chat
//                                   // ===========================================================
//                                   if (type.toLowerCase() == "chat") {
//                                     final chatId = data?['chatId'];
//                                     if (chatId != null) {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (_) => BlocProvider(
//                                             create: (context) => ChatCubit(
//                                               chatRepo: context
//                                                   .read<ChatRepo>(),
//                                               modulesLessonsRepo: context
//                                                   .read<ModulesLessonsRepo>(),
//                                               chatId: chatId,
//                                               moduleId: 1,
//                                               courseId: 2,
//                                               user: user,
//                                             )..loadChat(),
//                                             child: ChatScreen(
//                                               chatId: chatId,
//                                               user: user,
//                                               moduleId: 1,
//                                               courseId: 2,
//                                             ),
//                                             // ChatCubit(
//                                             //   context.read<ChatRepo>(),
//                                             //   chatId,
//                                             //   user,
//                                             // )..loadChat(),
//                                             // child: ChatScreen(
//                                             //   chatId: chatId,
//                                             //   user: user,
//                                             // ),
//                                           ),
//                                         ),
//                                       );
//                                     }
//                                     return;
//                                   }

//                                   if (type == "NEW_LESSON" && link != null) {
//                                     try {
//                                       final uri = Uri.parse(link);

//                                       final segments = uri.pathSegments;
//                                       final courseId = int.tryParse(
//                                         segments[1],
//                                       );
//                                       final moduleId = int.tryParse(
//                                         segments[3],
//                                       );

//                                       final lessonId = int.tryParse(
//                                         uri.queryParameters['lessonId'] ?? "",
//                                       );

//                                       if (courseId != null &&
//                                           moduleId != null &&
//                                           lessonId != null) {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (_) => BlocProvider(
//                                               create: (context) =>
//                                                   ModuleLessonsCubit(
//                                                     context
//                                                         .read<
//                                                           ModulesLessonsRepo
//                                                         >(),
//                                                   )..emitModuleLessonsStates(
//                                                     moduleId,
//                                                     courseId,
//                                                   ),
//                                               child: ViewModule(
//                                                 moduleId: moduleId,
//                                                 courseId: courseId,
//                                                 itemId: lessonId,
//                                                 user: user,
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                       }
//                                     } catch (e) {
//                                       print(
//                                         "Error parsing NEW_LESSON link: $e",
//                                       );
//                                     }

//                                     return;
//                                   }

//                                   if (type == "EXTERNAL_SOURCE" &&
//                                       link != null) {
//                                     launchUrlString(link);
//                                     return;
//                                   }
//                                 },

//                                 child: Stack(
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.only(
//                                         bottom: 8.0,
//                                       ),
//                                       child: Container(
//                                         height: itemHeight,
//                                         decoration: BoxDecoration(
//                                           color: noti.isRead
//                                               ? Mycolors.grey
//                                               : Color(0xFFFF9933),
//                                           borderRadius: BorderRadius.circular(
//                                             borderRadiusSize,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                       height: itemHeight,
//                                       margin: EdgeInsets.only(
//                                         right: marginSize,
//                                       ),
//                                       padding: EdgeInsets.symmetric(
//                                         horizontal: paddingSize * 0.75,
//                                         vertical: paddingSize * 0.5,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: Mycolors.cardColor,
//                                         borderRadius: BorderRadius.circular(
//                                           borderRadiusSize,
//                                         ),
//                                       ),
//                                       child: Row(
//                                         children: [
//                                           Expanded(
//                                             child: Text(
//                                               noti.data?['title'] ??
//                                                   noti.data?['message'] ??
//                                                   "No title",
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontWeight: noti.isRead
//                                                     ? FontWeight.normal
//                                                     : FontWeight.normal,
//                                                 fontSize:
//                                                     deviceType ==
//                                                         DeviceType.mobile
//                                                     ? 14
//                                                     : 16,
//                                               ),
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                           ),
//                                           Icon(
//                                             icon,
//                                             size: iconSize,
//                                             color: noti.isRead
//                                                 ? Colors.grey
//                                                 : Color(0xFFFF9933),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     );
//                   } else if (state is NotificationError) {
//                     return Center(
//                       child: Text(
//                         "Error: ${state.message}",
//                         style: const TextStyle(color: Colors.white),
//                       ),
//                     );
//                   }
//                   return const Center(
//                     child: Text(
//                       "No notifications",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/di/dependency_injection.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/Chat/data/repos/chat_repo.dart';
import 'package:prime_academy/features/Chat/logic/chat_cubit.dart';
import 'package:prime_academy/features/CoursesModules/data/repo/modules_lessons_repo.dart';
import 'package:prime_academy/features/CoursesModules/logic/module_lessons_cubit.dart';
import 'package:prime_academy/features/Notification/data/models/notification_model.dart';
import 'package:prime_academy/features/Notification/logic/notification_cubit.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/presentation/Chat/ChatPage1.dart';
import 'package:prime_academy/presentation/Chat/chatPage.dart';
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
      : size.height * 0.6;

  final itemHeight = deviceType == DeviceType.mobile
      ? size.height * 0.09
      : size.height * 0.12;

  final titleFontSize = deviceType == DeviceType.mobile ? 18.0 : 22.0;
  final iconSize = deviceType == DeviceType.mobile
      ? size.width * 0.05
      : size.width * 0.03;

  final paddingSize = deviceType == DeviceType.mobile ? 16.0 : 20.0;
  final marginSize = deviceType == DeviceType.mobile ? 5.0 : 10.0;
  final borderRadiusSize = deviceType == DeviceType.mobile ? 12.0 : 16.0;

  showDialog(
    context: context,
    builder: (_) {
      return Align(
        alignment: Alignment.topLeft,
        child: Dialog(
          backgroundColor: Mycolors.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusSize),
          ),
          child: Container(
            padding: const EdgeInsets.all(2),
            width: dialogWidth,
            height: dialogHeight,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff4f2349), Color(0xffa76433)],
              ),
              borderRadius: BorderRadius.circular(borderRadiusSize),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Mycolors.backgroundColor,
                borderRadius: BorderRadius.circular(borderRadiusSize),
              ),
              padding: EdgeInsets.all(paddingSize),
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

                              final isChat = noti.type.toLowerCase() == 'chat';
                              final icon = isChat
                                  ? Icons.chat_bubble_outline
                                  : Icons.notifications;

                              return GestureDetector(
                                onTap: () {
                                  context
                                      .read<NotificationCubit>()
                                      .markNotificationAsRead(noti.id!);

                                  final type = noti.type;
                                  final data = noti.data;
                                  final link = data?["link"];

                                  // فتح الشات
                                  if (type.toLowerCase() == "chat") {
                                    final chatId = data?['chatId'];
                                    if (chatId != null) {
                                      Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => BlocProvider(
      create: (context) => ChatCubit(
        chatRepo: getIt<ChatRepo>(),
        chatId: chatId,
        user: user,
      )..loadChat(),
      child: ChatScreen(  // ⭐ أضفنا الـ child
        chatId: chatId,
        user: user,
      ),
    ),
  ),
);
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (_) =>
                                      //         // BlocProvider(
                                      //         //   create: (context) => ChatCubit(
                                      //         //     chatRepo: context
                                      //         //         .read<ChatRepo>(),
                                      //         //     modulesLessonsRepo: context
                                      //         //         .read<ModulesLessonsRepo>(),
                                      //         //     chatId: chatId,
                                      //         //     // moduleId: 1,
                                      //         //     // courseId: 2,
                                      //         //     user: user,
                                      //         //   )..loadChat(),
                                      //         //   child: ChatScreen(
                                      //         //     chatId: chatId,
                                      //         //     user: user,
                                      //         //     // moduleId: ,
                                      //         //     // courseId: 2,
                                      //         //   ),
                                      //         // ),
                                      //         BlocProvider(
                                      //           create: (context) => ChatCubit(
                                      //             chatRepo: getIt<ChatRepo>(),
                                      //             // modulesLessonsRepo مش مطلوب هنا
                                      //             chatId: chatId,
                                      //             user: user,
                                      //           )..loadChat(),
                                      //         ),
                                      //   ),
                                      // );
                                    }
                                    return;
                                  }

                                  // فتح درس جديد
                                  if (type == "NEW_LESSON" && link != null) {
                                    try {
                                      final uri = Uri.parse(link);
                                      final segments = uri.pathSegments;
                                      final courseId = int.tryParse(
                                        segments[1],
                                      );
                                      final moduleId = int.tryParse(
                                        segments[3],
                                      );
                                      final lessonId = int.tryParse(
                                        uri.queryParameters['lessonId'] ?? "",
                                      );

                                      if (courseId != null &&
                                          moduleId != null &&
                                          lessonId != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => BlocProvider(
                                              create: (context) =>
                                                  ModuleLessonsCubit(
                                                    context
                                                        .read<
                                                          ModulesLessonsRepo
                                                        >(),
                                                  )..emitModuleLessonsStates(
                                                    moduleId,
                                                    courseId,
                                                  ),
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
                                      print(
                                        "Error parsing NEW_LESSON link: $e",
                                      );
                                    }
                                    return;
                                  }

                                  // ✅ فتح صفحة الترتيب عند الحصول على نقطة
                                  if (type == "NEW_QUESTION_POINT" ||
                                      type == "NEW_LESSON_TROPHY") {
                                    Navigator.pop(context); // إغلاق الـ Dialog
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => HomePage(
                                          user: user,
                                          initialTab:
                                              2, // التاب الثالث (Ranking)
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  // فتح رابط خارجي
                                  if (type == "EXTERNAL_SOURCE" &&
                                      link != null) {
                                    launchUrlString(link);
                                    return;
                                  }
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
                                              : Color(0xFFFF9933),
                                          borderRadius: BorderRadius.circular(
                                            borderRadiusSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: itemHeight,
                                      margin: EdgeInsets.only(
                                        right: marginSize,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: paddingSize * 0.75,
                                        vertical: paddingSize * 0.5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Mycolors.cardColor,
                                        borderRadius: BorderRadius.circular(
                                          borderRadiusSize,
                                        ),
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
                                                    : FontWeight.normal,
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
                                                : Color(0xFFFF9933),
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
