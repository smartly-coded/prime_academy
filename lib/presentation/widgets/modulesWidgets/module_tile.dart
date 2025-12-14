import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/core/routing/app_routes.dart';
import 'package:prime_academy/features/CoursesModules/data/models/lesson_type.dart';
import 'package:prime_academy/features/CoursesModules/data/models/module_model.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:url_launcher/url_launcher.dart';

import 'lesson_item.dart';

class ModuleTile extends StatefulWidget {
  final ModuleModel module;
  final int courseId;
  final LoginResponse user;
  final int index;

  const ModuleTile({
    super.key,
    required this.module,
    required this.courseId,
    required this.user,
    required this.index,
  });

  @override
  State<ModuleTile> createState() => _ModuleTileState();
}

class _ModuleTileState extends State<ModuleTile> {
  bool _isExpanded = false;
  bool get isGradientNonSpecial {
    if (widget.index == 0) return true;

    final adjustedIndex = widget.index - 1;
    final cycleIndex = adjustedIndex % 4;

    return cycleIndex >= 2;
  }

  @override
  Widget build(BuildContext context) {
    final isSpecial = widget.module.special == true;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),

      decoration: BoxDecoration(
        color: !isSpecial && !isGradientNonSpecial
            ? Mycolors.cardColor1.withOpacity(.6)
            : null,

        gradient: isSpecial
            ? const LinearGradient(
                colors: [Color(0xFF6a760c), Color(0xFF1b2130)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : isGradientNonSpecial
            ? const LinearGradient(
                colors: [Color(0xFF0e3995), Color(0xFF1b2130)],
                begin: Alignment.bottomLeft,
                end: Alignment.bottomRight,
              )
            : null,

        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            minVerticalPadding: 0,
            dense: true,
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.white,
                  size: isTablet ? 24 : 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSpecial)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              widget.module.title,
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: isTablet ? 20 : 18,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Image.asset(
                              "assets/images/olive.png",
                              height: 45,
                              width: 45,
                            ),
                          ],
                        )
                      else
                        Text(
                          widget.module.title,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: isTablet ? 20 : 18,
                          ),
                        ),

                      if (isSpecial || widget.module.subtitle != null)
                        SizedBox(height: 4),
                      if (isSpecial)
                        Text(
                          " لن يخرج عنها الامتحان",
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet ? 16 : 14,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      else if (widget.module.subtitle != null)
                        Text(
                          widget.module.subtitle!,
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: isTablet ? 14 : 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isExpanded)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Mycolors.cardColor1.withOpacity(.6),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.module.items
                        .map(
                          (item) => LessonItem(
                            title: item.title,
                            time: item.time,
                            type: item.type,
                            onTap: () async {
                              if (item.type == LessonType.link &&
                                  item.url != null) {
                                final uri = Uri.parse(item.url!);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(
                                    uri,
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('لا يمكن فتح الرابط'),
                                    ),
                                  );
                                }
                              } else {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.moduleLessonsPreview,
                                  arguments: {
                                    'moduleId': widget.module.id,
                                    'courseId': widget.courseId,
                                    'user': widget.user,
                                    "itemId": item.id,
                                  },
                                );
                              }
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
