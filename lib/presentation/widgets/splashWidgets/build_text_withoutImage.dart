// import 'package:flutter/material.dart';

// Widget buildTextWithBorder(
//   String mainTitle,
//   String subTitle,
//   BuildContext context,
// ) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     mainAxisAlignment: MainAxisAlignment.start,
//     children: [

//       Align(
//         alignment: Alignment.bottomRight,
//         child: Container(
//           padding: EdgeInsets.all(3),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xff4f2349), Color(0xffa76433)],
//               begin: Alignment.topRight,
//               end: Alignment.bottomLeft,
//             ),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
//             decoration: BoxDecoration(
//               color: Color(0XFF222633),
//               borderRadius: BorderRadius.circular(7),
//             ),
//             child: Directionality(
//               textDirection: TextDirection.rtl,
//               child: Text(
//                 mainTitle,
//                 textAlign: TextAlign.start,
//                 style: TextStyle(
//                   fontSize: getResponsiveFontSize(context, fontSize: 20),
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   height: 1.2,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//       const SizedBox(height: 16),

//       // العنوان الفرعي مع الصورة في آخر النص
//       Align(
//         alignment: Alignment.bottomRight, // ✅ إجبار المحاذاة من اليمين
//         child: Directionality(
//           textDirection: TextDirection.rtl,
//           child: RichText(
//             textAlign: TextAlign.start,
//             text: TextSpan(
//               children: [
//                 // النص
//                 TextSpan(
//                   text: subTitle,
//                   style: TextStyle(
//                     fontSize: getResponsiveFontSize(context, fontSize: 20),
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                     height: 1.3,
//                   ),
//                 ),

//                 TextSpan(text: " "),

//               ],
//             ),
//           ),
//         ),
//       ),
//       const SizedBox(height: 24),
//     ],
//   );
// }

// // Helper functions
// double getResponsiveFontSize(BuildContext context, {required double fontSize}) {
//   double scaleFactor = getScaleFactor(context);
//   double responsiveFontSize = fontSize * scaleFactor;
//   double lowerLimit = responsiveFontSize * .8;
//   double upperLimit = responsiveFontSize * 1.2;
//   return responsiveFontSize.clamp(lowerLimit, upperLimit);
// }

// double getScaleFactor(BuildContext context) {
//   double width = MediaQuery.sizeOf(context).width;
//   if (width < 600) {
//     return width / 400;
//   } else {
//     return width / 700;
//   }
// }
import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';

Widget buildTextWithBorder(
  String mainTitle,
  String subTitle,
  BuildContext context, {
  double? containerWidth, // ← optional width
}) {
  double defaultWidth =
      containerWidth ?? MediaQuery.of(context).size.width * 0.5;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Align(
        alignment: Alignment.centerRight, // دايمًا على اليمين
        child: Container(
          width: defaultWidth, // استخدمنا width سواء مرسل أو default
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: Mycolors.primary_color.colors,
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0XFF222633),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              mainTitle,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: getResponsiveFontSize(context, fontSize: 24),
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
            ),
          ),
        ),
      ),

      // const SizedBox(height: 6),
      RichText(
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        text: TextSpan(
          children: [
            TextSpan(
              text: subTitle,
              style: TextStyle(
                fontSize: getResponsiveFontSize(context, fontSize: 22),
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.3,
              ),
            ),
            const TextSpan(text: " "),
          ],
        ),
      ),
      const SizedBox(height: 24),
    ],
  );
}

double getResponsiveFontSize(BuildContext context, {required double fontSize}) {
  double scaleFactor = getScaleFactor(context);
  double responsiveFontSize = fontSize * scaleFactor;
  double lowerLimit = responsiveFontSize * 0.8;
  double upperLimit = responsiveFontSize * 1.2;
  return responsiveFontSize.clamp(lowerLimit, upperLimit);
}

double getScaleFactor(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  if (width < 600) {
    return width / 400;
  } else {
    return width / 700;
  }
}
