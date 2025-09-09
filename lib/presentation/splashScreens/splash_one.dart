import 'package:flutter/material.dart';

import 'package:prime_academy/presentation/widgets/splashWidgets/buildMobileLayout.dart';
import 'package:prime_academy/presentation/widgets/splashWidgets/buildTabletLayout.dart';

class SplashOne extends StatelessWidget {
  const SplashOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF0f1217),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // تحديد نوع التخطيط حسب حجم الشاشة
            final isTablet = constraints.maxWidth > 600;
            final isMobile = constraints.maxWidth < 600;
            final isLandscape = constraints.maxWidth > constraints.maxHeight;
            final gifAsset = "assets/Gifs/splash1.gif";

            final mainTitle = "برايم اكاديمي ";
            final subTitle = "تلم لك كل دروسك بالشكل الذي تبيه و على مزاجك بعد";
            String image = "assets/icons/banner.jpg";
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16.0 : 10,
                vertical: isMobile ? 20.0 : 10,
              ),
              child: isMobile
                  ? buildMobileLayout(
                      constraints,
                      isMobile,
                      isTablet,
                      isLandscape,
                      gifAsset,
                      mainTitle,
                      subTitle,
                      image,
                      context,
                    )
                  : buildTabletLayout(
                      constraints,
                      isMobile,
                      isTablet,
                      isLandscape,
                      gifAsset,
                      mainTitle,
                      subTitle,
                      image,
                      context,
                    ),
            );
          },
        ),
      ),
    );
  }
}
