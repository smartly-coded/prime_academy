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
        const SizedBox(height: 20), // ✅ مسافة أقل من الأعلى
        // GIF في الأعلى - حجم أكبر
        Expanded(
          flex: 5, // ✅ زيادة حجم الـ GIF
          child: buildGifSection(constraints, isMobile, gifUrl),
        ),

        const SizedBox(height: 16), // ✅ مسافة أقل بين GIF والنص
        // النص في الأسفل - حجم أقل
        Expanded(
          flex: 3, // ✅ تقليل حجم منطقة النص
          child: buildTextSection(
            constraints,
            isMobile,
            mainTitle,
            subTitle,
            image,
            context,
          ),
        ),

        const SizedBox(height: 10), // ✅ مسافة أقل من الأسفل
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
