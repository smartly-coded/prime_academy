import 'package:flutter/material.dart';
import 'package:prime_academy/presentation/widgets/splashWidgets/buildGif.dart';

import 'package:prime_academy/presentation/widgets/splashWidgets/build_text_with_border.dart';

Widget buildMobileLayout(
  BoxConstraints constraints,
  bool isMobile,
  bool isTablet,
  bool isLandscape,
  String gifUrl,
  String mainTitle,
  String subTitle,
  String image,
  BuildContext context,
) {
  if (isMobile && !isLandscape) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: buildTextSection(
            constraints,
            isMobile,
            mainTitle,
            subTitle,
            image,
            context,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          flex: 5,
          child: buildGifSection(constraints, isMobile, gifUrl),
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
                context,
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
