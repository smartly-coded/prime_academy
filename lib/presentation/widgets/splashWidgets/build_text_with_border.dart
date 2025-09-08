import 'package:flutter/material.dart';

Widget buildTextSection(
  BoxConstraints constraints,
  bool isMobile,
  String mainTitle,
  String subTitle,
  String image,
  BuildContext context,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      // العنوان الرئيسي
      Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: EdgeInsets.all(3), // عرض البوردر
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff4f2349), Color(0xffa76433)],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: Color(0XFF0f1217), // لون الخلفية الداخلية
              borderRadius: BorderRadius.circular(7), // أصغر من الخارجي بـ 3px
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                mainTitle,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: getResponsiveFontSize(context, fontSize: 18),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 16),

      // العنوان الفرعي مع الصورة في آخر النص
      Align(
        alignment: Alignment.centerRight, // ✅ إجبار المحاذاة من اليمين
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              children: [
                // النص
                TextSpan(
                  text: subTitle,
                  style: TextStyle(
                    fontSize: getResponsiveFontSize(context, fontSize: 20),
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),

                // مسافة صغيرة
                TextSpan(text: " "),

                // الصورة كـ WidgetSpan في آخر النص
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: TweenAnimationBuilder(
                    tween: Tween<double>(begin: -3.0, end: 3.0),
                    duration: const Duration(seconds: 3),
                    curve: Curves.easeInOut,
                    builder: (context, double value, child) {
                      return Transform.translate(
                        offset: Offset(0, value),
                        child: SizedBox(
                          width: isMobile ? 40 : 60,
                          height: isMobile ? 40 : 60,
                          child: Image.asset(image),
                        ),
                      );
                    },
                    onEnd: () {
                      // إعادة تشغيل الأنيميشن إذا أردت
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 24),
    ],
  );
}

// Helper functions
double getResponsiveFontSize(BuildContext context, {required double fontSize}) {
  double scaleFactor = getScaleFactor(context);
  double responsiveFontSize = fontSize * scaleFactor;
  double lowerLimit = responsiveFontSize * .8;
  double upperLimit = responsiveFontSize * 1.2;
  return responsiveFontSize.clamp(lowerLimit, upperLimit);
}

double getScaleFactor(BuildContext context) {
  double width = MediaQuery.sizeOf(context).width;
  if (width < 600) {
    return width / 400;
  } else {
    return width / 700;
  }
}
