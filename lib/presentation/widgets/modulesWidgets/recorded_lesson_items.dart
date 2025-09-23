import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/CoursesModules/data/models/lesson_type.dart';

class RecordedLessonItem extends StatelessWidget {
  final String title;
  final LessonType type;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool lessonRewarded; // إضافة خاصية المكافأة

  const RecordedLessonItem({
    super.key,
    required this.title,
    required this.type,
    required this.onTap,
    this.isSelected = false,
    this.lessonRewarded = false, // القيمة الافتراضية false
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? Mycolors.cardColor1.withOpacity(0.3)
              : Mycolors.darkblue,
          border: Border.all(color: Color.fromARGB(255, 34, 58, 120)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (type == LessonType.video) ...[
              Column(
                children: [
                  // أيقونة الكاس بدلاً من الوقت
                  Icon(
                    Icons.emoji_events, // أيقونة الكاس
                    color: lessonRewarded
                        ? Colors
                              .orange // برتقالي لو حصل على المكافأة
                        : Colors.grey, // رمادي لو لم يحصل على المكافأة
                    size: 25,
                  ),
                ],
              ),
              const SizedBox(width: 12),
            ] else ...[
              // للمصادر الخارجية
              Column(
                children: [
                  Icon(
                    Icons.link,
                    color: isSelected ? Colors.white : Colors.white70,
                    size: 20,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "رابط",
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : Colors.white54,
                      fontSize: 12,
                      fontFamily: 'Cairo',
                      fontWeight: isSelected
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white,
                  fontSize: 14,
                  fontFamily: 'Cairo',
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),

            // مؤشر للعنصر المحدد
            if (isSelected) ...[
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
            ],

            Icon(
              type == LessonType.video
                  ? Icons.play_circle_fill
                  : Icons.open_in_new,
              color: isSelected ? Colors.white : Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
