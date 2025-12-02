
// import 'package:flutter/material.dart';
// import 'package:prime_academy/core/helpers/themeing/app_colors.dart';

// Widget buildTextWithBorder(
//   String mainTitle,
//   String subTitle,
//   BuildContext context, {
//   double? containerWidth,
// }) {
//   double defaultWidth =
//       containerWidth ?? MediaQuery.of(context).size.width * 0.5;

//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.end,
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       Align(
//         alignment: Alignment.centerRight,
//         child: Container(
//           width: defaultWidth,
//           padding: const EdgeInsets.all(3),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: Mycolors.primary_color.colors,
//               begin: Alignment.bottomRight,
//               end: Alignment.topLeft,
//             ),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//             decoration: BoxDecoration(
//               color: const Color(0XFF222633),
//               borderRadius: BorderRadius.circular(7),
//             ),
//             child: Text(
//               mainTitle,
//               textAlign: TextAlign.center,
//               textDirection: TextDirection.rtl,
//               style: TextStyle(
//                 fontSize: getResponsiveFontSize(context, fontSize: 18),
//                 color: Colors.white,
//                 height: 1.2,
//               ),
//             ),
//           ),
//         ),
//       ),

//       const SizedBox(height: 10),
//       RichText(
//         textAlign: TextAlign.right,
//         textDirection: TextDirection.rtl,
//         text: TextSpan(
//           children: [
//             TextSpan(
//               text: subTitle,
//               style: TextStyle(
//                 fontSize: getResponsiveFontSize(context, fontSize: 17),
//                 color: Colors.white,
//                 fontFamily: 'Bahij',
//                 height: 1.3,
//               ),
//             ),
//             const TextSpan(text: " "),
//           ],
//         ),
//       ),
//       const SizedBox(height: 24),
//     ],
//   );
// }

// double getResponsiveFontSize(BuildContext context, {required double fontSize}) {
//   double scaleFactor = getScaleFactor(context);
//   double responsiveFontSize = fontSize * scaleFactor;
//   double lowerLimit = responsiveFontSize * 0.8;
//   double upperLimit = responsiveFontSize * 1.2;
//   return responsiveFontSize.clamp(lowerLimit, upperLimit);
// }

// double getScaleFactor(BuildContext context) {
//   double width = MediaQuery.of(context).size.width;
//   if (width < 600) {
//     return width / 400;
//   } else {
//     return width / 700;
//   }
// }
import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/build_text.dart';

Widget buildTextWithBorder(
  String mainTitle,
  String subTitle,
  BuildContext context, {
  double? containerWidth,
}) {
  double defaultWidth =
      containerWidth ?? MediaQuery.of(context).size.width * 0.5;

  // نستخدم ValueNotifier لتغيير اتجاه gradient عند الضغط
  final gradientFlipped = ValueNotifier<bool>(false);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Align(
        alignment: Alignment.centerRight,
        child: ValueListenableBuilder<bool>(
          valueListenable: gradientFlipped,
          builder: (context, isFlipped, _) {
            return GestureDetector(
              onTap: () {
                gradientFlipped.value = !gradientFlipped.value;
              },
              child: Container(
                width: defaultWidth,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: Mycolors.primary_color.colors,
                    begin: isFlipped ? Alignment.topLeft : Alignment.bottomRight,
                    end: isFlipped ? Alignment.bottomRight : Alignment.topLeft,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0XFF222633),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    mainTitle,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(context, fontSize: 18),
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 10),
      RichText(
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        text: TextSpan(
          children: [
            TextSpan(
              text: subTitle,
              style: TextStyle(
                fontSize: getResponsiveFontSize(context, fontSize: 17),
                color: Colors.white,
                fontFamily: 'Bahij',
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
