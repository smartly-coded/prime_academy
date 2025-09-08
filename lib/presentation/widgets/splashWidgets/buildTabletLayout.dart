import 'package:flutter/material.dart';
import 'package:prime_academy/presentation/widgets/splashWidgets/buildGif.dart';

import 'package:prime_academy/presentation/widgets/splashWidgets/build_text_with_border.dart';

Widget buildTabletLayout(
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
  // للشاشات الصغيرة - تخطيط عمودي
  if (isTablet && !isLandscape) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: buildTextSection(
            constraints,
            isMobile,
            mainTitle,
            subTitle,
            image,
            context,
          ),
        ),

        Expanded(
          flex: 2,
          child: buildGifSection(constraints, isMobile, gifUrl),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  // للشاشات الكبيرة - تخطيط أفقي
  return Column(
    children: [
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

            SizedBox(width: 32),

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
