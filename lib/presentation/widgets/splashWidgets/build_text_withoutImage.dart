// import 'package:flutter/material.dart';
// import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
// import 'package:prime_academy/presentation/widgets/homeWidgets/build_text.dart';

// Widget buildTextWithBorder(
//   String mainTitle,
//   String subTitle,
//   BuildContext context, {
//   double? containerWidth,
// }) {
//   double defaultWidth =
//       containerWidth ?? MediaQuery.of(context).size.width * 0.5;

//   // نستخدم ValueNotifier لتغيير اتجاه gradient عند الضغط
//   final gradientFlipped = ValueNotifier<bool>(false);

//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.end,
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       Align(
//         alignment: Alignment.centerRight,
//         child: ValueListenableBuilder<bool>(
//           valueListenable: gradientFlipped,
//           builder: (context, isFlipped, _) {
//             return GestureDetector(
//               onTap: () {
//                 gradientFlipped.value = !gradientFlipped.value;
//               },
//               child: Container(
//                 width: defaultWidth,
//                 padding: const EdgeInsets.all(3),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: Mycolors.primary_color.colors,
//                     begin: isFlipped
//                         ? Alignment.topLeft
//                         : Alignment.bottomRight,
//                     end: isFlipped ? Alignment.bottomRight : Alignment.topLeft,
//                   ),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 15,
//                     vertical: 10,
//                   ),
//                   decoration: BoxDecoration(
//                     color: const Color(0XFF222633),
//                     borderRadius: BorderRadius.circular(7),
//                   ),
//                   child: Text(
//                     mainTitle,
//                     textAlign: TextAlign.center,
//                     textDirection: TextDirection.rtl,
//                     style: TextStyle(
//                       fontSize: getResponsiveFontSize(context, fontSize: 18),
//                       color: Colors.white,
//                       height: 1.2,
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
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

// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
// import 'package:prime_academy/presentation/widgets/homeWidgets/build_text.dart';

// Widget buildTextWithBorder(
//   String mainTitle,
//   String subTitle,
//   BuildContext context, {
//   double? containerWidth,
// }) {
//   double defaultWidth =
//       containerWidth ?? MediaQuery.of(context).size.width * 0.5;
//   final gradientFlipped = ValueNotifier<bool>(false);

//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.center,
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       Align(
//         alignment: Alignment.center,
//         child: ValueListenableBuilder<bool>(
//           valueListenable: gradientFlipped,
//           builder: (context, isFlipped, _) {
//             return GestureDetector(
//               onTap: () {
//                 gradientFlipped.value = !gradientFlipped.value;
//               },
//               child: SizedBox(
//                 width: defaultWidth,
//                 child: Stack(
//                   children: [
//                     // ::before gradient (orange → purple)
//                     AnimatedOpacity(
//                       opacity: isFlipped ? 0.0 : 1.0,
//                       duration: const Duration(milliseconds: 250),
//                       curve: Curves.easeInOut,
//                       child: Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(2), // 2px border
//                         decoration: BoxDecoration(
//                           gradient: const RadialGradient(
//                             center: Alignment.bottomLeft,
//                             radius: 1.5,
//                             colors: [
//                               Color(0xFFFF9933), // orange
//                               Color(0xFF450486), // purple
//                             ],
//                           ),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: ConstrainedBox(
//                           constraints: BoxConstraints(maxWidth: defaultWidth),
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 11,
//                             ),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFF222633),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Text(
//                               mainTitle,
//                               textAlign: TextAlign.center,
//                               textDirection: TextDirection.rtl,
//                               style: TextStyle(
//                                 fontSize: _getResponsiveFontSize(context),
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.white,
//                                 height: 1.2,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),

//                     // ::after gradient (purple → orange) - overlaid
//                     AnimatedOpacity(
//                       opacity: isFlipped ? 1.0 : 0.0,
//                       duration: const Duration(milliseconds: 250),
//                       curve: Curves.easeInOut,
//                       child: Container(
//                         padding: const EdgeInsets.all(2), // 2px border
//                         decoration: BoxDecoration(
//                           gradient: const RadialGradient(
//                             center: Alignment.bottomLeft,
//                             radius: 1.5,
//                             colors: [
//                               Color(0xFF450486), // purple (reversed)

//                               Color(0xFFFF9933), // orange
//                             ],
//                           ),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: ConstrainedBox(
//                           constraints: BoxConstraints(maxWidth: defaultWidth),
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 11,
//                             ),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFF222633),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Text(
//                               mainTitle,
//                               textAlign: TextAlign.center,
//                               textDirection: TextDirection.rtl,
//                               style: TextStyle(
//                                 fontSize: _getResponsiveFontSize(context),
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.white,
//                                 height: 1.2,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//       const SizedBox(height: 10),
//       RichText(
//         textAlign: TextAlign.center,
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

// double _getResponsiveFontSize(BuildContext context) {
//   final width = MediaQuery.of(context).size.width;
//   if (width < 640) return 20;
//   if (width < 768) return 24;
//   return 36;
// }
import 'dart:ui';
import 'dart:math';
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
  final gradientFlipped = ValueNotifier<bool>(false);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Align(
        alignment: Alignment.center,
        child: ValueListenableBuilder<bool>(
          valueListenable: gradientFlipped,
          builder: (context, isFlipped, _) {
            return GestureDetector(
              onTap: () {
                gradientFlipped.value = !gradientFlipped.value;
              },
              child: SizedBox(
                width: defaultWidth,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculate radius to match CSS farthest-corner behavior
                    // Web button is 382px × 54px, we need to match that ratio
                    // final width = constraints.maxWidth;
                    // final height = 54.0; // Button height from web
                    // final diagonal = sqrt(width * width + height * height);
                    // // Normalize radius: CSS farthest-corner calculates distance to farthest corner
                    // // In Flutter's coordinate system, we need to express this relative to button size
                    // final radius =
                    //     diagonal /
                    //     (width / 2); // Divide by half-width for normalization
                    final width = constraints.maxWidth;
                    final height = 54.0; // Button height from web
                    // Match web's farthest-corner behavior more accurately
                    // For a wide button, we need a smaller multiplier
                    final radius = 1.6; // Adjusted to match web gradient spread
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        gradient: isFlipped
                            ? RadialGradient(
                                center: const Alignment(
                                  1.0,
                                  -1.0,
                                ), // bottom-right for RTL (matches web at 0% 100%)
                                // : const Alignment(
                                //     -2.0,
                                //     1.5,
                                //   ), // bottom-left for LTR
                                radius: radius,
                                colors: const [
                                  Color(0xFF450486), // purple at center
                                  Color(0xFFFF9933), // orange at edges
                                ],
                              )
                            : RadialGradient(
                                center: const Alignment(
                                  1.0,
                                  1.0,
                                ), // bottom-right for RTL (matches web at 0% 100%)
                                // bottom-left for LTR
                                radius: radius,
                                colors: const [
                                  Color(0xFFFF9933), // orange at center
                                  Color(0xFF450486), // purple at edges
                                ],
                              ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF222633),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          mainTitle,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: _getResponsiveFontSize(context),
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 10),
      RichText(
        textAlign: TextAlign.center,
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

double _getResponsiveFontSize(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < 640) return 20;
  if (width < 768) return 24;
  return 36;
}
