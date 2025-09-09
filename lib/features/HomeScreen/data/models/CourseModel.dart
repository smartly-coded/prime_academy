class Course {
  final int id;
  final String title;
  final List<Module> modules;

  Course({required this.id, required this.title, required this.modules});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      modules: (json['modules'] as List)
          .map((m) => Module.fromJson(m))
          .toList(),
    );
  }
}

class Module {
  final int id;
  final String title;
  final List<Item> items;

  Module({required this.id, required this.title, required this.items});

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'],
      title: json['title'],
      items: (json['items'] as List)
          .map((i) => Item.fromJson(i))
          .toList(),
    );
  }
}

class Item {
  final int id;
  final String itemType;
  final Lesson? lesson;

  Item({required this.id, required this.itemType, this.lesson});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      itemType: json['item_type'],
      lesson: json['lesson'] != null ? Lesson.fromJson(json['lesson']) : null,
    );
  }
}

class Lesson {
  final int id;
  final String title;

  Lesson({required this.id, required this.title});

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
    );
  }
}
