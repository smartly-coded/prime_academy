import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/CoursesModules/data/models/lesson_type.dart';

class LessonItem extends StatelessWidget {
  final String title;
  final String? time;
  final LessonType type;
  final VoidCallback? onTap;

  const LessonItem({
    super.key,
    required this.title,
    this.time,
    required this.type,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Mycolors.darkblue,
          border: const Border(
            top: BorderSide(color: Colors.white12, width: 1.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (type == LessonType.video) ...[
              Column(
                children: [
                  const Icon(
                    Icons.remove_red_eye,
                    color: Colors.white70,
                    size: 20,
                  ),
                  if (time != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      time!,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        fontFamily: 'Cairo',
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
                  const Icon(Icons.link, color: Colors.white70, size: 20),
                  const SizedBox(height: 4),
                  Text(
                    "رابط",
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Cairo',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              type == LessonType.video
                  ? Icons.play_circle_fill
                  : Icons.open_in_new,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
