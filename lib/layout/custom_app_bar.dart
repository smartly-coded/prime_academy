
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'package:prime_academy/core/routing/app_routes.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/presentation/widgets/animated_notification_bell.dart';
import 'package:prime_academy/presentation/widgets/splashWidgets/build_text_withoutImage.dart';

class CustomAppBar extends StatelessWidget {
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
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0b0f12),
          border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),

        child: Row(
          children: [
            if (showBackArrow && automaticallyImplyLeading)
              IconButton(
                icon: Icon(Icons.arrow_back_ios, color: backArrowColor),
                onPressed: () => Navigator.pop(context),
              ),

            if (showNotificationIcon && user != null)
              Transform.scale(
                scale: 0.85,
                child: AnimatedNotificationBell(user: user!),
              ),

            ...?additionalActions,
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => _handleAccountButton(context),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                    center: Alignment(-1, 1),
                    radius: 1.5,
                    colors: [Color(0xFFFF9933), Color(0xFF450486)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF222633),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "حسابي",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),

            GestureDetector(
              onTap: onLogoPressed,
              child: Image.asset(
                "assets/images/footer-logo.webp",
                height: 60,
                width: 120,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleAppBar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0b0f12),
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (leading != null) leading!,
          if (actions != null) ...actions!,

          const Spacer(),

          if (title != null)
            Text(
              title!,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            )
          else
            GestureDetector(
              onTap: onLogoPressed,
              child: Image.asset("assets/images/footer-logo.webp", height: 40),
            ),
        ],
      ),
    );
  }
}
