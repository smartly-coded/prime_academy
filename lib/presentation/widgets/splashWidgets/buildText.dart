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

    mainAxisAlignment: isMobile
        ? MainAxisAlignment.end
        : MainAxisAlignment.start,
    children: [
      // العنوان الرئيسي
      Container(
        padding: EdgeInsets.all(3), // عرض البوردر
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff4f2349), Color(0xffa76433)],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Color(0XFF0f1217), // لون الخلفية الداخلية
            borderRadius: BorderRadius.circular(7), // أصغر من الخارجي بـ 3px
          ),
          child: Text(
            mainTitle,

            style: TextStyle(
              fontSize: getResponsiveFontSize(context, fontSize: 18),
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
        ),
      ),
      const SizedBox(height: 16),

      // العنوان الفرعي
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // النص ثابت
          Text(
            subTitle,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: getResponsiveFontSize(context, fontSize: 20),
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.3,
            ),
          ),

          const SizedBox(width: 8),

          // الصورة المتحركة فقط
          TweenAnimationBuilder(
            tween: Tween<double>(begin: -3.0, end: 3.0),
            duration: const Duration(seconds: 2),
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
              // إعادة تشغيل الأنيميشن
            },
          ),
        ],
      ),

      const SizedBox(height: 24),
    ],
  );
}

//scale factor = width/platform
//responsive font size =base font size* scaleFactor
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
    //tablet
    return width / 700;
  }
}
