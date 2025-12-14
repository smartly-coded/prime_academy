import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/CoursesModules/data/models/lesson_type.dart';

import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/CoursesModules/data/models/lesson_type.dart';

class LessonItem extends StatelessWidget {
  final String title;
  final String? time;
  final LessonType type;
  final VoidCallback? onTap;
  final bool isSelected;

  const LessonItem({
    super.key,
    required this.title,
    this.time,
    required this.type,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isSmallMobile = size.width < 350;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
        
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Mycolors.cardColor1, Color(0xff1a1a2e)],
                )
              : LinearGradient(
                  colors: [
                    Mycolors.cardColor1.withOpacity(.6),
                    Mycolors.cardColor1.withOpacity(.5),
                  ],
                ),
          border: Border(
            // top: const BorderSide(color: Colors.white12, width: 1.0),
            right: isSelected
                ? const BorderSide(color: Colors.white, width: 3.0)
                : BorderSide.none,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 20 : 16,
          vertical: isTablet ? 16 : 12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.rtl,
          children: [
            Icon(
              type == LessonType.video
                  ? Icons.play_circle_fill
                  : Icons.open_in_new,
              color: isSelected ? Colors.white : Colors.white,
              size: isTablet ? 28 : 24,
            ),

            SizedBox(width: isTablet ? 12 : 8),

            if (isSelected) ...[
              Container(
                width: isTablet ? 10 : 8,
                height: isTablet ? 10 : 8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: isTablet ? 12 : 8),
            ],

            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white,
                  fontSize: isTablet
                      ? 18
                      : isSmallMobile
                      ? 13
                      : 16, // تكبير الخط
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            SizedBox(width: isTablet ? 16 : 12),

            // if (type == LessonType.video) ...[
            //   Column(
            //     children: [
            //       Icon(
            //         isSelected ? Icons.visibility : Icons.remove_red_eye,
            //         color: isSelected ? Colors.white : Colors.white70,
            //         size: isTablet ? 24 : 20, // تكبير الأيقونة
            //       ),
            //       if (time != null) ...[
            //         SizedBox(height: isTablet ? 6 : 4),
            //         Text(
            //           time!,
            //           textAlign: TextAlign.right,
            //           style: TextStyle(
            //             color: isSelected ? Colors.white70 : Colors.white54,
            //             fontSize: isTablet
            //                 ? 14
            //                 : isSmallMobile
            //                 ? 10
            //                 : 12, // تكبير الخط
            //             fontWeight: isSelected
            //                 ? FontWeight.w500
            //                 : FontWeight.normal,
            //           ),
            //         ),
            //       ],
            //     ],
            //   ),
            // ] else ...[
            //   Column(
            //     children: [
            //       Icon(
            //         Icons.link,
            //         color: isSelected ? Colors.white : Colors.white70,
            //         size: isTablet ? 24 : 20, // تكبير الأيقونة
            //       ),
            //       SizedBox(height: isTablet ? 6 : 4),
            //       Text(
            //         "رابط",
            //         textAlign: TextAlign.right,
            //         style: TextStyle(
            //           color: isSelected ? Colors.white70 : Colors.white54,
            //           fontSize: isTablet
            //               ? 14
            //               : isSmallMobile
            //               ? 10
            //               : 12, // تكبير الخط
            //           fontWeight: isSelected
            //               ? FontWeight.w500
            //               : FontWeight.normal,
            //         ),
            //       ),
            //     ],
            //   ),
            // ],
          ],
        ),
      ),
    );
  }
}
