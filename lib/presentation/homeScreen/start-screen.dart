import 'package:flutter/material.dart';

import 'package:prime_academy/presentation/widgets/splashWidgets/buildMobileLayout.dart';
import 'package:prime_academy/presentation/widgets/splashWidgets/buildTabletLayout.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

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
            final gifUrl =
                "https://cdn.primeacademy.education/primeacademy/uploads/Final-Book-Mobile-ezgif-com-optimize.gif";
            final mainTitle = "نافس و تعلم ";
            final subTitle = "برايم أكاديـمي رحلتك التعليمية الشاملة في الكويت";
            String image = "lib/assets/images/big-screen-cup.jpg";
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
                      gifUrl,
                      mainTitle,
                      subTitle,
                      image,
                    )
                  : buildTabletLayout(
                      constraints,
                      isMobile,
                      isTablet,
                      isLandscape,
                      gifUrl,
                      mainTitle,
                      subTitle,
                      image,
                    ),
            );
          },
        ),
      ),
    );
  }
}
