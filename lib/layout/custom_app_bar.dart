// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'dart:convert';

// import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
// import 'package:prime_academy/core/routing/app_routes.dart';
// import 'package:prime_academy/features/Notification/logic/notification_cubit.dart';
// import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
// import 'package:prime_academy/features/authScreen/logic/login_cubit.dart';
// import 'package:prime_academy/presentation/Notification/notification_screen.dart';

// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final LoginResponse? user;
//   final bool showNotificationIcon;
//   final List<Widget>? additionalActions;
//   final VoidCallback? onAccountPressed;
//   final VoidCallback? onLogoPressed;
// final bool showBackArrow ;
//   final Color? backArrowColor;
//   final bool automaticallyImplyLeading;

//   const CustomAppBar({
//     super.key,
//     this.user,
//     this.showNotificationIcon = true,
//     this.additionalActions,
//     this.onAccountPressed,
//     this.onLogoPressed,
//     this.backArrowColor = Colors.white, 
//     this.automaticallyImplyLeading = true,
//      required this.showBackArrow, 
//   });

//   @override
//   Size get preferredSize => const Size.fromHeight(90);

//   Future<void> _handleAccountButton(BuildContext context) async {
//     if (onAccountPressed != null) {
//       onAccountPressed!();
//       return;
//     }

//     // الـ default behavior
//     try {
//       const storage = FlutterSecureStorage();
//       final accessToken = await storage.read(key: "accessToken");

//       if (accessToken == null || accessToken.isEmpty) {
//         if (context.mounted) {
//           Navigator.pushNamed(context, AppRoutes.login);
//         }
//         return;
//       }

//       final userData = await storage.read(key: "userData");

//       if (userData == null || userData.isEmpty) {
//         await storage.delete(key: "accessToken");
//         await storage.delete(key: "refreshToken");
//         if (context.mounted) {
//           Navigator.pushNamed(context, AppRoutes.login);
//         }
//         return;
//       }

//       try {
//         final loginResponse = LoginResponse.fromJson(jsonDecode(userData));

//         if (context.mounted) {
//           Navigator.pushNamed(
//             context,
//             AppRoutes.Home,
//             arguments: loginResponse,
//           );
//         }
//       } catch (parseError) {
//         await storage.delete(key: "userData");
//         await storage.delete(key: "accessToken");
//         await storage.delete(key: "refreshToken");

//         if (context.mounted) {
//           Navigator.pushNamed(context, AppRoutes.login);
//         }
//       }
//     } catch (e) {
//       if (context.mounted) {
//         Navigator.pushNamed(context, AppRoutes.login);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
//       child: Container(
//         decoration: BoxDecoration(
//           color: const Color(0xFF0b0f12),
//           border: Border(
//             bottom: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1.0),
//           ),
//         ),
//         child: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           automaticallyImplyLeading: automaticallyImplyLeading,
//           iconTheme: IconThemeData(color: backArrowColor),
//           leading: GestureDetector(
//             onTap: onLogoPressed,
//             child: Image.asset(
//               "assets/images/footer-logo.webp",
//               height: 120,
//               width: 120,
//             ),
//           ),
//           leadingWidth: 120,
//           actions: [
//             Container(
//               height: 40,
//               decoration: BoxDecoration(
//                 gradient: const RadialGradient(
//                   center: Alignment(-1, 1), // at left bottom
//                   radius: 1.5,
//                   colors: [
//                     Color(0xFFFF9933), // rgb(255, 153, 51) - #f93
//                     Color(0xFF450486), // rgb(69, 4, 134) - #450486
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(2), // 2px border width
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: const Color(
//                       0xFF222633,
//                     ), // rgb(34, 38, 51) - same as notification
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Material(
//                     color: Colors.transparent,
//                     child: InkWell(
//                       borderRadius: BorderRadius.circular(10),
//                       onTap: () => _handleAccountButton(context),
//                       child: const Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 8,
//                         ),
//                         child: Text(
//                           "حسابي",
//                           style: TextStyle(color: Colors.white, fontSize: 14),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             // Container(
//             //   padding: const EdgeInsets.all(2),
//             //   width: 70,
//             //   height: 40,
//             //   decoration: BoxDecoration(
//             //     gradient: LinearGradient(colors: Mycolors.primary_color.colors),
//             //     borderRadius: BorderRadius.circular(20),
//             //   ),
//             //   child: Container(
//             //     width: 50,
//             //     height: 30,
//             //     decoration: BoxDecoration(
//             //       color: const Color(0xFF0b0f12),
//             //       borderRadius: BorderRadius.circular(20),
//             //     ),
//             //     child: TextButton(
//             //       onPressed: () => _handleAccountButton(context),
//             //       child: const Text(
//             //         "حسابي",
//             //         style: TextStyle(color: Colors.white, fontSize: 12),
//             //       ),
//             //     ),
//             //   ),
//             // ),
//             const SizedBox(width: 10),

//             // أي actions إضافية
//             ...?additionalActions,

//             // أيقونة الإشعارات
//             // if (showNotificationIcon && user != null)
//             //   BlocBuilder<NotificationCubit, NotificationState>(
//             //     builder: (context, state) {
//             //       bool hasUnread = false;

//             //       if (state is NotificationLoaded) {
//             //         hasUnread = state.notifications.any(
//             //           (n) => n.isRead == false,
//             //         );
//             //       }

//             //       return Stack(
//             //         clipBehavior: Clip.none,
//             //         children: [
//             //           Container(
//             //             padding: const EdgeInsets.all(2),
//             //             width: 40,
//             //             height: 40,
//             //             decoration: BoxDecoration(
//             //               gradient: LinearGradient(
//             //                 colors: Mycolors.primary_color.colors,
//             //               ),
//             //               borderRadius: BorderRadius.circular(50),
//             //             ),
//             //             child: Container(
//             //               decoration: BoxDecoration(
//             //                 color: const Color(0xFF0b0f12),
//             //                 borderRadius: BorderRadius.circular(20),
//             //               ),
//             //               child: Center(
//             //                 child: IconButton(
//             //                   icon: const Icon(
//             //                     Icons.notifications_none,
//             //                     color: Colors.white,
//             //                     size: 20,
//             //                   ),
//             //                   onPressed: () {
//             //                     showNotificationsDialog(context, user!);
//             //                   },
//             //                 ),
//             //               ),
//             //             ),
//             //           ),

//             //           if (hasUnread)
//             //             Positioned(
//             //               right: 4,
//             //               top: -1,
//             //               child: Container(
//             //                 width: 12,
//             //                 height: 12,
//             //                 decoration: BoxDecoration(
//             //                   color: Colors.red,
//             //                   shape: BoxShape.circle,
//             //                 ),
//             //               ),
//             //             ),
//             //         ],
//             //       );
//             //     },
//             //   ),
//             if (showNotificationIcon && user != null)
//               BlocBuilder<NotificationCubit, NotificationState>(
//                 builder: (context, state) {
//                   bool hasUnread = false;

//                   if (state is NotificationLoaded) {
//                     hasUnread = state.notifications.any(
//                       (n) => n.isRead == false,
//                     );
//                   }

//                   return Stack(
//                     clipBehavior: Clip.none,
//                     children: [
//                       // Outer container for gradient border effect
//                       Container(
//                         width: 48,
//                         height: 48,
//                         decoration: BoxDecoration(
//                           gradient: const RadialGradient(
//                             center: Alignment(-1, 1), // at left bottom
//                             radius: 1.5,
//                             colors: [
//                               Color(0xFFFF9933), // rgb(255, 153, 51) - #f93
//                               Color(0xFF450486), // rgb(69, 4, 134) - #450486
//                             ],
//                           ),
//                           borderRadius: BorderRadius.circular(9999),
//                         ),
//                         // Inner container with background color
//                         child: Padding(
//                           padding: const EdgeInsets.all(2), // 2px border width
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: const Color(0xFF222633), // rgb(34, 38, 51)
//                               borderRadius: BorderRadius.circular(9999),
//                             ),
//                             child: Center(
//                               child: Material(
//                                 color: Colors.transparent,
//                                 child: InkWell(
//                                   borderRadius: BorderRadius.circular(9999),
//                                   onTap: () {
//                                     showNotificationsDialog(context, user!);
//                                   },
//                                   child: const Padding(
//                                     padding: EdgeInsets.all(
//                                       8,
//                                     ), // 12px padding from web
//                                     child: Icon(
//                                       Icons.notifications,
//                                       color: Colors.white,
//                                       size: 25,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),

//                       // Red notification dot
//                       if (hasUnread)
//                         Positioned(
//                           right: 0,
//                           top: 0,
//                           child: Container(
//                             width: 12, // 12px
//                             height: 12, // 12px
//                             decoration: const BoxDecoration(
//                               color: Color(0xFFFF5757),
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                         ),
//                     ],
//                   );
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // AppBar بسيط بدون أيقونات
// class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String? title;
//   final Widget? leading;
//   final List<Widget>? actions;
//   final VoidCallback? onLogoPressed;
//   final Color? backArrowColor; // 🔥 إضافة لون سهم الرجوع
//   final bool automaticallyImplyLeading; // 🔥 التحكم في الظهور

//   const SimpleAppBar({
//     super.key,
//     this.title,
//     this.leading,
//     this.actions,
//     this.onLogoPressed,
//     this.backArrowColor = Colors.white, // 🔥 لون افتراضي أبيض
//     this.automaticallyImplyLeading = true, // 🔥 ظهور افتراضي
//   });

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFF0b0f12),
//         border: Border(
//           bottom: BorderSide(
//             color: Colors.grey.withOpacity(0.3), // matches border-gray-500/30
//             width: 1.0,
//           ),
//         ),
//       ),
//       child: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: leading,
//         automaticallyImplyLeading:
//             automaticallyImplyLeading, 
//         iconTheme: IconThemeData(
//           color: backArrowColor, // 🔥 تغيير لون سهم الرجوع
//         ),
//         title: title != null
//             ? Text(title!)
//             : GestureDetector(
//                 onTap: onLogoPressed,
//                 child: Image.asset(
//                   "assets/images/footer-logo.webp",
//                   height: 40,
//                 ),
//               ),
//         actions: actions,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/core/routing/app_routes.dart';
import 'package:prime_academy/features/Notification/logic/notification_cubit.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/features/authScreen/logic/login_cubit.dart';
import 'package:prime_academy/presentation/Notification/notification_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final LoginResponse? user;
  final bool showNotificationIcon;
  final List<Widget>? additionalActions;
  final VoidCallback? onAccountPressed;
  final VoidCallback? onLogoPressed;
  final bool showBackArrow;
  final Color? backArrowColor;
  final bool automaticallyImplyLeading;

  const CustomAppBar({
    super.key,
    this.user,
    this.showNotificationIcon = true,
    this.additionalActions,
    this.onAccountPressed,
    this.onLogoPressed,
    this.backArrowColor = Colors.white,
    this.automaticallyImplyLeading = true,
    required this.showBackArrow,
  });

  @override
  Size get preferredSize => const Size.fromHeight(90);

  Future<void> _handleAccountButton(BuildContext context) async {
    if (onAccountPressed != null) {
      onAccountPressed!();
      return;
    }

    try {
      const storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: "accessToken");

      if (accessToken == null || accessToken.isEmpty) {
        if (context.mounted) {
          Navigator.pushNamed(context, AppRoutes.login);
        }
        return;
      }

      final userData = await storage.read(key: "userData");

      if (userData == null || userData.isEmpty) {
        await storage.delete(key: "accessToken");
        await storage.delete(key: "refreshToken");
        if (context.mounted) {
          Navigator.pushNamed(context, AppRoutes.login);
        }
        return;
      }

      try {
        final loginResponse = LoginResponse.fromJson(jsonDecode(userData));

        if (context.mounted) {
          Navigator.pushNamed(
            context,
            AppRoutes.Home,
            arguments: loginResponse,
          );
        }
      } catch (parseError) {
        await storage.delete(key: "userData");
        await storage.delete(key: "accessToken");
        await storage.delete(key: "refreshToken");

        if (context.mounted) {
          Navigator.pushNamed(context, AppRoutes.login);
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pushNamed(context, AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0b0f12),
          border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1.0),
          ),
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: showBackArrow && automaticallyImplyLeading,
          iconTheme: IconThemeData(color: backArrowColor),
          leading: showBackArrow && automaticallyImplyLeading
              ? null // السهم هيظهر automatically
              : GestureDetector(
                  onTap: onLogoPressed,
                  child: Image.asset(
                    "assets/images/footer-logo.webp",
                    height: 120,
                    width: 120,
                  ),
                ),
          leadingWidth: showBackArrow && automaticallyImplyLeading ? 56 : 120,
          title: showBackArrow && automaticallyImplyLeading
              ? GestureDetector(
                  onTap: onLogoPressed,
                  child: Image.asset(
                    "assets/images/footer-logo.webp",
                    height: 120,
                    width: 120,
                  ),
                )
              : null,
          actions: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                gradient: const RadialGradient(
                  center: Alignment(-1, 1),
                  radius: 1.5,
                  colors: [
                    Color(0xFFFF9933),
                    Color(0xFF450486),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF222633),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => _handleAccountButton(context),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          "حسابي",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ...?additionalActions,
            if (showNotificationIcon && user != null)
              BlocBuilder<NotificationCubit, NotificationState>(
                builder: (context, state) {
                  bool hasUnread = false;

                  if (state is NotificationLoaded) {
                    hasUnread = state.notifications.any(
                      (n) => n.isRead == false,
                    );
                  }

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: const RadialGradient(
                            center: Alignment(-1, 1),
                            radius: 1.5,
                            colors: [
                              Color(0xFFFF9933),
                              Color(0xFF450486),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF222633),
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Center(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(9999),
                                  onTap: () {
                                    showNotificationsDialog(context, user!);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.notifications,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (hasUnread)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF5757),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final VoidCallback? onLogoPressed;
  final Color? backArrowColor;
  final bool automaticallyImplyLeading;

  const SimpleAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.onLogoPressed,
    this.backArrowColor = Colors.white,
    this.automaticallyImplyLeading = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0b0f12),
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.3),
            width: 1.0,
          ),
        ),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
        iconTheme: IconThemeData(
          color: backArrowColor,
        ),
        title: title != null
            ? Text(title!)
            : GestureDetector(
                onTap: onLogoPressed,
                child: Image.asset(
                  "assets/images/footer-logo.webp",
                  height: 40,
                ),
              ),
        actions: actions,
      ),
    );
  }
}