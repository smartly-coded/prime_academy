import 'package:flutter/material.dart';
import 'package:prime_academy/core/routing/app_routes.dart';
import 'package:prime_academy/presentation/login/veiw/loginScreen.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/video_player.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/build_text.dart';
import 'package:prime_academy/presentation/widgets/splashWidgets/build_text_withoutImage.dart';

class TrophySection extends StatelessWidget {
  const TrophySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTextWithBorder("نافس و تعلم", "هدفنا إخراج جيل جديد", context),
        const SizedBox(height: 15),

        Row(
          children: [
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
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.login);
                },
                style: TextButton.styleFrom(
                  shadowColor: Color(0XFF222633),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  "ابدأ الآن",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),

            const SizedBox(width: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                const SizedBox(width: 10),
                const Text(
                  "اعرف أكثر",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
