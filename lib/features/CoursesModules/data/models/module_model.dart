import 'package:prime_academy/features/CoursesModules/data/models/item_model.dart';

class ModuleModel {
  final int id;
  final String title;
  final String? subtitle;
  final bool special;
  final List<ItemModel> items;

  ModuleModel({
    required this.id,
    required this.title,
    this.subtitle,
    required this.special,
    required this.items,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    final isSpecial = json['special'] ?? false;

    return ModuleModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      // ✅ لو special true → هنعرض description كـ subtitle
      subtitle: isSpecial
          ? (json['description'] ?? 'This is a special lesson')
          : json['subtitle'],
      special: isSpecial,
      items: (json['items'] as List? ?? [])
          .map((e) => ItemModel.fromJson(e))
          .toList(),
    );
  }
}
