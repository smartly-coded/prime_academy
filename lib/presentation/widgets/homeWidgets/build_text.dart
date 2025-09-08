import 'package:flutter/material.dart';

Widget buildText(String mainTitle, String subTitle, BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      // العنوان الرئيسي
      Text(
        mainTitle,

        style: TextStyle(
          fontSize: getResponsiveFontSize(context, fontSize: 18),
          fontWeight: FontWeight.bold,
          color: Colors.white,
          height: 1.2,
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
