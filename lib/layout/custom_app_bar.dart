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
  final Color? backArrowColor;
  final bool automaticallyImplyLeading;

  const CustomAppBar({
    super.key,
    this.user,
    this.showNotificationIcon = true,
    this.additionalActions,
    this.onAccountPressed,
    this.onLogoPressed,
    this.backArrowColor = Colors.white, // 🔥 لون افتراضي أبيض
    this.automaticallyImplyLeading = true, // 🔥 ظهور افتراضي
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Future<void> _handleAccountButton(BuildContext context) async {
    if (onAccountPressed != null) {
      onAccountPressed!();
      return;
    }

    // الـ default behavior
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
    return AppBar(
      backgroundColor: Mycolors.backgroundColor,
      elevation: 0,
      automaticallyImplyLeading:
          automaticallyImplyLeading,
      iconTheme: IconThemeData(
        color: backArrowColor, 
      ),
      title: GestureDetector(
        onTap: onLogoPressed,
        child: Image.asset("assets/images/footer-logo.webp", height: 40),
      ),
      actions: [
        // زر "حسابي"
        Container(
          padding: const EdgeInsets.all(2),
          width: 70,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: Mycolors.primary_color.colors),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 50,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0XFF0f1217),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextButton(
              onPressed: () => _handleAccountButton(context),
              child: const Text(
                "حسابي",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),

        // أي actions إضافية
        ...?additionalActions,

        // أيقونة الإشعارات
        if (showNotificationIcon && user != null)
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              bool hasUnread = false;

              if (state is NotificationLoaded) {
                hasUnread = state.notifications.any((n) => n.isRead == false);
              }

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: Mycolors.primary_color.colors,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0XFF0f1217),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: IconButton(
                          icon: const Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            showNotificationsDialog(context, user!);
                          },
                        ),
                      ),
                    ),
                  ),

                  if (hasUnread)
                    Positioned(
                      right: 4,
                      top: -1,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
      ],
    );
  }
}

// AppBar بسيط بدون أيقونات
class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final VoidCallback? onLogoPressed;
  final Color? backArrowColor; // 🔥 إضافة لون سهم الرجوع
  final bool automaticallyImplyLeading; // 🔥 التحكم في الظهور

  const SimpleAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.onLogoPressed,
    this.backArrowColor = Colors.white, // 🔥 لون افتراضي أبيض
    this.automaticallyImplyLeading = true, // 🔥 ظهور افتراضي
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Mycolors.backgroundColor,
      elevation: 0,
      leading: leading,
      automaticallyImplyLeading:
          automaticallyImplyLeading, // 🔥 التحكم في الظهور
      iconTheme: IconThemeData(
        color: backArrowColor, // 🔥 تغيير لون سهم الرجوع
      ),
      title: title != null
          ? Text(title!)
          : GestureDetector(
              onTap: onLogoPressed,
              child: Image.asset("assets/images/footer-logo.webp", height: 40),
            ),
      actions: actions,
    );
  }
}
