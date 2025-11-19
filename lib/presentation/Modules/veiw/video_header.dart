import 'package:flutter/material.dart';
import 'package:prime_academy/presentation/Modules/veiw/view_lesson.dart';

Widget videoHeader(
  String lessonTitle,
  BuildContext context,
  DeviceType deviceType,
) {
  // أحجام responsive حسب نوع الجهاز
  double containerWidth;
  double containerHeight;
  double fontSize;
  EdgeInsets padding;

  switch (deviceType) {
    case DeviceType.mobilePortrait:
      containerWidth = MediaQuery.of(context).size.width * 0.9;
      containerHeight = 60;
      fontSize = 20;
      padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      break;
    case DeviceType.mobileLandscape:
      containerWidth = MediaQuery.of(context).size.width * 0.55;
      containerHeight = 50;
      fontSize = 20;
      padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      break;
    case DeviceType.tablet:
      containerWidth = MediaQuery.of(context).size.width * 0.8;
      containerHeight = 70;
      fontSize = 24;
      padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
      break;
    case DeviceType.desktop:
      containerWidth = MediaQuery.of(context).size.width * 0.9;
      containerHeight = 80;
      fontSize = 28;
      padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      break;
  }

  return Container(
    width: containerWidth,
    height: containerHeight,
    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF172955), Color(0xFF1B202F)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // أيقونة للفيديو
          // Container(
          //   padding: const EdgeInsets.all(8),
          //   decoration: BoxDecoration(
          //     color: Colors.white.withOpacity(0.1),
          //     borderRadius: BorderRadius.circular(8),
          //   ),
          //   child: Icon(
          //     Icons.play_circle_outline,
          //     color: Colors.white,
          //     size: fontSize + 4,
          //   ),
          // ),
          // const SizedBox(width: 12),
          // عنوان الدرس
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  lessonTitle.isNotEmpty ? lessonTitle : "اختر درساً",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    // fontWeight: FontWeight.bold,
                    
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
