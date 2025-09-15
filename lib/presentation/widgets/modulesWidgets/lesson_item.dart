import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/CoursesModules/data/models/lesson_type.dart';

class LessonItem extends StatelessWidget {
  final String title;
  final String? time;
  final LessonType type;
  final VoidCallback? onTap;
  final bool isSelected; // إضافة خاصية التحديد

  const LessonItem({
    super.key,
    required this.title,
    this.time,
    required this.type,
    required this.onTap,
    this.isSelected = false, // القيمة الافتراضية false
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), // تأثير الانتقال السلس
        decoration: BoxDecoration(
          // تغيير اللون حسب حالة التحديد
          color: isSelected
              ? Mycolors.cardColor1.withOpacity(0.3) // لون مختلف للعنصر المحدد
              : Mycolors.darkblue,
          border: Border(
            top: const BorderSide(color: Colors.white12, width: 1.0),
            // إضافة حدود جانبية للعنصر المحدد
            left: isSelected
                ? const BorderSide(color: Colors.white, width: 3.0)
                : BorderSide.none,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (type == LessonType.video) ...[
              Column(
                children: [
                  Icon(
                    // تغيير الأيقونة حسب حالة التحديد
                    isSelected ? Icons.visibility : Icons.remove_red_eye,
                    color: isSelected ? Colors.white : Colors.white70,
                    size: 20,
                  ),
                  if (time != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      time!,
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

            // إضافة مؤشر للعنصر المحدد
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
