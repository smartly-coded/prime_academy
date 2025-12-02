import 'package:flutter/material.dart';
import 'package:prime_academy/core/routing/app_routes.dart';
import 'package:prime_academy/features/CoursesModules/data/models/lesson_type.dart';
import 'package:prime_academy/features/CoursesModules/data/models/module_model.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'lesson_item.dart';
import 'package:flutter/material.dart';
import 'package:prime_academy/core/routing/app_routes.dart';
import 'package:prime_academy/features/CoursesModules/data/models/module_model.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';

import 'lesson_item.dart';

class ModuleTile extends StatefulWidget {
  final ModuleModel module;
  final int courseId;
  final LoginResponse user;

  const ModuleTile({
    super.key,
    required this.module,
    required this.courseId,
    required this.user,
  });

  @override
  State<ModuleTile> createState() => _ModuleTileState();
}

class _ModuleTileState extends State<ModuleTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isSpecial = widget.module.special == true;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        gradient: isSpecial
            ? LinearGradient(
                colors: [Color(0xFF3F471F), Color(0xFF1B202F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [Color(0xFF172955), Color(0xFF1B202F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
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
                      Text(
                        widget.module.title,
                        // textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 18 : 16,
                        ),
                      ),
                      if (isSpecial || widget.module.subtitle != null)
                        SizedBox(height: 4),
                      if (isSpecial)
                        Text(
                          "هذا درس خاص",
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: isTablet ? 14 : 12,
                            fontWeight: FontWeight.w500,
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
            Container(
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
                            // درس عادي
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
    );
  }
}
