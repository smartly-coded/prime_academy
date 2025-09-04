import 'package:flutter/material.dart';
import 'package:prime_academy/presentation/widgets/splashWidgets/buildGif.dart';
import 'package:prime_academy/presentation/widgets/splashWidgets/buildText.dart';

Widget buildMobileLayout(
  BoxConstraints constraints,
  bool isMobile,
  bool isTablet,
  bool isLandscape,
  String gifUrl,
  String mainTitle,
  String subTitle,
  String image,
) {
  
  if (isMobile && !isLandscape) {
    return Column(
      children: [
        const SizedBox(height: 40),

        // GIF في الأعلى
        Expanded(
          flex: 2,
          child: buildGifSection(constraints, isMobile, gifUrl),
        ),

        const SizedBox(height: 32),

        // النص في الأسفل
        Expanded(
          flex: 3,
          child: buildTextSection(
            
            constraints,
            isMobile,
            mainTitle,
            subTitle,
            image,
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  //  تخطيط أفقي
  return Column(
    children: [
      SizedBox(height: isMobile ? 40 : 60),

      Expanded(
        child: Row(
          children: [
            // النص على اليمين
            Expanded(
              flex: isTablet ? 2 : 3,
              child: buildTextSection(
                constraints,
                isMobile,
                mainTitle,
                subTitle,
                image,
              ),
            ),

            SizedBox(width: isMobile ? 16 : 32),

            // GIF على اليسار
            Expanded(
              flex: isTablet ? 3 : 2,
              child: buildGifSection(constraints, isMobile, gifUrl),
            ),
          ],
        ),
      ),
    ],
  );
}
