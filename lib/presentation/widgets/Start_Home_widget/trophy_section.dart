

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:prime_academy/core/routing/app_routes.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/video_player.dart';
import 'package:prime_academy/presentation/widgets/splashWidgets/build_text_withoutImage.dart';

class TrophySection extends StatelessWidget {
  const TrophySection({super.key});

  bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600;
  }

  Future<void> _handleStartButton(BuildContext context) async {
    try {
      const storage = FlutterSecureStorage();

      final accessToken = await storage.read(key: "accessToken");

      if (accessToken == null || accessToken.isEmpty) {
        if (context.mounted) Navigator.pushNamed(context, AppRoutes.login);
        return;
      }

      final userData = await storage.read(key: "userData");

      if (userData == null || userData.isEmpty) {
        await storage.delete(key: "accessToken");
        await storage.delete(key: "refreshToken");
        if (context.mounted) Navigator.pushNamed(context, AppRoutes.login);
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
      } catch (_) {
        await storage.delete(key: "userData");
        await storage.delete(key: "accessToken");
        await storage.delete(key: "refreshToken");
        if (context.mounted) Navigator.pushNamed(context, AppRoutes.login);
      }
    } catch (_) {
      if (context.mounted) Navigator.pushNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool tablet = isTablet(context);

    final double borderWidth = tablet
        ? MediaQuery.of(context).size.width * 0.19
        : MediaQuery.of(context).size.width * 0.4;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,

        children: [
          tablet
              ? IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: Align(
                          alignment: Alignment.center,
                          child: const Text(
                            "هدفنا إخراج جيل جديد",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),

                      const SizedBox(width: 15),
                      SizedBox(
                        width: borderWidth,
                        child: Center(
                          child: buildTextWithBorder(
                            "نافس و تعلم",
                            "",
                            context,
                            containerWidth: borderWidth,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : buildTextWithBorder(
                  "نافس و تعلم",
                  "هدفنا إخراج جيل جديد",
                  context,
                  containerWidth: borderWidth,
                ),

          const SizedBox(height: 15),

          // --------------------------
          //   اعرف أكثر + ابدأ الآن
          //   (زي ما هما بدون ولا تعديل)
          // --------------------------
          Row(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "اعرف أكثر",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xffd67944),
                          Color(0xff51255b),
                          Color(0xff51255b),
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0XFF222633),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            showVideoDialog(context);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xffd67944),
                      Color(0xff863868),
                      Color(0xff51255b),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextButton(
                  onPressed: () => _handleStartButton(context),
                  style: TextButton.styleFrom(
                    shadowColor: const Color(0XFF222633),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    "ابدأ الآن",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
