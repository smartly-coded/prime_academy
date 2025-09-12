import 'package:flutter/material.dart';
import 'package:prime_academy/features/CoursesModules/data/models/module_model.dart';
import 'lesson_item.dart';

class ModuleTile extends StatefulWidget {
  final ModuleModel module;

  const ModuleTile({super.key, required this.module});

  @override
  State<ModuleTile> createState() => _ModuleTileState();
}

class _ModuleTileState extends State<ModuleTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isSpecial = widget.module.special == true;

    return Container(
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
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.white,
                ),
                Spacer(),
                Expanded(
                  child: Column(
                   
                    children: [
                      Text(
                        widget.module.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      if (isSpecial)
                        const Text(
                          "This is a special lesson",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontFamily: 'Cairo',
                          ),
                        )
                      else if (widget.module.subtitle != null)
                        Text(
                          widget.module.subtitle!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontFamily: 'Cairo',
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
              children: widget.module.items
                  .map(
                    (lesson) => LessonItem(
                      title: lesson.title,
                      time: lesson.time,
                      type: lesson.type,
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}
